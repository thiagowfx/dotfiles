#!/bin/bash

. assert.sh/assert.sh

# assert.sh tests
assert "echo 42" "42"
assert_raises "exit 10" "10"
assert_end assert.sh
