#!/usr/bin/env bash

# 说明：客户端为 windows 或 linux 的方法类似，找到浏览器的启动路径，后面传入相同的参数即可

# url="${your kml site}" # 直接拷贝你 KML 的 Jupyter 地址
if [ ! -n "$1" ]; then
  echo "传入你的 KML 网址"
  exit
else
  url=$1
fi

# for Google Chrome
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --ignore-certificate-errors --ignore-urlfetcher-cert-requests --unsafely-treat-insecure-origin-as-secure=${url} --app=${url} &> /dev/null

# for Google Chrom Canary
# /Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary --ignore-certificate-errors --ignore-urlfetcher-cert-requests --unsafely-treat-insecure-origin-as-secure=${url} --app=${url} &> /dev/null

