# Sets up the Dell OMSA repository and installs Dell OpenManage
# packages. Also includes a nice facter plugin which fetches warranty
# information from the Dell website.
#
# Including this module on a non-Dell machine will result in a no-op.
#
# == Dependencies
#
# The warranty fact module requires rubygem-nokogiri to work.
# It's recommended you have atleast package { 'rubygem-nokogiri': }
# defined somewhere in your manifests. I recommend somewhere in your
# base manifests.
#
# == Parameters
#
# N/A
#
# == Variables
#
# N/A
#
# == Examples
#
#   # Simple version:
#   include dell
#
#   # If you have more than one vendor:
#   class hardware {
#     case $manufacturer {
#       /Dell/ => { include dell }
#       /HP/   => { include hp }
#     }
#   }
#
#   # To only include the openmanage part:
#   include dell::openmanage
#
# == Authors
#
# Mikael Fridh <frimik@gmail.com>
#   -- facter modules are based on
#   -- http://github.com/camptocamp/puppet-dell
#   -- the rest is actually a clean rewrite because the original didn't
#   -- suit me that well.
#
class dell {
  if $manufacturer =~ /Dell/ {
    include dell::openmanage
    include dell::firmware
  }
}

