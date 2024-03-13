#!/usr/bin/env bash
cargo install --version='~0.7' sqlx-cli \
	--no-default-features --features rustls,postgres
cargo install cargo-tarpaulin
cargo install cargo-audit
cargo install cargo-udeps
cargo install cargo-watch
cargo install bunyan
