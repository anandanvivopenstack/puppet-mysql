class mysql::master(
  $mysql_serverid,
) {
  include mysql::server::base
  class { 'mysql::config::replication::master':
    mysql_serverid => $mysql_serverid,
  }
}
