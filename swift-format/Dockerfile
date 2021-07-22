FROM swift:5.4 as build

WORKDIR /build

RUN apt-get update
RUN apt-get install -y git
RUN git clone -b swift-5.4-branch https://github.com/apple/swift-format.git

WORKDIR /build/swift-format

RUN swift build --configuration release

FROM swift:5.4-slim
RUN apt-get update && \
apt-get install -y libz3-4 && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*
COPY --from=build /build/swift-format/.build/x86_64-unknown-linux-gnu/release/swift-format /usr/bin
ENTRYPOINT ["/usr/bin/swift-format"]
