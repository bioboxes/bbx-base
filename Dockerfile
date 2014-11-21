FROM debian:stable
MAINTAINER Johannes Dröge, johannes.droege@uni-duesseldorf.de

ENV DEBIAN_FRONTEND noninteractive

# anonymous volumes
VOLUME ["/tmp", "/var/tmp"]

# upgrade to latest debian packages
RUN apt-get -q update && apt-get upgrade -q -y -o DPkg::Options::=--force-confnew && \
apt-get -q clean && rm -rf /var/lib/apt/lists/*

ENV DCKR_MNT /dckr/mnt
ENV DCKR_TASKS /dckr/etc/tasks.d
ENV DCKR_INTERFACE /dckr/etc/dockermount.conf

# user UID must match UID of host shared folder, until docker supports proper user mapping
# unpriviledged container processes are more secure when mounting host folders
ENV DCKR_USER nobody

# add container functionality
COPY dckr /dckr

# settings
RUN id $DCKR_USER || useradd -N -g nogroup $DCKR_USER

# cleanup
RUN rm -rf /tmp/* /var/tmp/*

# default process on container startup
ENTRYPOINT ["/dckr/bin/run"]
