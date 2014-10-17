#
# Class mysql::client
#
# Installs mysql client utilities such as mysqldump, mysqladmin, the "mysql"
# interactive shell, etc.
#
class mysql::client {

  $pkg_name = $::osfamily ? {
    'Debian' => 'mysql-client',
    'RedHat' => 'mysql',
  }

  package { 'mysql-client':
    ensure => present,
    name   => $pkg_name,
  }

}
