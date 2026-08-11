#!/bin/sh
set -eu

cd "$(dirname "$0")"

moon build --target wasm --release examples/hello

exec /Users/zhengyu/.local/bin/tic80 \
  --cli \
  --skip \
  --fs "$PWD" \
  --cmd 'new wasm & import binary _build/wasm/release/build/examples/hello/hello.wasm & run & exit'
