class mysql::configuration::replication {

  validate_re($::mysql::server::replication, ['^NONE', '^master', '^slave'])

  if $::mysql::server::replication == 'NONE' {
    $config = {
      'mysqld/log-bin'         => { ensure => absent },
      'mysqld/server-id'       => { ensure => absent },
      'mysqld/master-host'     => { ensure => absent },
      'mysqld/master-user'     => { ensure => absent },
      'mysqld/master-password' => { ensure => absent },
      'mysqld/report-host'     => { ensure => absent },
    }
  } else {
    validate_string($::mysql::server::replication_serverid)

    $repl_base_config = {
      'mysqld/log-bin'          => { value => 'mysql-bin' },
      'mysqld/server-id'        => { value => $::mysql::server::replication_serverid },
      'mysqld/master-host'      => { ensure => absent },
      'mysqld/master-user'      => { ensure => absent },
      'mysqld/master-password'  => { ensure => absent },
      'mysqld/report-host'      => { ensure => absent },
      'mysqld/expire_logs_days' => { value => '7'},
      'mysqld/max_binlog_size'  => { value => '100M'},
    }

    if $::mysql::server::replication == 'slave' {
      validate_string($::mysql::server::replication_masterhost)
      validate_string($::mysql::server::replication_masteruser)
      validate_string($::mysql::server::replication_masterpw)
      validate_string($::mysql::server::replication_binlog_format)

      $repl_slave_base_config = {
        'mysqld/master-host'           => { value => $::mysql::server::replication_masterhost },
        'mysqld/master-user'           => { value => $::mysql::server::replication_masteruser },
        'mysqld/master-password'       => { value => $::mysql::server::replication_masterpw },
        'mysqld/report-host'           => { value => $::hostname },
        'mysqld/relay-log'             => { value => '/var/lib/mysql/mysql-relay-bin' },
        'mysqld/relay-log-index'       => { value => '/var/lib/mysql/mysql-relay-bin.index' },
        'mysqld/relay-log-info-file'   => { value => '/var/lib/mysql/relay-log.info' },
        'mysqld/relay_log_space_limit' => { value => '2048M' },
        'mysqld/max_relay_log_size'    => { value => '100M' },
      }

      # binlog_format comes with MySQL 5.1+
      # RHEL6+, Debian6+
      case $::operatingsystem {
        'Debian','RedHat','Centos': {
          if versioncmp($::operatingsystemmajrelease, '6') >= 0 {
            $repl_slave_config = merge($repl_slave_base_config, {
              'mysqld/binlog_format' => { value => $::mysql::server::replication_binlog_format },
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
