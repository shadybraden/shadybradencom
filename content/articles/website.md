---
date: "2024-12-29T20:02:41-05:00"
draft: false
tags:
- website
- intro
- Cloudflare
- Hugo
title: This Website
---

## How I made this Website

The goal of this is to have a folder of files I can edit, then upload to GitHub, and have a website built whenever there is a commit.

Steps :

- [Install hugo](#install) and initiate a new site
- [Set a theme](#theme)
- [Make a page](#page)
- [Run Hugo locally](#run) for testing and viewing changes
- [Use a git repo](#git) and send it to GitHub for later
- [Run it on Cloudflare pages](#cloudflare) and connect a domain

---

## Install

Install via package manager, ie: `dnf install hugo`

Choose a directory, then `hugo new site ./`

I referenced [this YouTube video](https://youtu.be/hjD9jTi_DQ4) to get me started

---
## Theme

[Download a theme](https://themes.gohugo.io/), and set it in hugo.toml: `theme = 'PaperMod'`

---
## Page

to make a new post, or new content, `hugo new articles/website.md`

this makes the md file in the content/articles folder

In the file website.md, you can add all kinds of markdown that will be rendered as html later.

For example: add an image: `![llama](/img/llama.png "llama")` or `# headings`

so here is what my website.md looks like so far:

```
+++
---
date: "2024-12-29T20:02:41-05:00"
draft: false
tags:
- website
- intro
- Cloudflare
- Hugo
title: This Website
---

## How I made this Website

The goal of this is to have a folder of files I can edit, then upload to GitHub, and have a website built whenever there is a commit.

Steps:

- [Install hugo](#install) and initiate a new site
- [Set a theme](#theme)
- [Make a page](#page)
- [Run Hugo locally](#run) for testing and viewing changes
- [Use a git repo](#git) and send it to GitHub for later
- [Run it on Cloudflare pages](#cloudflare) and connect a domain

---

## Install

Install via package manager, ie: `dnf install hugo`

Choose a directory, then `hugo new site ./`

I referenced [this YouTube video](https://youtu.be/hjD9jTi_DQ4) to get me started

---
## Theme

[Download a theme](https://themes.gohugo.io/), and set it in hugo.toml: `theme = 'PaperMod'`

---
## Page

to make a new post, or new content, `hugo new articles/website.md`

this makes the md file in the content/articles folder

In the file website.md, you can add all kinds of markdown that will be rendered as html later.

For example: add an image: `![llama](/img/llama.png "llama")` or `# headings`

so here is what my website.md looks like so far:
```

---
## Run

Now, the next step is to get this running somewhere.

Run `hugo server` from the directory, and look at it at http://localhost:1313

Now, when you make changes, it will refresh and show here.

---
## Git

Run `git init` to start the git repo, and send it to a public git platform. for me it will be here:
https://github.com/shadybraden/shadybradencom

I also added a `.gitignore` file and added `/public` to it so that the whenever I run `hugo server` locally, Git ignores the changes made in /public

then `git remote add origin https://github.com/shadybraden/shadybradencom.git`
`git branch -M main`
`git push -u origin main`

Or use a visual Git program (like VSCode)

Now, whenever you make a normal commit, it will be on GitHub

---
## Cloudflare

Now all the files are in my Git repo, now To host the site somewhere publicly.

I will be using Cloudflare's own [guide here](https://developers.cloudflare.com/pages/framework-guides/deploy-a-hugo-site/)

Basically, follow the steps from [Deploy with Cloudflare Pages](https://developers.cloudflare.com/pages/framework-guides/deploy-a-hugo-site/#deploy-with-cloudflare-pages) and make a new page with `main` as the branch, `hugo` as the command and directory as `public`. Also make sure to set the env var as `HUGO_VERSION` to the current version you have locally (for me it is `0.126.2` (run `hugo version`))

You should get a success!

I have my domain  (shadybraden.com) setup through cloudflare, so its just a few clicks, then done! see https://shadybraden.com

### **Now, whenever I make a commit to [this git repo](https://github.com/shadybraden/shadybradencom, Cloudflare automatically builds this website and updates it. All for free (minus domain cost)**
