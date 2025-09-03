# Rush Audio Chat 🎵💬

一个基于Flutter的现代化聊天应用，采用MVVM架构，支持多语言和主题自定义。

## ✨ 主要功能

- 🌍 **多语言支持** - 中文/英文动态切换
- 🎨 **主题自定义** - 8种颜色主题可选
- 💬 **用户聊天** - 实时消息和用户资料
- 🔍 **搜索功能** - 智能用户搜索和历史记录
- 📱 **响应式UI** - Material Design 3设计
- 💾 **数据持久化** - SQLite本地存储

## 🛠️ 技术栈

- **Flutter** ^3.8.0 - 跨平台UI框架
- **Provider** - MVVM状态管理
- **SQLite** - 本地数据存储
- **Fluro** - 路由管理
- **国际化** - 多语言支持

## 🏗️ 项目架构

```
lib/
├── database/              # 数据库管理
├── services/              # 业务服务层
├── modules/               # 功能模块
│   ├── main/             # 主页面模块
│   │   ├── viewmodel/    # MVVM - ViewModel层
│   │   ├── page/         # UI页面
│   │   └── fragment/     # UI片段
│   └── settings/         # 设置模块
├── commom/               # 通用工具
├── l10n/                 # 国际化资源
└── main.dart            # 应用入口
```

## 🚀 快速开始

```bash
# 1. 克隆项目
git clone https://github.com/yourusername/rush_audio_chat.git
cd rush_audio_chat

# 2. 安装依赖
flutter pub get

# 3. 生成国际化文件
flutter gen-l10n

# 4. 运行应用
flutter run

# 5. 构建发布版本
flutter build apk --release
```

## 🎯 核心特性

### MVVM架构
- **ViewModel** - 业务逻辑和状态管理
- **View** - UI界面展示
- **Model** - 数据模型定义

### 数据持久化
- **SQLite** - 用户设置、搜索历史
- **SharedPreferences** - 轻量级配置
- **缓存管理** - 图片和数据缓存

### 国际化
- **动态语言切换** - 无需重启应用
- **完整本地化** - 所有文本支持多语言
- **RTL支持** - 支持从右到左的语言

## 📝 开发说明

### 环境要求
- Flutter SDK ^3.8.0
- Dart SDK
- Android Studio / VS Code

### 主要依赖
```yaml
dependencies:
  flutter: sdk: flutter
  provider: ^6.1.2          # 状态管理
  sqflite: ^2.3.3+1         # 本地数据库
  fluro: ^2.0.5             # 路由管理
  cached_network_image: ^3.4.1  # 图片缓存
```

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

Made with Flutter ❤️
