ARG SDK_VERSION=3.1
FROM mcr.microsoft.com/dotnet/sdk:${SDK_VERSION}

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    apt-get update --quiet && \
    apt-get install --quiet --assume-yes \
        unzip \
        supervisor \
        inotify-tools \
        libgdiplus \
        libc6-dev \
        && \
    curl -sSL https://aka.ms/getvsdbgsh | /bin/sh /dev/stdin -v latest -l /remote_debugger && \
    apt-get remove --assume-yes unzip && \
    rm -r /var/lib/apt/lists/*

ARG SDK_VERSION
RUN dotnet tool install --no-cache --tool-path /usr/local/dotnet-tools dotnet-ef --version ${SDK_VERSION}

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/dotnet-tools:/remote_debugger

ENV UNISON_VERSION=2.52.1

# debian unison is missing unison-fsmonitor so we install from source
RUN apt-get update --quiet && \
    apt-get --quiet --assume-yes install build-essential opam && \
    curl -L  https://github.com/bcpierce00/unison/archive/refs/tags/v${UNISON_VERSION}.tar.gz | tar zxv -C /tmp && \
    cd /tmp/unison-${UNISON_VERSION} && \
    sed -i -e 's/GLIBC_SUPPORT_INOTIFY 0/GLIBC_SUPPORT_INOTIFY 1/' src/fsmonitor/linux/inotify_stubs.c && \
    make UISTYLE=text NATIVE=true STATIC=true && \
    cp src/unison src/unison-fsmonitor /usr/local/bin && \
    apt-get remove --assume-yes build-essential opam && \
    apt-get autoremove --assume-yes && \
    rm -rf /var/lib/apt/lists/* /tmp/unison-${UNISON_VERSION}

RUN mkdir -p /state && chmod 1777 /state

COPY --from=busybox:stable /bin/busybox /bin/

RUN busybox adduser -D -H -u 1000 user0 && \
    busybox adduser -D -H -u 1001 user1 && \
    busybox adduser -D -H -u 1002 user2

ENV HOME=/tmp \
    UNISON_REPEAT=watch \
    UNISONLOCALHOSTNAME=localhost \
    START_PROJECT=MyProject \
    START_COMMAND="dotnet watch run" \
    AUTOSTART_APP=true \
    AUTOSTART_INETD=false \
    DELAY_START_PORT=""

COPY . /
