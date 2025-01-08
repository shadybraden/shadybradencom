---
date: 2025-01-07T20:02:41-05:00
draft: true
tags:
  - api
  - bot
  - telegram
  - mastodon
  - fediverse
title: Telegram to Mastodon Bot
---
## The Goal:
To make a python script that checks a Telegram channel and whenever it makes a post, it takes that content and puts it on Mastoton.

Take: `https://t.me/S2undergroundWire` and put it on `https://mastodon.social/@S2Undergroundbot`

## The Accounts:

### Mastodon:
Go to development and add a new application and give it access to write.
Now you should have a `Client key`, a `Client secret` and an `access token`

### Telegram
Use Bot Father, and guides online to get your Telegram `api token` 

## Scripting:

`pip install python-telegram-bot Mastodon.py`
Then, make a python file, say `mybot.py`
Then add the following to it: (replacing the tokens and channel ID)

```python
from
```