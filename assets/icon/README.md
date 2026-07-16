# 图标资源说明

## 文件
- `app_icon.svg` - App 图标源文件（1024x1024 矢量）
- `splash_logo.svg` - 启动屏中央 logo（1024x1024 矢量）

## 设计理念
- **主色调**：雅思蓝 (#1976D2) → 深蓝 (#0D47A1) 渐变
- **中心元素**：打开的书（双页）+ 顶部大写 "I"（IELTS 首字母）
- **底部标识**：「雅思」中文字样
- **细节**：白色装饰圆点（教育/知识感）

## 使用方法

### 1. 转 PNG（一次性）
推荐用 [Inkscape](https://inkscape.org/) 或在线工具：
```bash
# 用 Inkscape
inkscape app_icon.svg --export-type=png --export-filename=app_icon.png -w 1024 -h 1024
inkscape splash_logo.svg --export-type=png --export-filename=splash_logo.png -w 1024 -h 1024
```

或者用 Python + cairosvg：
```python
import cairosvg
cairosvg.svg2png(url='app_icon.svg', output_width=1024, write_to='app_icon.png')
cairosvg.svg2png(url='splash_logo.svg', output_width=1024, write_to='splash_logo.png')
```

### 2. Flutter 端生成所有尺寸
在 `pubspec.yaml` 中加：
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  adaptive_icon_background: "#1976D2"
  adaptive_icon_foreground: "assets/icon/splash_logo.png"
```

然后：
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

自动生成：
- iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Android: `android/app/src/main/res/mipmap-{m,h,xh,xxh,xxxh}dpi/`

## 自定义颜色
要换主色调，编辑 SVG 里的：
- `#1976D2` (主色)
- `#0D47A1` (深色)
- `#42A5F5` (浅色)

## 自定义文字
要改 "雅思" 字样或加英文 "IELTS"，编辑 `app_icon.svg` 底部 `<text>` 标签。
