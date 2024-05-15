


# compile with dune

dune build
dune exec bin/main.exe
watch mode: dune exec bin/main.exe -w

# compile with ocamlc
ocamlc -c -I lib lib/a.ml lib/b.ml lib/lib.ml bin/main.ml
./main

# add new modules
modify:
- lib/dune
- lib/lib.ml