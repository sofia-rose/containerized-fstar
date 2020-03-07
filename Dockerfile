FROM debian:buster-20200224

################################################################################
# Update apt and install system packages
################################################################################
RUN apt-get update \
 && apt-get install -y \
    curl \
    darcs \
    gcc \
    git \
    m4 \
    make \
    mercurial \
    patch \
    rsync \
    sudo \
    unzip
################################################################################
# End Update apt and install system packages
################################################################################


################################################################################
# Install OPAM
################################################################################
ARG OPAM_VERSION
ADD opam-${OPAM_VERSION}-x86_64-linux.sha256 /tmp/
RUN curl -sSLo /usr/local/bin/opam \
  https://github.com/ocaml/opam/releases/download/${OPAM_VERSION}/opam-${OPAM_VERSION}-x86_64-linux \
 && chmod +x /usr/local/bin/opam \
 && sha256sum -c /tmp/opam-${OPAM_VERSION}-x86_64-linux.sha256 \
 && rm /tmp/opam-${OPAM_VERSION}-x86_64-linux.sha256
################################################################################
# End Install OPAM
################################################################################


################################################################################
# Create devuser
################################################################################
ARG USER_ID
ARG GROUP_ID

RUN useradd \
    --create-home \
    --shell /bin/bash \
    --uid ${USER_ID} \
    --gid ${GROUP_ID} \
    devuser \
 && echo "devuser ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

USER devuser
ENV HOME /home/devuser
################################################################################
# End Create devuser
################################################################################


################################################################################
# Initialize OPAM and install OCaml
################################################################################
ARG OCAML_VERSION
RUN opam init -y \
    --disable-sandboxing \
    --compiler=${OCAML_VERSION} \
    --dot-profile=/home/devuser/.bashrc \
    --shell-setup \
    --enable-completion \
 && opam update
################################################################################
# End Initialize OPAM and install OCaml
################################################################################

################################################################################
# Install Z3
################################################################################
ARG Z3_URL
RUN mkdir -p /home/devuser/tmp \
 && curl -sSLo /home/devuser/tmp/z3.zip ${Z3_URL} \
 && unzip /home/devuser/tmp/z3.zip -d /home/devuser/tmp \
 && mv /home/devuser/tmp/z3-* /home/devuser/z3 \
 && rm -rf /home/devuser/tmp
ENV Z3_HOME /home/devuser/z3
ENV PATH ${Z3_HOME}/bin:${PATH}
################################################################################
# End Install Z3
################################################################################


################################################################################
# Install F*
################################################################################
ARG FSTAR_SHA
RUN mkdir -p /home/devuser/fstar /home/devuser/tmp \
 && curl -sSLo /home/devuser/tmp/fstar.tar.gz \
    https://github.com/FStarLang/FStar/archive/${FSTAR_SHA}.tar.gz \
 && tar --strip-components=1 -C /home/devuser/fstar -xzf /home/devuser/tmp/fstar.tar.gz \
 && cd /home/devuser/fstar \
 && sudo apt-get install -y libgmp-dev \
 && opam install -y \
    ocamlbuild \
    ocamlfind \
    batteries \
    stdint \
    zarith \
    yojson \
    fileutils \
    pprint \
    menhir\>20161115 \
    ulex \
    ppx_deriving \
    ppx_deriving_yojson \
    process \
 && eval $(opam env) \
 && make -j6 -C src ocaml-fstar-ocaml \
 && make -j6 -C ulib \
 && make -j6 -C ulib/ml \
 && rm -rf /home/devuser/tmp \
 && ln -s /home/devuser/fstar/bin/fstar.exe /home/devuser/fstar/bin/fstar
ENV FSTAR_HOME /home/devuser/fstar
ENV PATH ${FSTAR_HOME}/bin:${PATH}
################################################################################
# End Install F*
################################################################################


################################################################################
# Install Kremlin
################################################################################
ARG KREMLIN_SHA
ENV KREMLIN_HOME /home/devuser/kremlin
RUN mkdir -p /home/devuser/kremlin /home/devuser/tmp \
 && curl -sSLo /home/devuser/tmp/kremlin.tar.gz \
    https://github.com/FStarLang/kremlin/archive/${KREMLIN_SHA}.tar.gz \
 && tar --strip-components=1 -C /home/devuser/kremlin -xzf /home/devuser/tmp/kremlin.tar.gz \
 && cd /home/devuser/kremlin \
 && sudo apt-get install -y \
    libffi-dev \
    pkg-config \
 && opam install -y \
    ppx_deriving_yojson \
    zarith \
    pprint \
    menhir \
    sedlex \
    process \
    fix \
    wasm \
    visitors \
    ctypes-foreign \
    ctypes \
 && eval $(opam env) \
 && make -j6 \
 && make -j6 test \
 && rm -rf /home/devuser/tmp
ENV PATH ${KREMLIN_HOME}:${PATH}
################################################################################
# End Install Kremlin
################################################################################


################################################################################
# Build F* Examples (some require kremlin)
################################################################################
RUN eval $(opam env) \
 && cd $FSTAR_HOME \
 && make -j6 -C examples
################################################################################
# Build F* Examples (some require kremlin)
################################################################################


################################################################################
# Install Vale
################################################################################
ARG VALE_VERSION
ENV VALE_HOME /home/devuser/vale
RUN sudo apt-get install -y mono-devel
RUN mkdir -p /home/devuser/tmp \
 && curl -sSLo /home/devuser/tmp/vale.zip \
    https://github.com/project-everest/vale/releases/download/v${VALE_VERSION}/vale-release-${VALE_VERSION}.zip \
 && unzip /home/devuser/tmp/vale.zip -d /home/devuser/tmp \
 && mv /home/devuser/tmp/vale-release-${VALE_VERSION} /home/devuser/vale \
 && chmod --reference=/home/devuser /home/devuser/vale/bin \
 && echo -e \
    "#\!/usr/bin/env bash\nexec mono ${VALE_HOME}/bin/vale.exe \"\${@}\"" \
    > ${VALE_HOME}/bin/vale \
 && chmod +x ${VALE_HOME}/bin/vale \
 && rm -rf /home/devuser/tmp
ENV PATH ${VALE_HOME}/bin:${PATH}
################################################################################
# End Install Vale
################################################################################

WORKDIR /home/devuser/workspace
