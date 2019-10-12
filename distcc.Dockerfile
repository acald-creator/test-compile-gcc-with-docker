FROM ubuntu:eoan

LABEL maintainer="antonette.caldwell"

RUN DEBIAN_FRONTEND="noninteractive" apt-get -q update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -y -q --no-install-recommends upgrade && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y -q g++ gcc clang distcc ccache && \
    DEBIAN_FRONTEND="noninteractive" apt-get -y -q autoremove && \
    DEBIAN_FRONTEND="noninteractive" apt-get -y -q clean

ENV ALLOW 192.168.0.0/16
RUN useradd distcc
USER distcc
EXPOSE 3632

CMD distccd --jobs $(nproc) --log-stderr --no-detach --daemon --allow ${ALLOW} --log-level info