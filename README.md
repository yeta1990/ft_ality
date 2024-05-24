

# create environment (switch)
4.14.0 for sdl package compatibility
```
opam switch create ft_ality 4.14.0
opam switch ft_ality
opam init
opam install ocamlsdl.0.9.1
```

to see the current switch:
```
opam switch
```

ocaml extension vscode:
select a sandbox: ft_ality




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
- Makefile