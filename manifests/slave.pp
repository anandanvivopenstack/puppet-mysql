# == Class: mysql::slave
#
# Define a MySQL slave server
#
class mysql::slave(
  $mysql_serverid,
  $mysql_masterhost,
  $mysql_masteruser,
  $mysql_masterpw,
  $replication_binlog_format = 'STATEMENT',
) {

  class { '::mysql::slave::common':
    mysql_serverid   => $mysql_serverid,
    mysql_masterhost => $mysql_masterhost,
    mysql_masteruser => $mysql_masteruser,
    mysql_masterpw   => $mysql_masterpw,
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
