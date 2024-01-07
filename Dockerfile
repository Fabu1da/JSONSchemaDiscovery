# Use Node.js version 18 (slim version)
FROM node:18-slim

# Update package list and install essential build tools, Git, Make, Python 3, and update CA certificates
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    gcc \
    git \
    make \
    python3 && \
    rm -rf /var/lib/apt/lists/* && \
    update-ca-certificates && \
    ln -s /usr/bin/python3 /usr/bin/python

# Install global npm packages
RUN npm install -g @angular/cli typescript && \
    npm cache clean --force

# Create app directory
WORKDIR /app/

# Copy package files
COPY package.json package-lock.json ./

# Install project dependencies
RUN npm ci && \
    npm cache clean --force

# Copy project files
COPY . .

# Build the application
RUN ["npm", "run", "build"]

# Run predev script
RUN ["npm", "run", "predev"]

# Set the command to run the application
CMD ["npm", "run", "start"]

# Expose port 3000
EXPOSE 3000
