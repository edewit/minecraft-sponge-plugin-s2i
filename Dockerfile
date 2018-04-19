# minecraft-osgi-plugin-s2i
#
# This image provide a base for running minecraft plugins. It
# provides a base Java 8 installation and Maven 3.

FROM openshift/base-centos7

EXPOSE 25565 25575 8080

ENV JAVA_VERSON 1.8.0
ENV MAVEN_VERSION 3.3.9

LABEL io.k8s.description="Platform for building and running minecraft plugins" \
      io.k8s.display-name="Minecraft plugin server" \
      io.openshift.expose-services="25565:tcp" \
      io.openshift.tags="builder,java,java8,maven,maven3,minecraft,plugins,osgi"

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
COPY ./s2i/bin/ $STI_SCRIPTS_PATH
COPY ./config/ /opt/app-root/

COPY ./server/ /opt/app-root
ADD http://search.maven.org/remotecontent?filepath=com/google/guava/guava/18.0/guava-18.0.jar /opt/app-root/osgi/boot/3_guava-18.0.jar
ADD http://search.maven.org/remotecontent?filepath=com/google/guava/guava/19.0/guava-19.0.jar /opt/app-root/osgi/boot/3_guava-19.0.jar
ADD http://search.maven.org/remotecontent?filepath=com/google/guava/guava/20.0/guava-20.0.jar /opt/app-root/osgi/boot/3_guava-20.0.jar
ADD http://search.maven.org/remotecontent?filepath=org/apache/felix/org.apache.felix.log/1.0.1/org.apache.felix.log-1.0.1.jar /opt/app-root/osgi/boot/1_org.apache.felix.log-1.0.1.jar
ADD http://search.maven.org/remotecontent?filepath=org/everit/osgi/org.everit.osgi.loglistener.slf4j/1.0.0/org.everit.osgi.loglistener.slf4j-1.0.0.jar /opt/app-root/osgi/boot/2_org.everit.osgi.loglistener.slf4j-1.0.0.jar
ADD http://search.maven.org/remotecontent?filepath=org/eclipse/xtext/org.eclipse.xtext.xbase.lib/2.10.0/org.eclipse.xtext.xbase.lib-2.10.0.jar /opt/app-root/osgi/boot/3_org.eclipse.xtext.xbase.lib-2.10.0.jar
ADD http://search.maven.org/remotecontent?filepath=org/eclipse/xtend/org.eclipse.xtend.lib.macro/2.10.0/org.eclipse.xtend.lib.macro-2.10.0.jar /opt/app-root/osgi/boot/3_org.eclipse.xtend.lib.macro-2.10.0.jar
ADD http://search.maven.org/remotecontent?filepath=org/eclipse/xtend/org.eclipse.xtend.lib/2.10.0/org.eclipse.xtend.lib-2.10.0.jar /opt/app-root/osgi/boot/3_org.eclipse.xtend.lib-2.10.0.jar

ADD https://s3.amazonaws.com/Minecraft.Download/versions/1.10.2/minecraft_server.1.10.2.jar /opt/app-root/minecraft_server.1.10.2.jar
ADD https://repo.spongepowered.org/maven/org/spongepowered/spongevanilla/1.10.2-5.1.0-BETA-374/spongevanilla-1.10.2-5.1.0-BETA-374.jar /opt/app-root/spongevanilla.jar
RUN echo "eula=true" > /opt/app-root/eula.txt

RUN chgrp -R 0 /opt/app-root && chmod -R g=u /opt/app-root
USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
