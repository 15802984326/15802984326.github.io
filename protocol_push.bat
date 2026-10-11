@echo off
chcp 65001 >nul

echo   Pelican 博客一键部署
echo.

:: 1. 生成静态页面
pelican content
if errorlevel 1 (
    echo [错误] 生成失败
    pause
    exit /b 1
)
echo.

:: 2. 推送源码到 gm_blog
git add -A
git diff --cached --quiet
if not errorlevel 1 (
    echo 没有需要提交的更改，跳过源码推送
) else (
    git commit -m "deploy blog"
    git push origin main
)
echo.


ghp-import output -b main -n -m "deploy blog" -p -r git@github.com:15802984326/15802984326.github.io.git --force

if errorlevel 1 (
    echo [错误] Pages 推送失败，代理已关闭
    pause
    exit /b 1
)

:: 3. 清理 ghp-import 在本地留下的提交
git reset --hard origin/main

echo.
echo ========================================
echo   部署完成！
echo   https://15802984326.github.io
echo ========================================
pause