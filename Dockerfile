FROM debian:stable
MAINTAINER Johannes Dröge, johannes.droege@uni-duesseldorf.de

ENV DEBIAN_FRONTEND noninteractive

# anonymous volumes
VOLUME ["/tmp", "/var/tmp", "/dckr/cache"]

# upgrade to latest debian packages
RUN apt-get -q update && apt-get upgrade -q -y -o DPkg::Options::=--force-confnew && \
apt-get -q clean && rm -rf /var/lib/apt/lists/*

ENV DCKR_MNT /dckr/mnt  # place to mount host folders into container
ENV DCKR_ETC /dckr/etc  # configuration files specific to the interface framework
ENV DCKR_CACHEDIR /dckr/cache  # to be used as persistent storage, can be linked to named volume
ENV DCKR_TASKDIR $DCKR_ETC/tasks.d  # place task definitions here
ENV DCKR_BINDCONF $DCKR_ETC/dockermount.conf  # define manditory mount points
ENV DCKR_USER nobody  # optional user to be used for running programs in the container (improves security)
ENV DCKR_THREADS 1  # number of threads available to the container (autodetection possible)

# add container functionality
COPY dckr /dckr

# settings
RUN id $DCKR_USER || useradd -N -g nogroup $DCKR_USER

# cleanup
RUN rm -rf /tmp/* /var/tmp/*

# default process on container startup
ENTRYPOINT ["/dckr/bin/run"]
