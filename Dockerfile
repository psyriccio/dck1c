FROM psyriccio/ubn1c-base
MAINTAINER psyriccio

ENV PLT_VERSION 8.3.7-1873
ENV PLT_ARCH amd64
ENV LANG ru_RU.utf8

RUN mkdir /opt/dck1c

ADD ./dist/ /opt/dck1c/
ADD ./start.sh /opt/dck1c/

RUN dpkg -i /opt/dck1c/1c-enterprise83-common_${PLT_VERSION}_${PLT_ARCH}.deb \
            /opt/dck1c/1c-enterprise83-server_${PLT_VERSION}_${PLT_ARCH}.deb \
            /opt/dck1c/1c-enterprise83-client_${PLT_VERSION}_${PLT_ARCH}.deb \
      && unzip /opt/dck1c/mscorefonts.zip -d /usr/share/fonts/TTF \
      && unzip /opt/dck1c/ttf-fira-code.zip -d /usr/share/fonts/TTF \
      && unzip /opt/dck1c/otf-fira-code.zip -d /usr/share/fonts/OTF \
      && unzip /opt/dck1c/zukitwo-themes.zip -d /usr/share/themes \
      && unzip /opt/dck1c/yltra-icons.zip -d /usr/share/icons \
      && unzip /opt/dck1c/ultraflat-icons.zip -d /usr/share/icons \
      && rm /opt/dck1c/*.deb && rm /opt/dck1c/*.zip && chmod +x /opt/dck1c/start.sh \
      && /bin/bash /etc/fonts/infinality/infctl.sh setstyle linux

USER user
ENV HOME /home/user
CMD /opt/dck1c/start.sh
