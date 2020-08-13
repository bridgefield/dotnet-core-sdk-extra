FROM mcr.microsoft.com/dotnet/core/sdk:3.1

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache && \
    apt-get update && \
    apt-get install unzip && \
    curl -sSL https://aka.ms/getvsdbgsh | /bin/sh /dev/stdin -v latest -l /remote_debugger && \
    apt-get remove -y unzip && \
    rm -r /var/lib/apt/lists/*

RUN dotnet tool install --global dotnet-ef

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.dotnet/tools:/remote_debugger
