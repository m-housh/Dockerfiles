FROM suchja/wine:latest

ADD flopro /flopro

USER xclient

RUN wine wineboot --init

CMD ["wine", "/flopro/FloPro Designer/FloPro Designer.exe"]
