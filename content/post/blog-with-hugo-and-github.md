---
title: "用 Hugo 搭建 Blog 并部署在 GitHub 上"
date: 2019-05-18T16:57:26+08:00
lastmod: 2019-05-18T16:57:26+08:00
draft: false
keywords: []
description: ""
tags: ["Hugo", "GitHub", "Blog", "FarBox"]
categories: ["博客变迁史"]
author: ""

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: true
toc: true
autoCollapseToc: false
postMetaInFooter: false
hiddenFromHomePage: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
reward: false
mathjax: false
mathjaxEnableSingleDollar: false
mathjaxEnableAutoNumber: false

# You unlisted posts you might want not want the header or footer to show
hideHeaderAndFooter: false

# You can enable or disable out-of-date content warning for individual post.
# Comment this out to use the global config.
#enableOutdatedInfoWarning: false

flowchartDiagrams:
  enable: false
  options: ""

sequenceDiagrams: 
  enable: false
  options: ""

---

## 缘由

FarBox 挺好用的，只需要在提供的编辑器中书写，剩下的事情就都不需要操心了。然而它就像 Python 2 一样，已经进入了倒计时。之前购买了 Basic 套餐，到期时间是 2020 年暑假。并没有太强烈的意愿转向 Bitcron，毕竟这只是一个自娱自乐的小角落。既然无人问津，我也不想特别正式地买个服务器再买个域名。此前微软收购了 GitHub 后开放了无限私有仓库的福利，就想着不如再用回 GitHub Pages 吧。

Hexo 还是 Hugo，这个问题我并没有纠结太久，因为看中的几款主题是 Hugo 的，就选择了后者。之后陆续看了几十篇关于用 Hugo 搭建博客的文章，但总有些问题没有想清楚。今天想着干脆直接做吧，遇到了再看怎么办好了。

## 安装

大体的步骤，别的文章和[官方文档](https://gohugo.io/documentation/)已经说得够详细了，我就不再多加解释了。

```sh
brew install hugo
# 挑个风水好的目录，切换到那
hugo new site blog
hugo new post/hello.md
hugo server -D # 草稿也加入预览
```

## 定制

我看中了几款主题，有 [Hermit](https://github.com/Track3/hermit)、[Even](https://github.com/olOwOlo/hugo-theme-even) 等。经过一番比较，Even 暂时排名第一，于是就选择它作为主题了。克隆到 `themes` 目录下后，照着它的指示一点点调整。

### 主题

我先把 `exampleSite` 目录下的 `config.toml` 文件复制到根目录，然后逐项进行修改。由于例子中有详细的注释，这些修改没有什么需要特别说明的。

期间为了更清晰地看到调整前后的对比，我把例子中的 posts 也一并复制到了根目录下的 `content` 目录中。

### 语言

Even 支持多语言，自带了 `i18n` 目录。我应该主要写的是中文，于是在 `config.toml` 中设置 `defaultContentLanguage="zh-cn"`。

随意打开其中的 `yaml` 文件，发现是一些翻译。在本地页面上浏览，没什么问题，但还是想做点调整。本来是直接修改 `themes` 中的文件，后来看到说明，就把文件复制到了根目录进行调整。

### 图标

挑选了早年的一张自拍，使用提供的[网址](https://realfavicongenerator.net/)生成所需的文件，将它们都保存到根目录下的 `static` 目录下。其中需要把 `site.webmanifest` 重命名为 `manifest.json`，并从 `themes/even/static/` 中复制 `safari-pinned-tab.svg` 到根目录的 `static` 中。

### Front Matter

默认的模板只有3个选项：标题、日期、是否为草稿。我将 `themes/even/archetypes/default.md` 直接复制到根目录下的 `archetypes` 中，并设置为默认开启 `toc`。

### 评论

我之前都没有自己设置过评论，FarBox 自带了评论系统。这次我选择的是 Disqus，因为之前在访问别人的博客时留下过一些评论，想着就继续用它好了。

Hugo 的文档上关于添加 Disqus 的部分很简单，只需要填写 `disqusShortname` 就好。我打开[官网](https://disqus.com/) ，根据安装的指南创建了一个站点，并把 ShortName 填入了 `config.toml` 中。

目前本地并没有显示评论系统，不知道推送之后网页上是否会正常显示。

看了看主题仓库的 issue，其中提到说本地不会加载评论框，那么无论是否开启，我在本地都看不到了。看到 front matter 中 `comment` 为关闭，我设置为开启，也不知道是否这样就可以了，先推送试试看。

刷新一下网页，果然可以了，那么就在模板中默认打开评论吧。

## 部署

在根目录下执行 `hugo` 后，会生成 `public` 目录，将其中的内容推送到 `github.io` 这个仓库中，即可正常显示博客内容。许多人的做法是只将这些内容保存到 GitHub，而问题在于，假如换一台电脑，根目录下的所有内容就丢失了。所以，我希望根目录下的内容也能保存到 GitHub。

### 一个 GitHub 仓库

这个做法是以前用 `simiki` 写 `wiki` 的时候学到的。大致的步骤可以分为3步：

1. 将 `public` 中的内容作为 `master` 分支推送到 `github.io` 中
2. 将根目录下的所有内容 作为 `source` 分支推送到 `github.io` 中（可忽略 `public` 中的内容）
3. 利用 [Travis CI](https://travis-ci.org/) 自动部署，每次 `source` 分支更新后，自动更新 `master` 分支

这种做法的方便之处在于“一库两用”，`github.io` 既托管了博客，又保存了源文件。但是，我有点小小的私心，只想展示博客，却不愿让人看到源文件，所以尝试后转向其他的解决方案。

### GitHub + Dropbox

由于我使用 Dropbox 作为私人云盘，所以很自然就想到把源文件保存在其中。试了试，还不错，但好像还有点不如意的地方。

### 两个 GitHub 仓库

除了 `github.io` 外，再创建另外一个仓库来保存这些原始文件。这个做法比较冗余，一开始的时候我直接跳过了，但是现在别的方法试了试都不够满意，那么就只好再回来试试这个。

为了每次写完后不必推送两次，我从其他人的仓库中找到了一个部署脚本，做的事情很简单：生成 `public` 中的内容，然后分别将两处的内容推送到两个仓库中。简单改了改 warning，试了试，也还可以。

三种方案都尝试了一遍，并没有特别满意的，但是相对而言，最后一种方案于我有更少的 cost，于是就选择了它。

### 一些坑

首先是私有仓库的限制。尽管微软允许免费用户创建无限量的私有仓库，但是 GitHub Pages 还是不能从私有仓库中创建。在 [Pricing](https://github.com/pricing) 的 Compare features 中，免费用户的 Pages and wikis 要求是公开仓库。在仓库的 `Settings` 中，GitHub Pages 也赫然写着 `Upgrade to GitHub Pro or make this repository public to enable Pages`。所以，为了博客能用，`github.io` 这个仓库必须是公开的，最多只能设置另外那个仓库为私有。

当我将仓库设置为公开后，等了许久，博客还是显示为404，回到仓库的设置页，也告诉我正在使用 master 分支部署。可是左等右等等不来，于是就搜索了一下，发现也有人遇到过和我一样的问题，而解决方案居然是：挑选一个 Jekyll 主题，哪怕你并不用它来部署博客。看到这个解决方案的时候，我心里真是一片羊驼奔腾而过。随意挑了一个主题，保存后刷新博客网址，瞬间就出来了。好吧，反正以后应该不会再有涉及到它的操作，就当它不存在吧。

## 参考资料

* [用hugo搭建blog](https://vinurs.me/post/blog-with-hugo-and-orgmode/)
* [部署 - simiki](http://simiki.org/zh-docs/deploy.html)
