# iOS / Android 发布配置

> 本文档说明怎么把本项目发布到 App Store / Google Play

## ✅ 已包含的文件

### iOS
- `ios/Runner/Info.plist` - **已优化**
  - 中文显示名「雅思词汇」
  - 7 个权限说明文案（麦克风/相机/相册等，全部标注「不需要」）
  - 音频后台播放模式
  - 国际化支持 zh_CN / en
- `ios/Runner/Base.lproj/LaunchScreen.storyboard` - **已写**
  - 雅思蓝 (#1976D2) 渐变背景
- `ios/Runner/PrivacyInfo.xcprivacy` - **已写**
  - 不追踪、不收集数据
  - UserDefaults / FileTimestamp 用途声明

### Android
- `android/app/src/main/AndroidManifest.xml` - **已优化**
  - 最小化权限：仅 INTERNET（debug 模式必需）
  - App 名称中文
  - 自适应启动屏

## 🍎 iOS 发布步骤

### 前置
1. Apple Developer 账号（$99/年）
2. Xcode 15+
3. 在 `ios/Runner.xcodeproj` 中配置：
   - Bundle Identifier: `com.yourname.ieltsmaster`
   - Team: 你的开发者团队
   - Provisioning Profile: 自动签名

### 构建并发布
```bash
# 1. 配置 bundle id
# 编辑 ios/Runner.xcodeproj/project.pbxproj 或在 Xcode GUI 中

# 2. 打 release ipa
flutter build ios --release

# 3. 在 Xcode 中：Product → Archive → Distribute App → App Store Connect
```

### App Store 审核要点
- ✅ 隐私清单已就绪
- ✅ 权限说明文案已写
- ⚠️ 词库/音频来源：必须自证不侵权（参考 AUDIO_LICENSE.md）
- ⚠️ 隐私政策 URL：必须提供（可挂在 GitHub Pages）

## 🤖 Android 发布步骤

### 前置
1. Google Play 开发者账号（$25 一次性）
2. JDK 17 + Android Studio
3. 在 `android/app/build.gradle` 中配置：
   - `applicationId`: `com.yourname.ieltsmaster`
   - `versionCode` / `versionName`
   - 签名密钥

### 生成签名密钥
```bash
# 一次性生成
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# 在 android/key.properties 中配置
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=/Users/yourname/upload-keystore.jks
```

### 构建 AAB
```bash
flutter build appbundle --release
# 产物：build/app/outputs/bundle/release/app-release.aab
```

### Google Play 审核要点
- ✅ 权限最小化
- ✅ targetSdkVersion 33+（强制要求）
- ⚠️ 数据安全声明：必须填写（虽然本 App 不收集数据，但要在后台勾选「无」）
- ⚠️ 内容分级：填「教育类」

## 🖼 App 图标

启动屏和图标已通过 `image` 工具生成，**位置**：

```
ios/Runner/Assets.xcassets/AppIcon.appiconset/
android/app/src/main/res/mipmap-*/
```

**生成后处理流程**：
1. 把生成的 1024x1024 png 放入 `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
2. 用 `flutter_launcher_icons` 包自动生成各尺寸：
   ```yaml
   # pubspec.yaml
   dev_dependencies:
     flutter_launcher_icons: ^0.13.1

   flutter_launcher_icons:
     android: true
     ios: true
     image_path: "assets/icon/app_icon.png"
   ```
3. `flutter pub run flutter_launcher_icons`

## 🔐 签名密钥保管

| 密钥 | 存放位置 | 备注 |
|---|---|---|
| iOS Certificate | Apple Developer 后台 + 本地 Keychain | 团队共享用 |
| iOS Provisioning | Apple Developer 后台 | 按设备/类型 |
| Android keystore | `android/app/upload-keystore.jks` | **不要提交到 git** |
| Google Play App Signing | Google Play Console | 自动管理 |

**重要：keystore 一旦丢失，无法更新已发布的 App，必须重新发新包！**
