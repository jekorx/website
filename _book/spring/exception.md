# 自定义异常处理

#### 基于Aspectj的自定义注解异常处理

> 定义业务异常类  

```java
/**
 * BusinessException.java
 * 自定义业务异常
 * 继承RuntimeException，而不是Exception，否则导致spring事务无法回滚
 */
public class BusinessException extends RuntimeException {
	private static final long serialVersionUID = 1L;
	// 自定义错误码
	private int code;
	private String msg;

	public BusinessException(ResultEnums resultEnum) {
		super(resultEnum.getMsg());
		this.code = resultEnum.getCode();
	}

	public BusinessException(int code, String msg) {
		super(msg);
		this.code = code;
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
}
```

```java
/**
 * ResultEnums.java
 * 自定义异常枚举：返回码-->返回信息
 */
public enum ResultEnums {
	// 常用信息
	ERROR(-1, "请求错误"),
	FAILED(0, "请求失败"),
	SUCCESS(1, "请求成功")

	;
	// 状态码
	private int code;
	// 返回信息
	private String msg;

	ResultEnums(int code, String msg) {
		this.code = code;
		this.msg = msg;
	}

	public int getCode() {
		return code;
	}
	public String getMsg() {
		return msg;
	}
}
```

> 自定义 Service 异常注解及处理  

```java
/**
 * ServiceExceptionHandler.java
 * 自定义Service异常注解
 */
@Target({ ElementType.METHOD })
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface ServiceExceptionHandler {
}
```

```java
/**
 * ServiceExceptionAspect.java
 * 自定义Service异常处理AOP
 */
@Component
@Aspect
public class ServiceExceptionAspect {

    private static final Logger log = LoggerFactory.getLogger(ServiceExceptionAspect.class);

    public ServiceExceptionAspect() {}

    /**
     * 异常通知, 在方法抛出异常之后
     * pointcut：切入点是带有@ServiceExceptionHandler注解的方法
     * @annotation()中填写@ServiceExceptionHandler注解位置
     * @param joinPoint
     * @param throwable
     * @throws BusinessException
     */
    @AfterThrowing(
        pointcut = "@annotation(com.admin.api.config.ServiceExceptionHandler)",
        throwing = "throwable"
    )
    public void afterRuntimeException(JoinPoint joinPoint, Throwable throwable) throws BusinessException {
        // 如果是业务异常，直接抛出
        if (throwable instanceof BusinessException) {
            throw (BusinessException) throwable;
        } else if (throwable instanceof RuntimeException) {
            // 如果是运行时异常，记录异常之后，包装成业务异常在抛出
            log.error("service: {}", throwable.getMessage(), throwable);
            throw new BusinessException(ResultEnums.ERROR);
        }
    }
}
```

> 自定义 Controller 异常注解及处理  

```java
/**
 * ControllerExceptionHandler.java
 * 自定义Controller异常注解
 */
@Target({ ElementType.METHOD })
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface ControllerExceptionHandler {
}
```

```java
/**
 * 自定义Controller异常处理AOP
 * @Author wang_dgang
 * @Date 2019/6/5 0005 9:48
 */
@Component
@Aspect
public class ControllerExceptionAspect {

    private static final Logger log = LoggerFactory.getLogger(ControllerExceptionAspect.class);

    /**
     * 环绕通知, 围绕着方法执行
     * 切入点是带有@ControllerExceptionHandler注解的方法
     * @annotation()中填写@ControllerExceptionHandler注解位置
     * @param joinPoint
     * @return
     */
    @Around("@annotation(com.admin.api.config.ControllerExceptionHandler)")
    public Object controllerMethodHandler(ProceedingJoinPoint joinPoint) {
        try {
            return joinPoint.proceed();
        } catch (Throwable throwable) {
            // 如果是业务异常，直接抛出
            if (throwable instanceof BusinessException) {
                throw (BusinessException) throwable;
            } else {
                // 非业务异常，记录异常之后，包装成业务异常在抛出
                log.error("Controller: {}", throwable.getMessage(), throwable);
                throw new BusinessException(ResultEnums.ERROR);
            }
        }
    }
}
```

> 异常处理，返回json格式的异常包装信息，而非错误页面，[返回值包装类参照请点击此处](../java/utils.md)  

```java
/**
 * ExceptionHandler.java
 * 全局异常处理
 */
@ControllerAdvice
public class ExceptionHandler {

	private final static Logger log = LoggerFactory.getLogger(ExceptionHandler.class);
	
	/**
	 * 异常处理，返回json格式的异常包装信息，而非错误页面
	 * @param e
	 * @return
	 */
	@org.springframework.web.bind.annotation.ExceptionHandler(value = Exception.class)
	@ResponseBody
	public <T> Result<T> handler(Exception e) {
		if (e instanceof BusinessException) {
			// 业务异常，响应相应错误
			BusinessException be = (BusinessException) e;
			return ResultUtil.error(be.getCode(), be.getMessage());
		} else {
			log.error(" -- 系统异常 --> {}", e);
			// 系统异常，相应相应错误
			return ResultUtil.error(ResultEnums.ERROR.getCode(), ResultEnums.ERROR.getMsg());
		}
	}
}
```