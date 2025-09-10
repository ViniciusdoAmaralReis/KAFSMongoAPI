# Use Ubuntu como base (tem mais compatibilidade com binários Delphi)
FROM ubuntu:22.04

# Instala as dependências necessárias
RUN apt-get update && \
    apt-get install -y \
    libc6 \
    libgcc-s1 \
    libstdc++6 \
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