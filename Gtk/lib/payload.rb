require File.join(File.dirname(__FILE__),"ffi.rb")

module Gtk
  setup_method "init"
  class << self
    alias :init_ :init
  end  
  def self.init a=[File.basename($0)]
    init_ a
  end
  load_class :Container
  class Gtk::Container
    setup_methods! 
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

  [:Button,:Label,:MenuItem,:Frame].each do |d|
    load_class d
    const_get(d).class_eval do
      use_constructor_overides()
      
      add_constructor do
	if d==:Frame or d == :Label
	  new__(nil)
	else
	  new__
	end
      end
      
      if d == :Label or d == :Frame
	add_constructor NilClass do |null|
	  new__(null)
	end
      end
      
      add_constructor String,TrueClass do |label,bool|
	new_with_mnemonic(label)
      end if d != :Frame
      
      if d == :Label
	def self.new_with_label text
	  l = new__(text)
	end
      end
      
      add_constructor String do |label|
	if d == :Frame
	  new__(label)
	else
	  new_with_label(label)
	end
      end
    end
  end
  
  [:HBox,:VBox].each do |box|
    load_class box
    const_get(box).class_eval do
      use_constructor_overides()
      
      add_constructor do
	new__ false,0
      end
      
      add_constructor FalseClass, Integer do |bool,int|
	new__ bool,int
      end
      
      add_constructor TrueClass, Integer do |bool,int|
	new__ bool,int
      end    
    end
  end
  
  load_class :Image
  class Image
    use_constructor_overides
    
    add_constructor String do |file|
      new_from_file(file)
    end
    
    add_constructor Gdk::Pixmap do |pixmap|
      new_from_pixmap(pixmap)
    end
    
    add_constructor do
      new__
    end
    
    add_constructor String,Integer do |stock_id,size|
      new_from_stock(stock_id,size)
    end
    
    add_constructor String,Symbol do |stock_id,size|
      new_from_stock(stock_id,size)
    end
  end  
  
  load_class :TextView
  class TextView
    use_constructor_overides
      
    add_constructor Gtk::TextBuffer do |buffer|
      new_with_buffer buffer
    end
      
    add_constructor do
      new__
    end
  end
    
  load_class :Entry
  class Entry
    use_constructor_overides
      
    add_constructor do
      new__
    end
      
    add_constructor String do |text|
      e = new__
      e.set_text text
      e
    end
  end
  
  load_class :Notebook
  class Notebook
    setup_methods!
    [:append_page,:prepend_page].each do |m|
      define_method m do |pg,l=nil|
	if l.is_a?(String) or l.is_a?(Symbol)
	  l = Gtk::Label.new(l)
	end
        Gtk::Lib.send("gtk_notebook_#{m}",self,pg,l)
      end
    end
  end
  
  load_class :ScrolledWindow
  class ScrolledWindow
    use_constructor_overides
    
    add_constructor do
      new__(nil,nil)
    end
    
    add_constructor NilClass,NilClass do |a,b|
      new__(a,b)
    end
    
    add_constructor Gtk::Adjustment,Gtk::Adjustment do |a,b|
      new__(a,b)
    end
  end
end

# TODO: figure out why this wont work if done at head of file
module Gtk
  IconSize_ = const_get(:IconSize)
  const_set(:IconSize,Class.new).class_eval do
    class << self
      def [] k
	IconSize_[k]
      end
    end
    def self.const_missing c
      self[c.downcase]
    end
  end
  
  class Stock
    def self.const_missing c
      Gtk.const_get(:"STOCK_#{c}")
    end
  end
end 