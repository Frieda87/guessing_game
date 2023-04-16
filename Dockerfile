FROM rust:1.66 as builder
ENV NAME=guessing_game

# First build a dummy project with our dependencies to cache them in Docker
WORKDIR /usr/src
RUN cargo new --bin ${NAME}
WORKDIR /usr/src/${NAME}
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
RUN cargo build --release
RUN rm src/*.rs

# Now copy the sources and do the real build
COPY . .
RUN cargo build --release 

# Second stage putting the build result into a debian buster-slim image
FROM debian:buster-slim
ENV NAME=guessing_game

COPY --from=builder /usr/src/${NAME}/target/release/${NAME} /usr/local/bin/${NAME}
CMD ${NAME}