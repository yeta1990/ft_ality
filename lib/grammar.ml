module Sdl = Tsdl.Sdl

let rec print_keys_list = function
| [] -> ()
| [last] -> print_string last
| first :: rest -> print_string first; print_string " + "; print_keys_list rest;
flush stdout

let rec print_descriptions = function
  | [] -> print_string "\n"; flush stdout
  | first :: last -> print_string (first ^ "\n"); print_descriptions last

let validate_key_combination grammar = 
  let (keys,___) = grammar in 
  if List.for_all (fun key -> Sdl.get_key_from_name key <> 0) keys
    then `Ok else `Error

let validate_grammar_keys grammar = 
    let results  = List.map validate_key_combination grammar in
      if List.for_all (fun res -> res == `Ok) results then true else (print_string "Bad key provided in file\n"; flush stdout; false)

let rec is_substate sub lst =
  match sub, lst with
 | [], _ -> true
 | _, [] -> false
 | x::xs, y::ys -> 
    (x = y && is_substate xs ys) || is_substate sub ys

let validate_grammar grammar = 
  if not (validate_grammar_keys grammar) then exit 1

let rec is_prefix_of_other_list prefix list =
  match prefix, list with
  | [], _ -> true
  | _, [] -> false
  | x::xs, y::ys -> x = y && is_prefix_of_other_list xs ys

let key_exists key states =
  List.exists (fun (state_key, _) -> is_prefix_of_other_list key state_key) states

let rec get_description_by_key grammar current_state found_descriptions = 
  match grammar, found_descriptions with
  | (key, description) :: tail, _ -> 
      if key = current_state then get_description_by_key tail current_state (found_descriptions @ [description]) else get_description_by_key tail current_state found_descriptions
  | [], []  -> 
      (false, current_state) (* returns the same description as the key name *)
  | [], _  -> 
      (true, found_descriptions) 


let print_key_and_description lst = 
    let (keys, keys_description) = lst in 
    print_keys_list keys;
    print_string (" -> " ^ keys_description ^ "\n")

let split_keys_and_descriptions s =
  let delimiter = " = " in
    let len = String.length delimiter in
      try
        let index = String.index_from s 0 '=' in
        let keys_raw = String.sub s 0 (index - 1) in
        let key_description = String.sub s (index + len - 1) (String.length s - index - len + 1) in
        let keys = String.split_on_char '+' keys_raw in 
          (keys, String.trim key_description)
      with Not_found -> print_string "Bad format provided in file. \"key = value\" is required, i.e.: P = Punch or P + K = Combo!!!\n"; flush stdout; exit 1

let grammar_file_to_list file_name = 
  let ic =
    try
      open_in file_name
    with Sys_error msg ->
      print_string ("Error opening file: " ^ msg ^ "\n");
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