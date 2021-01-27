FROM fedora:latest
RUN dnf -y update && dnf -y install git emacs zsh bash && dnf clean all
RUN dnf -y update && dnf -y install cmake make clang automake gcc gcc-c++ libtool perl && dnf clean all
RUN dnf -y update && dnf -y install hostname && dnf clean all
COPY bashrc /root/.bashrc
COPY zshrc /root/.zshrc
COPY init.el /root/.emacs.d/init.el
ENTRYPOINT ["emacs"]
