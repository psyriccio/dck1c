#!/bin/bash
rm -rf /tmp/user
mkdir /tmp/user
cp -R ~/.1C /tmp/user
cp -R ~/.1cv8 /tmp/user
docker run -it --rm -e DISPLAY -v $HOME/.Xauthority:/home/user/.Xauthority -v $HOME:/home/user -v /mnt:/mnt --net=host --pid=host --ipc=host psyriccio/dck1c $*
