# == Class: mysql::slave::common
# ** The composants available in all versions of MySQL
# ** This is the inital mysql::slave class.
class mysql::slave::common(
  $mysql_serverid,
  $mysql_masterhost,
  $mysql_masteruser,
  $mysql_masterpw,
) {

  class { '::mysql::master':
    mysql_serverid => $mysql_serverid,
  }

  class { '::mysql::config::replication::slave':
    mysql_masterhost => $mysql_masterhost,
    mysql_masteruser => $mysql_masteruser,
    mysql_masterpw   => $mysql_masterpw,
  }
}
