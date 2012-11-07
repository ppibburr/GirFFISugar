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
v.add bb=Gtk::Button.new("foo",true)
assert bb.get_label == "foo","should have label set to 'foo'"
v.add Gtk::Button.new

w = Gtk::Window.new("Hello")
Gtk::Settings.get_default.gtk_auto_mnemonics = false
class W < Gtk::Window
  def initialize
    super "world"
    mb = Gtk::MenuBar.new
    ["_File","_Edit","_Help"].each do |mn|
      mi = Gtk::MenuItem.new(mn,true)
      mi.set_submenu sm=Gtk::Menu.new
      sm.append Gtk::MenuItem.new("No Underline")
      mb.append mi
    end
    
    v = Gtk::VBox.new
    v.pack_start mb,false,true,0
    v.add Gtk::Button.new_with_label("Hi")
    v.add Gtk::Label.new("Fo_o",true)
    v.add Gtk::Button.new("_Bar",true)
    v.add Gtk::Image.new
    v.add Gtk::Image.new(Gtk::STOCK_OPEN,Gtk::IconSize[:menu])
    v.add Gtk::Image.new(Gtk::STOCK_QUIT,:dnd)
    v.add Gtk::Image.new("nonesuch.png")
    v.add Gtk::Entry.new "text"
    v.add n=Gtk::Notebook.new
    v.add Gtk::Label.new
    v.add Gtk::Label.new nil
    n.append_page Gtk::Frame.new
    n.append_page Gtk::Frame.new,"Foo"
    n.append_page Gtk::Frame.new,Gtk::Button.new("Bar")
    add v
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
ww.show_all
ww.signal_connect "delete-event" do Gtk.main_quit end
Gtk.main

