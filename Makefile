NAME := "Boot2RootVM"

all: $(NAME)

$(NAME):
	./utils/install-boot2root.sh $(NAME)
	./utils/install-kali.sh $(NAME)

clean:
	./utils/uninstall.sh $(NAME)
	./utils/uninstall.sh Kali

re: clean $(NAME)
