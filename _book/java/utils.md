# java工具类

#### 返回值包装工具

> [异常处理参照请点击此处](../spring/exception.md)  

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
	 * @return
	 */
	public static <T> Result<T> success() {
		return new Result<T>(ResultEnums.SUCCESS);
	}
	/**
	 * 请求成功，通用提示
	 * @param resultEnums
	 * @return
	 */
	public static <T> Result<T> success(ResultEnums resultEnums) {
		return new Result<T>(resultEnums);
	}
	/**
	 * 请求成功（如：保存、修改成功，返回结果可为null，提示保存成功、修改成功、删除成功等）
	 * @param Object
	 * @param msg
	 * @return
	 */
	public static <T> Result<T> success(T Object, String msg) {
		return new Result<T>(ResultEnums.SUCCESS.getCode(), msg);
	}
	/**
	 * 请求成功
	 * @param object 返回值 
	 * @return
	 */
	public static <T> Result<T> success(T object) {
		return new Result<T>(ResultEnums.SUCCESS, object);
	}
	/**
	 * 请求失败（Enums.FAILED，请求失败）
	 * @return
	 */
	public static <T> Result<T> error() {
		return new Result<T>(ResultEnums.FAILED);
	}
	/**
	 * 请求失败（Enums中定义的错误）
	 * @param resultEnum 枚举
	 * @return
	 */
	public static <T> Result<T> error(ResultEnums resultEnum) {
		return new Result<T>(resultEnum);
	}
	/**
	 * 请求失败（Enums.FAILED，msg自定义，如：返回一些字段验证错误信息，使用频率低没必要在Enums中定义的）
	 * @param msg 失败信息
	 * @return
	 */
	public static <T> Result<T> error(String msg) {
		return new Result<T>(ResultEnums.FAILED.getCode(), msg);
	}
	/**
	 * 请求失败（code，msg 都是自定义，尽量现在Enums中定义错误（尤其是常用的错误），避免使用此方法）
	 * @param code 错误码
	 * @param msg 错误信息
	 * @return
	 */
	public static <T> Result<T> error(int code, String msg) {
		return new Result<T>(code, msg);
	}
}
```