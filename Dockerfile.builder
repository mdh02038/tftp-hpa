FROM alpine:3.12

# Publish the typical syslinux and pxelinux files at tftp root.
# We only need one subtree of files from syslinux, and
# we don't need its dependencies, so...
#
# Install the package and its dependencies as a virtual set "sl_plus_deps",
# copy the desired files, then purge the virtual set.
#
# This trick keeps the image as small as possible.
#
# NOTE: If you bump the syslinux version here,
#       please also update the README.md.
#RUN apk add --no-cache --virtual sl_plus_deps syslinux && \
#    cp -r /usr/share/syslinux /tftpboot && \
#    find /tftpboot -type f -exec chmod 0444 {} + && \
#    apk del sl_plus_deps

RUN apk add --no-cache syslinux && \
    cp -r /usr/share/syslinux /tftpboot && \
    find /tftpboot -type f -exec chmod 0444 {} +

CMD tar -cf - -C /tftpboot /tftpboot
