class mysql::configuration::mysqld_safe {

  $socket = $::operatingsystem ? {
    /RedHat|Fedora|CentOS/ => '/var/lib/mysql/mysql.sock',
    default                => '/var/run/mysqld/mysqld.sock',
  }

  $config = {
    'mysqld_safe/pid-file' => { value => '/var/run/mysqld/mysqld.pid' },
    'mysqld_safe/socket'   => { value => $socket },
  }

}
