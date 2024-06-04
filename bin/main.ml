module Sdl = Tsdl.Sdl

let split_keys_and_descriptions s =
  let delimiter = " = " in
    let len = String.length delimiter in
      try
        let index = String.index_from s 0 '=' in
        Printf.printf ("ee %d\n") index;
        let keys_raw = String.sub s 0 (index - 1) in
        let key_description = String.sub s (index + len - 1) (String.length s - index - len + 1) in
        let keys = String.split_on_char '+' keys_raw in 
          (keys, String.trim key_description)
      with Not_found -> exit 1 (*([], "")*)
  
let rec print_keys_list = function
| [] -> ()
| [last] -> print_string last
| first :: rest -> print_string first; print_string " + "; print_keys_list rest;
flush stdout

let print_current_state lst = 
  print_string "["; print_keys_list lst; print_string "]\n"

let print_key_and_description lst = 
    let (keys, keys_description) = lst in 
    print_keys_list keys;
    print_string " -> ";
    print_string keys_description; 
    print_string "\n"

    (*Printf.printf "%d\n" (Sdl.get_key_from_name "W"); flush stdout;*)

let grammar_file_to_list file_name = 
  let ic = open_in file_name in
  let rec read_lines() =
    try
      let line = input_line ic in 
        let key_and_description = split_keys_and_descriptions line in 
          key_and_description :: read_lines() 
    with End_of_file -> 
      close_in ic;
      []
    in 
    read_lines()

    (*
let print_pressed_keys lst = 
    List.iter print_string lst; print_newline (); flush stdout
   *)  
let rec get_description_by_key grammar current_state = 
  match grammar with
  | (key, description) :: tail -> 
      if key = current_state then (true, description) else get_description_by_key tail current_state 
  | [] -> 
      (false, "") 

let update_state current_state pressed_key states =
  let key_exists key =
    List.exists (fun (k, _) -> k = key) states in
  if key_exists (current_state @ [pressed_key]) then
    current_state @ [pressed_key]
  else if List.length current_state = 0 then []
  else if key_exists ([List.hd (List.rev current_state)] @ [pressed_key]) then
    (List.rev (List.tl (List.rev current_state))) @ [pressed_key]
  else
    [pressed_key]

let validate_key_combination grammar = 
  let (keys,___) = grammar in 
  if List.for_all (fun key -> Sdl.get_key_from_name key <> 0) keys
    then `Ok else `Error

let validate_grammar_keys grammar = 
    let results  = List.map validate_key_combination grammar in
      if List.for_all (fun res -> res == `Ok) results then () else (Sdl.log "Bad key provided in file"; exit 1)

let () =
  match Sdl.init Sdl.Init.video with
  | Error (`Msg e) -> Sdl.log "No se pudo inicializar SDL: %s" e; exit 1
  | Ok () -> ();

  let grammar = grammar_file_to_list "moves" in
    ignore(validate_grammar_keys grammar);
  (*Printf.printf "%d\n" (Sdl.get_key_from_name "W_"); flush stdout;*)
  
    print_string "[ft_ality]\n";
    print_string "Key -> Name of the movement or combo\n";
    print_string "-----------\n";
    List.iter print_key_and_description grammar;
    print_string "-----------\n"; flush stdout;
    let window =
      match Sdl.create_window ~w:640 ~h:480 "ft_ality" Sdl.Window.shown with
      | Error (`Msg e) -> Sdl.log "No se pudo crear la ventana: %s" e; exit 1
      | Ok win -> win
    in
    
    let rec event_loop (pressed_keys) =
      let event = Sdl.Event.create () in
      match Sdl.wait_event (Some event) with
      | Error (`Msg e) -> Sdl.log "Error esperando un evento: %s" e; Sdl.destroy_window window; Sdl.quit ()
      | Ok () ->
        let event_type = Sdl.Event.get event Sdl.Event.typ in
        match Sdl.Event.enum event_type with
        | `Quit -> Sdl.log "Evento de salida recibido, cerrando."; Sdl.destroy_window window; Sdl.quit ()
        | `Key_down -> 
          let keycode = Sdl.Event.get event Sdl.Event.keyboard_keycode in
          let keyname = Sdl.get_key_name keycode in
          if keyname = "Escape" then (Sdl.destroy_window window; Sdl.quit(); exit 0); (* remove before the evaluation*)
          let current_state = update_state pressed_keys keyname grammar in 
            let (found, description) = get_description_by_key grammar current_state in  
              if found then (print_current_state current_state; print_string description; print_string "\n\n";flush stdout) else print_string ("[" ^ keyname ^ "]: key not found, state reset\n"); flush stdout ;
              event_loop (current_state)
        | _ -> event_loop (pressed_keys)  
    in
    event_loop ([]);
  Sdl.quit ()