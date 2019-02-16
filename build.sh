set -ex
USERNAME=verybadsoldier
IMAGE=blocklist-de
docker build -t $USERNAME/$IMAGE:latest .
