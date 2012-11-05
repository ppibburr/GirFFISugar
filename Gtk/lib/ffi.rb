module Gtk::Lib
  callback :GtkCallback,[:pointer,:pointer],:void
  attach_function :gtk_container_forall,[:pointer,:GtkCallback],:void
end