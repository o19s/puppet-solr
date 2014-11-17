# = Class: solr::core
#
# This class downloads and installs a Apache Solr
#
# == Parameters:
#
# $solr_version:: which version of solr to install
#
# $solr_install:: where to place solr
#
#
# == Requires:
#
#   wget
#
# == Sample Usage:
#
#   class {'solr::core':
#     solr_version           => '4.4.0'
#   }
#
class solr::core(
  $solr_version = $solr::params::solr_version,
  $solr_install = $solr::params::solr_install,
  $apache_mirror = $solr::params::apache_mirror,
  $core_name = $solr::params::core_name,
) inherits solr::params {

  $solr_tgz_url = "${apache_mirror}/lucene/solr/${solr_version}/solr-${solr_version}.tgz"

  notify { 'Tarball URI notice':
    message => "We are going to fetch Apache Solr installation tarball from '${solr_tgz_url}'."
  }

  # Using the 'creates' option here against the finished product so we only download this once.
  exec { "wget solr":
    command => "wget --output-document=/tmp/solr-${solr_version}.tgz ${solr_tgz_url}",
    creates => "${solr_install}/solr-${solr_version}",
  } ->

  user { "solr":
    ensure => present
  } ->

  file { $solr_install:
    ensure => directory,
    owner  => solr,
  } ->

  exec { "untar solr":
    command => "tar -xf /tmp/solr-${solr_version}.tgz -C ${solr_install}",
    creates => "${solr_install}/solr-${solr_version}",
  } ->

  file { "${solr_install}/current":
    ensure => link,
    target => "${solr_install}/solr-${solr_version}",
    owner  => solr,
  }

  file { $solr_home:
    ensure => directory,
    owner  => solr,
  } ->

  exec { 'Copy solr.xml':
    command => "cp -f ${solr_install}/current/example/solr/solr.xml ${solr_home}/solr.xml",
    user    => solr,
    creates => "${solr_home}/solr.xml"
  } ->

  # Creating new core from example.
  file { "${solr_home}/${core_name}":
    ensure => directory,
    owner  => solr,
  } ->

  exec { "Copy core files to ${core_name}":
    command => "cp -rf ${solr_install}/current/example/solr/collection1/* ${solr_home}/${core_name}/",
    user    => solr,
    creates => "${solr_home}/${core_name}/conf/schema.xml"
  } ->

  file { "$solr_home/${core_name}/core.properties":
    ensure => file,
    owner  => solr,
    content => "name=${core_name}",
  }

}
