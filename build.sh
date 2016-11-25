#!/bin/bash
source ./config.sh
cd unt1c-base
docker build -t pyriccio/ubn1c-base . && cd .. && docker build -t psyriccio/dck1c .
