FROM rust:1.76.0 AS builder

WORKDIR /app
RUN apt-get update && apt-get install -y lld clang --no-install-recommends
COPY . .
ENV SQLX_OFFLINE true
RUN cargo build --release

FROM rust:1.76.0-slim as runtime

WORKDIR /app
COPY --from=builder /app/target/release/matcha_analytics matcha_analytics
COPY configuration configuration
ENV APP_ENVIRONMENT production
ENTRYPOINT ["./matcha_analytics"]
