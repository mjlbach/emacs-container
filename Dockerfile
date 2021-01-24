FROM alpine:edge
RUN apk add --no-cache emacs zsh bash
RUN apk add --no-cache git cmake make clang build-base llvm-static llvm-dev clang-static clang-dev libtool perl
COPY bashrc /root/.bashrc
COPY init.el /root/.emacs.d/init.el
ENTRYPOINT ["emacs"]
