FROM node:18-alpine

# Accept API URL at build time
ARG NEXT_PUBLIC_API_URL
ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# 👇 Build with env var injected into the Next.js build process
RUN NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL npm run build

EXPOSE 3000
CMD ["npm", "start"]
