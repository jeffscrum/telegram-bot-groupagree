FROM ubuntu:19.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -yq mono-complete wget

WORKDIR /app

ADD telegram-bot-groupagree/packages.config telegram-bot-groupagree/packages.config
ADD WJClubBotFrame/packages.config WJClubBotFrame/packages.config
ADD WJClubInternalApiFrame/packages.config WJClubInternalApiFrame/packages.config

RUN mkdir packages && \
    cd packages/ && \
    wget https://dist.nuget.org/win-x86-commandline/v3.3.0/nuget.exe && \
    for PKGCONF in ../*/packages.config ; do mono nuget.exe install $PKGCONF ; done && \
    cd ..

ADD . .

RUN xbuild telegram-bot-groupagree.sln

CMD cd telegram-bot-groupagree/bin/Debug/ && \
    while true ; do mono ./telegram-bot-groupagree.exe gab gab groupagreebot_beta ; done
