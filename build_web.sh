#!/usr/bin/env bash
# Builds the Wordle game for the web (WebAssembly) using karl2d's web build tool.
#
# karl2d renders through its own WebGL backend on the plain core:sys/wasm/js
# runtime, so -- unlike a raylib project -- no emscripten is required. The tool
# generates a small web entry that calls this package's init/step/shutdown,
# compiles to bin/web/main.wasm, and drops index.html + odin.js beside it.
#
# Output: bin/web/  -- serve it with any static web server, e.g.
#   python -m http.server --directory bin/web
#
# Extra Odin flags are passed straight through, e.g. `./build_web.sh -o:size`
# for a smaller, faster-loading build.
set -euo pipefail

cd "$(dirname "$0")"

odin run karl2d/build_web -- . "$@"
