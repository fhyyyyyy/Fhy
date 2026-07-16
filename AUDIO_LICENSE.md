# 音频资源版权问题 - 专项说明

> 这个文档针对的是**音频（.mp3）资源**，词库文字内容（word/meaning/replace）版权风险较低，下面会分开说。

## 一、原项目声明

参考仓库 [hefengxian/my-ielts](https://github.com/hefengxian/my-ielts) 的 README 明确写了：

> **「禁止将本项目用于任何商业目的！！！」**

这个声明是**整体项目级**的，意味着：词库、音频、所有派生内容都不能商用。

## 二、风险分级

### 🟢 低风险（个人学习/试用）
- 把整个仓库（包括音频）下载到本地，自己用
- 不发布、不上架、不分发的纯个人学习
- 在 README 中标注来源

### 🟡 中风险（开源/分享）
- 把本 App 上传到 GitHub/Gitee 当开源项目
- 仅供其他人下载自用
- 风险点：可能被人利用作商业用途

### 🔴 高风险（必须替换）
- 上架 App Store / Google Play
- 应用内付费 / 订阅
- 内嵌广告变现
- 卖给第三方

## 三、词库 vs 音频 - 版权差异

| 内容 | 风险 | 说明 |
|---|---|---|
| **单词本身**（reserve, book） | 🟢 无 | 英语单词不受版权保护 |
| **中文释义** | 🟢 低 | 通用词典释义通常不构成独创性 |
| **同义替换词列表** | 🟢 低 | 教学性内容，编排方式可能涉及 |
| **音频 MP3** | 🔴 高 | 具体录音是受版权保护的"作品" |

**核心风险点在音频**。文字词库即使有版权纠纷，赔偿通常很低；但录音是明确的"作品"。

## 四、解决方案（按推荐顺序）

### 方案 1：纯个人使用（零成本）
- 直接用原仓库的音频
- 仅本地运行，不分发
- ✅ 完全合规

### 方案 2：TTS 本地生成（推荐用于开源发布）
用 Flutter 端 TTS 库动态生成音频：

```yaml
# pubspec.yaml
dependencies:
  flutter_tts: ^4.0.2
```

```dart
// 首次启动时批量预生成
import 'package:flutter_tts/flutter_tts.dart';

class AudioGenerator {
  final tts = FlutterTts();

  Future<void> generate(String word, String outputPath) async {
    await tts.setLanguage('en-US');
    await tts.setSpeechRate(0.5);
    await tts.synthesizeToFile(word, outputPath);
  }
}
```

**优点**：零版权风险，每个 App 独立生成
**缺点**：
- 音质不如真人录音
- iOS/Android 平台 TTS 音色不一样
- 179 + 538 + 词汇真经 ≈ 1000 词，首次生成需 10-30 分钟

### 方案 3：购买正版词库
- 沪江开心词场、有道词典的词库（部分商用授权）
- 直接联系雅思词汇真经出版社（石油工业出版社）
- 期望成本：几千到几万元一次性

### 方案 4：免费可商用音频
- **Cambridge Dictionary API**：[https://dictionary.cambridge.org/](https://dictionary.cambridge.org/) 提供真人发音，**需自行确认使用条款**
- **Forvo API**：真人发音，付费 API
- **Google Cloud TTS** / **Azure TTS**：商用 TTS，按字符计费，约 $4/百万字符

### 方案 5：众包录制
- 自己做 MVP 时自己录 179 个词（半天搞定）
- 后续开放给用户贡献（需要审核 + 存储）

## 五、推荐路线

| 阶段 | 做法 | 版权状态 |
|---|---|---|
| **MVP (W1-W2)** | 直接用原仓库音频 | 🟢 个人使用 OK |
| **开源发布 (W3+)** | 切换到本地 TTS 生成 | 🟢 零风险 |
| **正式上架** | 接入 Google Cloud TTS / 真人录制 | 🟢 完全合规 |
| **长期运营** | 考虑购买正版 / 自建词库 | 🟢 可控 |

## 六、代码层面的合规设计

为了将来切换音频源零成本，本项目做了**音频路径解耦**：

```dart
// 单词只引用路径，不直接耦合资源
class Word {
  late String audioPath;  // 资产路径，可任意替换
}

// DAO 层封装切换逻辑
class AudioService {
  // 未来可换成：网络下载 / 平台 TTS / CDN
  Future<void> play(Word word) async {
    await player.setAsset(word.audioPath);
  }
}
```

将来要从"本地 MP3"切换到"在线 TTS"或"自建资源"，只需要改 `Word.audioPath` 的赋值逻辑，**业务代码一行不动**。

## 七、最终建议

> **对你个人用** → 直接拿原仓库资源，最快最省事。
> **要开源分享** → 加个"音频由 TTS 生成"的开关，让用户自选。
> **要商业化** → 必须从方案 2-5 里挑一个替换音频源。

**本仓库代码本身**（lib/、test/、所有 Dart 文件）采用 MIT 协议，你可以自由使用、修改、商用。**只有 assets/ 下的资源需要单独评估版权**。
