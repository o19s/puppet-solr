# = Class: solr
#
# This class installs/configures/manages Apache Solr. 
#
# == Parameters:
#
# $solr_version:: the version of solr to install
#
# $solr_home:: where the solr files will be installed
#
# $exec_path:: the path to use when executing commands on the
#             local system
#
# $number_of_cloud_shards:: specify only for SolrCloud
#
# $zookeeper_hosts:: An comma seperated list of zookeeper hosts for SolrCloud.
#                   Specify only for SolrCloud
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class {'solr':
#     number_of_cloud_shards => 2,
#     zookeeper_hosts        => ["example.com:2181", "anotherserver.org:2181/alternate_root"]
#   }
#
class solr (
  $solr_version = '4.3.0',
  $solr_home = '/opt',
  $number_of_cloud_shards = nil,
  $zookeeper_hosts = nil,
  $exec_path = '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin'
) {
  # using the 'creates' option here against the finished product so we only download this once
  exec { "wget solr":
    command => "wget --output-document=/tmp/solr-${solr_version}.tgz http://apache.petsads.us/lucene/solr/${solr_version}/solr-${solr_version}.tgz",
    path    => $exec_path,
    creates => "${solr_home}/solr-${solr_version}",
  } ->

  user { "solr": 
    ensure => present
  } ->

  exec { "untar solr":
    command => "tar -xf /tmp/solr-${solr_version}.tgz -C ${solr_home}",
    path    => $exec_path,
    creates => "${solr_home}/solr-${solr_version}",
  } ->

  file { "${solr_home}/solr":
    ensure => link,
    target => "${solr_home}/solr-${solr_version}",
    owner  => solr,
  } ->

  file { "/etc/solr":
    ensure => directory,
    owner  => solr,
  } ->

  file { "/etc/solr/solr.xml":
    ensure => present,
    source => "puppet:///modules/solr/solr.xml",
    owner  => solr,
  } ->
  
  file { "/etc/solr/collection1":
    ensure => directory,
    owner  => solr,
  } ->

  file { "/etc/solr/collection1/conf":
    ensure => directory,
    owner  => solr,
  } ->

  file { "/var/lib/solr":
    ensure => directory,
    owner  => solr,
  } -> 

  file { "/var/lib/solr/collection1":
    ensure => directory,
    owner  => solr,
  } ->

  exec { "copy core files to collection1":
    command => "cp -rf /opt/solr/example/solr/collection1/* /etc/solr/collection1/conf/",
    path    => $exec_path,
    user    => solr,
    creates => "/etc/solr/collection1/conf/schema.xml"

  } -> 

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
    enable => false
  }

}
