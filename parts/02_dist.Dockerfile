RUN mkdir /opt/dck1c

ADD ./dist/ /opt/dck1c/
ADD ./start.sh /opt/dck1c/
ADD ./config.sh /opt/dck1c/config.sh
ADD ./lib/ /opt/dck1c/

RUN dpkg -i /opt/dck1c/1c-enterprise83-common_${PLT_VERSION}_${PLT_ARCH}.deb \
            /opt/dck1c/1c-enterprise83-server_${PLT_VERSION}_${PLT_ARCH}.deb \
            /opt/dck1c/1c-enterprise83-client_${PLT_VERSION}_${PLT_ARCH}.deb \
