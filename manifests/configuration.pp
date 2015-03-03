class mysql::configuration {

  include ::mysql::configuration::replication
  $replication_config = $::mysql::configuration::replication::config

  include ::mysql::configuration::client
  $client_config = $::mysql::configuration::client::config

  include ::mysql::configuration::mysqld
  $mysqld_config = $::mysql::configuration::mysqld::config

  include ::mysql::configuration::mysqld_safe
  $mysqld_safe_config = $::mysql::configuration::mysqld_safe::config

  $config = merge($replication_config,
                  $client_config,
                  $mysqld_config,
                  $mysqld_safe_config,
                  $::mysql::server::config_override)

  create_resources(::mysql::config, $config)

}
