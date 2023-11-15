FROM archlinux:latest AS stage1

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

RUN cmake -DMINGW32=1 .. && make

RUN mv Optimization/libOptimization.dll Optimization/Optimization.dll


from scratch AS export-stage

COPY --from=stage1 /app/_build/Optimization/Optimization.dll .