class solr::params {

  case  $::osfamily {
    'Debian', 'Redhat': {
      $solr_version = '4.5.1'
      $distro_home = '/opt/solr' # The distrobution dled from an apache mirror lives here 
      # needs to be full path to an apache mirrors root
      $apache_mirror = "apache.petsads.us" #because this is sometimes depressingly slow
      $zookeeper_hosts = ""
      $exec_path = '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin'
      $java_home = '/usr/lib/jvm/default-java'
      $core_name = 'collection1'
    }
     default: { fail("Running on an untested OS bailing out") }
  }

  $solr_home = "${distro_home}/current/example/solr"
  # WARNING
  # We specify global path for every exec command in this class here
  Exec {
    path => $exec_path
  }
}
