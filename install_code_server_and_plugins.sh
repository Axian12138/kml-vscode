#!/usr/bin/env bash

set -e

# 默认设置
INSTALL_CODE_SERVER_FLAG=1
INSRALL_LATEST_VERSION_FLAG=0 # 设置为 1 安装最新版 code-server
INSTALL_PLUGIN_FLAG=1

LINUX_DISTRIBUTED_VERSION=$(. /etc/os-release; echo $ID)

# 只安装最新版 code-server
# INSTALL_CODE_SERVER_FLAG=1
# INSRALL_LATEST_VERSION_FLAG=1
# INSTALL_PLUGIN_FLAG=0

RECOMMENED_VERSION=4.14.1 # 4.14.1 为当前推荐版本

# 缺省安装插件，若传参为 0，则不安装
if [ -n "$1" ]; then
    INSTALL_PLUGIN_FLAG=$1
fi

# 海外代理下载更快
export http_proxy=http://oversea-squid2.ko.txyun:11080 https_proxy=http://oversea-squid2.ko.txyun:11080

install_code_server(){
    VERSION=$1

    echo "开始安装"

    if [ "$LINUX_DISTRIBUTED_VERSION" = "ubuntu" ]; then
        # Ubuntu
        wget -c https://github.com/cdr/code-server/releases/download/v${VERSION}/code-server_${VERSION}_amd64.deb
        dpkg -i code-server_${VERSION}_amd64.deb

        echo "删除软件包"
        rm code-server_${VERSION}_amd64.deb
    fi

    if [ "$LINUX_DISTRIBUTED_VERSION" = "centos" ]; then
        # CentOS
        curl -fsSL https://code-server.dev/install.sh | sh -s --
    fi

    echo "安装完成"
}

install_recommended_plugins() {
    if ! command -v code-server &> /dev/null; then
        echo "系统未安装 code-server，退出"
        exit 1
    fi
    # 安装插件
    echo "开始安装推荐的插件..."
    declare -a arr_plugins=(
        # c++
        # "ms-vscode.cpptools" # for c++，需要通过 vsix 安装！
        # "twxs.cmake" # for c++
        # "ms-vscode.cmake-tools" # for c++
        # "austin.code-gnu-global" # C++ Intellisense，未测试
        # python
        "ms-python.python" # for python，强力推荐，需要通过 vsix 安装！
        "ms-toolsai.jupyter" # for jupyter，强力推荐
        # "tushortz.python-extended-snippets" # coding 增强工具，建议测试下是否适合自己
        # git
        # "donjayamanne.githistory" # git 历史记录
        "eamodio.gitlens" # git 插件，很强大
        "mhutchie.git-graph" # git graph 插件，很赞
        # 主题相关
        "dracula-theme.theme-dracula"
        "zhuangtongfa.material-theme"
        # others
        # "vscode-icons-team.vscode-icons" # beautify 所有文件类型的 icon
        "aaron-bond.better-comments" # 增强注释
        # "coenraads.bracket-pair-colorizer" # 括号匹配带颜色
        "oderwat.indent-rainbow" # 给 indent 加颜色
        # "yzhang.markdown-all-in-one" # markdown preview
        # "shd101wyy.markdown-preview-enhanced" # 小众 markdown 预览插件，跟 github 渲染比较接近
        "johnpapa.vscode-peacock" # 每个 instance 可以自定义颜色，方便区分
        "wayou.vscode-todo-highlight" # highlight todo tag
        # "pnp.polacode" # 代码截图，偶尔用的上
        # "tabnine.tabnine-vscode" # 个人并不是很喜欢
        "kisstkondoros.vscode-gutter-preview" # Image preview
        )

    ## loop plugins
    for plugin in "${arr_plugins[@]}"; do
        echo "--- $plugin ---"
        code-server --install-extension $plugin 
    done
    
    # echo "通过 vsix 方式安装 cpptools-linux 及 ms-python.python"
    # 安装 ms-vscode.cpptools！4.0.1 需要通过如下方式安装！
    # mkdir -p extensions
    # wget https://github.com/microsoft/vscode-cpptools/releases/download/1.7.1/cpptools-linux.vsix -O extensions/cpptools-linux.vsix
    # code-server --install-extension extensions/cpptools-linux.vsix

    # 安装 ms-python.python 4.0.1 不需要通过如下方式安装
    # wget https://github.com/microsoft/vscode-python/releases/download/2021.8.1159798656/ms-python-release.vsix -O extensions/ms-python-release.vsix # for code-server 3.11.1
    # wget https://github.com/microsoft/vscode-python/releases/download/2021.9.1230869389/ms-python-release.vsix -O extensions/ms-python-release.vsix # for 3.12.0
    # code-server --install-extension extensions/ms-python-release.vsix

    # 安装 jupyter NOTE: 4.0.1 不需要通过如下方式安装
    # code-server --install-extension extensions/jupyter-2021.6.999230701_for_code_server_v3.11.vsix

    echo "插件安装完成"
}

# 一行安装最新版 code-server @程默 提供
# curl -fsSL https://code-server.dev/install.sh | sh -s -- --dry-run

if [ "$INSTALL_CODE_SERVER_FLAG" = 1 ]; then
    if [ "$INSRALL_LATEST_VERSION_FLAG" = 1 ]; then
        # 自动获取当前最新版
        LATEST_VERSION=`wget -qO- -t1 -T2 "https://api.github.com/repos/cdr/code-server/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g'`
        LATEST_VERSION="${LATEST_VERSION:1}"
        echo "code-server 当前最新版本为 v${LATEST_VERSION}"

        # 检测 code-server 是否安装以及安装版本
        if command -v code-server &> /dev/null; then
            # 已安装 code-server
            EXISTED_VERSION=`code-server --version | cut -d' ' -f 1`
            if [ "$EXISTED_VERSION" = "$LATEST_VERSION" ]; then
                echo "已安装最新版 vv${LATEST_VERSION}，跳过安装"
                INSTALL_CODE_SERVER_FLAG=0
            # echo "系统已安装旧版 code-server v$EXISTED_VERSION，开始执行更新"
            else
                echo "已安装旧版 v$EXISTED_VERSION，覆盖更新"
                install_code_server $LATEST_VERSION
            fi
        else
            # 未安装 code-server，安装最新版
            install_code_server $LATEST_VERSION
        fi
    else
        # 或者在下面安装指定的版本，有些 code server 版本会有些问题
        install_code_server $RECOMMENED_VERSION
    fi
fi

if [ "$INSTALL_PLUGIN_FLAG" = 1 ]; then
    install_recommended_plugins
else
    echo "跳过插件安装"
fi
