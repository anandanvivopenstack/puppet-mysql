class mysql::configuration {

  include ::mysql::configuration::mysqld
  $mysqld_config = $::mysql::configuration::mysqld::config

  include ::mysql::configuration::mysqld_safe
  $mysqld_safe_config = $::mysql::configuration::mysqld_safe::config

  $replication_config = {
    'mysqld/log-bin'         => { ensure => absent },
    'mysqld/server-id'       => { ensure => absent },
    'mysqld/master-host'     => { ensure => absent },
    'mysqld/master-user'     => { ensure => absent },
    'mysqld/master-password' => { ensure => absent },
    'mysqld/report-host'     => { ensure => absent },
  }

  $client_config = {
    'client/socket' => {
      value => $::osfamily ? {
        'RedHat' => '/var/lib/mysql/mysql.sock',
        default  => '/var/run/mysqld/mysqld.sock',
      },
    },
  }

  $config = merge($replication_config,
                  $client_config,
                  $mysqld_config,
                  $mysqld_safe_config,
                  $::mysql::server::config_override)

  create_resources(::mysql::config, $config)

}
