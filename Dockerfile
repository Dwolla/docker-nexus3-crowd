FROM sonatype/nexus3:3.18.1
MAINTAINER Dwolla Dev <dev+docker-nexus3-crowd@dwolla.com>
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/docker-nexus3-crowd"

USER root
COPY startup.sh /
RUN export M2_HOME=/opt/maven && \
    export PATH=${M2_HOME}/bin:${PATH} && \
    yum install -y git which && \
    cd /opt && \
    curl -O http://www.trieuvan.com/apache/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz && \
    tar xzvf apache-maven-3.6.1-bin.tar.gz && \
    ln -s apache-maven-3.6.1 maven && \
    git clone https://github.com/pingunaut/nexus3-crowd-plugin.git && \
    cd nexus3-crowd-plugin && \
    git checkout tags/nexus3-crowd-plugin-3.5.0 && \
    mvn install && \
    cp -ra ~/.m2/repository/com/pingunaut /opt/sonatype/nexus/system/com && \
    echo -e 'mvn\:com.pingunaut.nexus/nexus3-crowd-plugin/3.5.0 = 200' >> /opt/sonatype/nexus/etc/karaf/startup.properties && \
    yum remove -y git && \
    rm -rf /opt/*maven* && \
    unset M2_HOME && \
    touch /opt/sonatype/nexus/etc/crowd.properties && \
    chown nexus /opt/sonatype/nexus/etc/crowd.properties && \
    chmod u+w /opt/sonatype/nexus/etc/crowd.properties

USER nexus

CMD ["/startup.sh"]
