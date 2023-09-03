NAME := "Boot2Root"

all: $(NAME)

$(NAME):
	./utils/install-boot2root.sh $(NAME)
	./utils/install-kali.sh Kali

clean:
	./utils/uninstall.sh $(NAME)
	./utils/uninstall.sh Kali

re: clean $(NAME)
