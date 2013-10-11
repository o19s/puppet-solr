# = Class: solr::core
#
# This class downloads and installs a Apache Solr
#
# == Parameters:
#
# $solr_version:: which version of solr to install
#
# $solr_home:: where to place solr
#
# $exec_path:: the path to use when executing commands on the
#             local system
#
#
# == Requires:
#
# curl
#
# == Sample Usage:
#
#   class {'solr::core':
#     solr_version           => '4.4.0'
#   }
#
class solr::core(
  $solr_version = '4.5.0',
  $solr_home = '/opt',
  $exec_path = '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin'
) {

  # using the 'creates' option here against the finished product so we only download this once
  exec { "wget solr":
    command => "wget --output-document=/tmp/solr-${solr_version}.tgz http://www.us.apache.org/dist/lucene/solr/${solr_version}/solr-${solr_version}.tgz",
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
    command => "cp -rf /opt/solr/example/solr/collection1/* /etc/solr/collection1/",
    path    => $exec_path,
    user    => solr,
    creates => "/etc/solr/collection1/conf/schema.xml"

  }


}
