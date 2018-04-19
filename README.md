# S2I OSGI Minecraft Plugin Image

[![Build Status](https://travis-ci.org/edewit/minecraft-sponge-plugin-s2i.svg?branch=master)](https://travis-ci.org/edewit/minecraft-sponge-plugin-s2i)

This repository contains the sources and [Dockerfile](https://github.com/edewit/minecraft-sponge-plugin-s2i/blob/osgi-s2i/Dockerfile) of the base image for deploying [OSGI based](https://github.com/vorburger/ch.vorburger.minecraft.osgi) Minecraft plugins as reproducible Docker images. The resulting images can be run either by [Docker](http://docker.io) or using [S2I](https://github.com/openshift/source-to-image).

## Usage

To build a simple sponge minecraft plugin using standalone S2I and then run the resulting image with Docker execute:

```
$ s2i build git@github.com/edewit/minecraft-che-test.git edewit/minecraft-osgi-plugin-s2i minecraft-sample-plugin
$ docker run -p 25565:25565 minecraft-sample-plugin
```

## Repository organization

* **`s2i/bin/`**

  This folder contains scripts that are run by [S2I](https://github.com/openshift/source-to-image):

  *   **assemble**

      Is used to restore the build artifacts from the previous built (in case of
      'incremental build'), to install the sources into location from where the
      server will be run and build the plugin (eg.
      using maven to build the plugin etc..)

  *   **run**

      This script is responsible for running a minecraft sponge server using `java -jar`.

  *   **save-artifacts**

      In order to do an *incremental build* (iow. re-use the build artifacts
      from an already built image in a new image), this script is responsible for
      archiving those. In this image, this script will archive the
      `/opt/java/.m2` directory.

## Environment variables

*  **MVN_ARGS** (default: '')

    This variable specifies the arguments for Maven inside the container.


## Contributing

In order to test your changes to this STI image or to the STI scripts, you can use the `test/run` script. Before that, you have to build the 'candidate' image:

```
$ make
```

After that you can execute `./test/run`. You can also use `make test` to automate this.

## Copyright

Released under the Apache License 2.0. See the [LICENSE](https://github.com/edewit/minecraft-sponge-plugin-s2i/blob/master/LICENSE) file.