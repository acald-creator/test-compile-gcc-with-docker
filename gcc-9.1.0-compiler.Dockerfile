FROM gcc:9.1.0 as compiler

# FROM pyrrhus/gcc-9.1.0

COPY preq.sh /tmp

RUN chmod 777 /tmp/preq.sh && /tmp/preq.sh

ENV PATH="/usr/local/cross/bin:${PATH}"