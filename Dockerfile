FROM mcr.microsoft.com/dotnet/core/sdk:3.1

RUN dotnet tool install --global dotnet-ef

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.dotnet/tools

