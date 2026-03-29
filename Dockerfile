FROM a1ex4/ownfoil:latest

USER root

RUN apk add --no-cache rclone fuse3 bash && \
    sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
