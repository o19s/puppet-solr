#exec {'sudo apt-get update':
#        path => '/usr/bin' } ->
#
#package {'curl':
#          ensure => 'installed'} 
#
#package {'default-jre':
#          ensure => 'installed',
#          before => Class['solr::jetty'],
#        } 
#
#class { 'solr::jetty' :
#        solr_home => '/etc/solr' }


class { "solr::tomcat6":
  zookeeper_hosts => "ec2-72-44-55-216.compute-1.amazonaws.com:2181/cld2", 
}
