require 'gir_ffi'
GirFFI.setup(:Gtk,'2.0')
require File.join(File.expand_path(File.dirname(__FILE__)),"..","gobject.rb")
require File.join(File.expand_path(File.dirname(__FILE__)),"..","..","GLib","glib.rb")
require File.join(File.expand_path(File.dirname(__FILE__)),"..","..","Gtk","gtk.rb")
Gtk.init []

module GObject
  load_class :Object
  class Object
    def self.overide q,&b
      a = ancestors.find_all do |a|
	a.instance_methods.index(q)
      end.last
      a._setup_instance_method(q.to_s)
      define_method(q,&b) if b
    end    
  end
end

# Should be able to declare subclass
# normally, and modifiy initialize
class F < Gtk::VBox
  def initialize
    super false,0
  end
  
  # need to ensure the method is setup
  # so our redefinition will not be overidden
  # redefine a method
  # and be able to use super
  overide :add do
    super Gtk::Button.new
  end
end

# Subclass subclasses
class N < F;
  def initialize
    super
  end
  
  # no need to setup a method setup in the superclass
  # and we can redefine it, and the super chain works
  def add
    super
    return 77
  end
end

def assert bool,msg
  if !bool
    raise msg
  end
end

v=F.new
v.add # should add a button
v.add # should still add a button
v.children.each do |c|
  assert c.is_a?(Gtk::Button),"child should be a Gtk::Button"
end
assert(v.children.length == 2, "should have 2 children")

v=N.new
assert v.add == 77, "method redefinition should return 77"
assert v.add == 77, "method redefinition should still return 77"
v.children.each do |c|
  assert c.is_a?(Gtk::Button),"child should be a Gtk::Button"
end
assert(v.children.length == 2, "should have 2 children")

b = Gtk::VBox.new false,0
b.add(v)

assert b.children[0] == v, "first child should equal v"
assert b.children[0].class == N, "first childs class should be N"

class W < Gtk::Window
  def initialize
    super 0
  end
end

w = W.new

w.signal_connect("expose-event") do |*o|
  assert o[0] == w, "passed parameter 0 should be equal w"
  Gtk.main_quit
end

w.show_all

Gtk.main