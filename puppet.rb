#!/usr/bin/ruby
require 'rubygems'
require 'yaml'
require 'puppet'

module Bobbie
  class PuppetLib
    
    # Initialize the PuppetLib class
    def initialize(master)
      # set some instance vars
      @_server = master
      
      # do we have a copy of the cert?
      if not File.exists?(File.dirname(__FILE__)+"/#{@_server}.pem")
        # get the puppet master ca
        @_ca_cert = %x[curl --insecure -H 'Accept: s' "https://#{@_server}:8140/production/certificate/ca" 2>/dev/null]
        # write cert to file
        File.open(File.dirname(__FILE__)+"/#{@_server}.pem",'w') {|f| f.write(@_ca_cert)}  # write our ca cert to file  
      end
    end
    
    # get node information
    def get(uri,raw=false)
      raw = self._get_raw(uri)  # get the raw response
      
      if raw==true  # return the raw output
        return raw
      else    # return the object
        return YAML.load(raw)
      end
      
    end
    
    # Returns a list of hosts with the given fact
    def hosts_with_fact(factname="inventory")
      get("/production/facts_search/#{factname}",false)            
    end
    
    # get raw response
    def _get_raw(uri)
      %x[curl -k -H 'Accept: yaml' https://#@_server:8140#{uri} 2>/dev/null]   
    end
  end # class PuppetLib
end # module Bobbie

