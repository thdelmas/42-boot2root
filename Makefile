NAME := "Boot2RootVM"

all: $(NAME)

$(NAME):
	./utils/install.sh $(NAME)

clean:
	./utils/uninstall.sh $(NAME)

re: clean $(NAME)
