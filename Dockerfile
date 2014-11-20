FROM debian:stable
MAINTAINER Johannes Dröge, johannes.droege@uni-duesseldorf.de

ENV DEBIAN_FRONTEND noninteractive

ENV DCKR_MNT /dckr/mnt
ENV DCKR_TASKS /dckr/etc/tasks.d
ENV DCKR_INTERFACE /dckr/etc/interface.conf

# user UID must match UID of host shared folder, until docker supports proper user mapping
# unpriviledged container processes are more secure when mounting host folders
ENV DCKR_USER nobody

# anonymous volumes
VOLUME ["/tmp", "/var/tmp"]

# add container functionality
COPY dckr /dckr

# settings
RUN id $DCKR_USER || useradd -N -g nogroup $DCKR_USER
# in the following line, $DCKR_USER is not allowed in Docker 1.2
USER nobody
# in the following line, $DCKR_MNT is not allowed in Docker 1.2

# cleanup
RUN rm -rf /tmp/* /var/tmp/*

# default process on container startup
ENTRYPOINT ["/dckr/bin/run"]
