# Bắt đầu từ image Node.js
FROM node:18-alpine

# Tạo và chuyển đến thư mục làm việc /app
WORKDIR /app

# Sao chép toàn bộ mã nguồn vào image
COPY . .

# Cài đặt các gói phụ thuộc
RUN npm install

# Xây dựng dự án Next.js
RUN npm run build

# Cung cấp cổng mà ứng dụng sẽ chạy
EXPOSE 3000

# Khởi chạy ứng dụng
CMD ["npm", "start"]