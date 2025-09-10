FROM alpine:3.18

# Instala dependências adicionais que programas Delphi podem precisar
RUN apk add --no-cache \
    libc6-compat \
    openssl \          # Para funcionalidades SSL
    libuuid \          # Para identificadores únicos
    zlib               # Para compressão

WORKDIR /app
COPY KAFSServidorDataSnap .
RUN chmod +x KAFSServidorDataSnap

# Verifique qual porta seu servidor realmente usa!
EXPOSE 8080

CMD ["./KAFSServidorDataSnap"]