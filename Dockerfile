FROM alpine:3.12

# Publish the typical syslinux and pxelinux files at tftp root.
# We only need one subtree of files from syslinux, and
# we don't need its dependencies, so...
#
# Install the package and its dependencies as a virtual set "sl_plus_deps",
# copy the desired files, then purge the virtual set.
#
COPY syslinux.tar /syslinux.tar

COPY pxelinux.cfg /tftpboot/pxelinux.cfg/
RUN tar -xf /syslinux.tar && \
    rm /syslinux.tar

# Add safe defaults that can be overriden easily.
COPY pxelinux.cfg /tftpboot/pxelinux.cfg/

# Support clients that use backslash instead of forward slash.
COPY mapfile /tftpboot/

# Do not track further change to /tftpboot.
VOLUME /tftpboot

# http://forum.alpinelinux.org/apk/main/x86_64/tftp-hpa
RUN apk add --no-cache tftp-hpa

EXPOSE 69/udp

RUN adduser -D tftp

COPY start /usr/sbin/start
ENTRYPOINT ["/usr/sbin/start"]
CMD ["-L", "--verbose", "-m", "/tftpboot/mapfile", "-u", "tftp", "--secure", "/tftpboot"]
