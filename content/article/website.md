+++
title = 'Website'
date = 2024-12-29T20:02:41-05:00
draft = false
tags = [ "website","intro" ]
+++

# How i made this website

---

## Install process:

`dnf install hugo`
go to directory, then `hugo new site ./`

i referenced https://youtu.be/hjD9jTi_DQ4 to get me started

download a theme, and set it in hugo.toml

to make a new post, or new content, `hugo new article/website.md`
this makes the md file in the content/posts folder

add an image: `![llama](/img/llama.png "llama")`

---

so here is what my website.md looks like so far:

```
+++
title = 'Website'
date = 2024-12-29T20:02:41-05:00
draft = false
tags = [ "website","intro" ]
+++

# how i made this website



`dnf install hugo`
go to directory, then `hugo new site ./`

i referenced https://youtu.be/hjD9jTi_DQ4 to get me started

download a theme, and set it in hugo.toml

to make a new post, or new content, `hugo new article/website.md`
this makes the md file in the content/posts folder

add an image: `![llama](/img/llama.png "llama")`

---

so here is what my website.md looks like so far:
```

---

tada

now, the next step is to get this running somewhere.
currently, i am just using `hugo server` and looking at it at localhost:1313

the goal is to have it so i can make changes to this site locally, test it, then do a git commit to a public git repo, and have the site built from that.

so, i need this data stored somewhere, and i need something to run the site.

the whole website info is stored in /public (in the hugo folder, run `hugo` and then it will update /public) so only this has to go to the hosting place. i will be uploading my whole hugo folder to git however.

now run  `git init` to start the git repo, and send it to a public git platform. for me it will be here:
https://github.com/shadyxN8ANacSoBCJzZpjG7LyXNgNfMAbLoME/site

then `git remote add origin https://github.com/shadybraden/site.git`
`git branch -M main`
`git push -u origin main`

## how to host it on netlify

so now the basics of the site exist, now i want to host it publicly. however, for security reasons, i dont want to host it internally, on my own servers.
so netlify. per the youtube video at the top, its super easy, so lets go!

- give netlify access to the git repo
- tell it the branch
- build command is `hugo`
- publish directory is `public`
- add `Environment variables` as `HUGO_VERSION` = `0.126.2`

deploy!