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

# Crie a estrutura de diretórios necessária
RUN mkdir -p /root/Documentos/KAFSServidorDataSnap

# Crie o arquivo cache.ini com o conteúdo EXATO do exemplo fornecido
RUN echo "[bW9uZ29kYg$$]" > /root/Documentos/KAFSServidorDataSnap/cache.ini && \
    echo "bm9tZQ$$=dmluaWNpdXNkb2FtYXJhbHJlaXM$" >> /root/Documentos/KAFSServidorDataSnap/cache.ini && \
    echo "c2VuaGE$=WUNubGM0T1dxT0lGRE9kTQ$$" >> /root/Documentos/KAFSServidorDataSnap/cache.ini && \
    echo "c2Vydmlkb3I$=c2Vydmlkb3IwLmFqaGJicngubW9uZ29kYi5uZXQ$" >> /root/Documentos/KAFSServidorDataSnap/cache.ini && \
    echo "" >> /root/Documentos/KAFSServidorDataSnap/cache.ini && \
    echo "[ZGF0YXNuYXA$]" >> /root/Documentos/KAFSServidorDataSnap/cache.ini && \
    echo "cG9ydGE$=ODA4MQ$$" >> /root/Documentos/KAFSServidorDataSnap/cache.ini

# Verifique o conteúdo do arquivo (para debug)
RUN echo "Conteúdo do cache.ini:" && \
    cat /root/Documentos/KAFSServidorDataSnap/cache.ini && \
    echo "----------------------------------------"

# Teste de decodificação (para verificar se está correto)
RUN apt-get update && apt-get install -y --no-install-recommends openssl && rm -rf /var/lib/apt/lists/*
RUN echo "Teste de decodificação:" && \
    echo "Seção mongodb: $(echo 'bW9uZ29kYg==' | sed 's/\$/=/g' | openssl base64 -d)" && \
    echo "Campo nome: $(echo 'bm9tZQ==' | sed 's/\$/=/g' | openssl base64 -d)" && \
    echo "Valor nome: $(echo 'dmluaWNpdXNkb2FtYXJhbHJlaXM=' | sed 's/\$/=/g' | openssl base64 -d)" && \
    echo "Campo senha: $(echo 'c2VuaGE=' | sed 's/\$/=/g' | openssl base64 -d)" && \
    echo "Valor senha: $(echo 'WUNubGM0T1dxT0lGRE9kTQ==' | sed 's/\$/=/g' | openssl base64 -d)" && \
    echo "Campo servidor: $(echo 'c2Vydmlkb3I=' | sed 's/\$/=/g' | openssl base64 -d)" && \
    echo "Valor servidor: $(echo 'c2Vydmlkb3IwLmFqaGJicngubW9uZ29kYi5uZXQ=' | sed 's/\$/=/g' | openssl base64 -d)" && \
    echo "Seção datasnap: $(echo 'ZGF0YXNuYXA=' | sed 's/\$/=/g' | openssl base64 -d)" && \
    echo "Campo porta: $(echo 'cG9ydGE=' | sed 's/\$/=/g' | openssl base64 -d)" && \
    echo "Valor porta: $(echo 'ODA4MQ==' | sed 's/\$/=/g' | openssl base64 -d)" && \
    echo "----------------------------------------"

# Defina variáveis de ambiente para o caminho de documentos
ENV HOME=/root
ENV XDG_DOCUMENTS_DIR=/root/Documentos

# Health check TCP para a porta 8081
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD nc -z localhost 8081 || exit 1

# Exponha a porta que seu servidor usa
EXPOSE 8081

# Comando para executar sua aplicação
CMD ["./KAFSServidorDataSnap"]