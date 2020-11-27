ARG BUILD_FROM
FROM $BUILD_FROM

LABEL maintainer="aabishkar@gmail.com"

ENV LANG C.UTF-8

RUN apk add --no-cache --virtual build-deps alpine-sdk cmake git go libc-dev libusb-dev; \
    git clone --single-branch git://git.osmocom.org/rtl-sdr.git /usr/local/rtl-sdr; \
    mkdir -vp /usr/local/rtl-sdr/build; \
    cd /usr/local/rtl-sdr/build; \
    cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON -DCMAKE_INSTALL_PREFIX:PATH=/usr/local; \
    make; \
    make install; \
    mkdir -vp /tmp/go; \
    export GOPATH=/tmp/go; \
    go get -v github.com/bemasher/rtlamr; \
    cp /tmp/go/bin/* /usr/local/bin/; \
    apk del build-deps; \
    rm -rf /tmp/src /tmp/go /usr/lib/go; \
    apk add --no-cache libusb mosquitto-clients

RUN echo "blacklist dvb_usb_rtl28xxu" >> /etc/modprobe.d/rtlsdr-blacklist.conf

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
