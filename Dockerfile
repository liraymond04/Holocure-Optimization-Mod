ARG DLL_NAME=Optimization
ARG VERSION=1.0.1


# Setup Ubuntu container
FROM ubuntu:20.04 AS stage1
ARG DLL_NAME
ARG VERSION

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y wine64-development python3 msitools python3-simplejson python3-six \
                       ca-certificates gcc g++ make git wget libssl-dev winbind && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN service winbind start

# Install CMake
WORKDIR /usr

RUN wget https://github.com/Kitware/CMake/releases/download/v3.28.0-rc5/cmake-3.28.0-rc5-linux-x86_64.tar.gz

RUN tar --strip-components=1 -xzf cmake-3.28.0-rc5-linux-x86_64.tar.gz

# Initialize the wine environment. Wait until the wineserver process has
# exited before closing the session, to avoid corrupting the wine prefix.
RUN wine64 wineboot --init && \
    while pgrep wineserver > /dev/null; do sleep 1; done

# Install MSVC compiler
WORKDIR /opt

RUN git clone https://github.com/mstorsjo/msvc-wine.git msvc

WORKDIR msvc

RUN PYTHONUNBUFFERED=1 ./vsdownload.py --accept-license --dest /opt/msvc && \
    ./install.sh /opt/msvc && \
    rm lowercase fixinclude install.sh vsdownload.py && \
    rm -rf wrappers

ENV PATH "$PATH:/opt/msvc/bin/x64"

# Copy and build project
WORKDIR /app

COPY . .

RUN mkdir _build

WORKDIR _build

RUN wineserver -p && \
    wine64 wineboot

RUN CC=cl CXX=cl cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_SYSTEM_NAME=Windows \
    -DPROJECT_VERSION=$VERSION \
    && make

RUN mv ../x64/Release/src.dll ../x64/Release/$DLL_NAME-v$VERSION.dll


# Copy output DLL to host machine
from scratch AS export-stage
ARG DLL_NAME
ARG VERSION

COPY --from=stage1 /app/x64/Release/$DLL_NAME-v$VERSION.dll .
