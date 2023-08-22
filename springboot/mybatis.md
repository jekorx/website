# MyBatis

> SpringBoot中使用[MyBatis](https://mybatis.org/mybatis-3/zh/index.html)（[maven地址](https://mvnrepository.com/artifact/org.mybatis.spring.boot/mybatis-spring-boot-starter)）的一些问题及知识点  

### 1、自增id，并返回新id

> 需要数据库表支持，相关请点击查看  
> [MySQL-自增字段](../sql/mysql.md#2-自增字段)  
> [PostgreSQL-自增字段](../sql/postgresql.md#1-自增字段)  
>  
> 使用tk.mybatis.mapper通用mapper，com.alibaba.druid数据库连接池，相关依赖如下  
> [tk mapper maven地址](https://mvnrepository.com/artifact/tk.mybatis/mapper-spring-boot-starter)  
> [druid maven地址](https://mvnrepository.com/artifact/com.alibaba/druid-spring-boot-starter)

```xml
<!-- 数据库连接池-druid -->
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid-spring-boot-starter</artifactId>
    <version>1.1.20</version>
</dependency>
<!--通用mapper-->
<dependency>
    <groupId>tk.mybatis</groupId>
    <artifactId>mapper-spring-boot-starter</artifactId>
    <version>2.1.5</version>
</dependency>
```

> 1、实体类id字段增加以下注解  

```java
@Id
@KeySql(useGeneratedKeys = true)
@Column(name = "id", insertable = false)
```

> 2、调用dao的```insert```方法或者```insertSelective```方法,  
> 执行之后都会将新的id赋值给实体类id字段，直接通过实体类```getId()```获取id  

> 示例  

```java
/**
 * 实体类
 */
@Entity
@Table(name = "t_goods")
public class Goods {
    @Id
    @KeySql(useGeneratedKeys = true)
    @Column(name = "id", insertable = false)
    private Integer id;
    private String name;
    
    // getter and setter
}

/**
 * Dao
 */
@Mapper
public interface GoodsDao extends BaseDao<Goods> {
}

/**
 * 调用dao的insert方法
 * insert和insertSelective执行之后都会将新的id赋值给实体类id字段
 */
@RunWith(SpringRunner.class)
@SpringBootTest
public class GoodsDaoTest {
    @Autowired
    private GoodsDao goodsDao;

    @Test
    public void test() {
        Goods goods = new Goods();
        goods.setName("this is name");
        int row = goodsDao.insert(goods);
        // int row = goodsDao.insertSelective(goods);
        System.out.println(goods.getId());
    }
}
```

### 相关问题

> 1、使用PageHelper分页时报错  
>  
> ```Cause: java.sql.SQLException: Parameter index out of range (5 > number of parameters, which is 4)```  
>  
> 原因：MyBatis的mapper.xml中存在sql注释，导致PageHelper无法赋值分页条件  
> 解决方法：去掉mapper.xml中存在sql注释即可  