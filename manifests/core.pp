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
#
# == Requires:
#
#   wget
#
# == Sample Usage:
#
#   class {'solr::core':
#       $solr_home = '/etc/my_config/'
#   }
#
class solr::core(
  $solr_version = $solr::params::solr_version,
  $solr_home = $solr::params::solr_home,
  $apache_mirror = $solr::params::apache_mirror,
  $core_name = $solr::params::core_name,
) inherits solr::params {

  # using the 'creates' option and a move here against the finished product so
  # we only download this once, downloading-solr is essentially a staging
  # location for the download
  $solr_tgz_url = "http://${apache_mirror}/lucene/solr/${solr_version}/solr-${solr_version}.tgz"
  exec { "wget solr":
    command => "wget --output-document=/tmp/downloading-solr-${solr_version}.tgz ${solr_tgz_url} && mv /tmp/downloading-solr-${solr_version}.tgz /tmp/solr-${solr_version}.tgz",
    creates => "/tmp/solr-${solr_version}.tgz",
  } ->

  user { "solr":
    ensure => present
  } ->

  file { "${distro_home}": 
    ensure  => directory,
  } ->

  exec { "untar solr":
    command => "tar -xf /tmp/solr-${solr_version}.tgz -C ${distro_home}", 
    creates => "${distro_home}/solr-${solr_version}",
  } ->

  file { "${distro_home}/current":
    ensure => link,
    target => "${distro_home}/solr-${solr_version}",
    owner  => solr,
  }

# defaults if solr_home is not provided
# data will go to /var/lib/solr
# conf will go to /etc/solr
    if $solr_home == "${distro_home}/current/example/solr" {
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
        command => "cp -rf ${distro_home}/current/example/solr/collection1/* /etc/solr/collection1/",
        user    => solr,
        creates => "/etc/solr/collection1/conf/schema.xml"
      }
    }

    else {
         alert("solr_home specificed as ${solr_home}. Everything will look there for configs!") 
    }
}
