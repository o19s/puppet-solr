# = Class: solr::jetty
#
# This class manages the default jetty installation included with Apache Solr
#
# == Parameters:
#
#
# == Requires:
#
#
# == Sample Usage:
#
#
class solr::jetty(
  $solr_version = '4.5.0',
  $solr_home = '/opt',
  $zookeeper_hosts = "",
  $exec_path = '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin'
){

  class { "solr::core":
    solr_version => $solr_version,
    exec_path    => $exec_path
  }

  file { "/etc/init.d/solr":
    ensure => "present",
    mode   => '0755',
    source => "puppet:///modules/solr/solr"
  } ->

  file { "/etc/default/solr-jetty":
    content => template("solr/solr-jetty.erb"),
    ensure => present,
    owner  => solr,
  } ->

  service {"solr":
    ensure  => running,
    require => Class["solr::core"]
  }

}
