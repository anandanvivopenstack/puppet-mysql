# ==Class: mysql::server
class mysql::server (
  $config_file = $::osfamily ? {
    'Debian' => '/etc/mysql/my.cnf',
    'RedHat' => '/etc/my.cnf',
  },
  $override_options = {},
  $mycnf_group = 'root',
  $mycnf_mode = '0644',
  $backup_dir = '/var/backups/mysql',
  $user = 'root',
  $password = undef,
  $unmanaged_config = false,
  $unmanaged_service = false,
  $unmanaged_password = false,
) inherits mysql::params {

  # TODO: use params
  include ::mysql::configuration::mysqld
  include ::mysql::configuration::mysqld_safe
  $client_config = {
    'client'     =>  {
      'socket' => $::osfamily ? {
        'RedHat' => '/var/lib/mysql/mysql.sock',
        default  => '/var/run/mysqld/mysqld.sock',
      },
    },
  }
  $options = mysql_deepmerge(
    $client_config,
    $::mysql::configuration::mysqld::config,
    $::mysql::configuration::mysqld_safe::config,
    $::mysql::server::override_options
  )
  $data_dir = $options['mysqld']['datadir']
  # END TODO

  if ! $unmanaged_config {
    create_resources(
      'augeas',
      mysql_options_to_augeas($options),
      {
        incl    => $config_file,
        lens    => 'MySQL.lns',
        require => [
          File['/etc/mysql/my.cnf'],
          File[$data_dir],
        ],
        notify => Service['mysql'],
      }
    )
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
    ensure  => file,
    path    => $config_file,
    owner   => root,
    group   => $mycnf_group,
    mode    => $mycnf_mode,
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
  $service_name = $::osfamily ? {
    'RedHat' => 'mysqld',
    default  => 'mysql',
  }
  service { 'mysql':
    ensure  => $service_ensure,
    enable  => $service_enable,
    name    => $service_name,
    require => Package['mysql-server'],
  }

  if ! $unmanaged_password {

    if $password {
      # If a password is supplied, set it in mysql and in the .my.cnf file

      mysql_user { "${user}@localhost":
        ensure        => present,
        password_hash => mysql_password($password),
        require       => File['/root/.my.cnf'],
        alias         => 'mysql root',
      }

      file { '/root/.my.cnf':
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0600',
        content => template('mysql/my.cnf.erb'),
      }

    } else {

      # If no password is supplied, generate on and set it in mysql and the
      # .my.cnf file, but only once! We don't want the password to change
      # on each puppet run!
  
      $gen_password = inline_template('<%=(0...20).map { [("a".."z"), ("A".."Z")].map { |i| i.to_a }.flatten[rand(52)] }.join%>')
  
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
        path    => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
        require => [Package['mysql-server'], Service['mysql']],
      }
    
      exec { 'Generate my.cnf':
        command     => "/bin/echo -e \"[mysql]\nuser=${user}\npassword=${gen_password}\n[mysqladmin]\nuser=${user}\npassword=${gen_password}\n[mysqldump]\nuser=${user}\npassword=${gen_password}\n[mysqlshow]\nuser=${user}\npassword=${gen_password}\n\" > /root/.my.cnf",
        refreshonly => true,
        creates     => '/root/.my.cnf',
        path        => '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin',
      }
    }
  
  }

  $file_path = $::osfamily ? {
    'RedHat' => '/var/log/mysql-slow-queries.log',
    default  => '/var/log/mysql/mysql-slow-queries.log',
  }
  file { 'mysql-slow-queries.log':
    ensure  => file,
    owner   => mysql,
    group   => mysql,
    mode    => '0640',
    seltype => mysqld_log_t,
    path    => $file_path,
  }

}
