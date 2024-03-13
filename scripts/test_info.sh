#!/usr/bin/env bash
# run `cargo install bunyan`
TEST_LOG=true cargo test "$@" | bunyan
