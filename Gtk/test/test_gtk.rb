require 'gir_ffi'
GirFFI.setup(:Gtk,'2.0')
require File.join(File.expand_path(File.dirname(__FILE__)),"..","gtk.rb")
require File.join(File.expand_path(File.dirname(__FILE__)),"..","..","GLib","glib.rb")
require File.join(File.expand_path(File.dirname(__FILE__)),"..","..","GObject","gobject.rb")
Gtk.init []
v = Gtk::VBox.new false,0
v.add Gtk::Button.new
v.add Gtk::Button.new
raise "Expected Array" if !(a=v.children).is_a?(Array)
x,y = a[0],a[1]
a[0] = y
a[1] = x
raise "Should not operate on the list via the Array!" if v.get_children[0] == y

