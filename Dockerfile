FROM alpine:3.18

# Instala as dependências (formato multilinha correto)
RUN apk add --no-cache \
    libc6-compat \
    openssl \
    util-linux \
    zlib

WORKDIR /app
COPY KAFSServidorDataSnap .
RUN chmod +x KAFSServidorDataSnap
EXPOSE 8080
CMD ["./KAFSServidorDataSnap"]