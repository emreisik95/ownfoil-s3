#!/bin/bash
set -e

mkdir -p /games

# Configure rclone for S3
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
  --daemon

sleep 2

if mountpoint -q /games; then
  echo "S3 mounted successfully at /games"
else
  echo "ERROR: S3 mount failed!"
  exit 1
fi

# Start ownfoil
exec python3 app.py
