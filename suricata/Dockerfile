FROM ubuntu:16.04
MAINTAINER Hallman He <heyong1949@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

## Install dependencies
RUN apt-get update && apt-get install -y \
	libpcre3 libpcre3-dbg libpcre3-dev \
        build-essential autoconf automake libtool libpcap-dev libnet1-dev \
        libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libcap-ng-dev libcap-ng0 \
        make libmagic-dev libjansson-dev libjansson4 pkg-config \
        libnetfilter-queue-dev libnetfilter-queue1 libnfnetlink-dev libnfnetlink0 \
        python-pip python-dev build-essential wget git supervisor \
        && \
#    pip install --upgrade pip && \
    pip install --upgrade distribute  && \
    pip install pyyaml && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Install hpfeeds and required libs...
RUN cd /tmp && \
    rm -rf libev*  && \
    wget https://github.com/threatstream/hpfeeds/releases/download/libev-4.15/libev-4.15.tar.gz && \
    tar zxvf libev-4.15.tar.gz && \ 
    cd libev-4.15 && \
    ./configure && make && make install && \
    ldconfig

RUN cd /tmp && \
    rm -rf hpfeeds && \
    git clone https://github.com/threatstream/hpfeeds.git && \
    cd hpfeeds/appsupport/libhpfeeds && \
    autoreconf --install && \
    ./configure && make && make install  && \
    ldconfig

RUN cd /tmp && \
    rm -rf htp* && \
    wget https://github.com/ironbee/libhtp/releases/download/0.5.15/htp-0.5.15.tar.gz && \
    tar -xzvf htp-0.5.15.tar.gz && \
    cd htp-0.5.15 && \
    ./configure && make && make install  && \
    ldconfig

## Install suricata
RUN mkdir -p /opt/suricata/etc/suricata/rules /opt/mhn/rules/ && \
    cd /tmp && \
    rm -rf suricata && \
    git clone -b hpfeeds-support https://github.com/threatstream/suricata.git && \
    cd suricata && \
    ./autogen.sh || ./autogen.sh && \
    export CPPFLAGS=-I/include && \
    ./configure --prefix=/opt/suricata --localstatedir=/var/ --enable-non-bundled-htp && \
    make && \
    make install-full

##Auto update rules from MHN
COPY ./etc/suricata/rules/update_suricata_rules.sh /etc/cron.daily/
RUN chmod 755 /etc/cron.daily/update_suricata_rules.sh

## Configuration
VOlUME ["/etc/supervisor/conf.d","/opt/suricata/etc/suricata","/var/log/suricata"]
WORKDIR /opt/suricata
CMD ["/usr/bin/supervisord","--nodaemon","-c","/etc/supervisor/supervisord.conf"]
