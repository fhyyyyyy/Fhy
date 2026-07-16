# GitHub Actions 编译 Android APK - 完整教程

> **目标**：把你电脑上的代码推到 GitHub，云端自动编译出 APK，你下载到手机安装。

## ⏱ 时间预估
- 注册/登录 GitHub：3 分钟
- 推代码：3 分钟
- CI 编译：10-15 分钟
- 下载 + 安装 APK：3 分钟
- **总耗时：20-25 分钟**

## 📋 前置条件
- ✅ GitHub 账号（没有去 https://github.com 注册）
- ✅ 你的项目代码（已在 `C:\Users\Fhy2\.qclaw\workspace-x5kuz49xple53hhg\ielts_app\`）
- ✅ 手机（Android 5.0+，开启"未知来源安装"）

---

## 🚀 步骤 1：创建 GitHub 仓库

1. 打开 https://github.com/new
2. 填写：
   - **Repository name**: `ielts-vocab-app`（或随便取）
   - **Description**: `Flutter 雅思背单词 App`
   - **Public**（必须公开，否则 GitHub Actions 跑不了）
   - ❌ 不要勾选 "Add a README file"（我们要自己 push）
3. 点 **Create repository**
4. 记下仓库地址，形如：`https://github.com/你的用户名/ielts-vocab-app.git`

---

## 🚀 步骤 2：推送代码到 GitHub

打开 PowerShell，进入项目目录：

```powershell
cd C:\Users\Fhy2\.qclaw\workspace-x5kuz49xple53hhg\ielts_app

# 初始化 git
git init
git config user.name "你的名字"
git config user.email "你的邮箱@example.com"

# 添加所有文件
git add .

# 第一次提交
git commit -m "init: 雅思词汇 App 初版"

# 关联远程仓库（替换成你自己的）
git remote add origin https://github.com/你的用户名/ielts-vocab-app.git

# 推送到 main 分支
git branch -M main
git push -u origin main
```

> 第一次 push 会弹出 GitHub 登录，按提示在浏览器里授权即可。

---

## 🚀 步骤 3：触发 GitHub Actions 编译

### 方法 A：自动触发
你刚才 push 的时候已经触发了！去 https://github.com/你的用户名/ielts-vocab-app/actions 看看。

### 方法 B：手动触发（如果自动没跑）
1. 进入仓库的 **Actions** 页面
2. 左侧选 **Build Android Debug APK**
3. 右侧点 **Run workflow** → 选 main 分支 → **Run workflow**

---

## 🚀 步骤 4：等待编译（约 10-15 分钟）

你会看到黄色圆点（运行中）→ 绿色对勾（成功）/ 红色叉（失败）

如果失败：
- 点进失败的 job，看红色那一步的日志
- 复制错误信息发给我

成功的标志：最后两步是绿色
- ✅ Upload APK to artifacts
- ✅ Show APK info

---

## 🚀 步骤 5：下载 APK

1. 编译成功后，停留在 Actions 页面
2. 滚到页面最底部，找 **Artifacts** 区域
3. 点 **ielts-app-debug-apk** 下载（一个 zip 文件）
4. 解压 zip，里面就是 `app-debug.apk`（约 30-50MB）

---

## 🚀 步骤 6：安装到手机

### Android 11 及以上
1. 把 `app-debug.apk` 通过微信/QQ/USB 传到手机
2. 点开 APK 文件
3. 弹出"是否允许此来源安装"→ 允许
4. 点 **安装**

### Android 10 及以下
1. 设置 → 安全 → 开启"未知来源"
2. 打开 APK → 安装

### 验证
- App 名称：雅思词汇
- 图标：蓝色背景 + 打开的书
- 进首页能看到 3 个词库卡片

---

## 🔄 后续更新代码

```powershell
cd C:\Users\Fhy2\.qclaw\workspace-x5kuz49xple53hhg\ielts_app
git add .
git commit -m "feat: 加了 XX 功能"
git push
```

每次 push 都会自动触发编译。APK 会带在新的 artifacts 里。

---

## 🆘 常见问题

### Q1: 编译失败，错误是 "Android licenses not accepted"
已经在 workflow 里加了 `yes | sdkmanager --licenses`，如果还报这个错就再跑一次。

### Q2: 编译失败，错误是 "Gradle build failed"
通常是网络问题导致依赖下载失败。点 **Re-run jobs** 重试。

### Q3: 编译失败，错误是 "Could not resolve com.android.tools.build:gradle"
GitHub Actions 国内访问偶尔慢。等 5 分钟重试。

### Q4: APK 装不上，提示"未安装应用"
- 检查手机是否是 Android 5.0+
- 删除旧版本（如果装过）
- 设置 → 应用 → 允许"安装未知应用"对你用的文件管理器授权

### Q5: 装上打开就闪退
- 打开 logcat 抓日志：
  ```powershell
  adb logcat | findstr "flutter"
  ```
- 把错误发我

### Q6: 想打 Release 版本（更小、但要签名）
需要配置签名密钥，比 debug 麻烦 5 倍。**先用 debug 跑起来再说**。

---

## 📊 APK 信息

| 项 | 值 |
|---|---|
| 类型 | Debug（未签名，但能直接装） |
| 大小 | 30-50MB |
| 包含 | Flutter 引擎 + Isar + Riverpod + just_audio + 全部 UI |
| 不包含 | 音频文件（首次启动会去 assets 找，找不到不报错，只是不发音） |

第一次启动：
- App 检测到没有音频 → try-catch 跳过 → 学习功能仍可用
- 没有词库 → App 里会显示"无结果"

如果想看完整效果：
- 等 App 跑起来后，我教你加词库数据
- 音频可以单独用 QQ 传文件追加进去

---

## 🎯 下一步

跑通后告诉我：
1. APK 装上没有？
2. App 能正常打开吗？
3. 看到什么界面？

我根据情况继续优化。
