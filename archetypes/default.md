---
date: "{{ .Date }}"
draft: false
tags:
- tag
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
---