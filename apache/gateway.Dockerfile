FROM debian:bullseye

WORKDIR /var/www

RUN apt-get update && apt-get install -y build-essential wget

COPY ./deps/openssl-1.0.2q.tar.gz .

#Setting up weak ciphers
RUN tar xzvf openssl-1.0.2q.tar.gz \
    && cd openssl-1.0.2q \
    && ./config --prefix=/opt/openssl-1.0.2 \
        --openssldir=/etc/ssl \
        shared enable-weak-ssl-ciphers \
        enable-ssl3 enable-ssl3-method \
        enable-ssl2 \
        -Wl,-rpath=/opt/openssl-1.0.2/lib \
    && make \
    && make install

RUN rm openssl-1.0.2q.tar.gz && rm -rf openssl-1.0.2q

COPY ./arm-linux-gnueabihf.conf /etc/ld.so.conf.d/arm-linux-gnueabihf.conf

RUN ldconfig

#Compiling Apache2
RUN apt-get install -y libpcre3 \
    libpcre3-dev \
    libexpat1 \
    libexpat1-dev \
    libxml2 \
    libxml2-dev \
    libxslt1-dev \
    libxslt1.1

COPY ./deps/httpd-2.4.61.tar.gz .
COPY ./deps/apr-1.6.5.tar.gz .
COPY ./deps/apr-util-1.6.3.tar.gz .

RUN tar xzvf httpd-2.4.61.tar.gz \
    && cd httpd-2.4.61/srclib/ \
    && tar xzvf ../../apr-1.6.5.tar.gz \
    && tar xzvf ../../apr-util-1.6.3.tar.gz \
    && ln -s apr-1.6.5 apr \
    && ln -s apr-util-1.6.3 apr-util \
    && cd ../ \
    && ./configure --prefix=/opt/gateway \
        --with-included-apr \
        --with-ssl=/opt/openssl-1.0.2 \
        --enable-ssl \
    && make \
    && make install

RUN rm httpd-2.4.61.tar.gz && rm -rf httpd-2.4.61 \
    && rm apr-1.6.5.tar.gz && rm -rf apr-1.6.5 \
    && rm apr-util-1.6.3.tar.gz && rm -rf apr-util-1.6.3

COPY --chown=0:0 ./etc /etc/gateway 

WORKDIR /var/www

COPY ./sites-enabled /opt/gateway/sites-enabled
COPY ./conf.d /opt/gateway/conf.d
COPY ./etc /etc
COPY httpd.conf /opt/gateway/conf/httpd.conf
COPY ./www /var/www
COPY --chmod=754 ./start.sh /var/www/

CMD [ "sh", "-c", "/var/www/start.sh" ]