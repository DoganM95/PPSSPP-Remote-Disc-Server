FROM node:alpine

# Set working directory
WORKDIR /usr/src/app

# Create internal iso folder
RUN mkdir -p /var/isos

# copy package- & lock.json
COPY package*.json ./

# Instal dependencies
RUN npm ci --only=production

# Copy actual app
COPY app.js ./

# Expose port to serve on
EXPOSE 8300

CMD [ "node", "app.js" ]