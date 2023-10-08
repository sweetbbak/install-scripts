#!/bin/bash
# update Okolors CLI tool
# basically Pywal but with way better color palettes

build=$(mktemp -d)
cd "$build" || exit 1
echo "pwd $(pwd)"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "script dir ${SCRIPT_DIR}"

wget https://github.com/Ivordir/Okolors/releases/download/v0.3.0/okolors-v0.3.0-x86_64-unknown-linux-gnu.tar.gz
tar -xvf okolors-v0.3.0-x86_64-unknown-linux-gnu.tar.gz
\cp ./okolors "$HOME/bin" 