let other () = 
  print_endline Lib.B.greet;

  let file = "moves" in

  let fd = open_in file in
    let line = Lib.Readfile.get_next_line fd in 
      List.iter (Printf.printf "%s") line;
      flush stdout

let window () = 
  try
    Sdl.init[`VIDEO];
    ignore (Sdl.Render.create_window_and_renderer ~width:0 ~height:0 ~flags:[Sdlwindow.Borderless]);
    at_exit Sdl.quit
  with
   | e -> raise e

let () = window ()