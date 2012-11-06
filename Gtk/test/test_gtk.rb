require 'gir_ffi'
GirFFI.setup(:Gtk,'2.0')
require File.join(File.expand_path(File.dirname(__FILE__)),"..","..","GLib","glib.rb")
require File.join(File.expand_path(File.dirname(__FILE__)),"..","..","GObject","gobject.rb")
require File.join(File.expand_path(File.dirname(__FILE__)),"..","gtk.rb")

def assert bool,msg
  raise msg unless bool
end

Gtk.init []
Gtk::VBox.new
v = Gtk::VBox.new false,0
v.add bb=Gtk::Button.new("foo")
assert bb.get_label == "foo","should have label set to 'foo'"
v.add Gtk::Button.new

w = Gtk::Window.new("Hello")

class W < Gtk::Window
  def initialize
    super "world"
  end
end
ww = W.new
Gtk::VBox.new
class Q < Gtk::Window
end
www=Q.new("Ok!")

class L < W
  def initialize str
    super()
  end
end
wwww = L.new("OO")

assert [wwww.get_title,www.get_title,ww.get_title,w.get_title] == ["world","Ok!","world","Hello"],"should have titles set"

raise "Expected Array" if !(a=v.children).is_a?(Array)
x,y = a[0],a[1]
a[0] = y
a[1] = x
raise "Should not operate on the list via the Array!" if v.get_children[0] == y

