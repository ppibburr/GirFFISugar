require File.join(File.dirname(__FILE__),"ffi.rb")

module GLib
  # g_timeout_add
  # g_timeout_add_full
  # GLib::Timeout.add, GLib::Lib.g_timeout_add, is Ruby-Gtk2 compatible
  class Timeout
    def self.add int,&b
      GLib::Lib.g_timeout_add int,b,nil
    end
 
    def self.add_full pl,int,&b
      GLib::Lib.g_timeout_add_full pl,int,b,nil,nil
    end
  end
  
  # g_idle_add
  # g_idle_add_full
  # GLib::Idle.add, GLib::Lib.g_idle_add, is Ruby-Gtk2 compatible  
  class Idle
    def self.add int,&b
      GLib::Lib.g_idle_add b,nil
    end
 
    def self.add_full pl,int,&b
      GLib::Lib.g_idle_add_full pl,b,nil,nil
    end
  end
  
  load_class :List
  # GLib::List
  # NOTE: stores elements as List's
  #       Elements refer to gpointer's
  #       item = GLib.g_list_nth_data(list,index) # will return FFI::Pointer
  #       GirFFI::ArgHelper.object_pointer_to_object(item) # will convert it to GObject (will upcast), if it is a GObject (or subclass)
  #
  #       item = aList.max(or from anywhere in Enumerable's mixin's) will be an Integer
  #       item = FFI::Pointer.new(item) # cast like above,
  class List
    # i, Integer, index in list
    # returns FFI::Pointer of value at index
    def nth_data i
      pt = GLib::Lib.g_list_nth_data self,i
    end
    
    def length
      GLib::Lib::g_list_length self
    end
    
    alias :size :length
    
    def << value
      append value
    end
  end  
end