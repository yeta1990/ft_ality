# Variables
OCAMLC = ocamlc
INCLUDES = -I lib
SRCS = lib/a.ml lib/b.ml lib/lib.ml bin/main.ml
OBJS = $(SRCS:.ml=.cmo)
INTERFACES = $(OBJS:.cmo=.cmi)
NAME = ft_ality

all: $(NAME)

%.cmo: %.ml
	$(OCAMLC) -c $(INCLUDES) $<

$(NAME): $(OBJS)
	$(OCAMLC) $(INCLUDES) -o $@ $^

clean:
	rm -f $(INTERFACES) $(OBJS)

# Limpiar y borrar el ejecutable
fclean: clean
	rm -f $(NAME)

# Regla para recompilar todo
re: fclean all

.PHONY: all clean fclean re
