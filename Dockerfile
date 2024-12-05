# 使用基础镜像并指定平台
FROM --platform=linux/amd64 starkwang/zgi-fe-base:1.0.1

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 pnpm-lock.yaml
COPY package.json pnpm-lock.yaml ./

# 安装依赖
RUN pnpm install

# 复制源代码和部署脚本
COPY . .

# 构建应用
RUN pnpm build

# 确保部署脚本有执行权限并使用 Unix 行尾
RUN chmod +x deploy.sh && \
    sed -i 's/\r$//' deploy.sh

# 设置环境变量（如果需要）
ENV NODE_ENV=production

# 使用 bash 执行部署脚本
CMD ["./deploy.sh"] 