require File.join(File.dirname(__FILE__),"ffi.rb")



module Gtk
  load_class :Container
  class Gtk::Container
    setup_methods! if !ARGV[0] # retains our overides
    if ARGV[0]
     _setup_instance_method("get_children")
     _setup_instance_method("foreach")
    end
    # ruby-gtk2 returns Array, it may be operated on, yet does not effect the list.
    # we'll do the same ...
    alias :get_children_ :get_children
    def get_children
      get_children_().map do |child|
	# get the GObject of gpointer, child
	GObject::Object.wrap(FFI::Pointer.new(child))
      end
    end
    
    # Ruby-Gtk2 compatibility
    alias :each :foreach
    def forall &b
      Gtk::Lib.gtk_container_forall(self,(Proc.new do |child|
        yield GObject::Object.wrap(FFI::Pointer.new(child))                                    
      end))
    end
    alias :each_forall :forall
  end
end

module Gtk
  load_class :Window
  class Window
    use_constructor_overides()
    
    add_constructor Symbol do |type|
      new__ type
    end
    
    add_constructor Integer do |type|
      new__ type
    end
    
    add_constructor String do |title|
      w=new__(0)
      w.set_title(title)
      w
    end
  end
  
  load_class :Button
  class Button
    use_constructor_overides()
    
    add_constructor do
      new__
    end
    
    add_constructor String do |label|
      b = new__
      b.set_label label
      b
    end
  end
end
p Gtk::Button.constructors