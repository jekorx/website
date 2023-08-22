# java工具类

### JWT常用工具

> 依赖```io.jsonwebtoken.jjwt```  

```xml
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt</artifactId>
    <version>0.9.1</version>
</dependency>
```

```java
/**
 * Jwt工具类
 */
public class JwtUtil {
    // 日志
    private static final Logger log = LoggerFactory.getLogger(JwtUtil.class);
    // JWT 加解密类型
    private static final SignatureAlgorithm JWT_ALG = SignatureAlgorithm.HS256;
    // JWT 秘钥，勿暴露于前端
    private static final String JWT_SECRET = "Y29tQHNoYW5kb25nI2hvbmdlbg";

    /**
     * 加密
     * @param subjectJson JSON
     * @param expire 超时时间，单位秒
     * @return
     */
    public static String buildJWT(String subjectJson, int expire) {
        // 生成JWT的时间
        Date startDate = DateUtil.date();
        // 过期时间
        Date endDate = DateUtil.offset(startDate, DateField.SECOND, expire);
        // 为payload添加各种标准声明和私有声明
        JwtBuilder builder = Jwts.builder() // new一个JwtBuilder，设置jwt的body
                .setId(IdUtil.simpleUUID()) // JWT的唯一标识，回避重放攻击
                .setIssuedAt(startDate)     // 签发时间
                .setExpiration(endDate)     // 过期时间
                .setSubject(subjectJson)    // json格式的字符串
                .compressWith(CompressionCodecs.DEFLATE)
                .signWith(JWT_ALG, generalKey()); // 设置签名算法和密钥
        return builder.compact();
    }

    // 测试方法
    public static void main(String[] args) {
        String buildJWT = buildJWT("aaaaa", 2);
        System.out.println(buildJWT);
        System.out.println(parseJWT(buildJWT));
    }

    /**
     * Jwt解析
     * @param jwt 内容文本
     * @return
     */
    public static String parseJWT(String jwt) {
        Jws<Claims> claimsJws = getClaimsJws(jwt);
        Claims body = claimsJws.getBody();
        // 获取加密的内容JSON并返回
        String subjectJson = body.getSubject();
        return subjectJson;
    }

    /**
     * Jwt验证（true：验证通过，false：验证失败）
     * @param jwt 内容文本
     * @return
     */
    public static boolean checkJWT(String jwt) {
        return ObjectUtil.isNotNull(getClaimsJws(jwt));
    }

    /**
     * parseClaimsJws
     * @param jwt 内容文本
     * @return
     */
    private static Jws<Claims> getClaimsJws(String jwt) {
        Jws<Claims> parseClaimsJws = null;
        try {
            SecretKey generalKey = generalKey();
            JwtParser parser = Jwts.parser().setSigningKey(generalKey);
            parseClaimsJws = parser.parseClaimsJws(jwt);
        } catch (Exception e) {
            log.warn("JWT验证失败，原因：{}", e.getMessage());
        }
        return parseClaimsJws;
    }

    /**
     * 生成加密key，单例模式
     * @return
     */
    private static SecretKey generalKey() {
        return JwtSecretKeyHolder.instance;
    }
    private static class JwtSecretKeyHolder {
        // 服务端保存的jwt 秘钥
        static final String str = JWT_SECRET;
        static final byte[] encodedKey = str.getBytes();
        private static final SecretKey instance = new SecretKeySpec(encodedKey, JWT_ALG.getJcaName());
    }
}
```

### 返回值包装工具

> 异常处理[可参照](../spring/exception.md)  

```java
/**
 * Result.java
 * 返回值包装类
 * @param <T>
 */
public class Result<T> {
    // 状态码
    private int code;
    // 状态信息
    private String msg;
    // 返回值
    private T data;
    
    // 默认无参构造
    public Result() {
    }
    /**
     * 构造函数
     * @param resultEnum 枚举
     */
    public Result(ResultEnums resultEnum) {
        this.code = resultEnum.getCode();
        this.msg = resultEnum.getMsg();
    }
    /**
     * 构造函数
     * @param code 状态码
     * @param msg 状态信息
     */
    public Result(int code, String msg) {
        this.code = code;
        this.msg = msg;
    }
    /**
     * 构造函数
     * @param resultEnum 枚举 
     * @param data 返回值
     */
    public Result(ResultEnums resultEnum, T data) {
        this.code = resultEnum.getCode();
        this.msg = resultEnum.getMsg();
        this.data = data;
    }
    /**
     * 构造函数
     * @param code 状态码
     * @param msg 状态信息
     * @param data 返回值
     */
    public Result(int code, String msg, T data) {
        this.code = code;
        this.msg = msg;
        this.data = data;
    }
    
    public int getCode() {
        return code;
    }
    public void setCode(int code) {
        this.code = code;
    }
    public String getMsg() {
        return msg;
    }
    public void setMsg(String msg) {
        this.msg = msg;
    }
    public T getData() {
        return data;
    }
    public void setData(T data) {
        this.data = data;
    }
}
```

```java
/**
 * ResultUtil.java
 * 返回值包装工具类
 */
public class ResultUtil {
	/**
	 * 请求成功，无返回结果的
	 * @param <T>
	 * @return
	 */
	public static <T> Result<T> success() {
		return new Result<>(ResultEnums.SUCCESS);
	}
	/**
	 * 请求成功，通用提示
	 * @param resultEnums
	 * @param <T>
	 * @return
	 */
	public static <T> Result<T> success(ResultEnums resultEnums) {
		return new Result<>(resultEnums);
	}
	/**
	 * 请求成功
	 * @param object 返回值
	 * @param <T>
	 * @return
	 */
	public static <T> Result<T> success(T object) {
		return new Result<>(ResultEnums.SUCCESS, object);
	}
	/**
	 * 请求成功（如：保存、修改成功，返回结果可为null，提示保存成功、修改成功、删除成功等）
	 * @param msg
	 * @param object 返回值
	 * @param <T>
	 * @return
	 */
	public static <T> Result<T> success(String msg, T object) {
		return new Result<>(ResultEnums.SUCCESS.getCode(), msg, object);
	}
	/**
	 * 请求成功
	 * @param resultEnums
	 * @param object 返回值
	 * @param <T>
	 * @return
	 */
	public static <T> Result<T> success(ResultEnums resultEnums, T object) {
		return new Result<>(resultEnums, object);
	}
	/**
	 * 请求失败（Enums.FAILED，请求失败）
	 * @param <T>
	 * @return
	 */
	public static <T> Result<T> error() {
		return new Result<>(ResultEnums.FAILED);
	}
	/**
	 * 请求失败（Enums中定义的错误）
	 * @param resultEnum
	 * @param <T>
	 * @return
	 */
	public static <T> Result<T> error(ResultEnums resultEnum) {
		return new Result<>(resultEnum);
	}
	/**
	 * 请求失败（Enums.FAILED，msg自定义，如：返回一些字段验证错误信息，使用频率低没必要在Enums中定义的）
	 * @param msg
	 * @param <T>
	 * @return
	 */
	public static <T> Result<T> error(String msg) {
		return new Result<>(ResultEnums.FAILED.getCode(), msg);
	}
	/**
	 * 请求失败（code，msg 都是自定义，尽量现在Enums中定义错误（尤其是常用的错误），避免使用此方法）
	 * @param code
	 * @param msg
	 * @param <T>
	 * @return
	 */
	public static <T> Result<T> error(int code, String msg) {
		return new Result<>(code, msg);
	}
}
```

### MultipartFile转File

> 转换后File文件存放于系统临时目录，使用完需删除该临时文件  

```java
/**
 * MultipartFile 转 File，并存放到系统临时目录中
 * @param file 文件
 * @return File
 * @throws IOException
 */
public static File multipartFile2File(MultipartFile file) throws IOException {
    return multipartFile2File(file, null, null);
}

/**
 * MultipartFile 转 File，并存放到系统临时目录中
 * @param file 文件
 * @param path 路径（不带 /）
 * @param name 文件名
 * @return File
 * @throws IOException
 */
public static File multipartFile2File(MultipartFile file, String path, String name) throws IOException {
    // 获取系统临时目录
    String tmpPath = System.getProperty("java.io.tmpdir");
    // 处理路径为空的情况
    if (StrUtil.isEmpty(path)) {
        path = "";
    } else {
        path += "/";
    }
    if (StrUtil.isEmpty(name)) {
        // 文件名为空，设置默认，文件名前增加4位随机字符串，防止重复
        name = RandomUtil.randomString(4) + file.getOriginalFilename();
    }
    File dir = new File(StrUtil.format("{}/{}", tmpPath, path));
    // 目录不存在，创建目录
    if (!dir.exists()) {
        dir.mkdirs();
    }
    // 将转换后的新文件暂存到临时目录，文件使用完后需删除
    File newFile = new File(StrUtil.format("{}/{}{}", tmpPath, path, name));
    BufferedInputStream bis = null;
    BufferedOutputStream bos = null;
    InputStream is = null;
    FileOutputStream fos = null;
    try {
        is = file.getInputStream();
        bis = new BufferedInputStream(is);
        fos = new FileOutputStream(newFile);
        bos = new BufferedOutputStream(fos);
        int bytesRead;
        byte[] buffer = new byte[8192];
        while ((bytesRead = bis.read(buffer, 0, 8192)) >= 0) {
            bos.write(buffer, 0, bytesRead);
        }
        bos.flush();
    } catch (IOException e) {
        if (bos != null) {
            bos.close();
            bos = null;
        }
        if (bis != null) {
            bis.close();
            bis = null;
        }
        if (fos != null) {
            fos.close();
            fos = null;
        }
        if (is != null) {
            is.close();
            is = null;
        }
        // 如果出现异常，删除该文件，需先关闭流
        newFile.delete();
        throw e;
    } finally {
        if (bos != null) bos.close();
        if (bis != null) bis.close();
        if (fos != null) fos.close();
        if (is != null) is.close();
    }
    return newFile;
}
```

### 切片文件合并

> 涉及工具类```cn.hutool.hutool-all```  
> 自定义业务异常[可参照](../spring/exception.md)  

```java
/**
 * 系统临时目录中，合并文件
 * @param path 文件在系统临时目录中的路径，md5
 * @param chunks 切片数量
 * @param suffix 文件后缀
 * @param md5 文件md5
 * @return File
 * @throws IOException
 * @throws BusinessException
 */
public static File fileMerge(String path, int chunks, String suffix, String md5) throws IOException, BusinessException {
    // 获取系统临时目录
    String tmpPath = System.getProperty("java.io.tmpdir");
    File dir = new File(StrUtil.format("{}/{}", tmpPath, path));
    // 如果不存在或者不为文件夹，直接返回null
    if (!dir.exists() || !dir.isDirectory()) {
        throw new BusinessException(ResultEnums.FAILED.getCode(), "切片文件不存在，请重新上传");
    }
    File[] files = dir.listFiles();
    if (files == null || files.length < chunks) {
        throw new BusinessException(ResultEnums.FAILED.getCode(), "切片文件缺失，请重新上传");
    }
    FileOutputStream fos = null;
    BufferedOutputStream bos = null;
    // 合并后新文件
    File newFile = new File(StrUtil.format("{}/{}{}", tmpPath, path, suffix));
    try {
        fos = new FileOutputStream(newFile);
        bos = new BufferedOutputStream(fos);
        File f;
        FileInputStream fis;
        BufferedInputStream bis;
        byte[] buffer;
        int bytesRead;
        // 循环将切片文件数据写入新文件
        for (int i = 0; i < chunks; i++) {
            f = new File(StrUtil.format("{}/{}/{}", tmpPath, path, i));
            if (f.isFile() && f.exists()) {
                fis = new FileInputStream(f);
                bis = new BufferedInputStream(fis);
                buffer = new byte[1024];
                while ((bytesRead = bis.read(buffer, 0, 1024)) >= 0) {
                    bos.write(buffer, 0, bytesRead);
                }
                bis.close();
                fis.close();
                f.delete();
            }
        }
        bos.flush();
    } finally {
        if (bos != null) bos.close();
        if (fos != null) fos.close();
    }
    // 文件处理完后删除目录
    dir.delete();
    // 校验文件MD5是否与上传前一致
    if (StrUtil.isNotEmpty(md5)) {
        String newFileMd5 = SecureUtil.md5(newFile);
        if (!md5.equals(newFileMd5)) {
            // 删除该文件
            newFile.delete();
            // 文件校验失败提示
            throw new BusinessException(ResultEnums.FAILED.getCode(), "文件合并失败，请重新上传");
        }
    }
    // 返回合并后的新文件
    return newFile;
}
```