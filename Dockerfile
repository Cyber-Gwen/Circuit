FROM rustlang/rust:nightly AS builder
RUN mkdir /new_tmp
WORKDIR /usr/src/
RUN rustup target add x86_64-unknown-linux-musl

RUN USER=root cargo new circuit-cards
WORKDIR /usr/src/circuit-cards
COPY Cargo.toml Cargo.lock ./
RUN cargo build --release

COPY src ./src
RUN cargo install --target x86_64-unknown-linux-musl --path .

FROM scratch

COPY --from=builder --chown=0:0 /usr/local/cargo/bin/circuit-cards /
COPY --chown=0:0 templates /templates

ENTRYPOINT ["/circuit-cards"]
