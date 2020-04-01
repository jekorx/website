# FastJson处理响应数据

> SpringBoot中使用FastJson将响应的数据转成json相关配置  
> springframework 版本 5.2 及之后，直接使用使用```MediaType.APPLICATION_JSON```即可，无需专门指定```charset=UTF-8```。  

```java
@Configuration
public class WebMvcConfig extends WebMvcConfigurationSupport {
    /**
     * FastJson对响应数据处理的相关配置
     */
    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        FastJsonHttpMessageConverter fastConverter = new FastJsonHttpMessageConverter();
				FastJsonConfig fastJsonConfig = new FastJsonConfig();
				// 序列化
				fastJsonConfig.setSerializerFeatures(
						SerializerFeature.WriteMapNullValue,
						SerializerFeature.WriteNullStringAsEmpty,
						SerializerFeature.WriteNullNumberAsZero,
						SerializerFeature.WriteNullListAsEmpty
				);
				// 时间戳格式
				fastJsonConfig.setDateFormat("yyyy-MM-dd HH:mm:ss");
				// 处理中文乱码问题
				List<MediaType> fastMediaTypes = new ArrayList<MediaType>();
				// fastMediaTypes.add(MediaType.APPLICATION_JSON_UTF8); // springframework 5.2后无需指定charset=UTF-8，直接使用MediaType.APPLICATION_JSON即可
				fastMediaTypes.add(MediaType.APPLICATION_JSON);
				fastConverter.setSupportedMediaTypes(fastMediaTypes);
        // 设置
        fastConverter.setFastJsonConfig(fastJsonConfig);
				converters.add(fastConverter);
    }
}
```



