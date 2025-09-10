# Use Ubuntu como base (tem mais compatibilidade com binários Delphi)
FROM ubuntu:22.04

# Instala as dependências necessárias incluindo MongoDB - CORRIGIDO
RUN apt-get update && \
    apt-get install -y \
    libc6 \
    libgcc-s1 \
    libstdc++6 \
    wget \
    gnupg \
    curl \
    libssl3 \
    libsasl2-2 \  # Alterado de libsasl2-3 para libsasl2-2
    && wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-6.0.gpg \
    && echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list \
    && apt-get update \
    && apt-get install -y \
    libmongoc-1.0-0 \
    libbson-1.0-0 \
    && ldconfig \
    && rm -rf /var/lib/apt/lists/*

# Verifica se a biblioteca está instalada
RUN ldconfig -p | grep mongoc && \
    find /usr -name "*mongoc*" -type f

# Crie um diretório para sua aplicação
WORKDIR /app

# Copie APENAS o binário Linux para o container
COPY KAFSServidorDataSnap .

# Torne o binário executável
RUN chmod +x KAFSServidorDataSnap

# Crie o arquivo INI codificado com as credenciais
RUN echo "[bW9uZ29kYg$$]" > cache.ini && \
    echo "bm9tZQ$$=dmluaWNpdXNkb2FtYXJhbHJlaXM$" >> cache.ini && \
    echo "c2VuaGE$=WUNubGM0T1dxT0lGRE9kTQ$$" >> cache.ini && \
    echo "c2Vydmlkb3I$=c2Vydmlkb3IwLmFqaGJicngubW9uZ29kYi5uZXQ$" >> cache.ini && \
    echo "" >> cache.ini && \
    echo "[ZGF0YXNuYXA$]" >> cache.ini && \
    echo "cG9ydGE$=ODA4MQ$$" >> cache.ini

# Health check TCP para a porta 8081
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD nc -z localhost 8081 || exit 1

# Exponha a porta que seu servidor usa
EXPOSE 8081

# Comando para executar sua aplicação
CMD ["./KAFSServidorDataSnap"]