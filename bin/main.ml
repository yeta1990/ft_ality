let () = 
  print_endline Lib.B.greet;

  let file = "moves" in

  let fd = open_in file in
    let line = Lib.Readfile.get_next_line fd in 
      List.iter (Printf.printf "%s") line;
      flush stdout;
