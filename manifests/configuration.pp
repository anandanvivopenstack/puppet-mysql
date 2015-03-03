class mysql::configuration {

  include ::mysql::configuration::client
  $client_config = $::mysql::configuration::client::config

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

  $config = merge($replication_config,
                  $client_config,
                  $mysqld_config,
                  $mysqld_safe_config,
                  $::mysql::server::config_override)

  create_resources(::mysql::config, $config)

}
