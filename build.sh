#!/bin/bash
source ./config.sh
if [[ -z $1 ]]; then
    
fi
if [[ $DCK1C_INJECT_NONFREE_FONTS ]]; then

fi
cd unt1c-base
docker build -t pyriccio/ubn1c-base . && cd .. && docker build -t psyriccio/dck1c .
if [[ -n  $DCK1C_SAVE_IMAGES_TO ]]; then
    docker save psyriccio/ubn1c-base -o $DCK1C_SAVE_IMAGES_TO/ubn1c-base.image.tar
    docker save psyriccio/dck1c -o $DCK1C_SAVE_IMAGES_TO/dck1c.image.tar
fi
if [[ -n $DCK1C_DOCKER_REGISTRY ]]; then
    docker tag psyriccio/ubn1-base $DCK1C_DOCKER_REGISTRY/psyriccio/ubn1-base
    docker tag psyriccio/dck1c $DCK1C_DOCKER_REGISTRY/psyriccio/dck1c
    docker push $DCK1C_DOCKER_REGISTRY/psyriccio/ubn1-base
    docker push $DCK1C_DOCKER_REGISTRY/psyriccio/ubn1-base
fi
