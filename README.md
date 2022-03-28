![status](https://github.com/wasilak/yacreaderlibrary-server-docker/actions/workflows/main.yml/badge.svg?branch=master)

HOW TO
===
```
1. docker run -d -p <port>:8080 -v <comics folder>:/comics --name=yacserver quay.io/wasilak/yacreaderlibrary-server:master
2. docker exec yacserver YACReaderLibraryServer create-library <library-name> /comics
3. docker exec yacserver YACReaderLibraryServer  update-library /comics
```
