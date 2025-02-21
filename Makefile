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
	@sudo ln -s /usr/bin/gcc-13 /usr/local/cuda/bin/gcc || true
	@sudo ln -s /usr/bin/g++-13 /usr/local/cuda/bin/g++ || true
	$(CC) $(CFLAGS) -g -o $(script) src/$(script).cu

.PHONY:
.ONESHELL:
run: build # Build and launch the cuda code `make run script=<>`
	@killall $(script) 2>/dev/null
	time ./$(script)

.PHONY:
.ONESHELL:
nvprof: build # Build and profile the cuda code with nvprof (deprecated) `make nvprof script=<>`
	@killall $(script) 2>/dev/null
	nvprof  ./$(script)

.PHONY:
.ONESHELL:
nsys-cli: build # Builds and profile the cuda code with Nsys-cli `make nsys script=<>`
	@killall $(script) 2>/dev/null
	@rm ./output.nsys-rep ./output.sqlit || true
	nsys profile --cuda-memory-usage="true" -o output ./$(script) 
	nsys stats ./output.nsys-rep

.PHONY:
.ONESHELL:
nsys-ui: build # Builds and profile the cuda code with Nsys-ui `make nsys script=<>`
	@killall $(script) 2>/dev/null
	@rm ./output.nsys-rep ./output.sqlite || true
	nsys profile --cuda-memory-usage="true" -o output ./$(script) 
	nsys-ui ./output.nsys-rep
