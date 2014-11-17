case $osfamily {
  'Redhat': {
    $jre = 'java-1.8.0-openjdk'
    $dependency = 'yum-update'

    exec {'yum makecache':
      path   => '/usr/bin',
      alias  => $dependency,
    }

    service { 'iptables' :
      ensure => 'stopped'
    }
  }
  'Debian': {
    $jre = 'openjdk-7-jre'
    $dependency = 'apt-get-update'

    exec {'apt-get update':
      path  => '/usr/bin',
      alias => $dependency,
    }
  }

  default: { fail("Supports only CentOS/RHEL and Ubuntu/Debian. You have used: ${operatingsystem}.") }
}

package { $jre:
  ensure  => installed,
  alias   => 'jre',
  require => Exec[$dependency],
}

class {'solr::jetty':
  solr_version => '4.10.2',
  apache_mirror => 'http://mirror.reverse.net/pub/apache',
  require => Package['jre'],
}
