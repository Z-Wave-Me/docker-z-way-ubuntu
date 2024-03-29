FROM ubuntu:focal

RUN apt-get update && \
    apt-get install -y wget procps gpg libcurl4 logrotate

ENV branch=ubuntu
ENV distro=focal

ENV TZ=Europe/Moscow

WORKDIR /opt
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add Z-Wave.Me repository
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 5b2f88a91611e683 && \
    echo "deb https://repo.z-wave.me/z-way/$branch $distro main" > /etc/apt/sources.list.d/z-wave-me.list

# Update packages list
RUN apt-get update && \
    apt-get install -y z-way-server zbw

ENV LD_LIBRARY_PATH=/opt/z-way-server/libs
ENV PATH=/opt/z-way-server:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

VOLUME ["/opt/z-way-server/config/zddx"]
VOLUME ["/opt/z-way-server/automation/storage"]

EXPOSE 8083

CMD /etc/init.d/z-way-server start && /bin/bash 
