#! /bin/sh

zig build-lib hello-world.zig -target wasm32-freestanding -dynamic -rdynamic -O ReleaseSmall  && wasm2wat -o hello-world.wat hello-world.wasm
zig build-lib add.zig -target wasm32-freestanding -dynamic -rdynamic -O ReleaseSmall && wasm2wat -o add.wat add.wasm

zig build-exe wasi-hello-world.zig -target wasm32-wasi -O ReleaseSafe && wasm2wat -o wasi-hello-world.wat wasi-hello-world.wasm