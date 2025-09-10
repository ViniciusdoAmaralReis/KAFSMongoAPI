# Use uma imagem base minimalista do Alpine Linux
FROM alpine:3.18

# Instala as dependências necessárias para o binário Delphi Linux
RUN apk add --no-cache \
    libc6-compat \
    openssl \
    util-linux \    # Fornece libuuid
    zlib

# Crie um diretório para sua aplicação
WORKDIR /app

# Copie APENAS o binário Linux para o container
COPY KAFSServidorDataSnap .

# Torne o binário executável
RUN chmod +x KAFSServidorDataSnap

# Exponha a porta que seu servidor usa (ajuste se necessário)
EXPOSE 8000

# Comando para executar sua aplicação
CMD ["./KAFSServidorDataSnap"]