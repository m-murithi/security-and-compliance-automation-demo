# Base image for Node.js (lightweight version)
FROM node:16-alpine

# Set environment variables for production use
ENV NODE_ENV=production

# Set the working directory inside the container
WORKDIR /app

# Copy package.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install --only=production

# Copy the application source code to the working directory
COPY . .

# Expose the port that Juice Shop uses
EXPOSE 3000

# Set the default command to start the application
CMD ["node", "server.js"]
