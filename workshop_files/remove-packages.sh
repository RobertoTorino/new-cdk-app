#!/bin/bash

echo "Uninstall deprecated packages"

# This module is not supported, and leaks memory.
npm r inflight@1.0.6
# deprecated
npm r source-map-support
npm r glob@7.2.3

