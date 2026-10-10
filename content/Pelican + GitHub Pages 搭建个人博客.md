Title: 用 Pelican + GitHub Pages 搭建个人博客
Date: 2026-10-10 22:30
Category: 技术教程
Tags: pelican, github pages, python, 博客
Slug: pelican-github-pages-blog-tutorial

# Pelican + GitHub Pages 搭建个人博客

这篇教程整理自一次真实搭建过程，适用于 Windows + PowerShell 环境，所有 pelican-quickstart 交互选项都写得比较清楚。

## 1. 环境准备

本地需要安装：

- Python
- Git
- GitHub 账号

安装完成后，打开 PowerShell，验证：

```powershell
python --version
git --version
```

## 2. 创建 GitHub 仓库

在 GitHub 创建一个仓库，名字必须和用户名一致：

```text
username.github.io
```

例如：

```text
15802984326.github.io
```

创建时可以选择：

- 勾选 **Add a README file**
- 勾选 **Add .gitignore**
- 选择 **Python** 或 **None** 都可以

这个仓库会作为博客的最终发布地址。

## 3. 创建本地博客目录

在本地新建一个博客目录：

```powershell
mkdir E:\workspace\my-blog
cd E:\workspace\my-blog
```

## 4. 安装 Pelican 和依赖

```powershell
pip install pelican markdown ghp-import
```

安装完成后验证：

```powershell
pelican --version
```

## 5. 初始化博客项目

在项目目录中执行：

```powershell
pelican-quickstart
```

它会进入交互式配置。下面按顺序给出每个问题和推荐输入。

| 交互问题 | 推荐输入 | 说明 |
|---|---|---|
| Where do you want to create your new web site? | 直接回车 | 默认当前目录 |
| What will be the title of this web site? | 输入博客标题 | 例如：protocol_blog |
| Who will be the author of this web site? | 输入作者名 | 例如：protocol |
| What will be the default language of this web site? | zh | 中文博客建议填 zh |
| Do you want to specify a URL prefix? | n | 不需要额外 URL 前缀 |
| Do you want to enable article pagination? | y | 开启文章分页 |
| How many articles per page? | 10 | 默认即可 |
| What is your time zone? | Asia/Shanghai | 中国时区 |
| Do you want to generate a tasks.py/Makefile? | y | 生成自动化脚本 |
| Do you want to upload your website using FTP? | n | 不使用 FTP |
| Do you want to upload your website using SSH? | n | 不使用 SSH |
| Do you want to upload your website using Dropbox? | n | 不使用 Dropbox |
| Do you want to upload your website using Amazon S3? | n | 不使用 S3 |
| Do you want to upload your website using Rackspace Cloud Files? | n | 不使用 Rackspace |
| Do you want to upload your website using GitHub Pages? | y | 使用 GitHub Pages |
| Is this your personal page? | y | 是 username.github.io 个人页 |

不同 Pelican 版本的问题顺序可能略有差异。如果某个问题后面有 `[.]`、`[en]`、`[Y/n]` 这类提示，表示方括号里是默认值，直接回车就会采用默认值。

## 6. 初始化 Git 仓库

因为后面要用 `ghp-import` 推送，当前目录必须是一个 Git 仓库：

```powershell
git init
git remote add origin https://github.com/15802984326/15802984326.github.io.git
```

## 7. 写第一篇文章

在 `content` 目录下新建一个 Markdown 文件，例如：

```text
content/my-first-post.md
```

内容示例：

```markdown
Title: 我的第一篇学习笔记
Date: 2026-10-10
Category: Python
Tags: pelican, 博客

这是第一篇博客。
```

文章开头的 `Title`、`Date`、`Category`、`Tags` 是 Pelican 识别文章信息的元数据，必须放在文件最前面。

## 8. 本地生成和预览

生成静态页面：

```powershell
pelican content
```

启动本地预览：

```powershell
pelican --listen
```

然后在浏览器打开：

```text
http://localhost:8000
```

如果能看到文章，说明博客已经生成成功。

## 9. 部署到 GitHub Pages

生成完成后，用 `ghp-import` 把 `output` 目录推送到 GitHub：

```powershell
ghp-import output -b main -n -m "deploy blog"
git push origin main
```

如果提示远程有本地没有的内容，可以先拉取合并：

```powershell
git pull origin main --allow-unrelated-histories
git push origin main
```

如果确认远程只有 GitHub 自动生成的 README 等文件，也可以强制推送：

```powershell
git push -f origin main
```

对于 `username.github.io` 这种个人站点，Pelican 生成的页面通常推送到 `main` 分支即可。

## 10. 开启 GitHub Pages

打开仓库设置：

1. 进入 https://github.com/15802984326/15802984326.github.io
2. 点击 **Settings**
3. 左侧选择 **Pages**
4. **Source** 选择 **Deploy from a branch**
5. Branch 选择 **main**
6. Folder 选择 **/(root)**
7. 点击 **Save**

等待一两分钟后，访问：

```text
https://15802984326.github.io
```

就能看到博客了。

## 11. 后续常用命令

生成博客：

```powershell
pelican content
```

本地预览：

```powershell
pelican --listen
```

部署博客：

```powershell
ghp-import output -b main -n -m "deploy blog"
git push origin main
```

如果之前选了生成 `tasks.py`，也可以使用：

```powershell
python tasks.py html
python tasks.py serve
python tasks.py github
```

## 12. 写新文章的方式

以后每次写新文章，只需要在 `content` 目录下新增 `.md` 文件，然后重新生成并部署：

```powershell
pelican content
ghp-import output -b main -n -m "add new post"
git push origin main
```

文章文件名建议用英文，例如：

```text
content/python-notes-01.md
```

这样可以避免部分环境下中文路径带来的问题。
```

