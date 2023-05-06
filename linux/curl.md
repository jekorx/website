# curl 命令相关

> Curl是一个命令行工具，用于传输使用URL语法指定的数据。  
> 以Centos 7.4 为例  

#### 参数

|  参数  |  简写  |  备注  |
|-------|--------|-------|
| --request | -X | 指定请求的方式 &#91;GET&#124;POST&#124;PUT&#124;DELETE&#124;…&#93; |
| --header | -H | 指定请求header |
| --include | -i | 显示返回的header |
| --data | -d | 指定参数  |
| --verbose | -v | 输出更详细信息 |
| --user | -u | 授权帐号和密码 |
| --cookie | -b | cookie  |

#### 示例

> GET/POST/PUT/DELETE  

```bash
curl -X GET "http://www.rest.com/api/users"
curl -X POST "http://www.rest.com/api/users"
curl -X PUT "http://www.rest.com/api/users"
curl -X DELETE "http://www.rest.com/api/users"
```

> HEADER  

```bash
curl -v -i -H "Content-Type: application/json" "http://www.example.com/users"
```

> 参数  

```bash
# 使用 `&` 串接多個參數
curl -X POST -d "param1=value1&param2=value2"
# 也可使用多個 `-d`，效果同上
curl -X POST -d "param1=value1" -d "param2=value2"
```

> JSON 格式参数  

```bash
# 如果需要同时传送 request parameter 和 json，request parameter 可以加在 url 后面，json 参数放入 -d 的参数，header 要加入 "Content-Type:application/json"

curl http://www.example.com?modifier=kent -X PUT -i -H "Content-Type:application/json" -H "Accept:application/json" -d '{"boolean" : false, "foo" : "bar"}'
# 不加"Accept:application/json"也可以
curl http://www.example.com?modifier=kent -X PUT -i -H "Content-Type:application/json" -d '{"boolean" : false, "foo" : "bar"}'
```

> 登录认证（session / cookie）  

```bash
# session
curl -X GET 'http://www.rest.com/api/users' -H 'sessionid:1234567890987654321'

# cookie
# 将 cookie 存档
curl -i -X POST -d username=kent -d password=kent123 -c ~/cookie.txt "http://www.rest.com/auth"
# 将 cookie 设置到 request 中 
curl -i -X "Accept:application/json" -X GET -b ~/cookie.txt "http://www.rest.com/users/1"
```
