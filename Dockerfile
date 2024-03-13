FROM lukemathwalker/cargo-chef:latest-rust-1.76.0 as chef
WORKDIR /app
RUN apt-get update && apt-get install -y lld clang --no-install-recommends

FROM chef as planner
COPY . .
# Compute a lock-like file for the project
RUN cargo chef prepare --recipe-path recipe.json

FROM chef as builder
COPY --from=planner /app/recipe.json recipe.json
# Build project dependencies
RUN cargo chef cook --release --recipe-path recipe.json
COPY . .
ENV SQLX_OFFLINE true
RUN cargo build --release --bin matcha_analytics

FROM debian:bookworm-slim as runtime

WORKDIR /app
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends openssl ca-certificates \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/matcha_analytics matcha_analytics
COPY configuration configuration
ENV APP_ENVIRONMENT production
ENTRYPOINT ["./matcha_analytics"]
