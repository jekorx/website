# Put请求无法获取参数对象

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



