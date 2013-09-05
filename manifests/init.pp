# = Class: solr
#
# This class can be used to install solr with the default server and settings.
#
# == Requires:
#
# curl
#
# == Sample Usage:
#
# include "solr"
class solr () {
  include solr::jetty
}
