FROM debian:stable
MAINTAINER Johannes Dröge, johannes.droege@uni-duesseldorf.de

ENV DEBIAN_FRONTEND noninteractive

# anonymous volumes
VOLUME ["/tmp", "/var/tmp"]

# upgrade to latest debian packages (avoid upgrade: https://docs.docker.com/articles/dockerfile_best-practices/)
RUN apt-get -q update && apt-get install -q -y -o DPkg::Options::=--force-confnew \
bc \
python-yaml \
&& apt-get -q clean && rm -rf /var/lib/apt/lists/*

# biobox base directory
ENV BBX_BASE /bbx

# location for container executables
ENV BBX_BINDIR ${BBX_BASE}/bin

# location of host mounts in the container
ENV BBX_MNTDIR ${BBX_BASE}/mnt

# container configuration files
ENV BBX_ETCDIR ${BBX_BASE}/etc

# location for container shared code
ENV BBX_LIBDIR ${BBX_BASE}/lib

# persistent storage, can be linked to named volume
ENV BBX_CACHEDIR ${BBX_MNTDIR}/cache

# location for task definitions (simple sh syntax)
ENV BBX_TASKDIR ${BBX_ETCDIR}/tasks.d

# manditory mount point definitions
ENV BBX_MNTCONF ${BBX_ETCDIR}/mount.conf

# add container functionality
COPY bbx /bbx

# create mandatory directories
RUN [ -d "$BBX_MNTDIR" ] || mkdir "$BBX_MNTDIR"
RUN [ -d "$BBX_CACHEDIR" ] || mkdir "$BBX_CACHEDIR"

# create optional default user
ENV BBX_RUNUSER bbxuser
ENV BBX_RUNGROUP bbxgroup
RUN groupadd "$BBX_RUNGROUP" || echo "$BBX_RUNGROUP exists."
RUN useradd -N -g "$BBX_RUNGROUP" "${BBX_RUNUSER}" || echo "$BBX_RUNUSER exists."

# cleanup all temporary data
RUN rm -rf /tmp/* /var/tmp/*; test -d "$TMPDIR" && rm -rf "$TMPDIR"/* || set ?=0

# default process on container startup (no support for infile variable substitution in Dockerfile)
ENTRYPOINT ["/bbx/bin/run"]
