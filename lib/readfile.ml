let get_next_line fd = 
  try
    let line = input_line fd in
    (*flush stdout;*)
    (*get_next_line fd;*)
    String.split_on_char ' ' line
  with _ -> 
    close_in_noerr fd;
    ["";""]
    

