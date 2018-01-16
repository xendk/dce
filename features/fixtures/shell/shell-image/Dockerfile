FROM alpine:3.6

# Install a shell script as /bin/sh that outputs the invoced name and
# exists. We need an installer to run in the container, as the build
# process doesn't like us messing with /bin/sh.
COPY installer /root/installer
COPY sh /root/sh

RUN /root/installer
