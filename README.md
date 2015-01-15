Interface framework for use in CAMI containers
==============================================

The Dockerfile and /dckr folder define an interface and enforce the binding of all the interchange directories in the container. They also define tasks which can be specified as the first docker run command line parameter. The Dockerfile sets up a default user which can be used to run all the commands inside the container. This container is meant to be used in the Dockerfile of derived containers in the CAMI contest but you can also pull and derive a container manually.

Variables for use in container
-----

Use the environment variables which are defined in the Dockerfile in your scripts and applications. Do not use absolute paths except for mounting the host volumes to the container (this is a limitation of the docker commmand). To list available mount points and their locations, see the output of ```docker run image --list-mount```. To see an exhaustive list of defined variables and their values, see the output of ```docker run cami/base --list-var```.
