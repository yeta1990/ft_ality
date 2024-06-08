module Sdl = Tsdl.Sdl

let hello = "Hello from A"

let rec get_description_by_key grammar current_state = 
  match grammar with
  | (key, description) :: tail -> 
      if key = current_state then (true, description) else get_description_by_key tail current_state 
  | [] -> 
      (false, "") 

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

let split_keys_and_descriptions s =
  let delimiter = " = " in
    let len = String.length delimiter in
      try
        let index = String.index_from s 0 '=' in
        let keys_raw = String.sub s 0 (index - 1) in
        let key_description = String.sub s (index + len - 1) (String.length s - index - len + 1) in
        let keys = String.split_on_char '+' keys_raw in 
          (keys, String.trim key_description)
      with Not_found -> Sdl.log "Bad format provided in file. \"key = value\" is required, i.e.: P = Punch or P + K = Combo!!!"; exit 1

let grammar_file_to_list file_name = 
  let ic =
    try
      open_in file_name
    with Sys_error msg ->
      Printf.printf "Error opening file: %s\n" msg;
      exit 1
  in
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

let print_grammar grammar = 
  print_string "[ft_ality]\n";
  print_string "Key -> Name of the movement or combo\n";
  print_string "-----------\n";
  List.iter print_key_and_description grammar;
  print_string "-----------\n"; flush stdout