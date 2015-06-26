FROM piotrminkina/alpine:3.2
MAINTAINER Piotr Minkina <projects[i.am.spamer]@piotrminkina.pl>


RUN apk --update add ca-certificates gnupg iptables squid wget
RUN ping -c 2 pool.sks-keyservers.net
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN wget -qO /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64" 
RUN wget -qO /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.4/gosu-amd64.asc" 
RUN gpg --verify /usr/local/bin/gosu.asc 
RUN chmod +x /usr/local/bin/gosu
RUN apk del --purge gnupg wget
RUN rm -rf /usr/local/bin/gosu.asc /root/.gnupg /var/cache/apk/*


RUN sed -i "s!^#cache_dir ufs /var/cache/squid 100 16 256!cache_dir ufs /var/cache/squid 5000 16 256!" /etc/squid/squid.conf \
 && sed -i "s!^http_port 3128!http_port 3128\nhttp_port 3129 intercept!" /etc/squid/squid.conf \
 && echo 'maximum_object_size 1000 MB' >> /etc/squid/squid.conf

COPY entrypoint.sh /usr/local/bin/entrypoint

VOLUME /var/cache/squid /var/log/squid
EXPOSE 3128 3129
ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD []
