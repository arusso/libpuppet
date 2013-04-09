#!/usr/bin/ruby
require 'rubygems'
require 'yaml'
require 'puppet'
require 'restclient'

# Simple ruby library for the Puppet 2.6.x API
class LibPuppet
  
  # Initialize the LibPuppet class
  def initialize(master)
    # set some instance vars
    @_server = master
    
  end
  
  # get request
  def get(uri,raw=false)
    raw = self._get_raw(uri)  # get the raw response
    
    if raw==true  # return the raw output
      return raw
    else    # return the object
      return YAML.load(raw)
    end  
  end
  
  # Returns a list of hosts with the given fact
  #
  def nodes_with_fact(factname)
    get("/production/facts_search/#{factname}",false)            
  end

  # Returns a list of all nodes
  #
  # we assume all nodes have a processor (safe, right?)
  def all_nodes
    get("/production/facts_search/search?facts.processorcount.ge=0",false)
  end

  def node(name, env="production")
    get("/#{env}/facts/#{name}",false)
  end
  
    # get raw response
  def _get_raw(uri)
      RestClient.get "https://#@_server:8140#{uri}", { :accept => 'Yaml' }
  end
end # LibPuppet

