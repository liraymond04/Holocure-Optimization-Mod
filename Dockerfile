ARG DLL_NAME=Optimization
ARG VERSION=1.0.1


# Setup Arch container
FROM archlinux:latest AS stage1
ARG DLL_NAME
ARG VERSION

RUN echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    git \
    gcc \
    make \
    cmake \
    python \
    python-simplejson \
    python-six \
    libunwind \
    msitools \
    samba \
    wine

# Clone and install MSVC wine compiler
RUN wine64 wineboot --init && \
    while pgrep wineserver > /dev/null; do sleep 1; done

WORKDIR /msvc

RUN git clone https://github.com/mstorsjo/msvc-wine.git

WORKDIR msvc-wine

RUN echo yes | ./vsdownload.py --dest ../cc && \
    ./install.sh ../cc

# Copy and build project
WORKDIR /app

COPY . .

RUN mkdir _build

WORKDIR _build

RUN CC=/msvc/cc/bin/x64/cl CXX=/msvc/cc/bin/x64/cl cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_SYSTEM_NAME=Windows -DPROJECT_VERSION=$VERSION && make

RUN mv ../x64/Release/src.dll ../x64/Release/$DLL_NAME-v$VERSION.dll


# Copy output DLL to host machine
from scratch AS export-stage
ARG DLL_NAME
ARG VERSION

COPY --from=stage1 /app/x64/Release/$DLL_NAME-v$VERSION.dll .
