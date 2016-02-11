#!/bin/bash

set -e

OUTPUT_PATH="$1"
OUTPUT_DIR="$(dirname "$OUTPUT_PATH")"
TEMP_PATH=$(mktemp --suffix .js)
trap "rm -f $TEMP_PATH" EXIT

$(dirname $0)/build-elm.sh "$TEMP_PATH"
mkdir -p "$OUTPUT_DIR"
uglifyjs "$TEMP_PATH" --screw-ie8 --compress --output "$OUTPUT_PATH" &> /dev/null
