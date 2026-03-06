#!/bin/zsh

NAME=$1
DATE=$(TZ=Asia/Bangkok date +"%Y-%m-%d %H:%M:%S %z")
DATE_FILE=$(TZ=Asia/Bangkok date +"%Y-%m-%d")

META="---
layout: post
title: ''
date: $DATE
categories: ''
---\n"

echo $META > _posts/$DATE_FILE-$NAME.md;