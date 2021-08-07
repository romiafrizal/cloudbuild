FROM raudhahdev/php74-fpm AS base
WORKDIR /var/www/html
ENV COMPOSER_PROCESS_TIMEOUT=600
COPY --chown=www-data:root . .
### Setup File Permission
RUN find /var/www/html -type f -exec chmod 664 {} \; && find /var/www/html -type d -exec chmod 775 {} \;     
RUN cd /var/www/html \
    && chgrp -R www-data storage \
    && chmod -R ug+rw storage
RUN composer install --prefer-dist
