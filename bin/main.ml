(* https://github.dev/dbuenzli/tsdl/blob/master/test/fmts.ml *)
module Sdl = Tsdl.Sdl


(*
let rec loop() = match Sdl.poll_event with
  | Sdl.get_key -> Printf.printf "eo"; loop();
  Some "a"
  *)
(*.create () in
  let rec loop() = match Sdl.wait_event (Some e) with
  | Error (`Msg e) -> Printf.printf "Not waiting for event %s" e; ()
  | Ok () ->
    match Sdl.Event.(get e keyboard_state) with
    | _ -> Printf.printf Sdl.get_scancode_name e; loop()
in
Sdl.start_text_input();
*)



let main () = 
  let inits = Sdl.Init.(video + events) in
  match Sdl.init inits with
  | Error (`Msg e) -> Tsdl.Sdl.log "Error: %s" e; exit 1
  | Ok () -> 
    match Sdl.create_window ~w:800 ~h:600 "Hello" Tsdl.Sdl.Window.input_focus with
    | Error (`Msg e) -> Tsdl.Sdl.log "Create window error: %s" e; exit 1
    | Ok window ->

    
      Sdl.pump_events ();
      Sdl.delay 3000l;
      Sdl.destroy_window window;
      Sdl.quit();
      exit 0

let () = main()