FROM python:3.8-alpine3.12

ENTRYPOINT [ "certbot" ]
VOLUME /etc/letsencrypt /var/lib/letsencrypt
WORKDIR /opt/certbot

# Copy certbot code
COPY dependency-requirements.txt letsencrypt-auto-source/pieces/
COPY tools tools
COPY acme src/acme
COPY certbot src/certbot
COPY health_checker.sh /opt/certbot/tools/docker/health_checker.sh

# Install certbot runtime dependencies
RUN apk add --no-cache --virtual .certbot-deps \
        libffi \
        libssl1.1 \
        openssl \
        ca-certificates \
        binutils

# Install certbot from sources
RUN apk add --no-cache --virtual .build-deps \
        gcc \
        linux-headers \
        openssl-dev \
        musl-dev \
        libffi-dev \
    && python tools/pipstrap.py \
    && python tools/pip_install.py --no-cache-dir \
            --editable src/acme \
            --editable src/certbot \
    && apk del .build-deps

HEALTHCHECK --interval=30s --timeout=10s --retries=2 CMD /opt/certbot/tools/docker/health_checker.sh,
