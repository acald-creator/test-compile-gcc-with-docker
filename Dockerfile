FROM gcc:9.1.0 as compiler

# FROM pyrrhus/gcc-9.1.0

COPY build.sh /tmp

RUN chmod 777 /tmp/build.sh && /tmp/build.sh

ENV PATH="/usr/local/cross/bin:${PATH}"