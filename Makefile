# Variables
OCAMLC = ocamlc
INCLUDES = -I lib
SRCS = lib/a.ml lib/b.ml lib/readfile.ml lib/lib.ml bin/main.ml
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

# Limpiar y borrar el ejecutable
fclean: clean
	rm -f $(NAME)

# Regla para recompilar todo
re: fclean all

.PHONY: all clean fclean re
