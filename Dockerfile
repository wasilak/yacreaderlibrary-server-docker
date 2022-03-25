FROM debian:buster

ENV YACREADER_VERSION 9.8.2

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

WORKDIR /src/git

# Update system
RUN apt-get update && \
    apt-get -y install qt5-image-formats-plugins p7zip-full git dumb-init qt5-default libpoppler-qt5-dev libpoppler-qt5-1 wget unzip libqt5sql5-sqlite libqt5sql5 sqlite3 libqt5network5 libqt5gui5 libqt5core5a build-essential libunarr-dev
RUN git clone https://github.com/YACReader/yacreader.git . && \
    git checkout ${YACREADER_VERSION}
RUN cd compressed_archive/unarr/ && \
    wget github.com/selmf/unarr/archive/master.zip &&\
    unzip master.zip  &&\
    rm master.zip &&\
    cd unarr-master/lzmasdk &&\
    ln -s 7zTypes.h Types.h
#RUN cd compressed_archive/ &&\
#    git clone https://github.com/btolab/p7zip ./libp7zip
RUN cd /src/git/YACReaderLibraryServer && \
    #    qmake "CONFIG+=7zip server_standalone" YACReaderLibraryServer.pro && \
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
