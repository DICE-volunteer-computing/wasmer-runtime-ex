SHELL := /bin/zsh

PROJECT := $(shell basename "$$PWD")

all:
	@echo ''
	@echo "DICE Runtime Examples - Wasmer & Rust"
	@echo "Vale Tolpegin (valetolpegin@gmail.com)"
	@echo ''
	@echo "-----------------------"
	@echo ''
	@echo " Project: $(PROJECT)"

init:
	@rustup target add wasm32-wasi
	@cargo install twiggy

clean:
	@rm -rf target
	@rm -rf data/output/*.json

build:
	@cargo build --release --target=wasm32-wasi
	@wasm-opt -O3 --strip-debug target/wasm32-wasi/release/$(PROJECT).wasm -o target/wasm32-wasi/release/$(PROJECT).wasm
	@cd target/wasm32-wasi/release && tar -czf $(PROJECT).tar $(PROJECT).wasm

test:
	@mkdir -p data/output
	@wasmer run --mapdir=input:data/input --mapdir=output:data/output target/wasm32-wasi/release/$(PROJECT).wasm

inspect:
	@echo 'Top'
	@echo "-----------------------"
	@echo ''
	@twiggy top target/wasm32-wasi/release/$(PROJECT).wasm
	@echo ''
	@echo ''
	@echo 'Garbage'
	@echo "-----------------------"
	@echo ''
	@twiggy garbage target/wasm32-wasi/release/$(PROJECT).wasm
