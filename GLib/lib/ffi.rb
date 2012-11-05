module GLib::Lib
  callback :GSourceFunc,[:pointer,:pointer],:bool
  # Timeout
  attach_function :g_timeout_add,[:uint,:GSourceFunc,:pointer],:uint
  attach_function :g_timeout_add_full,[:int,:uint,:GSourceFunc,:pointer,:pointer],:uint
  # Idle
  attach_function :g_idle_add,[:GSourceFunc,:pointer],:uint
  attach_function :g_idle_add_full,[:int,:GSourceFunc,:pointer,:pointer],:uint
  
  # GList
  attach_function :g_list_nth_data,[:pointer,:int],:pointer
  attach_function :g_list_length,[:pointer],:int
end