FROM debian:stable
MAINTAINER Johannes Dröge, johannes.droege@uni-duesseldorf.de

ENV DEBIAN_FRONTEND noninteractive

# anonymous volumes
VOLUME ["/tmp", "/var/tmp"]

# upgrade to latest debian packages (avoid upgrade: https://docs.docker.com/articles/dockerfile_best-practices/)
# RUN apt-get -q update && apt-get upgrade -q -y -o DPkg::Options::=--force-confnew && \
# apt-get -q clean && rm -rf /var/lib/apt/lists/*

# biobox base directory
ENV BBX_BASE /bbx

# location of container executables
ENV BBX_BINDIR ${BBX_BASE}/bin

# location of host mounts in the container
ENV BBX_MNTDIR ${BBX_BASE}/mnt

# container configuration files
ENV BBX_ETCDIR ${BBX_BASE}/etc

# persistent storage, can be linked to named volume
ENV BBX_CACHEDIR ${BBX_MNTDIR}/cache

# location for task definitions (simple sh syntax)
ENV BBX_TASKDIR ${BBX_ETCDIR}/tasks.d

# manditory mount point definitions
ENV BBX_MNTCONF ${BBX_ETCDIR}/mount.conf

# add container functionality
COPY bbx /bbx

# create cache directory (in case it's not mounted)
RUN mkdir ${BBX_CACHEDIR}

# create optional default user
ENV BBX_RUNUSER nobody
ENV BBX_RUNGROUP nogroup
RUN groupadd ${BBX_RUNGROUP} || echo "${BBX_RUNGROUP} exists."
RUN useradd -N -g ${BBX_RUNGROUP} ${BBX_RUNUSER} || echo "${BBX_RUNUSER} exists."

# cleanup all temporary data
RUN rm -rf /tmp/* /var/tmp/*; test -d "$TMPDIR" && rm -rf "$TMPDIR"/* || set ?=0

# default process on container startup
ENTRYPOINT ["${BBX_BINDIR}/run"]
