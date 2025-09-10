FROM ubuntu:22.04

# Instala apenas as dependências básicas e libmongoc
RUN apt-get update && \
    apt-get install -y \
    libc6 \
    libgcc-s1 \
    libstdc++6 \
    wget \
    && wget http://archive.ubuntu.com/ubuntu/pool/main/m/mongo-c-driver/libmongoc-1.0-0_1.21.1-1_amd64.deb \
    && wget http://archive.ubuntu.com/ubuntu/pool/main/m/mongo-c-driver/libbson-1.0-0_1.21.1-1_amd64.deb \
    && dpkg -i libmongoc-1.0-0_1.21.1-1_amd64.deb libbson-1.0-0_1.21.1-1_amd64.deb \
    && apt-get install -y -f \
    && ldconfig \
    && rm -f *.deb \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY KAFSServidorDataSnap .
RUN chmod +x KAFSServidorDataSnap

RUN echo "[bW9uZ29kYg$$]" > cache.ini && \
    echo "bm9tZQ$$=dmluaWNpdXNkb2FtYXJhbHJlaXM$" >> cache.ini && \
    echo "c2VuaGE$=WUNubGM0T1dxT0lGRE9kTQ$$" >> cache.ini && \
    echo "c2Vydmlkb3I$=c2Vydmlkb3IwLmFqaGJicngubW9uZ29kYi5uZXQ$" >> cache.ini && \
    echo "" >> cache.ini && \
    echo "[ZGF0YXNuYXA$]" >> cache.ini && \
    echo "cG9ydGE$=ODA4MQ$$" >> cache.ini

EXPOSE 8081
CMD ["./KAFSServidorDataSnap"]