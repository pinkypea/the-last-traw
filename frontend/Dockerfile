# Bắt đầu từ image Node.js
FROM node:18-alpine

# Tạo và chuyển đến thư mục làm việc /app
WORKDIR /app

# Sao chép các file cấu hình package
COPY package.json package-lock.json ./

# Cài đặt các gói phụ thuộc
RUN npm install

# Sao chép toàn bộ mã nguồn vào image
COPY . .

# Xây dựng dự án Next.js
RUN npm run build

# Cung cấp cổng mà ứng dụng sẽ chạy
EXPOSE 3000

# Khởi chạy ứng dụng
CMD ["npm", "start"]