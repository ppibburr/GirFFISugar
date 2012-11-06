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

module ConstructorOveride
  def self.included cls
    cls.class_eval do
      def self.add_constructor *signature,&b
	@constructors << [signature,b]
      end

      @constructors = []
      
      def self.constructors
	@constructors
      end
      
      def self.use_constructor_overides
	_setup_method :new.to_s
        
	class << self
          alias :new__ :new
        end
	
        def self.new *o	  
	  ca = @constructors.find_all do |cs|
	    cs[0].length == o.length
	  end
	  
	  c = ca.find do |cs|
	    a = []
	    cs[0].each_with_index do |q,i|
	      p o[i],q
	      a << o[i].is_a?(q)
	    end
	    !a.index(false)
	  end
	  
	  if c
	    instance_exec(*o,&c[1])
	  else
	    possibles = @constructors.map do |c| c[0] end
	    buff = ["possible constructors are:\n"]
	    
	    possibles.each do |pc|
	      buff << "#{self}.new(#{pc.join(", ")})"
	    end
	    
	    raise "no constructor for signature found\n#{buff.join("\n")}"
	  end
	end
      end
    end
  end
end

module GObject
  load_class :Object
  class Object
    class << self
      alias :inherited_ :inherited
    end
    
    def self.inherited cls
      result = inherited_(cls)
      cls.class_eval do
	include ConstructorOveride
      end
      result
    end
  end
end
