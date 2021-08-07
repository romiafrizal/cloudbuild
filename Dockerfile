FROM raudhahdev/php74-fpm AS base
WORKDIR /var/www/html
COPY --chown=www-data:root . .
### Setup File Permission
RUN find /var/www/html -type f -exec chmod 664 {} \; && find /var/www/html -type d -exec chmod 775 {} \;     
RUN cd /var/www/html \
    && chgrp -R www-data storage \
    && chmod -R ug+rw storage

#DEVELOPEMT
FROM base AS development
ENV DB_DATABASE=mydb_dev
COPY ./srvr/supervisord.conf /etc/supervisor/conf.d/supervisor-be.conf
CMD ["/usr/bin/supervisord"]

#STAGING
FROM base AS staging
ENV DB_DATABASE=mydb_stg
COPY ./srvr/supervisord.conf /etc/supervisor/conf.d/supervisor-be.conf
CMD ["/usr/bin/supervisord"]

#PRODUCTION
FROM base AS production
ENV DB_DATABASE=mydb
COPY ./srvr/supervisord.conf /etc/supervisor/conf.d/supervisor-be.conf
CMD ["/usr/bin/supervisord"]
