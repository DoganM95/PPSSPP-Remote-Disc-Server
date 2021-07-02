FROM node:14
WORKDIR /usr/src/app

RUN mkdir -p /var/isos

# Install dependencies.
COPY package*.json ./
RUN npm ci --only=production

# Copy actual app.
COPY app.js ./

ENV HOST=0.0.0.0
ENV PORT=8300
ENV ISO_PATH=/var/isos/

EXPOSE $PORT

CMD [ "node", "app.js" ]