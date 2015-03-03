class mysql::configuration {

  include ::mysql::configuration::mysqld
  $mysqld_config = $::mysql::configuration::mysqld::config

  include ::mysql::configuration::mysqld_safe
  $mysqld_safe_config = $::mysql::configuration::mysqld_safe::config

  $client_config = {
    'client'     =>  {
      'socket' => $::osfamily ? {
        'RedHat' => '/var/lib/mysql/mysql.sock',
        default  => '/var/run/mysqld/mysqld.sock',
      },
    },
  }

  $config = mysql_deepmerge(
    $client_config,
    $mysqld_config,
    $mysqld_safe_config,
    $::mysql::server::config_override
  )

  create_resources(
    augeas,
    mysql_options_to_augeas($config),
    {
      incl    => $::mysql::server::config_file,
      lens    => 'MySQL.lns',
      require => [
        File['/etc/mysql/my.cnf'],
        File[$mysql::server::data_dir],
      ],
      notify => Service['mysql'],
    }
  )

}
