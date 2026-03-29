FROM a1ex4/ownfoil:latest

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends rclone fuse3 && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
