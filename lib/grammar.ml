module Sdl = Tsdl.Sdl

let rec print_keys_list = function
| [] -> ()
| [last] -> print_string last
| first :: rest -> print_string first; print_string " + "; print_keys_list rest;
flush stdout
let validate_key_combination grammar = 
  let (keys,___) = grammar in 
  if List.for_all (fun key -> Sdl.get_key_from_name key <> 0) keys
    then `Ok else `Error

let validate_grammar_keys grammar = 
    let results  = List.map validate_key_combination grammar in
      if List.for_all (fun res -> res == `Ok) results then true else (Sdl.log "Bad key provided in file"; false)

let rec is_substate sub lst =
  match sub, lst with
 | [], _ -> true
 | _, [] -> false
 | x::xs, y::ys -> 
    (x = y && is_substate xs ys) || is_substate sub ys

let rec validate_substates states =
  match states with
  | [] -> true
  | ([_], _)::rest -> validate_substates rest (*not checking single keys*)
  | (s1, _)::rest ->
    let has_sublist =
      List.exists (fun (s2, _) -> 
        if ((s1 <> s2) && (is_substate s1 s2 || is_substate s2 s1)) then
          (print_string "Defined substates of other states are not allowed: "; print_keys_list s1; print_string " has coincidences with "; print_keys_list s2; print_string "\n";
          true)
        else false
      ) rest
      in
        if has_sublist then false else validate_substates rest

let validate_grammar grammar = 
  if not (validate_grammar_keys grammar) || not (validate_substates grammar) then exit 1

let rec is_prefix_of_other_list prefix list =
  match prefix, list with
  | [], _ -> true
  | _, [] -> false
  | x::xs, y::ys -> x = y && is_prefix_of_other_list xs ys

let key_exists key states =
  List.exists (fun (state_key, _) -> is_prefix_of_other_list key state_key) states



(*
avoids defining a state that is at the same time a substate/subset of another state. i.e:
  P+K = Power Strike
  W+P+K = Ultra combo
are incompatible
*)
let rec get_description_by_key grammar current_state = 
  match grammar with
  | (key, description) :: tail -> 
      if key = current_state then (true, description) else get_description_by_key tail current_state 
  | [] -> 
      (false, "") 


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