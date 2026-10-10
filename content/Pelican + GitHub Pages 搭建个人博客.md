Title: 用 Pelican + GitHub Pages 搭建个人博客
Date: 2026-10-10
Category: 工具推荐
Tags: pelican, github pages, python, 博客
Slug: pelican-github-pages-blog-tutorial

这篇教程整理自一次真实搭建过程，适用于 Windows + PowerShell 环境。本文采用**源码仓库与发布仓库分离**的方案，即本地开发用的博客源码和 GitHub Pages 发布的静态文件分别放在两个不同的仓库中。所有 pelican-quickstart 交互选项都写得比较清楚。

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

## 2. 创建两个 GitHub 仓库

你需要创建**两个**仓库：

**仓库一：博客源码仓库**（可以设为私有）

在 GitHub 创建一个仓库，例如命名为`gm_blog`。这个仓库用来存放你的 Pelican 配置文件、文章源码等。

**仓库二：GitHub Pages 仓库**（必须公开）

再创建一个仓库，名字必须和用户名一致：

```text
username.github.io
```

例如：

```text
15802984326.github.io
```

这个仓库会作为博客的最终发布地址，里面只需要放生成的静态文件即可。

创建两个仓库时都可以勾选 **Add a README file** 和 **Add .gitignore**（选择 Python 或 None 都可以）。

## 3. 拉取博客源码仓库


```powershell
cd E:\workspace
git clone https://github.com/15802984326/gm_blog.git
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

在博客源码目录中执行：

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

执行pelican-quickstart有可能会报错，下面有失败案例：

[[程序 "pelican-quickstart.exe" 无法运行|Windows下Pelican快捷命令被拦截]] 

## 6. 提交到 gm_blog Git 仓库

```powershell
git add .
git commit -m "init: pelican blog project"
git push -u origin main
```

注意这里关联的是你的**源码仓库**（仓库一），不是 `username.github.io` 那个仓库。

## 7. 写第一篇文章

在 `content` 目录下新建一个 Markdown 文件，例如：

```text
content/my-first-post.md
```

内容示例：

```markdown
Title: Windows 下 pelican-quickstart 被应用程序控制策略拦截的排查方法
Date: 2026-10-10
Category: 疑难杂症
Tags: pelican, windows, powershell, 博客搭建
Slug: pelican-quickstart-blocked-by-app-control

这是第一篇博客。
```

这 5 个是 Pelican 文章的**元数据字段**，是 Pelican 识别文章信息的元数据，必须放在文件最前面。

| 字段 | 含义 | 你例子里的值 |
|---|---|---|
| **Title** | 文章标题，会显示在博客列表页和文章页顶部 | Windows 下 pelican-quickstart 被应用程序控制策略拦截的排查方法 |
| **Date** | 文章发布日期，Pelican 会按这个时间排序 | 2026-10-10 |
| **Category** | 文章分类，类似“栏目”，一般一篇只属于一个分类 | 疑难杂症 |
| **Tags** | 文章标签，可以多写几个，用来标记关键词、方便检索 | pelican, windows, powershell, 博客搭建 |
| **Slug** | URL 别名，决定这篇文章生成后的网址路径 | pelican-quickstart-blocked-by-app-control |

其中 **Category** 是大类，比如“技术教程”“疑难杂症”；**Tags** 是更细的关键词，比如这篇可以加 `pelican`、`windows`、`powershell`。

**Slug** 比较重要：它会影响最终 URL。比如你的 `Slug` 是 `pelican-quickstart-blocked-by-app-control`，生成后这篇文章的地址大概会是：

```text
https://15802984326.github.io/pelican-quickstart-blocked-by-app-control.html
```
Slug 建议用小写字母、数字和短横线，不要用中文和空格，这样 URL 更稳定、也更友好。

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
http://127.0.0.1:8000
```

如果能看到文章，说明博客已经生成成功。

## 9. 部署到 GitHub Pages（推送到独立仓库）

生成完成后，我们用 `ghp-import` 把 `output` 目录推送到**另一个独立的 GitHub Pages 仓库**。

确保你在 my-blog 项目根目录下执行：

```powershell
ghp-import output -b main -n -m "deploy blog" -p
```

参数说明：

- `output`：要推送的目录
- `-b main`：推送到 main 分支
- `-n`：不显示推送的文件列表
- `-m "deploy blog"`：提交信息
- `-p`：自动推送（push），不需要再手动执行 git push

`ghp-import` 会自动找到你 GitHub Pages 仓库（`15802984326.github.io`）作为目标远程地址并推送。

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

写新文章后，按以下流程操作：

**第一步：生成静态页面**

```powershell
pelican content
```

**第二步：提交源码到源码仓库**

```powershell
git add .
git commit -m "add: new post"
git push origin main
```

**第三步：推送发布文件到 GitHub Pages 仓库**

```powershell
ghp-import output -b main -n -m "deploy blog" -p
```

如果之前选了生成 `tasks.py`，也可以使用：

```powershell
python tasks.py html
python tasks.py serve
```

但 `tasks.py github` 命令依赖于 pelican-quickstart 时配置的上传方式，在分离方案下可能不生效，建议始终用上面的 `ghp-import` 命令。


## 12. 写新文章的方式

以后每次写新文章，只需要：

1. 在 `content` 目录下新增 `.md` 文件
2. 执行 `pelican content` 生成静态页面
3. 用 `ghp-import` 推送到 GitHub Pages 仓库

```powershell
# 编辑文章后
pelican content
git add .
git commit -m "add: new post"
git push origin main
ghp-import output -b main -n -m "deploy blog" -p
```

文章文件名建议用英文，例如：

```text
content/python-notes-01.md
```

这样可以避免部分环境下中文路径带来的问题。

