exec {'sudo apt-get update':
        path => '/usr/bin' } ->

package {'curl':
          ensure => 'installed'} 

package {'default-jre':
          ensure => 'installed',
          before => Class['solr::jetty'],
        } 

class { 'solr::jetty' :
        solr_home => '/etc/solr' }

