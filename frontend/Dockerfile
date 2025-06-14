# Base image
FROM node:18-alpine

# Create app dir
WORKDIR /app

# Copy and install
COPY package*.json ./
RUN npm install

# Copy rest of the code
COPY . .

# Build and expose
RUN npm run build
EXPOSE 3000

# Run app
CMD ["npm", "start"]
