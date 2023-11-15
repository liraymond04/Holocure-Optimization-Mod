ARG DLL_NAME=Optimization
ARG VERSION=1.0.1


FROM archlinux:latest AS stage1
ARG DLL_NAME
ARG VERSION

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    gcc \
    cmake \
    mingw-w64 \
    make

WORKDIR /app

COPY . .

RUN mkdir _build

WORKDIR _build

RUN cmake -DMINGW32=1 -DPROJECT_VERSION=$VERSION .. && make

RUN mv Optimization/libOptimization.dll Optimization/$DLL_NAME-v$VERSION.dll


from scratch AS export-stage
ARG DLL_NAME
ARG VERSION

COPY --from=stage1 /app/_build/Optimization/$DLL_NAME-v$VERSION.dll .