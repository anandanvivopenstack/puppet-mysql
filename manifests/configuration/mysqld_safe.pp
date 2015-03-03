class mysql::configuration::mysqld_safe {

  $socket = $::osfamily ? {
    'RedHat' => '/var/lib/mysql/mysql.sock',
    default  => '/var/run/mysqld/mysqld.sock',
  }

  $config = {
    'mysqld_safe'        => {
      'pid-file' => '/var/run/mysqld/mysqld.pid',
      'socket' => $socket,
    },
  }

}
