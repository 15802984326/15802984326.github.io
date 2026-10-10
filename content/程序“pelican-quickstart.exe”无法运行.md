Title: Windows 下 pelican-quickstart 被应用程序控制策略拦截的排查方法
Date: 2026-10-10
Category: 疑难杂症
Tags: pelican, windows, powershell, 博客搭建
Slug: pelican-quickstart-blocked-by-app-control

在 Windows PowerShell 中运行 `pelican-quickstart` 时，如果出现类似下面的报错：

```text
PS E:\workspace\my-blog> pelican-quickstart
程序“pelican-quickstart.exe”无法运行: 应用程序控制策略已阻止此文件。所在位置 行:1 字符: 1
+ pelican-quickstart
+ ~~~~~~~~~~~~~~~~~~。
所在位置 行:1 字符: 1
+ pelican-quickstart
+ ~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ResourceUnavailable: (:) [], ApplicationFailedException
    + FullyQualifiedErrorId : NativeCommandFailed

PS E:\workspace\my-blog>
```

这通常不是 Pelican 本身的问题，而是 **Windows 安全策略拦截了 `pelican-quickstart.exe`**。常见原因包括：智能应用控制、文件被标记为“来自网络”，或者企业/域策略限制。

## 第一步：确认电脑环境

如果这台电脑是公司电脑、学校机房电脑，或者使用域账号登录，拦截很可能来自 IT 管理员下发的策略。这种情况下不建议自行修改系统策略，最好联系公司 IT 放行 Python 脚本目录。

如果是个人电脑，可以继续往下排查。

## 第二步：Pelican 已经安装成功

在 PowerShell 中执行：

```powershell
python -m pelican -h
```

如果能正常输出帮助信息，说明 Pelican 已经安装成功，只是 `pelican-quickstart.exe` 这个快捷命令被拦截。

## 第三步：：关闭智能应用控制

**设置 → 隐私和安全性 → Windows 安全中心 → 应用和浏览器控制 → 智能应用控制设置**

将模式改为：

- **关闭**
- 或 **评估模式**

修改后重新运行 `pelican-quickstart`。需要注意，关闭智能应用控制后，部分windows系统版本可能需要重启电脑才能重新开启。