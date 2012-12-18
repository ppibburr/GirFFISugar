if !Object.const_defined?(:GirFFI)
  begin
    require 'gir_ffi'
  rescue LoadError
    require 'rubygems'
    require 'gir_ffi'
  end
end

module GirFFISugar
  def self.sugar ns,version=nil
    require File.join(File.dirname(__FILE__),ns.to_s,ns.to_s.downcase+".rb")
  end
end
