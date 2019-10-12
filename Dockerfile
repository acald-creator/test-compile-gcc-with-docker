FROM gcc:9.1.0

RUN apt-get update -y && \
    apt-get install -y curl \
    build-essential \
    bison \
    flex \
    libgmp3-dev \
    libmpc-dev \
    libmpfr-dev \
    texinfo \
    subversion \
    git \
    libffi-dev \
    libgdbm-dev \
    libgmp-dev \
    libjemalloc-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline6-dev \
    libssl-dev \
    libyaml-dev \
    openssl \
    valgrind \
    zlib1g-dev \
    ccache

# FROM pyrrhus/gcc-9.1.0

COPY build.sh /tmp

RUN chmod 777 /tmp/build.sh && /tmp/build.sh

ENV PATH="/usr/local/cross/bin:${PATH}"