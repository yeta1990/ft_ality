open Tsdl

let split_keys_and_descriptions s =
  let delimiter = " = " in
    let len = String.length delimiter in
      try
        let index = String.index_from s 0 '=' in
        let keys_raw = String.sub s 0 (index - 1) in
        let key_description = String.sub s (index + len - 1) (String.length s - index - len + 1) in
        let keys = String.split_on_char '+' keys_raw in 
          (keys, String.trim key_description)
      with Not_found -> ([], "")
  
let rec print_keys_list = function
| [] -> ()
| [last] -> print_string last
| first :: rest -> print_string first; print_string " + "; print_keys_list rest;
flush stdout

let print_key_and_description lst = 
    let (keys, keys_description) = lst in 
    print_keys_list keys;
    print_string " -> ";
    print_string keys_description; 
    print_string "\n";
    flush stdout

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
  
let rec last = function 
  | [] -> [] 
  | [ x ] -> [x]
  | _ :: t -> last t;;

let print_pressed_keys lst = 
    List.iter print_string lst; print_newline (); flush stdout

let rec match_combo pressed_keys = match pressed_keys with
| ["A"] -> print_pressed_keys pressed_keys; pressed_keys
| ["A"; "B"] -> print_pressed_keys pressed_keys; pressed_keys
| _ -> print_string "Nothing to do with keys "; print_pressed_keys pressed_keys; if List.length pressed_keys > 1 then match_combo (last pressed_keys) else []

let () =
  
  let grammar = grammar_file_to_list "moves" in List.iter print_key_and_description grammar;
  match Sdl.init Sdl.Init.video with
  | Error (`Msg e) -> Sdl.log "No se pudo inicializar SDL: %s" e; exit 1
  | Ok () -> ();

  let window =
    match Sdl.create_window ~w:640 ~h:480 "Ventana de ejemplo" Sdl.Window.shown with
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
        let pressed_keys2 = match_combo (pressed_keys @ [keyname]) in 
          event_loop (pressed_keys2)
      | _ -> event_loop (pressed_keys)  (* Para otros eventos, continúa el bucle *)
  in
  event_loop ([]);
  Sdl.quit ()
