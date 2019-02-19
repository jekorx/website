# Put请求无法获取参数对象

> SpringBoot中使用RESTful API设计规范，如果Put请求无法将参数转为对象，增加以下配置。

```java
@Configuration
public class WebMvcConfig extends WebMvcConfigurationSupport
    /**
     * 解决put请求无法将参数转为对象
     * @return
     */
    @Bean
    public HttpPutFormContentFilter httpPutFormContentFilter() {
        return new HttpPutFormContentFilter();
    }
}
```



