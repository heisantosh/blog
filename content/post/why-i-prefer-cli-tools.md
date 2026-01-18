---
title: "Why I Prefer CLI Tools"
date: 2026-01-15T14:30:00+05:30
draft: false
description: "On composability, speed, and the Unix philosophy."
tags: ["cli", "unix", "tools"]
---

> AI generated to act as place holder for my blog post!

After years of using various development tools, I've found myself gravitating more and more toward command-line interfaces. Here's why.

## Composability

The Unix philosophy of small tools that do one thing well remains powerful. I can pipe `grep` into `sort` into `uniq` into `wc` and get exactly what I need. Try doing that with a GUI.

```bash
git log --oneline | grep "fix" | wc -l
```

This tells me how many commits contain "fix" in their message. Simple, fast, and I didn't need to click through any menus.

## Speed

CLIs start instantly. There's no waiting for a window to render, no loading splash screens, no checking for updates on startup. Type a command, get a result.

## Scriptability

Anything I do manually on the command line can become a script. This morning's repetitive task becomes this afternoon's automated workflow. GUIs rarely offer this same path from manual to automated.

## Remote Work

SSH into a server and you have your full toolkit. No need for remote desktop, no lag from rendering graphics over the network. Just text, which travels light.

## Memory

Commands are easy to remember and combine. `ls -la`, `cd ..`, `grep -r "pattern" .` - these become muscle memory. GUI workflows are harder to internalize because they depend on visual recognition rather than recall.

## That Said...

I'm not a CLI purist. Some tasks genuinely benefit from visual interfaces - image editing, complex merge conflict resolution, or exploring an unfamiliar codebase. The key is choosing the right tool for the task.

But when I can choose, I usually reach for the terminal first.
