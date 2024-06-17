module Sdl = Tsdl.Sdl
module Grammar = Lib.Grammar
module State = Lib.State
      
let get_grammar_filename () =
  try
    Sys.argv.(1)
  with
  | Invalid_argument _ ->
    print_string "Usage: ./ft_ality grammar_file\n";
    exit 1
  | _ -> print_string "Error\n"; exit 1


let confirm_only_1_argument () = 
  try
    let _ = Sys.argv.(2) in 
    print_string "Only 1 argument allowed. Usage: ./ft_ality grammar_file\n";
    exit 1
  with
  | _ -> ()

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
    let _ = confirm_only_1_argument () in 
      let grammar = Grammar.grammar_file_to_list grammar_filename in
  Grammar.validate_grammar grammar;
  Grammar.print_grammar grammar;
  let window = initialize_window () in
    State.event_loop grammar [];
    Sdl.destroy_window window;
    Sdl.quit ();
