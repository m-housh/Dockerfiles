.PHONY: feature

SHELL = /usr/local/bin/zsh

NAME := ""

feature:
	[ $(NAME) != "" ] && \
		source ./.docker_func.sh && \
		git_flow feature start $(NAME) && \
		mkdir $(NAME) && \
		touch "$(NAME)/Dockerfile" && \
		touch "$(NAME)/README.md" && \
		git add . && \
		git commit -m "Initial skeleton for feature $(NAME)" && \
		echo "Your feature has been started." && \
		echo "You should `cd $(NAME)'" || \
		echo "NAME not set"
