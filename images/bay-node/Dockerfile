FROM uselagoon/node-14:20.12.0

ENV CYPRESS_INSTALL_BINARY 0
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD 1

# End of build time env vars

RUN apk --update add curl git

# Force cloning with https rather than ssh.
# @expires 2022-10
RUN git config --global url."https://github.com/".insteadOf 'git@github.com:'
RUN git config --global url."https://github.com/".insteadOf 'ssh://git@github.com/'
