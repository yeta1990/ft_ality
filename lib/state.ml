module Sdl = Tsdl.Sdl

let update_state current_state pressed_key states =
  if Grammar.key_exists (current_state @ [pressed_key]) states then
    current_state @ [pressed_key]
  else if Grammar.key_exists current_state states then [pressed_key]
  else if List.length current_state = 0 then []
  else
    [pressed_key]

let rec print_keys_list = function
| [] -> ()
| [last] -> print_string last
| first :: rest -> print_string first; print_string " + "; print_keys_list rest;
flush stdout

let print_current_state lst = 
  print_string "["; print_keys_list lst; print_string "]\n"

let handle_event grammar pressed_keys =
  let event = Sdl.Event.create () in
    match Sdl.wait_event (Some event) with
    | Error (`Msg e) ->
        Sdl.log "Error waiting event: %s" e;
        (false, [])
    | Ok () ->
        let event_type = Sdl.Event.get event Sdl.Event.typ in
        match Sdl.Event.enum event_type with
        | `Quit ->
            print_string "Exit event received, closing the program."; flush stdout;
            (false, [])
        | `Key_down ->
            let keycode = Sdl.Event.get event Sdl.Event.keyboard_keycode in
            let keyname = Sdl.get_key_name keycode in
            if keyname = "Escape" then (
              (false, [])
            )
            else 
              let current_state = update_state pressed_keys keyname grammar in
              let (found, description) = Grammar.get_description_by_key grammar current_state [] in
              if found then (
                print_current_state current_state;
                Grammar.print_descriptions description;
               ) else if Grammar.key_exists current_state grammar then ( (*final state and starting a new one*)
                print_current_state current_state;
                let (_, description) = Grammar.get_description_by_key grammar [keyname] [] in
                Grammar.print_descriptions description;
              ) else (
                print_string ("[" ^ keyname ^ "]: key not found, state reset\n");
              );
              flush stdout;
              (true, current_state)
        | _ -> (true, pressed_keys)

let rec event_loop grammar pressed_keys =
  let (continue_looping, new_pressed_keys) = handle_event grammar pressed_keys in
    if continue_looping then event_loop grammar new_pressed_keys
