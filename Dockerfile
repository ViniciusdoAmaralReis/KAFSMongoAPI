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

# Expõe a porta que sua aplicação usa (ajuste conforme necessário)
EXPOSE 8081

# Comando de execução com parâmetros
CMD ["/app/KAFSServidorDataSnap", "-p", "8081", "-u", "$MONGO_USER", "-s", "$MONGO_PASSWORD", "-h", "$MONGO_HOST"]