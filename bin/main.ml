let printf = Format.printf

let rec poll_keys () =
  let open Sdlevent in
  if has_event () then begin
    match wait_event () with
    | KEYDOWN {keysym=key} -> printf "keydown '%c'@." (Sdlkey.char_of_key key)
    | KEYUP {keysym=key} -> printf "keyup '%c'@." (Sdlkey.char_of_key key)
    | _ -> Sdltimer.delay 5
  end;
  poll_keys ()

let () =
  Sdl.init [`VIDEO];
  (* Sdlkey.enable_key_repeat (); *)
  poll_keys ()