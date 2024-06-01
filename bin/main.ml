
let rec wait_for_escape () =
    match Sdlevent.wait_event () with
    | KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_ESCAPE} ->
        print_endline "You pressed escape! The fun is over now."
    | event ->
        print_endline (Sdlevent.string_of_event event);
        wait_for_escape ()



let main () =
  Sdl.init [`VIDEO];
  at_exit Sdl.quit;
  
  wait_for_escape ()

let _ = main ()