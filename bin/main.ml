(* Importa la biblioteca TSDL *)
open Tsdl

let grammar_file_to_list file_name = 
  let ic = open_in file_name in
  let rec read_lines() =
    try
      let line = input_line ic in 
      line :: read_lines() 
    with End_of_file -> 
      close_in ic;
      []
    in 
    read_lines() 
  

let rec last = function 
  | [] -> [] 
  | [ x ] -> [x]
  | _ :: t -> last t;;

let print_pressed_keys lst = List.iter print_string lst; print_newline (); flush stdout

let rec match_combo pressed_keys = match pressed_keys with
| ["A"] -> print_pressed_keys pressed_keys; pressed_keys
| ["A"; "B"] -> print_pressed_keys pressed_keys; pressed_keys
| _ -> print_string "Nothing to do with keys "; print_pressed_keys pressed_keys; if List.length pressed_keys > 1 then match_combo (last pressed_keys) else []

(* Función principal *)
let () =
  
  let grammar = grammar_file_to_list "moves" in 
    List.iter print_string grammar; flush stdout;
  match Sdl.init Sdl.Init.video with
  | Error (`Msg e) -> Sdl.log "No se pudo inicializar SDL: %s" e; exit 1
  | Ok () -> ();

  (* Crea una ventana *)
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
        (*
        Printf.printf "Tecla presionada: %s\n%!" keyname;
        Printf.printf "Tecla presionada: %d\n%!" keycode;
        *)
        let pressed_keys2 = match_combo (pressed_keys @ [keyname]) in 
          event_loop (pressed_keys2)
      | _ -> event_loop (pressed_keys)  (* Para otros eventos, continúa el bucle *)
  in
  event_loop ([]);
  Sdl.quit ()
