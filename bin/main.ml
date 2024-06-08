module Sdl = Tsdl.Sdl
module Grammar = Lib.Grammar
module State = Lib.State
      
let get_grammar_filename () =
  try
    Sys.argv.(1)
  with
  | Invalid_argument _ ->
    print_string "Usage: ./ft_alit grammar_file\n";
    exit 1
  | _ -> print_string "Error\n"; exit 1


let initialize_sdl () =
  match Sdl.init Sdl.Init.video with
  | Error (`Msg e) ->
    Sdl.log "Error initializing SDL: %s" e;
    exit 1
  | Ok () -> ()

let initialize_window () =
  match Sdl.create_window ~w:640 ~h:480 "ft_ality" Sdl.Window.shown with
  | Error (`Msg e) ->
    Sdl.log "Error creating window: %s" e;
    exit 1
  | Ok win -> win

let () =
  initialize_sdl ();
  let grammar_filename = get_grammar_filename () in
  let grammar = Grammar.grammar_file_to_list grammar_filename in
  Grammar.validate_grammar grammar;
  Grammar.print_grammar grammar;
  let window = initialize_window () in
    State.event_loop grammar [];
    Sdl.destroy_window window;
    Sdl.quit ();