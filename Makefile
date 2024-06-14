# Variables
OCAMLC = ocamlc
INCLUDES = -I lib -I /home/albgarci/.brew/Cellar/sdl2/2.30.3/lib
SRCS = lib/grammar.ml lib/state.ml lib/lib.ml bin/main.ml
OBJS = $(SRCS:.ml=.cmo)
INTERFACES = $(OBJS:.cmo=.cmi)
NAME = ft_ality
PACKAGES = tsdl

all: $(NAME)

%.cmo: %.ml
	ocamlfind $(OCAMLC) -c -package $(PACKAGES) -thread -linkpkg  $(INCLUDES) $<

$(NAME): $(OBJS)
	ocamlfind $(OCAMLC) $(INCLUDES) -o $@ -linkpkg -thread -package $(PACKAGES) $^ 

clean:
	rm -f $(INTERFACES) $(OBJS)

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re
