class solr::params {

	case  $::osfamily {
	  'Debian', 'Redhat': {
		  $solr_version = '4.4.0'
		  $solr_home = '/opt'
		  $zookeeper_hosts = ""
		  $exec_path = '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin'
		  $java_home = '/usr/lib/jvm/default-java'
		}
	   default: { fail("Running on an untested OS bailing out") }
	}
	# WARNING
	# We specify global path for every exec command in this class here
	Exec {
		path => $exec_path
	}

}
