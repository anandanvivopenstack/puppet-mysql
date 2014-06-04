class mysql::params {

  $mycnf = $::osfamily ? {
    'RedHat' => '/etc/my.cnf',
    default  => '/etc/mysql/my.cnf',
  }

  $logfile_group = $::osfamily ? {
    'RedHat' => 'mysql',
    'Debian' => 'adm',
    default  => 'adm',
  }

}
