(* Importa la biblioteca TSDL *)
open Tsdl

(* Función principal *)
let () =
  (* Inicializa SDL *)
  match Sdl.init Sdl.Init.video with
  | Error (`Msg e) -> Sdl.log "No se pudo inicializar SDL: %s" e; exit 1
  | Ok () -> ();

  (* Crea una ventana *)
  let window =
    match Sdl.create_window ~w:640 ~h:480 "Ventana de ejemplo" Sdl.Window.shown with
    | Error (`Msg e) -> Sdl.log "No se pudo crear la ventana: %s" e; exit 1
    | Ok win -> win
  in

  (* Bucle de eventos *)
  let rec event_loop () =
    (* Crear un evento *)
    let event = Sdl.Event.create () in
    (* Esperar a un evento *)
    match Sdl.wait_event (Some event) with
    | Error (`Msg e) -> Sdl.log "Error esperando un evento: %s" e; Sdl.destroy_window window; Sdl.quit ()
    | Ok () ->
      (* Obtener el tipo de evento *)
      let event_type = Sdl.Event.get event Sdl.Event.typ in
      match Sdl.Event.enum event_type with
      | `Quit -> Sdl.log "Evento de salida recibido, cerrando."; Sdl.destroy_window window; Sdl.quit ()
      | `Key_down -> 
        (* Obtener la tecla presionada *)
        let keycode = Sdl.Event.get event Sdl.Event.keyboard_keycode in
        let keyname = Sdl.get_key_name keycode in
        Printf.printf "Tecla presionada: %s\n%!" keyname;
        event_loop ()
      | _ -> event_loop ()  (* Para otros eventos, continúa el bucle *)
  in
  event_loop ();
  Sdl.quit ()
