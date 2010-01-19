#this shit is required to init rufus lib
if !ENV["RTM_AUTH_TOKEN"] then
  ENV["RTM_API_KEY"] = "stub"
  ENV["RTM_SHARED_SECRET"] = "stub"
  ENV["RTM_FROB"] = "stub"
  ENV["RTM_AUTH_TOKEN"] = "stub"
end

require 'rubygems'
require 'rufus/rtm'
require "require_all"
require 'pstore'
require_all File.dirname(__FILE__)  + '/rmilk/*.rb'
