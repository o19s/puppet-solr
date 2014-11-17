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
  $solr_version = $solr::params::solr_version,
  $solr_install = $solr::params::solr_install,
  $zookeeper_hosts = $solr::params::zookeeper_hosts,
  $core_name = $solr::params::core_name,
  $apache_mirror = $solr::params::apache_mirror,
) inherits solr::params {

  class { 'solr::core':
    core_name => $core_name,
    solr_version => $solr_version,
    solr_install => $solr_install,
    apache_mirror => $apache_mirror,
  }

  if $operatingsystem == "Ubuntu" {
      exec { "load init.d into upstart":
        command => "update-rc.d solr defaults",
        user    => "root",
        onlyif  => "test 7 != `ls -al /etc/rc*.d | grep solr | wc | awk '{print \$1}'`" ,
        require => [File["/etc/init.d/solr"], Class['solr::core']]
        # checks if solr service is enabled
      }
  }

  file { "/etc/init.d/solr":
    ensure => "present",
    mode   => '0755',
    source => "puppet:///modules/solr/solr",
    owner  => 'root',
  } ->

  file { "/etc/default/solr":
    content => template("solr/solr-jetty.erb"),
    ensure => present,
    owner  => 'root',
  } ->

  service {"solr":
    ensure  => running,
    require => Class["solr::core"]
  }

}
