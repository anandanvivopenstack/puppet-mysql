class mysql::configuration::replication {

  validate_re($::mysql::server::replication, ['^NONE', '^master', '^slave'])

  if $::mysql::server::replication == 'NONE' {
    $config = {
      'log-bin'         => { ensure => absent },
      'server-id'       => { ensure => absent },
      'master-host'     => { ensure => absent },
      'master-user'     => { ensure => absent },
      'master-password' => { ensure => absent },
      'report-host'     => { ensure => absent },
    }
  } else {
    validate_string($::mysql::server::replication_serverid)

    $repl_base_config = {
      'log-bin'          => { value => 'mysql-bin' },
      'server-id'        => { value => $::mysql::server::replication_serverid },
      'master-host'      => { ensure => absent },
      'master-user'      => { ensure => absent },
      'master-password'  => { ensure => absent },
      'report-host'      => { ensure => absent },
      'expire_logs_days' => { value => '7'},
      'max_binlog_size'  => { value => '100M'},
    }

    if $::mysql::server::replication == 'slave' {
      validate_string($::mysql::server::replication_masterhost)
      validate_string($::mysql::server::replication_masteruser)
      validate_string($::mysql::server::replication_masterpw)
      validate_string($::mysql::server::replication_binlog_format)

      $repl_slave_base_config = {
        'master-host'           => { value => $::mysql::server::replication_masterhost },
        'master-user'           => { value => $::mysql::server::replication_masteruser },
        'master-password'       => { value => $::mysql::server::replication_masterpw },
        'report-host'           => { value => $::hostname },
        'relay-log'             => { value => '/var/lib/mysql/mysql-relay-bin' },
        'relay-log-index'       => { value => '/var/lib/mysql/mysql-relay-bin.index' },
        'relay-log-info-file'   => { value => '/var/lib/mysql/relay-log.info' },
        'relay_log_space_limit' => { value => '2048M' },
        'max_relay_log_size'    => { value => '100M' },
      }

      # binlog_format comes with MySQL 5.1+
      # RHEL6+, Debian6+
      case $::operatingsystem {
        Debian,RedHat,Centos: {
          if $::lsbmajdistrelease >= '6' {
            $repl_slave_config = merge($repl_slave_base_config, {
              'binlog_format' => { value => $::mysql::server::replication_binlog_format },
            })
          } else {
            $repl_slave_config = $repl_slave_base_config
          }
        }
        default: {
          $repl_slave_config = $repl_slave_base_config
        }
      }

    } else {
      $repl_slave_config = {}
    }

    $config = merge($repl_base_config, $repl_slave_config)
  }

}
