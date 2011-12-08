# Dell Facter module
#
# Author: Mikael Fridh <frimik@gmail.com>
# Date: 2011-11-24
# 
# this is a rather substantial rewrite of the camptocamp puppet module
# https://github.com/camptocamp/puppet-dell
#
# The regex matching has been ripped out completely and replaced with
# some xpath expressions from Nokogiri. Unfortunately this means another
# dependency on Nokogiri but it's a decent compromise.
#

require 'net/http'
require 'uri'
require 'nokogiri'

def fetch(uri, limit = 2)
  raise ArgumentError, 'HTTP redirect too deep' if limit == 0

  scheme = uri.scheme
  host = uri.host
  response = Net::HTTP.get_response(uri)
  case response
  when Net::HTTPSuccess     then response.body
  when Net::HTTPRedirection then
    Facter.debug("warranty.rb: redirection to #{response['location']}")
    uri = URI.parse(response['location'])
    uri.scheme = scheme unless uri.scheme
    uri.host = host unless uri.host
    uri = URI.parse(uri.scheme + '://' + uri.host + response['location'])
    fetch(uri, limit -1)
  else
    response.error!
  end
end

def fetch_page(tag)

  cache = "/var/tmp/dell-warranty-#{tag}.fact"
  html = nil
  url_string = 'http://support.dell.com/support/topics/global.aspx/support/my_systems_info/details?c=us&l=en&ServiceTag=' + tag

  # fetch from cache if newer than 5 days.
  if File.exists?(cache) and Time.now < File.stat(cache).mtime + 432000
    Facter.debug('warranty.rb: Cache file is fresh: ' + File.stat(cache).mtime.asctime)
    file = File.new(cache, "r")
    html = file.read
    file.close
  else
    Facter.debug('warranty.rb: Cache file not found or stale')

    begin
      Facter.debug("warranty.rb: fetching url: #{url_string}")
      html = fetch(URI.parse(url_string))
    rescue StandardError => error
      $stderr.print "%s in %s\n" % [error, __FILE__]
    end

    # if page got downloaded successfully
    if html and not html.empty?
      # store html in cache
      file = File.new(cache, "w")
      file.puts html
      file.close
    end
  end

  html
end

if Facter.value(:id) == 'root' and
   Facter.value(:is_virtual) == 'false' and
   Facter.value(:manufacturer) =~ /dell/i

  tag = Facter.value(:serialnumber)

  Facter.debug('warranty.rb: fetching page')
  html = fetch_page(tag)

  doc = Nokogiri::HTML(html)
  Facter.debug('warranty.rb: xpath expression')
  rows = doc.xpath('//table[@class="contract_table"]/tr[2]//td')

  Facter.add('warranty_description') do
    setcode do
      rows[0].content
    end
  end

  Facter.add('warranty_provider') do
    setcode do
      rows[1].content
    end
  end

  Facter.add('warranty_start') do
    setcode do
      rows[2].content
    end
  end

  Facter.add('warranty_end') do
    setcode do
      rows[3].content
    end
  end

  Facter.add('warranty_days_left') do
    setcode do
      rows[4].content
    end
  end

end
