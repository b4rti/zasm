# ZASM (WIP - ver. 0.0.0)
Name is a work in progress and is subject to change.

ZASM is a simple, blazingly fast runtime for WebAssembly and WebAssembly System Interface (WASI) written in Zig. It is optimized for being embedded as a plugin system for games and other high-performance applications.

## Table of Contents

- [ZASM (WIP - ver. 0.0.0)](#zasm-wip---ver-000)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Features](#features)
  - [Getting Started](#getting-started)
  - [Usage](#usage)
  - [Contributing](#contributing)
  - [License](#license)

## Introduction

ZASM is designed to provide a lightweight and efficient runtime for WebAssembly and WASI. It is intended to be used as a plugin system for games and other high-performance applications that require fast and efficient execution of WebAssembly modules.

## Features

- Simple and lightweight runtime for WebAssembly and WASI
- Blazingly fast performance
- Optimized for embedding as a plugin system
- Easy to use API

## Getting Started

To get started with ZASM, you will need to have Zig installed on your system. Once you have Zig installed, you can clone the ZASM repository and build the runtime using the following commands:

```bash
git clone https://github.com/your-username/zasm.git
cd zasm
zig build
```

This will build the ZASM runtime and generate a static library that you can link to your application.

## Usage

To use ZASM in your application, you will need to link against the static library generated by the build process. You can then use the ZASM API to load and execute WebAssembly modules.

Here's an example of how to load and execute a WebAssembly module using ZASM:

```zig
const Module = @import("zasm").Module;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    const module = try Module.fromPath(allocator, "path/to/your/module.wasm");
    // TODO: Implement decoding and execution of the module.
}
```

## Contributing

Contributions doesn't make sense at this point in time, but feel free to open an issue if you have any questions or suggestions.

## License

ZASM is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.