DOCKER_ACC=qambar
DOCKER_REPO=kubernetes-bitbucket-deployment
IMG_TAG=latest
docker build -t $DOCKER_ACC/$DOCKER_REPO:$IMG_TAG .