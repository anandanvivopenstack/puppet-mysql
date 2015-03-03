class mysql::configuration::mysqld {

  $log_error = $::osfamily ? {
    'RedHat' => '/var/log/mysqld.log',
    default  => '/var/log/mysql.err',
  }
  $log_slow_queries = $::osfamily ? {
    'RedHat' => '/var/log/mysql-slow-queries.log',
    default  => '/var/log/mysql/mysql-slow.log',
  }
  $socket = $::osfamily ? {
    'RedHat' => '/var/lib/mysql/mysql.sock',
    default  => '/var/run/mysqld/mysqld.sock',
  }

  $config = {
    'mysqld' => {
      'pid-file' => '/var/run/mysqld/mysqld.pid',
      'old_passwords'        => '0',
      'character-set-server' => 'utf8',
      'log-warnings'         => '1',
      'datadir'              => $::mysql::server::data_dir,
      'log-error'            => $log_error,
      'log-slow-queries'     => $log_slow_queries,
      'socket'               => $socket,
    },
  }

}
