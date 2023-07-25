rem 这里设置设置你的 kml 链接，下面只是个示范
set url="http://kml-dtmachine-XXXX-prod.kmlclusteronlinetrain.corp.kuaishou.com"

rem 以 chrome beta 浏览器为例，下载链接：https://www.google.com/intl/zh-CN/chrome/dev/，安装路径可能会有差异
"C:/Program Files/Google/Chrome Dev/Application/chrome.exe" --ignore-certificate-errors --ignore-urlfetcher-cert-requests --unsafely-treat-insecure-origin-as-secure="%url%" --app="%url%"