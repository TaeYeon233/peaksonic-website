#!/bin/bash

# Peak Sonic Website Server Deployment Script
# 此脚本应在服务器上运行

echo "Peak Sonic Website 服务器部署脚本"
echo "=================================="

# 检查是否在正确的目录下运行
if [ "$EUID" -eq 0 ]; then
    echo "警告: 不建议以root身份运行此脚本"
    read -p "是否继续? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "正在部署网站..."

# 进入临时目录
cd /tmp

# 下载最新的网站代码
echo "正在下载最新版本..."
wget https://github.com/TaeYeon233/peaksonic-website/archive/main.zip -O peaksonic-latest.zip

# 解压文件
echo "正在解压文件..."
unzip peaksonic-latest.zip

# 备份当前网站（保留最近3个备份）
echo "正在备份当前网站..."
cd /var/www/
BACKUP_DIR="peaksonic.studio.backup.$(date +%Y%m%d_%H%M%S)"
sudo cp -r peaksonic.studio "$BACKUP_DIR"
# 保留最近3个备份，删除更早的备份
ls -dt peaksonic.studio.backup.* | tail -n +4 | xargs -r sudo rm -rf
cd -

# 删除旧文件并复制新文件
echo "正在更新网站文件..."
sudo rm -rf /var/www/peaksonic.studio/*
sudo cp -r /tmp/peaksonic-website-main/* /var/www/peaksonic.studio/

# 设置正确的文件权限
echo "正在设置文件权限..."
sudo chown -R www-data:www-data /var/www/peaksonic.studio/
sudo chmod -R 644 /var/www/peaksonic.studio/
sudo chmod -R 755 /var/www/peaksonic.studio/

# 重启Web服务器
echo "正在重启Nginx..."
sudo systemctl reload nginx

# 清理临时文件
rm -rf /tmp/peaksonic-latest.zip /tmp/peaksonic-website-main

echo ""
echo "网站部署完成！"
echo "访问您的网站: https://peaksonic.studio"
echo ""

# 显示部署信息
echo "部署详情:"
echo "- 部署时间: $(date)"
echo "- 当前版本: $(git -C /var/www/peaksonic.studio rev-parse HEAD 2>/dev/null || echo '无git信息')"