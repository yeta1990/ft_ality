

let () = 
  match Tsdl.Sdl.init Tsdl.Sdl.Init.video with
  | Error (`Msg _) -> Tsdl.Sdl.log "no"
  | Ok () -> 
    match Tsdl.Sdl.create_window ~w:800 ~h:600 "Hello" Tsdl.Sdl.Window.windowed with
    | Error (`Msg _) -> Tsdl.Sdl.log "nooo"
    | Ok window -> 
      Tsdl.Sdl.delay 3000l;
      Tsdl.Sdl.destroy_window window;

      Tsdl.Sdl.quit()

