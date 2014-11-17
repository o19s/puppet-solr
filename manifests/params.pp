class solr::params {

  case  $::osfamily {
    'Debian', 'Redhat': {
      $solr_version = '4.10.2'
      $solr_install = '/opt/solr'
      # Needs to be full path to apache root, no slash at the end.
      $apache_mirror = 'ftp://mirror.reverse.net/pub/apache'
      $zookeeper_hosts = ''
      $exec_path = '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin'
      $java_home = '/usr/lib/jvm/default-java'
      $core_name = 'default'
      $solr_home = '/var/lib/solr'
    }
     default: { fail("Running on an untested OS bailing out") }
  }
  # WARNING
  # We specify global path for every exec command in this class here
  Exec {
    path => $exec_path
  }
}
