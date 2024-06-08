module Sdl = Tsdl.Sdl

let update_state current_state pressed_key states =
  if Grammar.key_exists (current_state @ [pressed_key]) states then
    current_state @ [pressed_key]
  else if Grammar.key_exists current_state states then [pressed_key]
  else if List.length current_state = 0 then []
  else
    [pressed_key]

let handle_event grammar pressed_keys =
  let event = Sdl.Event.create () in
    match Sdl.wait_event (Some event) with
    | Error (`Msg e) ->
        Sdl.log "Error esperando un evento: %s" e;
        (false, [])
    | Ok () ->
        let event_type = Sdl.Event.get event Sdl.Event.typ in
        match Sdl.Event.enum event_type with
        | `Quit ->
            Sdl.log "Evento de salida recibido, cerrando.";
            (false, [])
        | `Key_down ->
            let keycode = Sdl.Event.get event Sdl.Event.keyboard_keycode in
            let keyname = Sdl.get_key_name keycode in
            if keyname = "Escape" then (
              (false, [])
            )
            else 
              let current_state = update_state pressed_keys keyname grammar in
              let (found, description) = Grammar.get_description_by_key grammar current_state in
              if found then (
                Grammar.print_current_state current_state;
                print_string (description ^ "\n\n");
              ) else if Grammar.key_exists current_state grammar then ( (*final state and starting a new one*)
                Grammar.print_current_state current_state;
                let (_, description) = Grammar.get_description_by_key grammar [keyname] in
                print_string (description ^ "\n\n");
              ) else (
                print_string ("[" ^ keyname ^ "]: key not found, state reset\n");
              );
              flush stdout;
              (true, current_state)
        | _ -> (true, pressed_keys)

let rec event_loop grammar pressed_keys =
  let (continue_looping, new_pressed_keys) = handle_event grammar pressed_keys in
    if continue_looping then event_loop grammar new_pressed_keys
