#
# ==Class: mysql::server
#
# Parameters:
#  $data_dir:
#    set the data directory path, which is used to store all the databases
#
#    If set, copies the content of the default mysql data location. This is
#    necessary on Debian systems because the package installation script
#    creates a special user used by the init scripts.
#
class mysql::server (
  $performance = 'default',
  $config_override = {},
  $logfile_group = $::mysql::params::logfile_group,
  $data_dir = '/var/lib/mysql',
  $backup_dir = '/var/backups/mysql',
  $user = 'root',
  $password = undef,
  $unmanaged_config = false,
  $unmanaged_service = false,
  $replication = 'NONE',
  $replication_serverid = undef,
  $replication_masterhost = undef,
  $replication_masteruser = undef,
  $replication_masterpw = undef,
  $replication_binlog_format = 'STATEMENT',
) inherits mysql::params {

  if ! $unmanaged_config {
    include ::mysql::configuration
  }

  user { 'mysql':
    ensure  => present,
    require => Package['mysql-server'],
  }

  package { 'mysql-server':
    ensure => installed,
  }

  file { $data_dir:
    ensure  => directory,
    owner   => 'mysql',
    group   => 'mysql',
    seltype => 'mysqld_db_t',
    require => Package['mysql-server'],
  }

  if( $data_dir != '/var/lib/mysql' ) {
    File[$data_dir]{
      source  => '/var/lib/mysql',
      recurse => true,
      replace => false,
    }
  }

  file { '/etc/mysql/my.cnf':
    ensure  => present,
    path    => $mysql::params::mycnf,
    owner   => root,
    group   => root,
    mode    => '0644',
    seltype => 'mysqld_etc_t',
    require => Package['mysql-server'],
  }

  $service_ensure = $unmanaged_service ? {
    false => 'running',
    true  => undef,
  }
  $service_enable = $unmanaged_service ? {
    false => true,
    true  => false,
  }
  service { 'mysql':
    ensure      => $service_ensure,
    enable      => $service_enable,
    name        => $::osfamily ? {
      'RedHat' => 'mysqld',
      default  => 'mysql',
    },
    require   => Package['mysql-server'],
  }

  if $password {
    # If a password is supplied, set it in mysql and in the .my.cnf file

    mysql_user { "${user}@localhost":
      ensure        => present,
      password_hash => mysql_password($password),
      require       => File['/root/.my.cnf'],
      alias         => 'mysql root',
    }

    file { '/root/.my.cnf':
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0600',
      content => template('mysql/my.cnf.erb'),
    }

  } else {
    # If no password is supplied, generate on and set it in mysql and the
    # .my.cnf file, but only once! We don't want the password to change
    # on each puppet run!

    $gen_password = generate('/usr/bin/pwgen', 20, 1)

    file { '/root/.my.cnf':
      owner   => root,
      group   => root,
      mode    => '0600',
      require => Exec['Initialize MySQL server root password'],
    }

    exec { 'Initialize MySQL server root password':
      unless  => 'test -f /root/.my.cnf',
      command => "mysqladmin -u${user} password ${gen_password}",
      notify  => Exec['Generate my.cnf'],
      require => [Package['mysql-server'], Service['mysql']]
    }
  
    exec { "Generate my.cnf":
      command     => "/bin/echo -e \"[mysql]\nuser=${user}\npassword=${gen_password}\n[mysqladmin]\nuser=${user}\npassword=${gen_password}\n[mysqldump]\nuser=${user}\npassword=${gen_password}\n[mysqlshow]\nuser=${user}\npassword=${gen_password}\n\" > /root/.my.cnf",
      refreshonly => true,
      creates     => "/root/.my.cnf",
    }
  
  }

  file { '/etc/logrotate.d/mysql-server':
    ensure => present,
    content => $::osfamily ? {
      'RedHat' => template('mysql/logrotate.redhat.erb'),
      'Debian' => template('mysql/logrotate.debian.erb'),
      default  => undef,
    }
  }

  file { 'mysql-slow-queries.log':
    ensure  => present,
    owner   => mysql,
    group   => mysql,
    mode    => '0640',
    seltype => mysqld_log_t,
    path    => $::osfamily ? {
      'RedHat' => '/var/log/mysql-slow-queries.log',
      default  => '/var/log/mysql/mysql-slow-queries.log',
    };
  }

}
