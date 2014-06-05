class mysql::config::replication::slave(
  $mysql_masterhost,
  $mysql_masteruser,
  $mysql_masterpw,
  $replication_binlog_format = 'STATEMENT',
) inherits mysql::config::replication {
  Mysql::Config['master-host'] {
    ensure => present,
    value  => $mysql_masterhost,
  }

  Mysql::Config['master-user'] {
    ensure => present,
    value  => $mysql_masteruser,
  }

  Mysql::Config['master-password'] {
    ensure => present,
    value  => $mysql_masterpw,
  }

  Mysql::Config['report-host'] {
    ensure => present,
    value  => $::hostname,
  }

  mysql::config {
    'relay-log':             value => '/var/lib/mysql/mysql-relay-bin';
    'relay-log-index':       value => '/var/lib/mysql/mysql-relay-bin.index';
    'relay-log-info-file':   value => '/var/lib/mysql/relay-log.info';
    'relay_log_space_limit': value => '2048M';
    'max_relay_log_size':    value => '100M';
  }

  # binlog_format comes with MySQL 5.1+
  # RHEL6+, Debian6+
  case  $::operatingsystem {

    Debian: {
      case $::lsbmajdistrelease {

        '4','5': { }

        default: {
          mysql::config {'binlog_format':
            value => $replication_binlog_format,
          }
        }
      }

    } # Debian

    RedHat,CentOS: {
      case $::lsbmajdistrelease {

        '4','5': { }

        default: {
          mysql::config {'binlog_format':
            value => $replication_binlog_format,
          }
        }
      }

    } # RedHat,CentOS

  } # case $operatingsystem

}
