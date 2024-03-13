FROM rust:1.76.0 AS builder

WORKDIR /app
RUN apt-get update && apt-get install -y lld clang --no-install-recommends
COPY . .
ENV SQLX_OFFLINE true
RUN cargo build --release

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
