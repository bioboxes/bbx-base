# Simple biobox base image for Docker

## Description

The image can be derived to implement bioboxes and provides the following functionality:

* a lightweight and stable Debian environment
* a parser for the bioboxes YAML input file and easy access of the passed parameters
* a common code base for biobox implementations
* definition of environment variables for your scripts in order to
 * avoid hard-coded file paths
 * provide better resource management
 * minimize errors when called from different host environments

The overall aim is to make the implementation of new bioboxes as easy and fast as possible.

## Concepts

### Init tasks

A container can do different things and the here we call each basic thing a task. A task is defined to be the any alphanumerical string passed the first argument to the container after '''docker run container-name'''. A task is implemented by a simple text files ${BBX_TASKDIR}/taskname. This file states the command line to be executed and can make use of all static environment variables as well as the input YAML parameters. If no task is given to the container, the task called default will be run.

### Init options

An init option is defined to be any alphanumerical string beginning with two dashes (`--`) and following the docker image name. The implementation of init options is currently almost identical to the tasks. There are some pre-defined options such as `docker run -t -i image --shell` (which drops you to a root shell, not the additional docker options which are necessary). To list mandatory mount points and their locations, see the output of `docker run image --list-mount`. to ease the development. To list available mount points and their locations, see the output of `docker run image --list-mount`.

### Bioboxes YAML parameters

The recent bioboxes.org specifications define the input to be in YAML format. Common types of applications can share an interface definition in form of a YAML definition. This structured approach has the advantage that arbitrarily complex interfaces can be defined, re-implemented and validated automatically. However, for any particular biobox implementation, it increases the complexity because the YAML file has to be parsed inside the container.

### Environment variables

Environment variables can be used to avoid hardcoding paths in the container (in case they might change) and to access information other than the Biobox parameters, which might require additional code. Most of these variables are defined in the Dockerfile but some might be added dynamically by the init run system. Currently, the best way to explore all available environment variables is by use of the init option `docker run image --list-var`.
