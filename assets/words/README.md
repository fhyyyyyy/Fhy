# 词库 JSON 格式

每个词库文件是一个 JSON 数组，元素结构：

```json
{
  "index": 1,
  "word": "reserve",
  "type": "v.",
  "meaning": "预订",
  "replace": ["book"]
}
```

字段说明：
- `index`：序号
- `word`：单词（音频文件名 = `word.mp3`，含空格请用下划线）
- `type`：词性（`v.` / `n.` / `adj.` / `conj.` 等，可空）
- `meaning`：中文释义
- `replace`：同义替换词列表

## 词库文件清单

把以下文件放到此目录（`assets/words/`）：

| 文件 | 来源 | 数量 |
|---|---|---|
| `zhenjing.json` | 雅思词汇真经 | ~368 |
| `listening179.json` | 听力 179 考点词 | 179 |
| `reading538.json` | 阅读 538 同义替换 | 538 |

数据来源：[hefengxian/my-ielts](https://github.com/hefengxian/my-ielts) 仓库
**注意版权：原仓库 README 明确「禁止商业用途」**
