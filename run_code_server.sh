#!/usr/bin/env bash

# 首先 kill 掉默认开放的端口（如 8888，有的 kml 不是 8888，请注意）对应的进程，默认为 Jupyter
PORT=8888 # 若默认开启端口非 8888，请替换下
PID=$(lsof -t -i:$PORT)
if [ -z "$PID" ]; then
    echo "$PORT 端口无进程"
else
    echo "Kill 进程 ID：$PID"
    kill -9 $PID
fi

# 如果 reconnect 比较频繁可以开代理，或者试试其它代理
# export http_proxy=http://oversea-squid4.sgp.txyun:11080 https_proxy=http://oversea-squid4.sgp.txyun:11080 

export PASSWORD='184058'

# 可以放在 tmux 后台运行，方便看日志
code-server --port $PORT --auth password --bind-addr 0.0.0.0

# 或者
# nohup code-server --port 8888 --auth password --bind-addr 0.0.0.0 &
