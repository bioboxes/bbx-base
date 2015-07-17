# A simple bioboxes base image for Docker (EXPERIMENTAL!)

## Description

The image can be derived to implement bioboxes and provides the following functionality:

* a lightweight and stable Debian environment
* a parser for the bioboxes YAML input file and easy access of the passed parameters
* convenience scripts
* a common base image for biobox implementations to facilitate debugging, support and image size
* definition of environment variables for your scripts in order to
 * avoid hard-coded file paths
 * provide better resource management
 * minimize errors when called from different host environments

The overall aim is to make the implementation of new bioboxes as easy and fast as possible.

## Concepts

### Init tasks

A container can do different things and the here we call each basic thing a task. A task is defined to be the any alphanumerical string passed the first argument to the container after '''docker run container-name'''. A task is implemented by a simple text files ${BBX_TASKDIR}/taskname. This file states the command line to be executed and can make use of all static environment variables as well as the input YAML parameters. If no task is given to the container, the task called default will be run.

### Init options

An init option is defined to be any alphanumerical string beginning with two dashes (`--`) and following the docker image name. The implementation of init options is currently almost identical to the tasks. There are some pre-defined options such as `docker run -t -i image --shell` (which drops you to a root shell, note the additional docker options `-t -i` which are necessary). To list mandatory mount points and their locations, see the output of `docker run image --list-mount`. to ease the development. To list available mount points and their locations, see the output of `docker run image --list-mount`.

### Bioboxes YAML parameters

The recent bioboxes.org specifications define the input to be in YAML format. Common types of applications can share an interface definition in form of a YAML definition. This structured approach has the advantage that arbitrarily complex interfaces can be defined, re-implemented and validated automatically. However, for any particular biobox implementation, it increases the complexity because the YAML file has to be parsed inside the container. If it is suitible for the biobox implementor, YAML options which have been passed to the container as defined by the bioboxes specification can be accessed as environment variables. The variables can be listed with the init option `--list-input`.


### Environment variables

Environment variables can be used to avoid hardcoding paths in the container (in case they might change) and to access information other than the Biobox parameters, which might require additional code. Most of these variables are defined in the Dockerfile but  some might be added dynamically by the init run system. Currently, the best way to explore all available environment variables is by use of the init option `docker run image --list-var`.

## Using the base image

* For testing your software or exploring the base image, just run
  * `docker run docker run -i -t fungs/bbx-base --shell`

* To implement a biobox
 1. Derive from the base image in a Dockerfile, use the syntax `FROM fungs/bbx-base`
 2. Copy your software into the container, e.g. by any of the following methods
    * `COPY yoursoftware /opt/yoursoftware`
    * `RUN dpkg -i yoursoftware.deb`
    * `RUN apt-get install yoursoftware`
 3. Write the command line to run into a text file named 'mytask' and copy it to `$BBX_TASKDIR/`

* Compile and run your biobox
  * `docker build -t="myuser/mybiobox" folder_containing_Dockerfile`
  * `docker run --bioboxes-docker-options-and-mounts myuser/mybiobox mytask`
