require 'rubygems'
require 'minitest/spec'
require 'minitest/autorun'
require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'gir_ffi-sugar'
