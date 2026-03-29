#!/bin/bash

mkdir -p /games

if [ -n "$S3_BUCKET" ] && [ -n "$AWS_ACCESS_KEY_ID" ]; then
  mkdir -p /root/.config/rclone
  cat > /root/.config/rclone/rclone.conf <<EOF
[s3]
type = s3
provider = AWS
access_key_id = ${AWS_ACCESS_KEY_ID}
secret_access_key = ${AWS_SECRET_ACCESS_KEY}
region = ${AWS_REGION:-eu-central-1}
EOF

  echo "Mounting S3 bucket: ${S3_BUCKET}..."
  rclone mount s3:${S3_BUCKET} /games \
    --allow-other \
    --vfs-cache-mode full \
    --vfs-cache-max-size 10G \
    --vfs-read-chunk-size 64M \
    --vfs-read-chunk-size-limit 1G \
    --buffer-size 64M \
    --dir-cache-time 72h \
    --daemon 2>&1 || echo "WARNING: S3 mount failed, continuing without S3"

  sleep 2
  mountpoint -q /games && echo "S3 mounted at /games" || echo "WARNING: /games not mounted, using local storage"
else
  echo "No S3 config, using local storage"
fi

cd /app
exec python3 app.py
