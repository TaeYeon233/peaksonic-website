#!/bin/bash

# Peak Sonic Website Auto Deployment Script
# 使用方法: ./deploy.sh [服务器IP] [用户名]

set -e  # 遇到错误时退出

echo "Peak Sonic Website 自动部署脚本"
echo "=================================="

# 检查参数
if [ $# -ne 2 ]; then
    echo "使用方法: $0 [服务器IP] [用户名]"
    echo "示例: $0 123.456.789.012 myuser"
    exit 1
fi

SERVER_IP=$1
USERNAME=$2

echo "正在部署网站到服务器: $USERNAME@$SERVER_IP"

# 创建临时部署脚本
TEMP_DEPLOY_SCRIPT=$(mktemp)
cat > "$TEMP_DEPLOY_SCRIPT" << 'EOF'
#!/bin/bash
set -e

echo "开始部署 Peak Sonic 网站..."

# 进入临时目录
cd /tmp

# 下载最新的网站代码
echo "正在下载最新版本..."
wget https://github.com/TaeYeon233/peaksonic-website/archive/main.zip -O peaksonic-latest.zip

# 解压文件
echo "正在解压文件..."
unzip peaksonic-latest.zip

# 备份当前网站
echo "正在备份当前网站..."
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
sudo cp -r /var/www/peaksonic.studio /var/www/peaksonic.studio.backup_$TIMESTAMP

# 删除旧文件并复制新文件
echo "正在更新网站文件..."
sudo rm -rf /var/www/peaksonic.studio/*
sudo cp -r peaksonic-website-main/* /var/www/peaksonic.studio/

# 设置正确的文件权限
echo "正在设置文件权限..."
sudo chown -R www-data:www-data /var/www/peaksonic.studio/
sudo chmod -R 644 /var/www/peaksonic.studio/
sudo chmod -R 755 /var/www/peaksonic.studio/

# 重启Web服务器
echo "正在重启Nginx..."
sudo systemctl reload nginx

# 清理临时文件
rm -rf peaksonic-latest.zip peaksonic-website-main

echo "网站部署完成！"
echo "访问您的网站: https://peaksonic.studio"
EOF

# 传输并执行部署脚本
echo "正在传输部署脚本到服务器..."
scp "$TEMP_DEPLOY_SCRIPT" "$USERNAME@$SERVER_IP:/tmp/deploy_script.sh"

echo "正在执行远程部署..."
ssh "$USERNAME@$SERVER_IP" "chmod +x /tmp/deploy_script.sh && /tmp/deploy_script.sh"

# 清理临时文件
rm "$TEMP_DEPLOY_SCRIPT"

echo ""
echo "部署完成！您的网站现在应该已经更新。"
echo "请访问 https://peaksonic.studio 查看更新后的网站。"