# 猫咪飞船

一个纯 HTML / CSS / JavaScript 的小游戏：驾驶猫咪飞船躲开陨石，收集小鱼罐头和星屑得分。

## 运行

直接用浏览器打开 `index.html`。

也可以在当前目录启动本地静态服务器：

```powershell
python -m http.server 8765 --bind 127.0.0.1
```

然后访问：

```text
http://127.0.0.1:8765/
```

## 操作

- 新手教程：开始界面点击“新手教程”
- 方向键 / WASD：移动飞船
- 鼠标 / 触屏拖动：移动飞船
- J：冲刺
- K：护盾
- L：猫爪光波
- 空格：暂停
- R：重新开始

## 发布

这是一个静态网站项目，可以发布到 GitHub Pages、Netlify、Vercel 或 Cloudflare Pages。

## 在线排行榜

排行榜使用 Supabase。

1. 新建 Supabase 项目。
2. 打开 SQL Editor，运行 `supabase-schema.sql`。
3. 在 `index.html` 里填入 `SUPABASE_URL` 和 `SUPABASE_ANON_KEY`。
4. 提交并推送到 GitHub Pages。

分数表默认允许匿名读取和提交分数。同一个昵称只保留最高分，适合小游戏朋友间比较。认真公开运营前建议再加防刷逻辑。

当前项目已经连接到 Supabase 项目 `cat-rocket-leaderboard`。
