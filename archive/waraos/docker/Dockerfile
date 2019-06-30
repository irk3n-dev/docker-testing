FROM alpine

# Create user
RUN adduser -D -u 1000 -g 1000 -s /bin/sh www-data && \
    mkdir -p /www && \
    chown -R www-data:www-data /www

# Install tini - 'cause zombies - see: https://github.com/ochinchina/supervisord/issues/60
# (also pkill hack)
RUN apk add --no-cache --update tini

# Install a golang port of supervisord
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/bin/supervisord

# Install nginx & gettext (envsubst)
# Install PHP/FPM + Modules
# Install GIT
# Create cachedir and fix permissions
RUN apk add --no-cache --update \
    gettext \
    nginx \
    php7 \
    php7-apcu \
    php7-bcmath \
    php7-bz2 \
    php7-cgi \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-fpm \
    php7-ftp \
    php7-gd \
    php7-iconv \
    php7-json \
    php7-mbstring \
    php7-oauth \
    php7-opcache \
    php7-openssl \
    php7-pcntl \
    php7-pdo \
    php7-pdo_mysql \
    php7-phar \
    php7-redis \
    php7-session \
    php7-simplexml \
    php7-tokenizer \
    php7-xdebug \
    php7-xml \
    php7-xmlwriter \
    php7-zip \
    php7-zlib \
    php7-zmq \
    php7-mcrypt \
    php7-mysqli \
    git \
    less \
    openssh \
    unzip && \
    mkdir -p /var/cache/nginx && \
    chown -R www-data:www-data /var/cache/nginx && \
    chown -R www-data:www-data /var/lib/nginx && \
    chown -R www-data:www-data /var/tmp/nginx


#install bash shell
RUN apk --no-cache --update add bash bash-completion

# Runtime env vars are envstub'd into config during entrypoint
ENV SERVER_NAME="localhost"
ENV SERVER_ALIAS=""
ENV SERVER_ROOT=/www

# Alias defaults to empty, example usage:
# SERVER_ALIAS='www.example.com'

COPY ./files/supervisord.conf /supervisord.conf
COPY ./files/php-fpm-www.conf /etc/php7/php-fpm.d/www.conf
COPY ./files/nginx.conf.template /nginx.conf.template
COPY ./files/docker-entrypoint.sh /docker-entrypoint.sh
COPY ./files/mgit /usr/local/bin/
ADD ./files/waraos.ini /usr/local/etc/php/conf.d
ADD ./files/waraos.pool.conf /usr/local/etc/php-fpm.d/

# Authorize SSH Host
ADD ./ssh_key /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa && \
    ssh-keyscan gitlab.com > /root/.ssh/known_hosts
## Add the keys and set permissions
#RUN echo "$SSH_PRIVATE_KEY" > /root/.ssh/id && \
#    echo "$SSH_PUBLIC_KEY" > /root/.ssh/id.pub && \
#    chmod 600 /root/.ssh/id && \
#    chmod 600 /root/.ssh/id.pub

# Nginx on :80
EXPOSE 80
WORKDIR /www
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
