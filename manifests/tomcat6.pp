# = Class : solr::tomcat6
#
# This class will create a Tomcat 6 installation with the solr
# servelet loaded
#
# == Parameters
#
# $tomcat6_home:: where to install tomcat. Default is /opt/tomcat6
#
# $exec_path:: path used to find execs required for installing tomcat. 
#   Default is '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin'
#
# $tomcat6_version:: specific version of tomcat 6 to install. Default is
#   "6.0.37"
#
class solr::tomcat6(
  $tomcat6_home = '/opt',
  $exec_path = '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin',
  $tomcat6_version = "6.0.37"
){

  class solr {
    ensure => present
  }

  exec {
    path => $exec_path
  }

  exec { "wget tomcat":
    command => "wget --output-document=/tmp/apache-tomcat-${tomcat6_version}.tgz http://apache.petsads.us/tomcat/tomcat-6/v${tomcat6_version}/bin/apache-tomcat-${tomcat6_version}.tar.gz",
    creates => "${tomcat6_home}/tomcat-${tomcate_version}"
  } ->

  exec { "untar tomcat":
    command => "tar -xzf /tmp/apache-tomcat-${tomcat6_version}.tgz -C ${tomcat_home}",
    creates => "${tomcat6_home}/tomcat-${tomcate_version}"
  } ->

  file { "${tomcat6_home}/tomcat6":
    ensure => link,
    target => "/${tomcat6_home}/apache-tomcat-${tomcat_version}",
    owner  => solr
  } ->

  file { "/etc/init.d/tomcat6-solr":
    ensure => present,
    mode   => '0755',
    source => "puppet:///modules/solr/tomcat6"
  } ->

  file { "${tomcat6_home}/tomcat6/conf/Catalina/localhost/solr.xml":
    owner   => solr,
    ensure  => present,
    content => '<?xml version="1.0" encoding="utf-8"?>
<Context docBase="/etc/solr/solr.war" debug="0" crossContext="true">
  <Environment name="solr/home" type="java.lang.String" value="/etc/solr" override="true"/>
</Context>'
  }

  # prep required solr libs for tomcat
  exec { "cp /opt/solr/example/lib/ext/* ${tomcat6_home}/tomcat6/lib/":
    path => "/bin"
    creates => "${tomcat6_home}/tomcat6/lib/log4j-1.2.16.jar"
    require => [ Class['solr'], File["${tomcat6_home}/tomcat6"]]
  }

  # stage the solr war file for tomcat
  exec { "cp /opt/solr/dist/solr-4.3.0.war /etc/solr/solr.war":
    path => "/bin"
    creates => "/etc/solr/solr.war"
    require => Exec["cp /opt/solr/example/lib/ext/* ${tomcat6_home}/tomcat6/lib/"],
  }

  service { "tomcat6-solr":
    ensure  => running,
    require => Exec["cp /opt/solr/dist/solr-4.3.0.war /etc/solr/solr.war"]
  }

}

