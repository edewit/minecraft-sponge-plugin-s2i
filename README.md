Spring Boot - Maven 3 - CentOS Docker image
========================================

This repository contains the sources and
[Dockerfile](https://github.com/codecentric/springboot-maven3-centos/blob/master/Dockerfile)
of the base image for deploying Spring Boot applications as reproducible Docker
images. The resulting images can be run either by [Docker](http://docker.io)
or using [STI](https://github.com/openshift/source-to-image).

This image is heavily inspired by the awesome [openshift/ruby-20-centos](https://github.com/openshift/ruby-20-centos/)
builder image.

Installation
---------------

_TODO_ Publish Image to Docker Hub

Repository organization
------------------------

* **`.sti/bin/`**

  This folder contains scripts that are run by [STI](https://github.com/openshift/source-to-image):

  *   **assemble**

      Is used to restore the build artifacts from the previous built (in case of
      'incremental build'), to install the sources into location from where the
      application will be run and prepare the application for deployment (eg.
      using maven to build the application etc..)

  *   **run**

      This script is responsible for running a Spring Boot fat jar using `java -jar`.
      The image exposes port 8080, so it expects application to listen on port
      8080 for incoming request.

  *   **save-artifacts**

      In order to do an *incremental build* (iow. re-use the build artifacts
      from an already built image in a new image), this script is responsible for
      archiving those. In this image, this script will archive the
      `/opt/java/.m2` directory.

Environment variables
---------------------

*  **APP_ROOT** (default: '.')

    This variable specifies a relative location to your application inside the
    application GIT repository. In case your application is located in a
    sub-folder, you can set this variable to a *./myapplication*.

*  **STI_SCRIPTS_URL** (default: '[.sti/bin](https://raw.githubusercontent.com/codecentric/springboot-maven3-centos/master/.sti/bin)')

    This variable specifies the location of directory, where *assemble*, *run* and
    *save-artifacts* scripts are downloaded/copied from. By default the scripts
    in this repository will be used, but users can provide an alternative
    location and run their own scripts.

Contributing
------------

In order to test your changes to this STI image or to the STI scripts, you can
use the `test/run` script. Before that, you have to build the 'candidate' image:

```
$ docker build -t openshift/ruby-20-centos-candidate .
```

After that you can execute `./test/run`. You can also use `make test` to
automate this.

Usage
---------------------

**Building the [spring-boot-example](https://github.com/codecentric/spring-boot-example) Spring Boot application..**

1. **using standalone [STI](https://github.com/openshift/source-to-image) and running the resulting image by [Docker](http://docker.io):**

```
$ sti build git://github.com/codecentric/spring-boot-example codecentric/springboot-maven3-centos spring-boot-app
$ docker run -p 8080:8080 spring-boot-app
```

**Accessing the application:**
```
$ curl 127.0.0.1:8080
```

Copyright
--------------------

Released under the Apache License 2.0. See the [LICENSE](https://github.com/codecentric/springboot-maven3-centos/blob/master/LICENSE) file.
