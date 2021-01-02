FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

# Install packages
# The option --path-include is needed in order to get the help file for Maxima, avoiding a warning at startup
RUN apt-get update && apt-get -y --no-install-recommends -o Dpkg::Options::="--path-include=/usr/share/doc/maxima/info/*" install \
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
    # Install additional software not present in a container image
    wget \
    # Install recommended software
    yacas \
    gap \
    maxima \
       # maxima-share is  needed since we are not installing recommended packages by default
    maxima-share  \
    octave \
    graphviz \
    ldap-utils \
       # scilab-cli is not recognized by WIMS
    scilab-cli \
    libwebservice-validator-html-w3c-perl \
    qrencode \
    fortune-mod \
    unzip \
    openbabel \
    povray \
    # Install other software
    bc \
    chemeq \
    # Install support for sending email (ssmtp alone is not enough)
    ssmtp \
    bsd-mailx

# Install Macaulay2
RUN apt-get install -y --no-install-recommends gnupg && \
    echo 'deb http://www.math.uiuc.edu/Macaulay2/Repositories/Ubuntu bionic main' > /etc/apt/sources.list.d/macaulay2.list && \
    apt-key adv --keyserver hkp://keys.gnupg.net --recv-key CD9C0E09B0C780943A1AD85553F8BD99F40DCB31 && \
    apt-get update && apt-get -y --no-install-recommends install macaulay2

# Enable CGI
RUN a2enmod cgid

# Install support for working behind a reverse proxy
RUN apt-get -y --no-install-recommends install iproute2 && \
    a2enmod remoteip

# This is required to make the default WIMS path for GAP works
RUN ln -s gap /usr/bin/gap.sh

# Compile WIMS
RUN adduser --disabled-password --gecos '' wims
USER wims
WORKDIR /home/wims
RUN wget -q https://sourcesup.renater.fr/frs/download.php/file/6299/wims-4.21e.tgz && \
    tar xzf wims-4.21e.tgz && \
    rm wims-4.21e.tgz && \
    (yes "" | ./compile --mathjax --jmol --modules --geogebra --swac)

# Configure WIMS
USER root
RUN ./bin/setwrapexec && \
    ./bin/setwimsd && \
    ./bin/apache-config

# Copy entrypoint script
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Metadata
LABEL maintainer="Gianluca Amato <gianluca.amato.74@gmail.com>"
VOLUME /home/wims/log
ENTRYPOINT [ "/entrypoint.sh" ]
EXPOSE 80/tcp
