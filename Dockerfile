FROM debian:bullseye

ARG ARCH=amd64

ENV YACREADER_VERSION 9.8.2

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-${ARCH} /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

WORKDIR /src/git

# Update system
RUN apt-get update && \
    apt-get -y install p7zip-full git sqlite3 build-essential libunarr-dev qtdeclarative5-dev qt5-image-formats-plugins libpoppler-qt5-dev libpoppler-qt5-1 libqt5sql5 libqt5sql5-sqlite libqt5network5 libqt5gui5 libqt5core5a

RUN git clone https://github.com/YACReader/yacreader.git . && \
    git checkout ${YACREADER_VERSION}

RUN cd /src/git/YACReaderLibraryServer && \
    # qmake "CONFIG+=7zip server_standalone" YACReaderLibraryServer.pro && \
    qmake "CONFIG+=server_standalone" YACReaderLibraryServer.pro && \
    make  && \
    make install
RUN cd /     && \
    apt-get purge -y git wget build-essential && \
    apt-get -y autoremove &&\
    rm -rf /src && \
    rm -rf /var/cache/apt

ADD YACReaderLibrary.ini /root/.local/share/YACReader/YACReaderLibrary/

# add specific volumes: configuration, comics repository, and hidden library data to separate them
VOLUME ["/comics"]

EXPOSE 8080

ENV LC_ALL=C.UTF8

CMD ["YACReaderLibraryServer","start"]
