FROM alpine:3.12

# buider container to extract syslinux files from x86 distribution

RUN apk add --no-cache syslinux && \
    cp -r /usr/share/syslinux /tftpboot && \
    find /tftpboot -type f -exec chmod 0444 {} +

CMD tar -cf - -C /tftpboot /tftpboot
