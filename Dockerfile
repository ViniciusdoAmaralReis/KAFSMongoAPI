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

# Crie a estrutura de diretórios EXATA que o sistema espera
# TPath.GetDocumentsPath + PathDelim + NomeProjeto
# No Linux, GetDocumentsPath geralmente retorna ~/Documents
# NomeProjeto = "KAFSServidorDataSnap" (nome do executável sem extensão)
RUN mkdir -p /root/Documents/KAFSServidorDataSnap

# Crie o arquivo cache.ini com o conteúdo EXATO do exemplo fornecido
# no caminho exato onde o sistema procura
RUN echo "[bW9uZ29kYg$$]" > /root/Documents/KAFSServidorDataSnap/cache.ini && \
    echo "bm9tZQ$$=dmluaWNpdXNkb2FtYXJhbHJlaXM$" >> /root/Documents/KAFSServidorDataSnap/cache.ini && \
    echo "c2VuaGE$=WUNubGM0T1dxT0lGRE9kTQ$$" >> /root/Documents/KAFSServidorDataSnap/cache.ini && \
    echo "c2Vydmlkb3I$=c2Vydmlkb3IwLmFqaGJicngubW9uZ29kYi5uZXQ$" >> /root/Documents/KAFSServidorDataSnap/cache.ini && \
    echo "" >> /root/Documents/KAFSServidorDataSnap/cache.ini && \
    echo "[ZGF0YXNuYXA$]" >> /root/Documents/KAFSServidorDataSnap/cache.ini && \
    echo "cG9ydGE$=ODA4MQ$$" >> /root/Documents/KAFSServidorDataSnap/cache.ini

# Verifique se o arquivo está no lugar certo
RUN echo "Verificando estrutura de diretórios:" && \
    echo "PWD: $(pwd)" && \
    echo "Conteúdo de /root:" && ls -la /root && \
    echo "Conteúdo de /root/Documents:" && ls -la /root/Documents && \
    echo "Conteúdo de /root/Documents/KAFSServidorDataSnap:" && ls -la /root/Documents/KAFSServidorDataSnap && \
    echo "Conteúdo do cache.ini:" && cat /root/Documents/KAFSServidorDataSnap/cache.ini && \
    echo "----------------------------------------"

# Defina variáveis de ambiente para garantir que GetDocumentsPath funcione corretamente
ENV HOME=/root
ENV XDG_DOCUMENTS_DIR=/root/Documents

# Também crie cópias em outros locais possíveis por segurança
RUN mkdir -p /root/Documentos/KAFSServidorDataSnap && \
    cp /root/Documents/KAFSServidorDataSnap/cache.ini /root/Documentos/KAFSServidorDataSnap/cache.ini

RUN mkdir -p /app/Documents/KAFSServidorDataSnap && \
    cp /root/Documents/KAFSServidorDataSnap/cache.ini /app/Documents/KAFSServidorDataSnap/cache.ini

RUN cp /root/Documents/KAFSServidorDataSnap/cache.ini /app/cache.ini

# Health check TCP para a porta 8081
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD nc -z localhost 8081 || exit 1

# Exponha a porta que seu servidor usa
EXPOSE 8081

# Comando para executar sua aplicação com debug
CMD ["sh", "-c", "echo 'Diretório atual: $(pwd)'; echo 'Conteúdo:'; ls -la; echo 'Procurando cache.ini...'; find / -name 'cache.ini' 2>/dev/null; echo 'Iniciando aplicação...'; ./KAFSServidorDataSnap"]