# 命令
* 参数1：切换网络的场景，1切换到Company；2切换到HUQUAN；3切换到LIUJIAOTING；4切换到NANHU
* 参数2：切换网络的ip尾号

例如： switchIp 1 81
在脚本的 initProperties 方法中修改想要切换的网络配置，参数1表示切换的场景，参数2表示虚拟机的ip尾号。
最终虚拟机的ip会是这样： ${hostPrefix}.81
