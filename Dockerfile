FROM debian:bullseye

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
      wget \
      curl \
      # Install recommended software
      yacas \
      gap \
      maxima \
      # maxima-share is  needed since we are not installing recommended packages by default
      maxima-share  \
      octave \
      graphviz \
      ldap-utils \
      scilab-cli \
      libwebservice-validator-html-w3c-perl \
      qrencode \
      fortune \
      unzip \
      zip \
      libgmp-dev \
      openbabel \
      povray \
      # Install other software
      bc \
      chemeq \
      # Install support for sending email (ssmtp alone is not enough)
      ssmtp \
      bsd-mailx && \
# Install Macaulay2
    apt-get install -y --no-install-recommends gnupg && \
    echo 'deb http://www.math.uiuc.edu/Macaulay2/Repositories/Debian bullseye main' > /etc/apt/sources.list.d/macaulay2.list && \
    wget -qO - http://www2.macaulay2.com/Macaulay2/PublicKeys/Macaulay2-key | apt-key add - && \
    apt-get update && \
    apt-get install -y --no-install-recommends macaulay2 && \
# Enable CGI
    a2enmod cgid && \
# Install support for working behind a reverse proxy
    a2enmod remoteip && \
# This is required to make the default WIMS path for GAP works
    ln -s gap /usr/bin/gap.sh && \
# Configure POVray according to WIMS instructions
    echo "read+write* = /home/wims/tmp/sessions" >> /etc/povray/3.7/povray.conf && \
# This is required if we want Maxima to find its help file, which avoids a warning at
# startup and allows WIMS to determine Maxima's version.
    gunzip /usr/share/doc/maxima/info/maxima-index.lisp.gz && \
# Add wims user
    adduser --disabled-password --gecos '' wims

# Compile WIMS
USER wims
WORKDIR /home/wims
RUN wget -q https://sourcesup.renater.fr/frs/download.php/file/6528/wims-4.24.tgz && \
    tar xzf wims-4.24.tgz && \
    rm wims-4.24.tgz && \
    (yes "" | ./compile --mathjax --jmol --modules --geogebra --shtooka)

# Configure WIMS and entry-point
USER root
COPY entrypoint.sh /
RUN apt-get -y install --no-install-recommends lsb-release && \
    ./bin/setwrapexec && \
    ./bin/setwimsd && \
    ./bin/apache-config && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /entrypoint.sh

# Metadata
LABEL maintainer="Gianluca Amato <gianluca.amato.74@gmail.com>"
VOLUME /home/wims/log
VOLUME /home/wims/public_html/modules/devel
ENTRYPOINT [ "/entrypoint.sh" ]
EXPOSE 80/tcp
