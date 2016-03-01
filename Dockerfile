# springboot-maven3-centos
#
# This image provide a base for running Spring Boot based applications. It
# provides a base Java 8 installation and Maven 3.

FROM centos:centos7

# Location of the STI scripts inside the image
#
LABEL io.openshift.s2i.scripts-url=image:///usr/libexec/s2i

# Path to be used in other layers to place s2i scripts into
ENV STI_SCRIPTS_PATH=/usr/libexec/s2i

ENV JAVA_VERSON 1.8.0
ENV MAVEN_VERSION 3.3.9

RUN yum update -y && \
  yum install -y curl && \
  yum install -y java-$JAVA_VERSON-openjdk java-$JAVA_VERSON-openjdk-devel && \
  yum clean all

RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV JAVA_HOME /usr/lib/jvm/java
ENV MAVEN_HOME /usr/share/maven

# Add configuration files, bashrc and other tweaks
ADD ./s2i/bin/ $STI_SCRIPTS_PATH

# Create 'ruby' account we will use to run Ruby application
# Add support for '#!/usr/bin/ruby' shebang.
RUN mkdir -p /opt/java/src && \
    groupadd -r java -f -g 433 && \
    useradd -u 431 -r -g java -d /opt/java -s /sbin/nologin -c "Java user" java && \
    chown -R java:java /opt/java

# Set the 'root' directory for this build
#
# This can be overridden inside another Dockerfile that uses this image as a base
# image or in STI via the '-e "APP_ROOT=subdir"' option.
#
# Use this in case when your application is contained in a subfolder of your
# GIT repository. The default value is the root folder.
ENV APP_ROOT .
ENV HOME     /opt/java
ENV PATH     $HOME/bin:$PATH

WORKDIR     /opt/java/src
USER        java

EXPOSE 8080

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
