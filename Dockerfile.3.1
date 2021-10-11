ARG SDK_VERSION=3.1

FROM mcr.microsoft.com/dotnet/sdk:${SDK_VERSION}

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    apt-get update && \
    apt-get install -y \
        unzip \
        supervisor \
        inotify-tools \
        libgdiplus \
        && \
    curl -sSL https://aka.ms/getvsdbgsh | /bin/sh /dev/stdin -v latest -l /remote_debugger && \
    apt-get remove -y unzip && \
    rm -r /var/lib/apt/lists/*

RUN dotnet tool install --tool-path /usr/local/dotnet-tools dotnet-ef

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/dotnet-tools:/remote_debugger

ENV UNISON_VERSION=2.51.4

# debian unison is missing unison-fsmonitor so we install from source
RUN apt-get update && \
    apt-get -y install build-essential opam && \
    curl -L  https://github.com/bcpierce00/unison/archive/refs/tags/v${UNISON_VERSION}.tar.gz | tar zxv -C /tmp && \
    cd /tmp/unison-${UNISON_VERSION} && \
    sed -i -e 's/GLIBC_SUPPORT_INOTIFY 0/GLIBC_SUPPORT_INOTIFY 1/' src/fsmonitor/linux/inotify_stubs.c && \
    make UISTYLE=text NATIVE=true STATIC=true && \
    cp src/unison src/unison-fsmonitor /usr/local/bin && \
    apt-get remove -y build-essential opam && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/unison-${UNISON_VERSION}

ENV HOME=/tmp \
    UNISONLOCALHOSTNAME=localhost \
    START_PROJECT=MyProject \
    START_COMMAND="dotnet watch run"

COPY . /
