require File.join(File.dirname(__FILE__),"ffi.rb")
require File.join(File.dirname(__FILE__),"subclass_normalize.rb")

module GObject
  load_class :Object
  class Object
    # set's up the farthest ancestor's method
    # q, method name, String|Symbol
    # b method body, optional, if passed, defines method q
    def self.overide q,&b
      a = ancestors.find_all do |a|
	a.instance_methods.index(q)
      end.last
      a._setup_instance_method(q.to_s)
      define_method(q,&b) if b
    end
  end
end