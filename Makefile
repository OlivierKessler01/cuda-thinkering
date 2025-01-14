CC = nvcc 
CFLAGS = -arch=compute_61 -code=sm_61
RED    := \033[31m
GREEN  := \033[32m
YELLOW := \033[33m
BLUE   := \033[34m
RESET  := \033[0m

# The @ makes sure that the command itself isn't echoed in the terminal
help: # Print help on Makefile
	@echo "Please use 'make <target>' where <target> is one of"
	@echo ""
	@grep '^[^.#]\+:\s\+.*#' Makefile | \
	sed "s/\(.\+\):\s*\(.*\) #\s*\(.*\)/`printf "\033[93m"`  \1`printf "\033[0m"`	\3 [\2]/" | \
	expand -35
	@echo ""
	@echo "Check the Makefile to know exactly what each target is doing."

clean: # Remove all generated binaries
	@rm -rf columnarc columnard *_test

.ONESHELL:
build: clean # Build the server 
	sudo ln -s /usr/bin/gcc-13 /usr/local/cuda/bin/gcc 
	sudo ln -s /usr/bin/g++-13 /usr/local/cuda/bin/g++
	@$(CC) $(CFLAGS) -g -o hello src/hello.cu

.PHONY:
.ONESHELL:
run: build # Build and launch the cuda code
	@killall hello 2>/dev/null
	./hello

