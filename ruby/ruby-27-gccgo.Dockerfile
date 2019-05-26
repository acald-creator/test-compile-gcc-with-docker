FROM pyrrhus/gccgo-9.1.0:test

COPY build.sh /tmp

RUN chmod 777 /tmp/build.sh && /tmp/build.sh

ENV PATH="/usr/local/cross/bin:${PATH}"