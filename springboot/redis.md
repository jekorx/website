# Redis

### Redis中key值过期通知

> CentOS版本```7.9```，redis版本```5.0.10```  

> 依赖  

```xml
<!-- redis -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

> 配置  
> Redis配置文件中要配置键空间通知，过期事件的监听```notify-keyspace-events Ex```，更多配置[请查看](../linux/redis.md#安装)  

```java
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.stereotype.Component;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Consumer;

/**
 * Redis消息监听器
 */
@Component
public class RedisMessageListener implements MessageListener {
    // 存放订阅回调函数，key可以是添加订阅所在的类名，this.getClass().getName()
    private final Map<String, Consumer<String>> subscribeMap = new HashMap<>();

    /**
     * 添加订阅
     * @param key key可以是添加订阅所在的类名，this.getClass().getName()
     * @param function 存放订阅回调函数
     */
    public void addSubscribe(String key, Consumer<String> function) {
        subscribeMap.put(key, function);
    }

    @Override
    public void onMessage(Message message, byte[] pattern) {
        // 遍历订阅回调函数，有消息通知时，分别执行
        if (null != message) {
            subscribeMap.values().forEach(function -> function.accept(message.toString()));
        }
    }
}
```

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.listener.ChannelTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;

/**
 * Redis 配置
 */
@Configuration
public class RedisConfig {
    @Autowired
    private RedisConnectionFactory redisConnectionFactory;
    @Autowired
    private RedisMessageListener redisMessageListener;
    @Value("${spring.redis.database}")
    private int database;
    // 键事件通知前缀，__keyevent@<db>__:expired
    private final String topicNameTemplate = "__keyevent@%d__:expired";

    /**
     * 创建消息接收容器
     */
    @Bean
    public RedisMessageListenerContainer redisMessageListenerContainer() {
        RedisMessageListenerContainer container = new RedisMessageListenerContainer();
        ChannelTopic topic = new ChannelTopic(String.format(topicNameTemplate, database));
        container.setConnectionFactory(redisConnectionFactory);
        container.addMessageListener(redisMessageListener, topic);
        return container;
    }
}
```

> 使用  

```java
@Service
public class BusinessService {
    @Autowired
    public void registerRedisMessageListener(RedisMessageListener redisMessageListener) {
        // 回调函数的key为过期的key
        redisMessageListener.addSubscribe(this.getClass().getName(), key -> {
            // 根据key进行业务操作，可以直接调用业务service
            // 分布式部署时，会通知所有节点，防止重复操作业务数据，需加锁处理，LockService
        });
    }
}
```