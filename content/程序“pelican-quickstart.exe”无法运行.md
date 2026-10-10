Title: Windows 下 pelican-quickstart 被应用程序控制策略拦截的排查方法
Date: 2026-10-10
Category: 开发工具
Tags: pelican, windows, powershell, 博客搭建
Slug: pelican-quickstart-blocked-by-app-control

在 Windows PowerShell 中运行 `pelican-quickstart` 时，如果出现类似下面的报错：

```text
程序“pelican-quickstart.exe”无法运行: 应用程序控制策略已阻止此文件。
CategoryInfo          : ResourceUnavailable
FullyQualifiedErrorId : NativeCommandFailed
```

这通常不是 Pelican 本身的问题，而是 **Windows 安全策略拦截了 `pelican-quickstart.exe`**。常见原因包括：智能应用控制、文件被标记为“来自网络”，或者企业/域策略限制。

## 第一步：确认电脑环境

如果这台电脑是公司电脑、学校机房电脑，或者使用域账号登录，拦截很可能来自 IT 管理员下发的策略。这种情况下不建议自行修改系统策略，最好联系公司 IT 放行 Python 脚本目录。

如果是个人电脑，可以继续往下排查。

## 第二步：先绕开 pelican-quickstart

在 PowerShell 中执行：

```powershell
python -m pelican -h
```

如果能正常输出帮助信息，说明 Pelican 已经安装成功，只是 `pelican-quickstart.exe` 这个快捷命令被拦截。此时可以先用模块方式运行 Pelican：

```powershell
python -m pelican
```

## 第三步：解除文件锁定

找到被拦截的可执行文件，例如：

```text
Scripts\pelican-quickstart.exe
```

右键该文件，选择 **属性**，在 **常规** 页底部查看是否有提示：

> 此文件来自其他计算机，可能被阻止以帮助保护该计算机

如果有，勾选 **解除锁定**，点击 **应用**，然后重新运行：

```powershell
pelican-quickstart
```

也可以使用 PowerShell 批量解除锁定：

```powershell
Get-ChildItem ".\Scripts" -Recurse -Filter "*.exe" | Unblock-File
```

注意路径需要根据实际 Python 环境调整。

## 第四步：关闭智能应用控制

如果仍然被拦截，可以打开：

**设置 → 隐私和安全性 → Windows 安全中心 → 应用和浏览器控制 → 智能应用控制设置**

将模式改为：

- **关闭**
- 或 **评估模式**

修改后重新运行 `pelican-quickstart`。需要注意，关闭智能应用控制后，部分系统版本可能需要重置才能重新开启。

## 第五步：检查 AppLocker / WDAC

如果上述方法都不生效，可以按 `Win + R`，输入：

```text
secpol.msc
```

查看左侧是否有：

```text
应用程序控制策略 → AppLocker
```

如果存在，说明系统确实启用了应用控制策略。如果是公司电脑，即使本地能打开该界面，实际策略也可能由域控制器下发，本机无法修改。

## 更稳的替代方案：手动初始化 Pelican

如果不想调整系统策略，可以跳过 `pelican-quickstart`，直接手动创建配置文件。

在项目根目录新建 `pelicanconf.py`：

```python
AUTHOR = '你的名字'
SITENAME = '我的学习笔记'
SITEURL = ''
PATH = 'content'
OUTPUT_PATH = 'output'
THEME = 'simple'
```

再新建 `content/first-post.md`：

```markdown
Title: 我的第一篇学习笔记
Date: 2026-10-10
Category: Python
Tags: pelican, 学习笔记
Slug: my-first-post
Author: 你的名字

这是第一篇博客。
```

然后执行：

```powershell
python -m pelican content
python -m pelican --listen
```

在浏览器中打开：

```text
http://localhost:8000
```

如果能看到页面，说明博客已经可以正常生成和预览。后续写文章时，只需要在 `content` 目录下新增 Markdown 文件，再重新生成即可。
```



---
需要我帮你整理一份手动配置后写第一篇博客文章的完整流程吗？从创建 .md 文件到本地预览，一步步来。
