$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
#require 'throat_punch'
require "test/unit"
require 'ostruct'
require 'flexmock/test_unit'
require File.dirname(__FILE__) + '/../lib/import_rmilk'