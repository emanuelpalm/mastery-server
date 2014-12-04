FROM google/nodejs

WORKDIR /mastery-server
ADD . /mastery-server/
RUN npm install --production

CMD []
ENTRYPOINT ["/nodejs/bin/npm/", "start"]

