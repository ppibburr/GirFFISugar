require 'gir_ffi'
GirFFI.setup :GLib,'2.0'
require File.join(File.expand_path(File.dirname(__FILE__)),"..","glib.rb")
require File.join(File.expand_path(File.dirname(__FILE__)),"..","..","GObject","gobject.rb")
#GLib.type_init
TData = {}
TData[:cnt1] = 0
TData[:cnt2] = 0
TData[:cnt3] = 0

GLib::Timeout.add 100 do
  puts "in timeout"
  TData[:cnt1] += 1
  false
end

GLib::Timeout.add 100 do
  puts "in timeout"
  TData[:cnt3] += 1
  true
  if TData[:cnt3] == 5
    TData[:loop].quit
    false
  end
end

GLib::Idle.add do
  puts "in idle"  
  TData[:cnt2] += 1
  true
  if TData[:cnt2] > 3
    false
  end
end

module GirFFI
  class InPointer
    def self.from type, val
      return nil if val.nil?
      case type
      when :utf8, :filename
        from_utf8 val
      when :gint32, :gint8
        self.new val
      when :void
        ArgHelper.object_to_inptr val
	
      # adds the value
      # however, will result in a FFI::Pointer when retrieving
      when nil
	if val.respond_to?(:to_ptr) or val.respond_to?(:address)
	 return val
	end
	raise NotImplementedError
      else
        raise NotImplementedError
      end
    end
  end
end

def assert bool,msg
  if !bool
    raise msg
  end
end

glist = (GLib::List.new(nil))
main = GLib::MainLoop.new(nil,true)
TData[:loop] = main
glist = glist.append(main)
main1 = GLib::MainLoop.wrap glist.nth_data(0)

raise "expected 1 as length" if glist.length != 1
raise "main1 should be a wrapped GLib::MainLoop" if !main1.is_a?(GLib::MainLoop)

Thread.new do
  sleep(8)
  raise "main_loop should have exited"
end
main1.run()

assert TData[:cnt3] < 6, "g_main_loop_quit should have been already called"
assert TData[:cnt1] < 2, "should only ran once"
assert TData[:cnt2] < 5, "should not ran past 4, increments by 1"