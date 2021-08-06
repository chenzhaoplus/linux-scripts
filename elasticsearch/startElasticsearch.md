##### 执行脚本要修改 cluster1,cluster2,cluster3
/ops/inst/installElasticsearch.sh
##### 切到root账号，并执行命令，然后再次启动
chown -R es /ops/app/elasticsearch
##### 不能用root启动，需要用es账户启动。
su - es
##### 如果遇到错误提示：
`Cannot open file logs/gc.log due to Permission denied`
##### 启动命令，后台启动，先进入elasticsearch的bin目录
/ops/app/elasticsearch/bin/elasticsearch -d
#### 查看启动结果
<http://v81:9200/>

<http://v82:9200/>

<http://v83:9200/>

#### es-head启动见
文档：elasticsearch可视化插件es-head安装.n...
链接：http://note.youdao.com/noteshare?id=c274fa4ee2c5e61b844f24e02cef6ddd&sub=4CDA2E21AC2B409E99BF9A919DA0D89B

