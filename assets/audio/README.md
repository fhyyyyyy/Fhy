# 音频资源目录

按词库分目录存放：

```
assets/audio/
├── 179/        # 听力 179 词
│   ├── reserve.mp3
│   ├── in_advance.mp3
│   └── ...
├── zhenjing/   # 词汇真经
└── 538/        # 阅读 538
```

## 命名规则

文件名 = `word.mp3`，单词中的空格用下划线替换：
- `reserve` → `reserve.mp3`
- `in advance` → `in_advance.mp3`
- `have to` → `have_to.mp3`

## 音频来源

**禁止用于商业用途！**（原项目声明）

推荐方案：
1. **个人使用**：从原仓库下载（仅供学习）
2. **正式发布**：自建 TTS 音频 / 购买正版素材 / 接入在线词典 API
3. **众包录制**：用 `tts` 工具批量生成（用 `package:tts` 等本地 TTS）
