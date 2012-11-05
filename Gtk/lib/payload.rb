require File.join(File.dirname(__FILE__),"ffi.rb")

module Gtk
  load_class :Container
  class Gtk::Container
    # ruby-gtk2 returns Array, it may be operated on, yet does not effect the list.
    # we'll do the same ...
    alias :get_children_ :get_children
    def get_children
      get_children_().map do |child|
	# get the GObject of gpointer, child
	GirFFI::ArgHelper.object_pointer_to_object(FFI::Pointer.new(child))
      end
    end
    
    # Ruby-Gtk2 compatibility
    alias :each :foreach
    def forall &b
      Gtk::Lib.gtk_container_forall(self,(Proc.new do |child|
        yield GirFFI::ArgHelper.object_pointer_to_object(FFI::Pointer.new(child))                                    
      end))
    end
    alias :each_forall :forall
  end
end