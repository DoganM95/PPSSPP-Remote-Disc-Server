# Use Node.js Base image
FROM node:latest

# Change current working directory
WORKDIR /usr/src/app

# Create directory on which iso's volume will be mounted to
RUN mkdir -p /var/isos

# Install dependencies.
COPY package*.json ./
RUN npm ci --only=production

# Copy actual app.
COPY app.js ./

# Set app configurations in environment
ENV HOST=0.0.0.0
ENV PORT=8300
ENV ISO_PATH=/var/isos/

# Expose port 8300
EXPOSE 8300

# Entrypoint to application
CMD [ "node", "app.js" ]
