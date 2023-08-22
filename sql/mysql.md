# MySQL

### 1、根据日期获取周数

```sql
-- 按照周数统计，可能某年的最后一天为第一周，如：2019-12-30周数为第一周
SELECT WEEK (date_add('<yyyy-MM-dd>', INTERVAL 6 DAY), 2);

/* 示例
SELECT WEEK (date_add('2019-12-30', INTERVAL 6 DAY), 2);
*/
```

### 2、自增字段

> 一般用于表的自增id主键  

```sql
-- 方法 1
-- 创建表的时候指定字段为自增
`<字段名>` int(11) NOT NULL AUTO_INCREMENT COMMENT '字段注释'

/* 示例
-- AUTO_INCREMENT=1参数表示从1开始自增
CREATE TABLE `t_goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
*/


-- 方法 2
ALTER TABLE `<数据库名>`.`<表名>` MODIFY COLUMN `<字段>` int(11) NOT NULL AUTO_INCREMENT COMMENT '<字段注释>' FIRST,
AUTO_INCREMENT = <自增开始值>;

/* 示例
ALTER TABLE `testdb`.`t_goods` MODIFY COLUMN `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id' FIRST,
AUTO_INCREMENT = 1;
*/
```