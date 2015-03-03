class mysql::configuration::mysqld {

  $log_error = $::operatingsystem ? {
    /RedHat|Fedora|CentOS/ => '/var/log/mysqld.log',
    default                => '/var/log/mysql.err',
  }
  $log_slow_queries = $::operatingsystem ? {
    /RedHat|Fedora|CentOS/ => '/var/log/mysql-slow-queries.log',
    default                => '/var/log/mysql/mysql-slow.log',
  }
  $socket = $::operatingsystem ? {
    /RedHat|Fedora|CentOS/ => '/var/lib/mysql/mysql.sock',
    default                => '/var/run/mysqld/mysqld.sock',
  }

  $config = {
    'mysqld/pid-file'             => { value => '/var/run/mysqld/mysqld.pid' },
    'mysqld/old_passwords'        => { value => '0' },
    'mysqld/character-set-server' => { value => 'utf8' },
    'mysqld/log-warnings'         => { value => '1' },
    'mysqld/datadir'              => { value => $::mysql::server::data_dir },
    'mysqld/log-error'            => { value => $log_error },
    'mysqld/log-slow-queries'     => { value => $log_slow_queries },
    'mysqld/socket'               => { value => $socket },
  }

}
