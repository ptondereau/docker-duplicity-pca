FROM debian:stretch-slim

ENV HOME=/home/duplicity

RUN set -x \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        ca-certificates \
        lftp \
        openssl \
        python-crypto \
        python-paramiko \
        python-setuptools \
        python-fasteners \
        python-future \
        python-swiftclient \
        python-keystoneclient \
        python-dev \
        python-pip \
        librsync-dev \
        rsync \
        bzr \
        gcc \
        gnupg

RUN set -x \
 && groupadd -r --gid=3000 duplicity \
 && useradd -r --uid 3000 --home /home/duplicity --gid 3000 duplicity \
 && mkdir -p /home/duplicity/.cache/duplicity \
 && mkdir -p /home/duplicity/.gnupg \
 && chmod -R go+rwx /home/duplicity/ \
 && bzr branch lp:duplicity \
 && cd duplicity \
 && pip install setuptools wheel \
 && pip install -r requirements.txt \
 && python setup.py install \
 && cd .. \
 && rm -rf duplicity \
 && su - duplicity -c 'duplicity --version' \
 && apt-get remove -f -y bzr gcc \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

VOLUME ["/home/duplicity/.cache/duplicity", "/home/duplicity/.gnupg"]

USER duplicity

CMD ["duplicity"]