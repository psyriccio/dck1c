FROM ubuntu:14.04
MAINTAINER psyriccio

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
      && apt-get install -y software-properties-common python-software-properties \
      && add-apt-repository multiverse && add-apt-repository ppa:no1wantdthisname/ppa && add-apt-repository ppa:openjdk-r/ppa && apt-get update && apt-get upgrade -y \
      && apt-get install -y unixodbc libgsf-1-114 imagemagick libglib2.0-dev libt1-5 t1utils openjdk-8-jdk libwebkit-dev libcanberra-gtk-module unzip xterm uuid
                            fonty-rg fonts-ubuntu-font-family-console comsole-data \
