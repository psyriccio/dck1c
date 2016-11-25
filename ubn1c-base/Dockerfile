FROM ubuntu:14.04
MAINTAINER psyriccio

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
      && apt-get install -y software-properties-common python-software-properties \
      && add-apt-repository multiverse && add-apt-repository ppa:no1wantdthisname/ppa && add-apt-repository ppa:openjdk-r/ppa && apt-get update && apt-get upgrade -y \
      && apt-get install -y unixodbc libgsf-1-114 imagemagick libglib2.0-dev libt1-5 t1utils openjdk-8-jdk \
          libwebkit-dev libcanberra-gtk-module unzip fontconfig-infinality gtk2-engines-murrine gtk2-engines-pixbuf dialog nano \
      && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	    && localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8

RUN export uid=1000 gid=1000 && \
      mkdir -p /home/user && \
      echo "user:x:${uid}:${gid}:User,,,:/home/user:/bin/bash" >> /etc/passwd && \
      echo "user:x:${uid}:" >> /etc/group && \
      echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/user && \
      chmod 0440 /etc/sudoers.d/user && \
      chown ${uid}:${gid} -R /home/user

CMD /bin/bash
