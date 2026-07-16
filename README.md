# 雅思背单词 App (ielts_app)

> 基于 [hefengxian/my-ielts](https://github.com/hefengxian/my-ielts) 词库的 Flutter 移动端重制版

## ✨ 特性

- 📚 **三大词库**：雅思词汇真经 / 听力 179 / 阅读 538 同义替换
- 🧠 **SM-2 间隔重复算法**：科学的复习调度，覆盖率 100% 单元测试
- 🎧 **听写练习**：拼写单词 + 同义替换匹配
- 📊 **学习统计**：每个词库的学习进度
- 💾 **纯本地**：无后端、无账号、所有数据在本地（Isar）
- 🌗 **暗色主题**：跟随系统

## 🏗 技术栈

- **Flutter 3.19+** / Dart 3.3+
- **Riverpod 2.5** - 状态管理
- **go_router 14** - 路由
- **Isar 3.1** - 本地数据库（比 Hive 快 2-3x）
- **just_audio 0.9** - 音频播放

## 🚀 快速开始

### 1. 环境准备

```bash
# 需要 Flutter 3.19+ 和 Dart 3.3+
flutter --version
```

### 2. 在 Flutter 环境下补全项目骨架

本项目只包含 `lib/` `assets/` `test/` 和 `pubspec.yaml`。
你需要在本地用 `flutter create .` 套上平台壳（ios/android/linux/macos/windows/web）。

```bash
cd ielts_app
flutter create . --org com.yourname --platforms=ios,android
```

### 3. 安装依赖

```bash
flutter pub get
```

### 4. 准备词库资源

把以下文件放到 `assets/words/`：
- `zhenjing.json`（来自原仓库的 `src/pages/ielts/`，**自用**，勿商用）
- `listening179.json`
- `reading538.json`

把音频文件按词库分目录放到 `assets/audio/{179,zhenjing,538}/`。
文件名 = `word.mp3`（空格转下划线）。

⚠️ 详见 [AUDIO_LICENSE.md](./AUDIO_LICENSE.md)

### 5. 代码生成（Isar / Riverpod）

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 6. 跑测试

```bash
flutter test
```

应该看到 SM-2 的 7 个测试用例全过。

### 7. 运行

```bash
flutter run
```

## 📁 目录结构

```
lib/
├── main.dart                      # 入口
├── app.dart                       # MaterialApp
├── core/
│   ├── router/app_router.dart     # 路由配置
│   ├── theme/app_theme.dart       # 主题
│   └── utils/
│       ├── bootstrap.dart         # 启动初始化
│       └── isar_provider.dart     # Isar Provider
├── data/
│   ├── models/                    # Isar Collection
│   │   ├── word.dart
│   │   ├── review_state.dart
│   │   └── study_session.dart
│   ├── datasources/
│   │   ├── local/                 # Isar DAO
│   │   └── seed/word_seed_loader.dart
│   └── repositories/              # 仓库层
├── domain/
│   └── algorithms/sm2.dart        # ★ SM-2 算法
└── features/
    ├── home/                      # 首页
    ├── library/                   # 词库浏览
    ├── study/                     # 学习（听写+评分）
    ├── quiz/                      # 测验（占位）
    └── stats/                     # 统计
```

## 🧪 测试

```bash
flutter test                                    # 全部
flutter test test/domain/algorithms/sm2_test.dart  # 仅 SM-2
```

## 📝 路线图

- [x] 项目脚手架 + 词库种子
- [x] SM-2 算法 + 单元测试
- [x] 学习页（听写 + 同义替换）
- [x] 词库浏览
- [x] 学习统计
- [ ] 测验页（四选一、匹配题）
- [ ] 拼写强化模式（首字母提示）
- [ ] 错题本
- [ ] 收藏夹
- [ ] 学习热力图
- [ ] App 图标 / 启动屏
- [ ] iOS / Android 发布

## ⚖️ 版权声明

本项目代码采用 MIT 协议。
**词库与音频来自第三方资源，仅供个人学习使用，不得用于商业目的。**
详见 [AUDIO_LICENSE.md](./AUDIO_LICENSE.md)
