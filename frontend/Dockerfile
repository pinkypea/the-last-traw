# Bắt đầu từ image Node.js
FROM node:18-alpine

# Tạo và chuyển đến thư mục làm việc /app
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker's caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Xây dựng dự án Next.js
RUN npm run build

# Cung cấp cổng mà ứng dụng sẽ chạy
EXPOSE 3000

# Khởi chạy ứng dụng
CMD ["npm", "start"]