zig build-exe add.zig -fno-entry -target wasm32-freestanding -rdynamic -O ReleaseFast
wasm2wat -o add.wat add.wasm

zig build-exe hello-world.zig -fno-entry -target wasm32-freestanding -rdynamic -O ReleaseFast
wasm2wat -o hello-world.wat hello-world.wasm

zig build-exe wasi-hello-world.zig -target wasm32-wasi -O ReleaseFast
wasm2wat -o wasi-hello-world.wat wasi-hello-world.wasm