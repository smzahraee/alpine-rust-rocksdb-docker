FROM rustlang/rust:nightly-alpine@sha256:e214daa535446bf48f6ec849cab6bd9b61ab1f82fb8fec86ff559b2fba4ea246 as builder

RUN apk update && \
    apk add zlib-dev bzip2-dev lz4-dev snappy-dev zstd-dev gflags-dev && \
    apk add build-base linux-headers git bash perl
RUN apk add clang \ 
        clang-libs \ 
        llvm \ 
        cmake \ 
        protobuf-c-dev \ 
        protobuf-dev \ 
        musl-dev \ 
        build-base \ 
        gcc \ 
        libc-dev \ 
        python3-dev 
        
RUN apk add glib
RUN apk add --no-cache clang pkgconfig openssl-dev gcc postgresql14-dev curl jq make musl-dev

ENV RUSTFLAGS="-C target-feature=-crt-static"

WORKDIR /sugarfunge
COPY ./sugarfunge-node /sugarfunge
RUN cargo fetch
RUN cargo build --locked --release

WORKDIR /sugarfunge-api
COPY ./sugarfunge-api /sugarfunge-api
RUN cargo fetch
RUN cargo build --locked --release

RUN ls /sugarfunge-api/

FROM alpine:3.17

COPY --from=builder /sugarfunge/target/release/sugarfunge-node /sugarfunge-node
COPY --from=builder /sugarfunge-api/target/release/sugarfunge-api /sugarfunge-api

#COPY ./run_node.sh /run_node.sh


#RUN git clone --recurse-submodules https://github.com/rust-rocksdb/rust-rocksdb.git
#WORKDIR rust
#COPY ./rust-rocksdb ./
#WORKDIR rust-rocksdb/librocksdb-sys
#ENV RUSTFLAGS="-C target-feature=-crt-static"
#RUN cargo build
