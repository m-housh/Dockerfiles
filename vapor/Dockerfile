FROM vapor/toolbox 

# Update to the latest packages.
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*;

WORKDIR /vapor

RUN ["vapor", "--help"]
