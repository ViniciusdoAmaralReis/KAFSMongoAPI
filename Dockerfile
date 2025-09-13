FROM ubuntu:22.04

# Instala dependências básicas
RUN apt-get update && \
    apt-get install -y \
    libc6 \
    libgcc-s1 \
    libstdc++6 \
    wget \
    build-essential \
    cmake \
    pkg-config \
    libssl-dev \
    libsasl2-dev \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Baixa e compila o mongo-c-driver from source
RUN wget https://github.com/mongodb/mongo-c-driver/releases/download/1.24.4/mongo-c-driver-1.24.4.tar.gz && \
    tar -xzf mongo-c-driver-1.24.4.tar.gz && \
    cd mongo-c-driver-1.24.4 && \
    mkdir cmake-build && \
    cd cmake-build && \
    cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DENABLE_SSL=OPENSSL -DENABLE_SASL=CYRUS .. && \
    make && \
    make install && \
    ldconfig && \
    cd / && \
    rm -rf mongo-c-driver-1.24.4*

# Crie um diretório para sua aplicação
WORKDIR /app

# Copie APENAS o binário Linux para o container
COPY KAFSServidorDataSnap .

# Torne o binário executável
RUN chmod +x KAFSServidorDataSnap

# Crie o diretório onde o arquivo INI deve estar
RUN mkdir -p /documentos/KAFSServidorDataSnap

# Crie o arquivo INI EXATAMENTE como fornecido (usando echo com escaping)
RUN echo "[bW9uZ29kYg\$\$]" > /documentos/KAFSServidorDataSnap/cache.ini && \
    echo "bm9tZQ\$\$=dmluaWNpdXNkb2FtYXJhbHJlaXM\$" >> /documentos/KAFSServidorDataSnap/cache.ini && \
    echo "c2VuaGE\$=WUNubGM0T1dxT0lGRE9kTQ\$\$" >> /documentos/KAFSServidorDataSnap/cache.ini && \
    echo "c2Vydmlkb3I\$=c2Vydmlkb3IwLmFqaGJicngubW9uZ29kYi5uZXQ\$" >> /documentos/KAFSServidorDataSnap/cache.ini && \
    echo "" >> /documentos/KAFSServidorDataSnap/cache.ini && \
    echo "[ZGF0YXNuYXA\$]" >> /documentos/KAFSServidorDataSnap/cache.ini && \
    echo "cG9ydGE\$=ODA4MQ\$\$" >> /documentos/KAFSServidorDataSnap/cache.ini

# Health check TCP para a porta 8081
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD nc -z localhost 8081 || exit 1

# Exponha a porta que seu servidor usa
EXPOSE 8081

# Comando para executar sua aplicação
CMD ["./KAFSServidorDataSnap"]