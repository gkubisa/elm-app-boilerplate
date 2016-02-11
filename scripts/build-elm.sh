#!/bin/bash

set -e
elm make src/Main.elm --output "$1" --warn
