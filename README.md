docker-ttk
==========

taxator-tk in a Docker container.

The Dockerfile and /dckr folder define an interface and enforce the binding of all the interchange directories in the container. They also define tasks which can be specified as the first docker run command line parameter. The Dockerfile sets the default user which is used to run all the commands inside the container to 'nobody' because this seems to be the only user with a consistent UID mapping from host to container for most distributions (besides the default user root who can do anything to the host filesystem). This is a precaution because currently there is no user remapping for mounted host directories for Docker to prevent processes in the host to modify or delete files on the host filesystem.

Usage
-----

1. Get Docker build files

        git clone https://github.com/CAMI-challenge/docker-ttk.git

2. Build the Docker image

        docker build -t="fungs/taxator-tk" docker-ttk

3. Create the interface

        mkdir in out ref  # directies which are mounted in the container
        mv mysample.fna in/sample.fna  # move your sample to the in folder
        sudo chown -R nobody in out ref  # make read-writable for user nobody

4. Run Docker container

        docker run -v $PWD/in:/dckr/mnt/in:ro -v $PWD/ref:/dckr/mnt/ref:rw -v $PWD/out:/dckr/mnt/out:rw fungs/taxator-tk download-refpack
        docker run -v $PWD/in:/dckr/mnt/in:ro -v $PWD/ref:/dckr/mnt/ref:rw -v $PWD/out:/dckr/mnt/out:rw fungs/taxator-tk index-blast
        docker run -v $PWD/in:/dckr/mnt/in:ro -v $PWD/ref:/dckr/mnt/ref:ro -v $PWD/out:/dckr/mnt/out:rw fungs/taxator-tk classify-blast

Use *index-last* and *classify-last* for better sensitivity in classification. Note that the LAST index requires more space in the *ref* folder.
