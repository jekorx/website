# PostgreSQL

##### 1、自增字段

> 一般用于表的自增id主键  

```sql
-- 创建序列
-- 序列名：一般命名规则，<表名>_<自增字段>_seq，如：t_goods_id_seq
CREATE SEQUENCE "public"."<序列名>" 
INCREMENT 1
MINVALUE  1
MAXVALUE 99999999999
START 1
CACHE 1;
-- 修改序列所有者
-- 所有者：一般为该database用户
ALTER SEQUENCE "public"."<序列名>" OWNER TO "<所有者>";

/* 示例
CREATE SEQUENCE "public"."t_goods_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 99999999999
START 1
CACHE 1;
ALTER SEQUENCE "public"."t_goods_id_seq" OWNER TO "test";
*/
```

```sql
-- 方法 1
-- 创建表的时候指定字段的默认值
"<字段名>" int8 NOT NULL DEFAULT nextval('<序列名>'::regclass)

/* 示例
CREATE TABLE "public"."t_goods" (
  "id" int8 NOT NULL DEFAULT nextval('t_goods_id_seq'::regclass),
  "name" varchar(20) COLLATE "pg_catalog"."default",
  CONSTRAINT "t_goods_pkey" PRIMARY KEY ("id")
);
ALTER TABLE "public"."t_goods" OWNER TO "test";
COMMENT ON COLUMN "public"."t_goods"."id" IS 'id';
*/


-- 方法 2
ALTER TABLE "public"."<表名>" ALTER COLUMN "<字段名>" SET DEFAULT nextval('<序列名>'::regclass);

/* 示例
ALTER TABLE "public"."t_goods" ALTER COLUMN "id" SET DEFAULT nextval('t_goods_id_seq'::regclass);
*/
```