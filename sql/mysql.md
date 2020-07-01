# MySQL

* **1、根据日期获取周数**

```sql
-- SELECT WEEK (date_add('<yyyy-MM-dd>', INTERVAL 6 DAY), 2);
-- 按照周数统计，可能某年的最后一天为第一周，如：2019-12-30周数为第一周
SELECT WEEK (date_add('2019-12-30', INTERVAL 6 DAY), 2);
```