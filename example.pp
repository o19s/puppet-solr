exec { "apt-get update":
     path => '/usr/bin',
} ->

package { "java7-jdk":
     ensure => present,
} -> 

class { 'solr' :
}

