require File.expand_path('test_helper.rb', File.dirname(__FILE__))

$ok = false

GirFFISugar.sugar(:GLib)

describe GLib::List do
  list = GLib::List.new(nil)
  main = GLib::MainLoop.new(nil,true)
  list = list.append(main)
  describe "#length" do
    it "should equal the length of the list" do
      assert list.length==1
    end
  end
  
  describe "#nth_data" do
    it "should return a pointer at index" do
      assert_kind_of(FFI::Pointer,list.nth_data(0))
    end 
  end
  
  describe "#max" do
    it "should return an address, Integer" do
      assert_kind_of(Integer,list.max)
    end 
  end 
  
  describe "value at index 0" do
    it "should be able to wrap as GLib::MainLoop" do
      ml = GLib::MainLoop.wrap(list.nth_data(0))
      assert_instance_of GLib::MainLoop,ml
    end
  end
  
  describe "value of max" do
    it "should be able to wrap as GLib::MainLoop" do
      ml = GLib::MainLoop.wrap(FFI::Pointer.new(list.max))
      assert_instance_of GLib::MainLoop,ml
    end
  end  
end
