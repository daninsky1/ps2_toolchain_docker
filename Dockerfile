FROM ps2dev/ps2dev:latest AS ps2

FROM ubuntu:22.04

ENV PS2DEV=/usr/local/ps2dev
ENV WORKING_DIRECTORY=/root/dev
ENV PS2TOOLCHAIN_REPO=https://github.com/ps2dev/ps2toolchain.git
ENV PS2SDK=$PS2DEV/ps2sdk
# ENV GSKIT $PS2DEV/gsKit
ENV PATH=$PATH:${PS2DEV}/bin:${PS2DEV}/ee/bin:${PS2DEV}/iop/bin:${PS2DEV}/dvp/bin:${PS2SDK}/bin
ENV PLATFORM=ps2

COPY --from=ps2 $PS2DEV $PS2DEV

# Update
RUN apt update && apt upgrade -y

# Non essential shell tools
RUN apt install -y neofetch vim

# Essential shell tools
RUN apt install -y bash fish git curl wget

# Essential build tools
RUN apt install -y build-essential git

# Dependecies
RUN apt install -y texinfo flex bison libgsl-dev libgmp-dev libmpfr-dev libmpc-dev gettext

# Shell
RUN wget https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install
RUN fish /install -y --noninteractive
RUN fish -c "omf install agnoster"
RUN echo "if status is-interactive\n \
    bind \\b backward-kill-bigword\n \
    alias ls='ls -l1Fhs --group-directories-first --dereference-command-line-symlink-to-dir --color=always' \n \
end" >> /root/.config/fish/config.fish

WORKDIR $WORKING_DIRECTORY

RUN git clone $PS2TOOLCHAIN_REPO

WORKDIR ${WORKING_DIRECTORY}/ps2toolchain
