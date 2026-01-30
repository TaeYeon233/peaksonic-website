# Peak Sonic Studio Clone

这是一个类似于 https://peaksonic.square.site 的音乐工作室网站克隆项目。

## 项目结构

```
peaksonic-clone/
├── index.html          # 主页
├── css/
│   └── style.css       # 样式表
├── js/
│   └── script.js       # JavaScript功能
└── images/             # 图片资源（占位符）
```

## 设计特点

- 响应式设计，适配各种屏幕尺寸
- 现代化布局，注重用户体验
- 包含以下主要部分：
  - 导航栏
  - 英雄横幅区域
  - 服务介绍
  - 作品集展示
  - 关于我们
  - 联系表单
  - 页脚

## 功能

- 平滑滚动导航
- 移动端友好菜单
- 表单验证
- 滚动动画效果
- 视差滚动效果

## 使用方法

1. 将项目文件放在Web服务器上
2. 替换示例图片为实际图片
3. 根据需要自定义颜色和内容

## 自定义

要自定义网站，请修改以下文件：

- `index.html` - 修改内容和结构
- `css/style.css` - 修改样式和颜色
- `js/script.js` - 修改交互行为

## 部署

### 本地部署到服务器

1. 使用提供的部署脚本：
   ```bash
   ./deploy.sh [服务器IP] [用户名]
   ```

### 服务器端部署

1. 将 `server-deploy.sh` 上传到服务器
2. 在服务器上运行：
   ```bash
   chmod +x server-deploy.sh
   ./server-deploy.sh
   ```

脚本将自动下载最新版本的网站并部署到 `/var/www/peaksonic.studio` 目录。