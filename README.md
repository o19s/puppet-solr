puppet-solr
===========

Puppet module for installing solr with a stand alone jetty server.  The server will default to port 8983 and store it's data in /var/lib/solr.  Configuration files can be found at /etc/solr.  

This install has been tested on:

* Ubuntu 12.04

Using this manifest
-----------

To include solr in your manifests.

1. Check out this repository in your modules directory
2. Add the following to your base manifest (Note that including an appropriate JDK is left to you):

```pp
package { 'default-jdk': }

include solr
```

Working with Solr Cloud
-----------------------

```pp
package { 'default-jdk' }

class {'solr':
  number_of_cloud_shards => 2,
  zookeeper_hosts        => ["example.com:2181", "anotherserver.org:2181/alternate_root"]
}
```
