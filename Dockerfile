# Use Ubuntu como base (tem mais compatibilidade com binários Delphi)
FROM ubuntu:22.04

# Instala as dependências necessárias incluindo MongoDB
RUN apt-get update && \
    apt-get install -y \
    libc6 \
    libgcc-s1 \
    libstdc++6 \
    wget \
    gnupg \
    && wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add - \
    && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list \
    && apt-get update \
    && apt-get install -y mongodb-mongosh \
    libmongoc-1.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Crie um diretório para sua aplicação
WORKDIR /app

# Copie APENAS o binário Linux para o container
COPY KAFSServidorDataSnap .

# Torne o binário executável
RUN chmod +x KAFSServidorDataSnap

# Exponha a porta que seu servidor usa
EXPOSE 8080

# Comando para executar sua aplicação
CMD ["./KAFSServidorDataSnap"]