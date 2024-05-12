FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
# Install packages
    apt-get -y --no-install-recommends install \
      # Install Apache
      apache2 \
      # Install required software
      make \
      g++ \
      texlive-base \
      texlive-latex-base \
      gnuplot \
      pari-gp \
      units-filter \
      flex \
      bison \
      perl \
      liburi-perl \
      imagemagick \
      libgd-dev \
      libfl-dev \
      wget \
      curl \
      # Install recommended software
      yacas \
      gap \
      maxima \
      # maxima-share is  needed since we are not installing recommended packages by default
      maxima-share  \
      octave \
      octave-statistics \
      graphviz \
      ldap-utils \
      scilab-cli \
      libwebservice-validator-html-w3c-perl \
      qrencode \
      fortune \
      zip \
      unzip \
      libgmp-dev \
      openbabel \
      # Other recommended software
      povray \
      macaulay2 \
      # Install other software
      bc \
      chemeq \
      # Install support for sending email (ssmtp alone is not enough)
      ssmtp \
      bsd-mailx && \
# Enable CGI
    a2enmod cgid && \
# Install support for working behind a reverse proxy
    a2enmod remoteip && \
# This is required to make the default WIMS path for GAP works
    ln -s gap /usr/bin/gap.sh && \
# Configure POVray according to WIMS instructions
    echo "read+write* = /home/wims/tmp/sessions" >> /etc/povray/3.7/povray.conf && \
    echo "pkg load statistics" >>  /etc/octaverc && \
    # WIMS instructions says 128k, but latest versions do not work with such a small stack size
    echo "-Xss256k" >> /usr/share/octave/6.4.0/m/java/java.opts && \
# Add wims user
    adduser --disabled-password --gecos '' wims

# Compile WIMS
USER wims
WORKDIR /home/wims
RUN wget https://sourcesup.renater.fr/frs/download.php/file/6667/wims-4.26.tgz && \
    tar xzf wims-4.26.tgz && \
    rm wims-4.26.tgz && \
    (yes "" | ./compile --mathjax --jmol --modules --geogebra --shtooka)

# Configure WIMS and entry-point
USER root
COPY entrypoint.sh /
RUN apt-get -y install --no-install-recommends lsb-release && \
    ./bin/setwrapexec && \
    ./bin/setwimsd && \
    ./bin/apache-config && \
    chmod go-rwx ./src && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /entrypoint.sh

# Metadata
LABEL maintainer="Gianluca Amato <gianluca.amato.74@gmail.com>"
VOLUME /home/wims/log
VOLUME /home/wims/public_html/modules/devel
ENTRYPOINT [ "/entrypoint.sh" ]
EXPOSE 80/tcp
