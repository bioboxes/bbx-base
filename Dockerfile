FROM debian:stable
MAINTAINER Johannes Dröge, johannes.droege@uni-duesseldorf.de

ENV DEBIAN_FRONTEND noninteractive

# anonymous volumes
VOLUME ["/tmp", "/var/tmp"]

# upgrade to latest debian packages
RUN apt-get -q update && apt-get upgrade -q -y -o DPkg::Options::=--force-confnew && \
apt-get -q clean && rm -rf /var/lib/apt/lists/*

ENV DCKR_MNT /dckr/mnt
ENV DCKR_ETC /dckr/etc
ENV DCKR_TASKS $DCKR_ETC/tasks.d
ENV DCKR_BIND $DCKR_ETC/dockermount.conf
ENV DCKR_USER nobody
ENV DCKR_THREADS 1

# add container functionality
COPY dckr /dckr

# settings
RUN id $DCKR_USER || useradd -N -g nogroup $DCKR_USER

# cleanup
RUN rm -rf /tmp/* /var/tmp/*

# default process on container startup
ENTRYPOINT ["/dckr/bin/run"]
