<style>
    a {text-decoration: none;}
    h1 {border-bottom: none; margin-top: auto;}
</style>
# <center>JAVA WEB</center>

---
---
---
## <center>JSP</center>

### 脚本

```jsp
1.
    <%
    	定义局部变量, 及常规Java代码
    %>
2.
    <%!
    	定义方法, 以及全局变量    
    %>
3.
	<%= 输出表达式 %>
```

------

### 指令

> #### page指令

```jsp
<%@ page attribute = "value" ··· %>
<jsp:directive.page attribute = "value" ··· />
<!--常用attribute
    language: jsp页面使用的脚本语言
    pageEcoding: jsp文件的自身编码
    contentType: 浏览器解析jsp的编码
    import: 导入的类(支持通配符*, 多个类之间通过逗号间隔)
    errorPage: 当前页面运行时出现错误时，指定一个错误提示页面
    isErrorPage: 表示当前的JSP是否可以作为错误页面, 默认false
-->
例: <%@ page language="Java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="Java.util.*" %>
```

> #### include指令

```jsp
<%@ include file = "···" %>
<jsp:directive.include file = "···" />
```

```jsp
<jsp:include page="···" flush="false(默认)/true">
    <!-- 传参 -->
    <jsp: param name="···" value="···"/>
    ···
<jsp:include>
```

```java
/*区别:
1. 两者均不支持url传参
2. 前者是将源文件内容引入当前页面，与当前页面一起编译; 后者是将源文件编译后在引入当前页面
3. 前者被引入文件与当前页面共享信息; 后者被引入文件与当前页面不能共享信息，因此需要单独进行参数传输
4. 前者不支持请求由Servlet转发的页面; 后者支持由Servlet转发的页面, 但要求Servlet转发页面的形式为以下格式: 
	getRequestDispatcher(String location).include(request,response)
*/
```

------

### 内置对象

``` jsp
1. response:响应对象;
    <% response对象的常见方法(response.): 
        addCookie(Cookie): 服务端向客户端增加Cookie对象;
        sendRedirect(String location ): "重定向"的方式跳转页面(url含有中文需要转码);
        setContentType(MIME): 设置服务端响应内容类型,同时可以包括字符编码说明;
        setCharacterEncoding(String type): 设置服务端响应的编码;
    %>

2. request: 请求对象, 存储客户端向服务端发送的请求信息;
    <% request对象的常见方法(request.): 
        getParameter(String name): 获取请求传递的参数; 根据请求的字段名key(input的name属性值), 返回value值(input的value属性值)
        /*有些符号在URL中是不能直接传递的,需装换成16进制ASCII编码进行传递,如: 
        "+"——>"%2B";"空格"——>"%20";"/"——>"%2F";"\"——>"%5C";"?"——>"%3F";"%"——>"%25";"#"——>"%23";"&"——>"%26";"="——>"%3D";
        */
        getParameterValues(String name): 根据请求的字段名key, 返回多个字段值value(checkbox)
        getCookies(): 获取cookie(一次性获取全部的cookie, 返回一个数组); 
        setCharacterEncoding(编码格式): 设置post方式的请求编码, get方式的编码设置需要修改server.xml文件; 
        /*
        tomcat 9之前的版本默认使用ISO-8859-1编码, get传参含中文需将server.xml文件的<Connector>标签中加入: URIEncoding="UTF-8"; 而tomcat 9开始默认使用UTF-8编码, 不需要设置！！！
        */
        getRequestDispatcher(String location).forward(request,response): "请求转发"的方式跳转页面(仅限同一个项目工程内跳转); 
        getServerContext(): 获取项目的ServletContext对象(application对象); 
    %>

3. session: 会话(开始—>结束)用于保存用户的信息, 跟踪用户的操作状态;
    客户端第一次请求服务端时, 服务端会产生一个session对象(用于保存该客户的信息); 并且每个session对象都会有一个唯一的sessionId(用于区分其他session);服务端由会产生一个cookie, 并且 该cookie的name=JSESSIONID, value=服务端sessionId的值; 然后服务端会在响应客户端的同时将该cookie发送给客户端,因此, 客户端的cookie就可以和服务端的session一一对应(JSESSIONID - sessionID); 
    客户端再次请求服务端时, 服务端会先用客户端cookie中的JSESSIONID去服务端的session中匹配sessionid, 如果匹配成功(cookie  JSESSIONID和session sessionid, 说明此用户不是第一次访问, 无需登录
    <% session对象的常见方法(session.): 
        getId(): 获取sessionId; 
        isNew(): 判断是否是新用户(第一次访问); 
        invalidate(): 使session失效(退出登录、注销); 
        setMaxInactiveInterval(): 设置最大有效"非活动"时间; 
        getMaxInactiveInterval(): 获取最大有效"非活动"时间; 
    %>

4. application: 全局对象;
    <% application对象的常见方法(application.):
        getContextPath(): 获取当前工程的虚拟路径也叫项目的根目录, 即("/" + "当前工程项目名"); 
        getRealPath(String path): 获取目标的绝对路径, 即("当前工程项目的绝对路径" + "/" + path); 
    %>

5. pageContext: JSP页面容器, 可通过它获取其他内置对象; 

6. config: 配置对象(服务器配置信息); 

7. out: 输出对象, 用于在Web浏览器内输出信息, 实质是一种输出流, 在Java中使用, 最后最好关闭即(out.close()); 

8. page: 当前JSP页面对象(相当于Java中的this); 

9. exception: 异常对象(只有在包含 isErrorPage="true" 的页面中才可以被使用); 
```

------

### 四种范围对象(小  —> 大)

```jsp
<!--
pageContext: 当前页面有效(页面跳转后无效);
request: 同一次请求有效(请求转发后有效; 重定向后无效);
session: 同一次会话有效(无论怎么跳转, 都有效; 关闭/切换浏览器后无效; 从 登陆->退出之间全部有效);
application: 全局有效(整个项目有效, 切换浏览器仍然有效; 关闭服务、其他项目无效);
-->

<% 以上4个对象共有的方法:
    void setAttribute(String name, Object obj):封装数据(新增或修改)
    Object getAttribute(String name):根据属性名获取属数据
    void removeAttribute(String name):根据属性名删除数据
%>

<% pageContext可通过如下两种方式向其他三种对象存储、获取以及删除数据: 
    void setAttribute(String name, Object obj, inet scope)
    Object getAttribute(String name, inet scope)
    void removeAttribute(String name, inet scope)
    /*
    其中参数其中scope可以是如下4个值:
        PageContext.PAGE_SCOPE: 对应于page范围。
        PageContext.REQUEST_SCOPE: 对应于request范围。
        PageContext.SESSION_SCOPE: 对应于session范围。
        PageContext.APPLICATION_SCOPE: 对应于application范围。
    */
%>
```

------

### JavaBean的使用

```jsp
JavaBean的使用的使用目的:
    a. 减轻的jsp复杂度(jsp->jsp+Java)
    b. 提高代码复用(同一工程的任何一个jsp文件都可以调用)

JavaBean(就是一个Java类)的定义: 满足以下2点, 就可以称为JavaBean
    a. public修饰的类且必须具有一个无参的构造方法
    b. 所有属性(如果有)的访问权限都是private, 并且提供set/get(如果boolean 则get 可以替换成is)

JavaBea分为两大类:
    a. 封装业务逻辑的JavaBean  ——> 封装操作
    b. 封装数据的JavaBean(实体类)  ——> 封装数据
        b.1: 声明访问权限为private的各成员变量属性
        b.2: 通过Source –> Generate Getters and Setters为每个变量属性创建Getter和Setter方法
        b.3: 可通过Source –> Generate Constructor using Fields生成构造方法

JavaBean的创建目录:
	工程 –> Java Resources –> src(classpath)目录下(一定要为类创建一个"包")
```

---

### 设置jsp项目服务器访问根路径

```jsp
Step1. 获取项目访问根路径
<%
    String scheme = request.getScheme();// 可以返回当前页面使用的协议(如:http、https)
    String serverName = request.getServerName();// 可以返回当前页面所在的服务器的名字(如:localhost)
    int serverPort = request.getServerPort();// 可以返回当前页面所在的服务器使用的端口(如:8080)
    String contextPath = request.getContextPath();// 返回当前工程项目的根目录(即"/" + "工程项目名")
    String basePath = scheme + "://" + serverName + ":" + serverPort + contextPath + "/";
%>
Step2. 在head标签中引入根路径
    <base href="<%=basePath%>"/>
    <!--
    经此设置过后, jsp页面中凡是涉及到填写路径的地方, 均可填写相对于根目录的"相对路径即可", 服务器会自动将路径拼接成完整的访问路径！！！
    -->

<!--Tip:
    1. Jsp中, 位于路径开头的"/"表示为服务器根路径, 即scheme + "://" + serverName + ":" + serverPort + "/"(如:http://localhost:8080/)
    2. java或XML中, 位于路径开头的"/"表示为服务器访问项目根路径, 即scheme + "://" + serverName + ":" + serverPort + pContextPath + "/"(如:http://localhost:8080/projectName/)
-->
```
---

---

## <center>SQL</center>

###  JDBC操作数据库

| **数据库类型** |        **驱动jar包**         |
| :------------: | :--------------------------: |
|     Oracle     |        ojdbc-xxx.jar         |
|     MySQL      | mysql-connector-java-xxx.jar |
|   SqlServer    |       sqljdbc-xxx.jar        |
>#### jdbc增删改查模板
```java
查询结果对应的列的属性名(不区分大小写)/*createStatement版本:*/
final String URL = "数据库连接字符串";  // MySQL 6.0及以上必须配置参数servertime(时区)
final String USERNAME = "数据库用户名";
final String PASSWORD = "数据库用户密码";
// 将各个变量预设为空
Connection connection = null;
Statement stmt = null;
ResultSet rs = null;
int count = null;
try {
    // a. 导入驱动包, 加载具体驱动类
    Class.forName("具体驱动类的全类名");
    // b. 与数据库建立连接
    connection =  DriverManager.getConnection(URL,USERNAME,PASSWORD);
    // c. 创建Statement对象
    stmt = connection.createStatement();
    // 编译并发送sql语句
    rs = stmt.executeQuery("查询语句"); // 返回查询结果
    count = stmt.executeUpdate("增删改语句"); // 返回增删改的数据条数
    // 遍历查询结果
    while(rs.next()) {
        // 提取数据属性值
        rs.get数据类型("查询结果对应的列的属性名(不区分大小写)"/索引号[从1开始]) // 如:rs.getInt("Sno")
    }
} catch(Exception e) {
    // 抛出错误信息
    e.printStackTrace();
} finally {    
    // d. 关闭连接, 关闭顺序与打开顺序相反
    try {
        if(rs!=null) rs.close();
        if(stmt!=null) stmt.close();
        if(connection != null) connection.close();
    } catch(SQLException e) {
        // 抛出错误信息
        e.printStackTrace();
    }
}
```

``` java
<%-- 推荐 --%>
/*prepareStatement版本:*/
final String URL = "数据库连接字符串";  // MySQL 6.0及以上必须配置参数servertime(时区)
final String USERNAME = "数据库用户名";
final String PASSWORD = "数据库用户密码";
// 将各个变量预设为空
Connection connection = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
int count = null;
try {
    // a. 导入驱动包, 加载具体驱动类
    Class.forName("具体驱动类的全类名");
    // b. 与数据库建立连接
    connection = DriverManager.getConnection(URL,USERNAME,PASSWORD);
    // c. 编译sql语句
    pstmt = connection.prepareStatement("查询语句"/"增删改语句"); // 预编译
    /*Tip: 
        1. prepareStatement中的sql语句可使用占位符"?"
        2. "?"不能作为sql的关键词和字段名的占位符(原因:prepareStatement默认会为"?"替换的内容加上单引号)
        3. 使用set数据类型(占位符的索引号[从1开始], 要替换的内容) 替换占位符"?"
        例:     
        // String sql = "insert into student values(?,?,?,?)";
        // pstmt = connection.prepareStatement(sql);
        // pstmt.setInt(1, 36);
        // pstmt.setString(2, "zhangsan");
        // pstmt.setInt(3, 56);
        // pstmt.setString(4, "s3");
    */
    // d. 发送sql语句
    rs = pstmt.executeQuery(); // 返回查询结果
    count = pstmt.executeUpdate(); // 返回增删改的数据条数
    // 遍历查询结果
    while(rs.next()) {
        // 提取数据属性值
        rs.get数据类型("查询结果对应的列的属性名(不区分大小写)"/索引号[从1开始]); // 如:rs.getInt("Sno")
    }
} catch(Exception e) {
    // 抛出错误信息
    e.printStackTrace();
} finally {    
    // e. 关闭连接, 关闭顺序与打开顺序相反
    try {
        if(rs!=null) rs.close();
        if(pstmt != null) pstmt.close();
        if(connection != null) connection.close();
    } catch(SQLException e) {
        // 抛出错误信息
        e.printStackTrace();
    }
}
```

> #### jdbc存储模板

```java
/*prepareCall版本:*/
final String URL = "数据库连接字符串";  // MySQL 6.0及以上必须配置参数servertime(时区)
final String USERNAME = "数据库用户名";
final String PASSWORD = "数据库用户密码";
// 将各个变量预设为空(的是设为全局变量, 在finally中可识别)
Connection connection = null;
CallableStatement cstmt = null;
ResultSet rs = null;
int count = null;
try {
    // a. 导入驱动包, 加载具体驱动类
    Class.forName("具体驱动类的全类名");
    // b. 与数据库建立连接
    connection = DriverManager.getConnection(URL,USERNAME,PASSWORD);
    // c. 编译sql存储过程或存储函数的调用语句
    cstmt = connection.prepareCall("{存储过程/存储函数}");
    /*
        存储过程(无返回值return, 用out参数替代):
            { call 存储过程名(参数列表) } ===> { call sumTwoNum(?,?,?) }
                // mysql存储过程示例如下:
                    CREATE PROCEDURE sumTwoNum (IN num1 INT,IN num2 INT,OUT result INT)
                    BEGIN
                    set result = num1 + num2;
                    END;
        存储函数(有返回值return):
            { ? = call 存储函数名(参数列表) } ===> { ? = call sumTwoNum(?,?)}
                // mysql存储函数示例如下:
                    CREATE FUNCTION sumNum (num1 INT,num2 INT)
                    RETURNS INT
                    begin
                    declare result INT;
                    set result = num1 + num2;
                    return (result);
                    end;
    */
    /*Tip:
        1. prepareCall中sql"存储过程/存储函数"的参数使用占位符"?"
        2. 使用set数据类型(占位符的索引号[从1开始], 要替换的内容) 替换占位符"?"设置输入参数的值
        3. 使用registerOutParameter(输出参数占位符的索引号[从1开始], Java.sql.Types.jdbc类型)设置"输出参数"的jdbc类型 
    */
    // d. 发送sql存储过程或存储函数的调用语句
    cstmt.execute(); 
    /*Tip: 使用get数据类型(输出参数占位符的索引号[从1开始])提取返回值*/
    数据类型 名称 = cstmt.get数据类型(输出参数占位符的索引号[从1开始])
} catch(Exception e) {
    // 抛出错误信息
    e.printStackTrace(); 
} finally {    
    // e. 关闭连接, 关闭顺序与打开顺序相反
    try {
        if(cstmt != null) cstmt.close();
        if(connection != null) connection.close();
    } catch(SQLException e) {
        // 抛出错误信息
        e.printStackTrace();
    }
}
```

----

### JDBC批量处理增删改语句

> #### createStatement版本

```java
final String URL = "数据库连接字符串";  // MySQL 6.0及以上必须配置参数servertime(时区)
final String USERNAME = "数据库用户名";
final String PASSWORD = "数据库用户密码";
// 将各个变量预设为空
Connection connection = null;
Statement stmt = null;
try {
    // a. 导入驱动包, 加载具体驱动类
    Class.forName("具体驱动类的全类名");
    // b. 与数据库建立连接
    connection =  DriverManager.getConnection(URL,USERNAME,PASSWORD);
    // c. 创建Statement对象
    stmt = connection.createStatement();
    // 添加sql增删改语句
    stmt.addBatch("sql增删改语句1");
    stmt.addBatch("sql增删改语句2");
    ···
    // 批量发送增删改语句(返回一个整数数组, 数组中的每个元素代表了各自的语句操作成功的数据条数)
    int[] count = stmt.executeBatch(); 
} catch(Exception e) {
    // 抛出错误信息
    e.printStackTrace();
} finally {    
    // d. 关闭连接, 关闭顺序与打开顺序相反
    try {
        if(stmt!=null) stmt.close();
        if(connection != null) connection.close();
    } catch(SQLException e) {
        // 抛出错误信息
        e.printStackTrace();
    }
}
```

> #### prepareStatement版本

```java
final String URL = "数据库连接字符串";  // MySQL 6.0及以上必须配置参数servertime(时区)
final String USERNAME = "数据库用户名";
final String PASSWORD = "数据库用户密码";
// 将各个变量预设为空
Connection connection = null;
PreparedStatement pstmt = null;
try {
    // a. 导入驱动包, 加载具体驱动类
    Class.forName("具体驱动类的全类名");
    // b. 与数据库建立连接
    connection = DriverManager.getConnection(URL,USERNAME,PASSWORD);
    // c. 编译sql语句
    pstmt = connection.prepareStatement("增删改语句"); // 预编译
    /*···替换占位符···*/
    // 添加编译后sql语句
    pstmt.addBatch();
    /*···再次替换占位符···*/
    // 添加另一个编译后sql语句
    pstmt.addBatch();
    ···
    // 批量发送增删改语句(返回一个整数数组, 数组中的每个元素代表了各自的语句操作成功的数据条数)
    int[] count = pstmt.executeBatch();
} catch(Exception e) {
    // 抛出错误信息
    e.printStackTrace();
} finally {    
    // d. 关闭连接, 关闭顺序与打开顺序相反
    try {
        if(pstmt != null) pstmt.close();
        if(connection != null) connection.close();
    } catch(SQLException e) {
        // 抛出错误信息
        e.printStackTrace();
    }
}
```

> #### prepareCall版本(通过存储过程或存储函数进行增删改)

```java
final String URL = "数据库连接字符串";  // MySQL 6.0及以上必须配置参数servertime(时区)
final String USERNAME = "数据库用户名";
final String PASSWORD = "数据库用户密码";
// 将各个变量预设为空(的是设为全局变量, 在finally中可识别)
Connection connection = null;
CallableStatement cstmt = null;
try {
    // a. 导入驱动包, 加载具体驱动类
    Class.forName("具体驱动类的全类名");
    // b. 与数据库建立连接
    connection = DriverManager.getConnection(URL,USERNAME,PASSWORD);
    // c. 编译sql存储过程或存储函数的调用语句
    cstmt = connection.prepareCall("{存储过程/存储函数}"); 
    /*···替换占位符···*/
    // 添加编译后sql语句
    cstmt.addBatch();
    /*···再次替换占位符···*/
    // 添加另一个编译后sql语句
    cstmt.addBatch();
    ···
    // d. 批量发送存储过程/存储函数语句(返回一个整数数组, 数组中的每个元素代表了各自的语句操作成功的数据条数)
    int[] count = cstmt.executeBatch();   
    /*批量操作的储过程或存储函数无法获取返回值, 所以不应在批量操作的存储过程或存储函数中设置返回值*/
} catch(Exception e) {
    // 抛出错误信息
    e.printStackTrace(); 
} finally {    
    // e. 关闭连接, 关闭顺序与打开顺序相反
    try {
        if(cstmt != null) cstmt.close();
        if(connection != null) connection.close();
    } catch(SQLException e) {
        // 抛出错误信息
        e.printStackTrace();
    }
}
```

---

### JDBC事务处理

> #### 事务的理解

```java
当执行"增删改"操作时, Java并未直接将操作语句发送至数据库, 而是将这些操作所产生的"改变"信息存放在该连接(同一个Connection对象)的缓存内——"事务", 当进行事务进行提交后, 才会将缓存中的"改变"信息提交至数据库从而对数据库进行真正的操作(每次提交事务, 视为一次事务的结束, 即清空一次缓存信息), 而JDBC默认自动进行事务提交, 即每执行一次"增删改"操作, 都会自动开启并提交一次事务, 当我们执行多次"增删改"操作时, 便会出现有操作成功, 有的操作失败的情况, 而有些时候(多表操作), 我们希望这些操作要么全部成功, 要么全部失败。。。。。
```

> #### 开启事务

```java
/*JDBC默认开启事务的自动提交, 我们可以认为将其设置为手动提交(开启事务):*/
Connection对象.setAutoCommit(false);
```

> #### 事务提交

```java
/*设置手动提交事务之后, 在发送sql的增删改查语句之后, 需要在提交事务之后才会真正对数据库做出操作*/
try{
    // 通过[Statement|PreparedStatement|CallableStatement]对象逐条或批量发送sql增删改语句
    ···
    Connection对象.commit( ); //提交事务
}

/*Tip: 
    1. 当且仅当事务中所有的sql语句的虚拟执行结果都成功, 提交事务后才会对数据库进行实质性的修改, 否则不会对数据库进行操作！
    2. 提交事务之前发送的sql语句均会进行虚拟执行, 当某个sql语句执行异常时, 排在其后的其他语句都会停止执行, 虚拟执行成功的sql语句虽然不会对数据库进行实质性的修改, 但是产生的缓存信息会对同一个Connection对象后续的查询产生影响, 即如果在"finally{}"板块中进行查询操作, 可以查询到事务提交前虚拟执行操作成功的数据(脏数据)
*/
```

> #### 事务回滚

```java
事务回滚: 将Connection对象的缓存信息("事务")还原至提交前数据库的真实状态, 避免缓存信息中的"脏数据"对后续查询产生影响
/*使用事务回滚的前提是设置事务的提交方式为手动提交*/
catch (Exception e) {
    Connection对象.rollback(); //事务回滚, 该操作必须在"catch"中进行
}
/*
事务回滚是否执行, 取决去是否捕获到符合"catch"中规定的异常, 通常设置为"Exception",即只要try{}中有异常发生, 不管是不是SQLException, 都进行事务回滚, 视为整个事务操作失败
*/
```

> > ##### 模板

```java
Connection对象.setAutoCommit(false); // 开启事务
try{
    ···发送sql语句···
    Connection对象.commit( ); //提交事务    
} catch (Exception e){
    Connection对象.rollback(); //事务回滚
} finally{
	各种close关闭
}
```

> #### 设置还原点

```java
/*我们可以在事务进行的某个阶段, 为Connection对象的缓存信息设置还原点*/
Savepoint spName = Connection对象.setSavepoint("为该还原点设置名称(可以忽略)"); 

/*可以通过事务回滚, 将Connection对象的缓存信息("事务")恢复至建立还原点时刻的状态*/
Connection对象.rollback(spName); 

/*Tip:
    1. 还原点也是建立在在"事务"之中的, 当事务提交成功后, 该还原点也随缓存的清空而被销毁; 
    2. 在将事务回滚至还原点以后, 可以再次执行commit操作提交事务, 即还原点之前的事务信息会被成功提交至数据库
*/
```

---

### 通过连接池连接数据库

> #### DBCP连接池

```
必要jar包: commons-dbcp2-Xxx.jar、commons-pool2-Xxx.jar
属性配置官方文档: https://commons.apache.org/proper/commons-dbcp/configuration.html
```

> > ##### 硬编码方式配置数据源

```java
/*创建并配置dbcp数据源(仅设置部分常用属性)*/        
BasicDataSource dbcpDs = new BasicDataSource();
dbcpDs.setDriverClassName("指定数据库JDBC具体驱动类的全类名");
dbcpDs.setUrl("数据库连接字符串(MySQL jdbc 6.0及以上必须配置参数servertime(时区))");
dbcpDs.setUsername("数据库登陆用户名");
dbcpDs.setPassword("数据库登陆密码");
dbcpDs.setInitialSize(接池启动时创建的初始化连接数量, 默认0);
dbcpDs.setMinIdle(连接池中允许保持空闲状态的最小连接数量, 默认0, 取负数表示不受限制);
dbcpDs.setMaxIdle(连接池中允许保持空闲状态的最大连接数量, 超过的空闲连接将被释放, 默认8, 取负数表示不受限制);
dbcpDs.setSoftMinEvictableIdleTimeMillis(连接保持空闲而不被驱逐的最小时间(单位毫秒), 默认-1无限, 在保留minIdle个空闲连接的基础上连接池中空闲时间超过该设置的连接将会被释放);
dbcpDs.setMinEvictableIdleTimeMillis(连接保持空闲而不被驱逐的最小时间(单位毫秒), 取负表示无限, 默认1800000即半小时, 连接池中空闲时间超过该设置的任意连接都将会被释放, 当池中连接数量低于minIdle时, 会向数据库获取新的连接放入池中以维持minIdle(如果该设置大于0, 则忽略softMinEvictableIdleTimeMillis设置));
dbcpDs.setTimeBetweenEvictionRunsMillis(检查连接池中所有空闲连接的间隔时间(单位毫秒), 取负表示不检查, 默认-1, 通过比较池中连接最后一次被使用时间和当前时间的时间差来和softMinEvictableIdleTimeMillis或minEvictableIdleTimeMillis做对比, 进而决定是否销毁这个连接对象(不可大于softMinEvictableIdleTimeMillis或minEvictableIdleTimeMillis的设置));
dbcpDs.setMaxTotal(连接池在同一时间能够分配的最大活动连接的数量, 如果数据连接请求超过此数, 后面的数据连接请求将被加入到等待队列中, 默认8, 取负表示不受限制);
dbcpDs.setMaxWaitMillis(获取连接时最大等待时间(单位毫秒), 超过时间则抛出异常, 取负表示无限等待, 默认-1无限等待);
/*通过数据源与数据库建立连接*/
Connection connection = dbcpDs.getConnection();
/*后续操作与jdbc连接数据库操作相同*/
```

> > ##### properties属性文件方式配置数据源

```properties
# 创建properties文件配置dbcp数据源(仅设置部分常用属性)
driverClassName=指定数据库JDBC具体驱动类的全类名
url=数据库连接字符串(MySQL jdbc 6.0及以上必须配置参数servertime(时区))
username=数据库登陆用户名
password=数据库登陆密码
initialSize=接池启动时创建的初始化连接数量, 默认0
minIdle=连接池中允许保持空闲状态的最小连接数量, 默认0, 取负数表示不受限制
maxIdle=连接池中允许保持空闲状态的最大连接数量,超过的空闲连接将被释放, 默认8, 取负数表示不受限制
softMinEvictableIdleTimeMillis=连接保持空闲而不被驱逐的最小时间(单位毫秒), 默认-1无限, 在保留minIdle个空闲连接的基础上连接池中空闲时间超过该设置的连接将会被释放
minEvictableIdleTimeMillis=连接保持空闲而不被驱逐的最小时间(单位毫秒), 取负表示无限, 默认1800000即半小时, 连接池中空闲时间超过该设置的任意连接都将会被释放, 当池中连接数量低于minIdle时, 会向数据库获取新的连接放入池中以维持minIdle(如果该设置大于0, 则忽略softMinEvictableIdleTimeMillis设置)
timeBetweenEvictionRunsMillis=检查连接池中所有空闲连接的间隔时间(单位毫秒), 取负表示不检查, 默认-1, 通过比较池中连接最后一次被使用时间和当前时间的时间差来和softMinEvictableIdleTimeMillis或minEvictableIdleTimeMillis做对比, 进而决定是否销毁这个连接对象(不可大于softMinEvictableIdleTimeMillis或minEvictableIdleTimeMillis的设置)
maxTotal=连接池在同一时间能够分配的最大活动连接的数量, 如果数据连接请求超过此数, 后面的数据连接请求将被加入到等待队列中, 默认8, 取负表示不受限制
maxWaitMillis=获取连接时最大等待时间(单位毫秒), 超过时间则抛出异常,如果设置为-1表示无限等待, 默认-1无限等待
```

```java
/*引入数据源配置文件*/
InputStream inputStream = 当前类className.class.getClassLoader().getResourceAsStream("properties配置文件(相对于src(classpath)的路径)");
Properties properties = new Properties(); 
properties.load(inputStream);
/*创建dbcp数据源并引入配置*/
DataSource dbcpDs = BasicDataSourceFactory.createDataSource(properties);
/*通过数据源与数据库建立连接*/
Connection connection = dbcpDs.getConnection();
/*后续操作与jdbc连接数据库操作相同*/
```

> #### C3P0连接池

```
必要jar包: c3p0-Xxx.jar、mchange-commons-java-Xxx.jar
属性配置官方文档: https://www.mchange.com/projects/c3p0/#configuration_properties
```

> > ##### 硬编码方式配置数据源

```java
/*创建并配置c3p0数据源(仅设置部分常用属性)*/        
ComboPooledDataSource c3p0Ds = new ComboPooledDataSource();
c3p0Ds.setDriverClass("指定数据库JDBC具体驱动类的全类名");
c3p0Ds.setJdbcUrl("数据库连接字符串(MySQL jdbc 6.0及以上必须配置参数servertime(时区))");
c3p0Ds.setUser("数据库登陆用户名");
c3p0Ds.setPassword("数据库登陆密码");
c3p0Ds.setInitialPoolSize(接池启动时创建的初始化连接数量, 默认3);
c3p0Ds.setMinPoolSize(连接池中允许保持空闲状态的最小连接数量, 默认3);
c3p0Ds.setMaxPoolSize(连接池中允许保持空闲状态的最大连接数量, 超过的空闲连接将被释放, 默认15);
c3p0Ds.setMaxIdleTime(最大空闲时间(单位秒), 设置为0表示无限, 默认0, 连接池中空闲时间超过该设置的连接将会被释放, 当池中连接数量低于minPoolSize时, 会向数据库获取新的连接放入池中以维持minPoolSize);
c3p0Ds.setIdleConnectionTestPeriod(检查连接池中所有空闲连接的间隔时间(单位秒), 设置为0表示不检查, 默认0, 通过比较池中连接最后一次被使用时间和当前时间的时间差来和axIdleTime做对比, 进而决定是否销毁这个连接对象(不可大于maxIdleTime的设置));
c3p0Ds.setCheckoutTimeout(获取连接时最大等待时间(单位毫秒), 超过时间则抛出异常, 如果设置为0表示无限等待, 默认0无限等待);
/*通过数据源与数据库建立连接*/
Connection connection = c3p0Ds.getConnection();
/*后续操作与jdbc连接数据库操作相同*/
```

> > ##### xml文件方式配置数据源

```xml
<!-- 该文件必须创建在src(classpath)直接目录下且名字必须为"c3p0-config.xml" -->
<?xml version="1.0" encoding="UTF-8"?>
<c3p0-config>
    <!-- 设置默认使用的数据源配置(仅设置部分常用属性) -->
    <default-config>
        <property name="driverClass">指定数据库JDBC具体驱动类的全类名</property>
        <property name="jdbcUrl">数据库连接字符串</property>
        <property name="user">数据库登陆用户名</property>
        <property name="password">数据库登陆密码</property>
        <property name="initialPoolSize">接池启动时创建的初始化连接数量, 默认3</property>
        <property name="minPoolSize">连接池中允许保持空闲状态的最小连接数量, 默认3</property>
        <property name="maxPoolSize">连接池中允许保持空闲状态的最大连接数量, 默认15</property>
        <property name="axIdleTime">最大空闲时间(单位秒), 设置为0表示无限, 默认0, 连接池中空闲时间超过该设置的连接将会被释放, 当池中连接数量低于minPoolSize时, 会向数据库获取新的连接放入池中以维持minPoolSize</property>
        <property name="idleConnectionTestPeriod">检查连接池中所有空闲连接的间隔时间(单位秒), 设置为0表示不检查, 默认0, 通过比较池中连接最后一次被使用时间和当前时间的时间差来和axIdleTime做对比, 进而决定是否销毁这个连接对象(不可大于maxIdleTime的设置)</property>
        <property name="checkoutTimeout">获取连接时最大等待时间(单位毫秒), 超过时间则抛出异常, 如果设置为0表示无限等待, 默认0无限等待</property>
    </default-config>

    <!-- 设置其他的数据源配置(可设置多个, 只要name属性不重复即可) -->
    <named-config name="该数据源配置的标识">
        ···
        各参数的配置与默认配置方式相同
    </named-config>
</c3p0-config>
```

```java
/*创建c3p0数据源自动加载配置文件*/   
ComboPooledDataSource c3p0Ds = new ComboPooledDataSource("xml配置文件中named-config的name值"); // 参数为空或未找到匹配的"named-config",则默认使用"default-config"下的配置
/*通过数据源与数据库建立连接*/
Connection connection = c3p0Ds.getConnection();
/*后续操作与jdbc连接数据库操作相同*/
```

> #### Druid连接池

```
必要jar包: druid-Xxx.jar
属性配置官方文档: https://github.com/alibaba/druid/wiki/DruidDataSource配置属性列表
```

> > ##### 硬编码方式配置数据源

```java
/*创建并配置dbcp数据源(仅设置部分常用属性)*/        
DruidDataSource druidDs = new DruidDataSource();
druidDs.setDriverClassName("指定数据库JDBC具体驱动类的全类名");
druidDs.setUrl("数据库连接字符串(MySQL jdbc 6.0及以上必须配置参数servertime(时区))");
druidDs.setUsername("数据库登陆用户名");
druidDs.setPassword("数据库登陆密码");
druidDs.setInitialSize(接池启动时创建的初始化连接数量, 默认0);
dbcpDs.setMinIdle(连接池中允许保持空闲状态的最小连接数量, 默认0);
druidDs.setMinEvictableIdleTimeMillis(连接保持空闲而不被驱逐的最小时间(单位毫秒), 默认1800000, 在保留minIdle个空闲连接的基础上连接池中空闲时间超过该设置的连接将会被释放);
druidDs.setMaxEvictableIdleTimeMillis(连接保持空闲而不被驱逐的最大时间(单位毫秒), 默认25200000(必须大于MinEvictableIdleTimeMillis), 连接池中空闲时间超过该设置的任意连接都将会被释放, 当池中连接数量低于minIdle时, 会向数据库获取新的连接放入池中以维持minIdle);
druidDs.setTimeBetweenEvictionRunsMillis(检查连接池中所有空闲连接的间隔时间(单位毫秒), 默认60000, 通过比较池中连接最后一次被使用时间和当前时间的时间差来和minEvictableIdleTimeMillis以及MaxEvictableIdleTimeMillis做对比, 进而决定是否销毁这个连接对象(不可大于minEvictableIdleTimeMillis的设置));
druidDs.setMaxActive(连接池在同一时间能够分配的最大活动连接的数量, 如果数据连接请求超过此数, 后面的数据连接请求将被加入到等待队列中, 默认8, 取负表示不受限制);
druidDs.setMaxWait(获取连接时最大等待时间(单位毫秒), 超过时间则抛出异常, 默认无限等待);
/*通过数据源与数据库建立连接*/
Connection connection = druidDs.getConnection();
/*后续操作与jdbc连接数据库操作相同*/
```

> > ##### properties属性文件方式配置数据源

```properties
# 创建properties文件配置druid数据源(仅设置部分常用属性)
driverClassName=指定数据库JDBC具体驱动类的全类名
url=数据库连接字符串(MySQL jdbc 6.0及以上必须配置参数servertime(时区))
username=数据库登陆用户名
password=数据库登陆密码
initialSize=接池启动时创建的初始化连接数量, 默认0
minIdle=连接池中允许保持空闲状态的最小连接数量, 默认0
minEvictableIdleTimeMillis=连接保持空闲而不被驱逐的最小时间(单位毫秒), 默认1800000, 在保留minIdle个空闲连接的基础上连接池中空闲时间超过该设置的连接将会被释放
maxEvictableIdleTimeMillis=连接保持空闲而不被驱逐的最大时间(单位毫秒), 默认25200000(必须大于MinEvictableIdleTimeMillis), 连接池中空闲时间超过该设置的任意连接都将会被释放, 当池中连接数量低于minIdle时, 会向数据库获取新的连接放入池中以维持minIdle
timeBetweenEvictionRunsMillis=检查连接池中所有空闲连接的间隔时间(单位毫秒), 默认60000, 通过比较池中连接最后一次被使用时间和当前时间的时间差来和minEvictableIdleTimeMillis以及MaxEvictableIdleTimeMillis做对比, 进而决定是否销毁这个连接对象(不可大于minEvictableIdleTimeMillis的设置)
maxActive=连接池在同一时间能够分配的最大活动连接的数量, 如果数据连接请求超过此数, 后面的数据连接请求将被加入到等待队列中, 默认8, 取负表示不受限制
maxWait=获取连接时最大等待时间(单位毫秒), 超过时间则抛出异常, 默认无限等待
```

```java
/*引入数据源配置文件*/
InputStream inputStream = 当前类className.class.getClassLoader().getResourceAsStream("properties配置文件(相对于src(classpath)的路径)");
Properties properties = new Properties(); 
properties.load(inputStream);
/*创建dbcp数据源并引入配置*/
DataSource druidDs = DruidDataSourceFactory.createDataSource(properties);
/*通过数据源与数据库建立连接*/
Connection connection = druidDs.getConnection();
/*后续操作与jdbc连接数据库操作相同*/
```

> #### Proxool连接池

```
必要jar包: proxool-Xxx.jar、proxool-cglib-Xxx.jar、commons-logging-Xxx.jar
属性配置官方文档: http://proxool.sourceforge.net/properties.html
```

> > ##### 硬编码方式配置数据源

```java
/*创建并配置Proxool数据源(仅设置部分常用属性)*/   
ProxoolDataSource proxoolDs = new ProxoolDataSource();
proxoolDs.setDriver("指定数据库JDBC具体驱动类的全类名");
proxoolDs.setDriverUrl("数据库连接字符串(MySQL jdbc 6.0及以上必须配置参数servertime(时区))");
proxoolDs.setUser("数据库登陆用户名");
proxoolDs.setPassword("数据库登陆密码");
proxoolDs.setPrototypeCount(连接池中允许保持空闲状态的最小连接数量, 默认0);
proxoolDs.setMinimumConnectionCount(保持打开状态的最小连接数量, 无论空闲还是活动, 默认5);
proxoolDs.setMaximumConnectionCount(保持打开状态的最大连接数量, 无论空闲还是活动, 默认15);
proxoolDs.setSimultaneousBuildThrottle(连接池中无空闲连接时, 一次请求可以建立的最大连接数, 默认10);
proxoolDs.setMaximumActiveTime(连接最大活动时间(单位毫秒), 如果连接活动超过该设置则自动回收, 默认30000);
proxoolDs.setMaximumConnectionLifetime(连接保持空闲而不被驱逐的最大时间(单位毫秒), 默认14400000, 连接池中空闲时间超过该设置的任意连接都将会被释放, 当池中连接数量低于prototype-count会向数据库获取新的连接放入池中以维持prototype-count);
proxoolDs.setHouseKeepingSleepTime(检查池中所有连接的状态的间隔时间(单位毫秒), 默认30000, 依据maximum-active-time检查活动连接, 依据maximum-connection-lifetime检查空闲连接(不可小于maximum-active-time或maximum-connection-lifetime));
/*通过数据源与数据库建立连接*/
Connection connection = proxoolDs.getConnection();
/*后续操作与jdbc连接数据库操作相同*/
```

> > ##### xml文件方式配置数据源

```xml
<!-- 创建xml文件配置proxool数据源(仅设置部分常用属性) -->
<?xml version="1.0" encoding="UTF-8"?>
<something-else-entirely>
    <!-- 一个"proxool"标签代表一种数据源配置, 可创建多个 -->
    <proxool>
        <alias>设置该数据源的别名, 不同"proxool"标签该属性值不可重复</alias>
        <driver-class>指定数据库JDBC具体驱动类的全类名r</driver-class>
        <driver-url>数据库连接字符串(MySQL jdbc 6.0及以上必须配置参数servertime(时区))</driver-url>
        <driver-properties>
            <property name="user" value="数据库登陆用户名" />
            <property name="password" value="数据库登陆密码" />
        </driver-properties>
        <prototype-count>连接池中允许保持空闲状态的最小连接数量, 默认0</prototype-count>
        <minimum-connection-count>保持打开状态的最小连接数量, 无论空闲还是活动, 默认5</minimum-connection-count>
        <maximum-connection-count>保持打开状态的最大连接数量, 无论空闲还是活动, 默认15</maximum-connection-count>
        <simultaneous-build-throttle>连接池中无空闲连接时, 一次请求可以建立的最大连接数, 默认10</simultaneous-build-throttle>
        <maximum-active-time>连接最大活动时间(单位毫秒), 如果连接活动超过该设置则自动回收, 默认30000</maximum-active-time>
        <maximum-connection-lifetime>连接保持空闲而不被驱逐的最大时间(单位毫秒), 默认14400000, 连接池中空闲时间超过该设置的任意连接都将会被释放, 当池中连接数量低于"prototype-count" 会向数据库获取新的连接放入池中以维持"prototype-count"</maximum-connection-lifetime>
        <house-keeping-sleep-time>检查池中所有连接的状态的间隔时间(单位毫秒), 默认30000, 依据"maximum-active-time"检查活动连接, 依据"maximum-connection-lifetime"检查空闲连接(不可小于"maximum-active-time"或"maximum-connection-lifetime")</house-keeping-sleep-time>
    </proxool>
</something-else-entirely>
```

```java
/*引入数据源配置文件*/
InputStream proxoolInputStream = 当前类className.class.getClassLoader().getResourceAsStream("xml配置文件相对于src(classpath)的路径");
InputStreamReader proxoolReader = new InputStreamReader(proxoolInputStream);
/*引入配置*/
JAXPConfigurator.configure(proxoolReader, false);
/*注册驱动类, Proxool专用的驱动*/
Class.forName("org.logicalcobwebs.proxool.ProxoolDriver");
/*通过数据源与数据库建立连接*/
Connection connection = DriverManager.getConnection("proxool."+"配置文件中<proxool>标签的alias值");
/*后续操作与jdbc连接数据库操作相同*/
```

> #### 通过Tomcat配置连接池(JNDI数据源)

``` xml
a. 首先在web项目的META-INF下建立context.xml文件, 或直接使用服务器的context.xml文件; 
b. 配置数据源,在context.xml文件中添加以下内容:
    <Context>
        <Resource name="DataSource的名称"
        auth="Container"
        factory="负责数据源生成的工厂类的全类名, 默认为org.apache.tomcat.dbcp.dbcp2.BasicDataSourceFactory(tomcat整合的dbcp)"  
        type="数据源对应的全类名, 一般使用Javax.sql.DataSource(所有数据源的祖宗类)"
        ··· 其他属性需依据连接池类型进行设置(同各连接池配置文件中的属性)
        />
    </Context>

<!--各类型连接池需要使用的工厂类的全类名: 
    DBCP: org.apache.commons.dbcp2.BasicDataSourceFactory
    C3P0: 无; (可使用通用项)
    Druid: com.alibaba.druid.pool.DruidDataSourceFactory
    通用: org.apache.naming.factory.BeanFactory(若使用该工程类, 则必须将type属性严格声明为数据源对应的全类名; 而不能直接使用Javax.sql.DataSource)
-->
```

```jsp
c. 引入数据源,在web.xml中加入以下内容(tomcat 5.5以后的版本该步骤可省略, 但建议添加):
    <resource-ref>
        <description>描述,可以省略</description>
        <res-ref-name>context.xml中Resource标签的name值</res-ref-name>
        <res-type>Javax.sql.DataSource</res-type>
        <res-auth>Condtainer</res-auth>
    </resource-ref>

d. Java建立连接:
    <%     
        //初始化查找命名空间即与context.xml文件建立连接
        Context ctx = new InitialContext();  
        //参数Java:/comp/env为tomcat服务器默认的JNDI目录  
        Context envContext = (Context)ctx.lookup("Java:/comp/env"); 
        //获取数据源,参数"DataSoeurce的名称"为context.xml中Resource标签的name值
        DataSource ds = (DataSource)envContext.lookup("DataSource的名称"); 
        // 通过数据源与数据库建立连接  
        Connection connection = ds.getConnection();  
    %>
e. 后续操作与jdbc连接数据库操作相同; 
```

---

### 通过ThreadLocal获取与线程绑定的Connection

```java
客户端的每一次请求均可视为开启一个新的线程, "户端发出请求 ——> 服务端业务处理 ——> 服务端响应结束"这一过程均是在同一线程内完成的! 而我们将JDBC Connection对象与线程绑定的目的是为了保证同一个线程下对数据库的操作是在同一个Connection对象下完成的, 并且保证不同线程之间使用的Connection对象是不同的, 以免对数据库的存储信息或用户查询的信息造成混乱！

/*使用与线程绑定的Connection的好处: 
    1. 不需要从外部传入Connection对象
    2. Dao层的多个方法(操作)也可以共享同一个事务
*/
    
/*如果不使用与线程绑定Connection, 可以采用下面的思想来避免上述错误的发生: 
    每次在客户端发出请求时, 为其单独创建一个Connection对象并开启事务, 在服务端执行操作期间始终使用该Connection对象执行有关数据库的更改操作, 直至服务端响应结束提交事务并将其关闭销毁!
*/
```

> #### 模板

```java
public class ConnectionThreadLocalManager {
    // 建立线程映射对象ThreadLocal, 可以看作为一个全局的Map<Thread thread, Connection connection>
    private static ThreadLocal<Connection> connectionThreadLocal = new ThreadLocal<Connection>();

    /*获取当前线程上绑定的Connection*/
    public  static Connection getCurrentConnection() throws SQLException {
        // 从ThreadLocal中寻找当前线程对应的Connection
        Connection connection = connectionThreadLocal.get();
        // 如果ThreadLocal没有与当前线程绑定的Connection对象, 则新建Connection对象并与当前线程绑定
        if (connection == null) {
            // 此处应为通过基础的JDBC方式或数据库链接池的方式创建一个Connection对象
            connection = ···;
            // 将conn绑定到ThreadLocal(map)上, 与当前线程进行绑定 
            connectionThreadLocal.set(conn);
        }
        return conn;
    }

    /*开启事务*/
    public static void StartTransaction() throws SQLException {
        Connection connection = getCurrentConnection();
        conn.setAutoCommit(false);
    }

    /*回滚事务*/
    public static void TransactionRollback() throws SQLException {
        // 获取与当前线程绑定的Connection对象
        Connection connection = getCurrentConnection();
        conn.rollback();
        // 将与当前线程绑定的Connection对象从ThreadLocal中移除
        connectionThreadLocal.remove();
        conn.close();
    }

    // 提交事务
    public static void TransactionCommit() throws SQLException {
        // 获取与当前线程绑定的Connection对象
        Connection connection = getCurrentConnection();
        // 将与当前线程绑定的Connection对象从ThreadLocal中移除
        connectionThreadLocal.remove();
        conn.close();
    }
}
```

---

---

## <center>Servlet</center>

### Servlet的使用

```xml
Step1. 创建Servlet(常用方式):
    a. 工程 –> Java Resources –> src(classpath)目录下新建一个类继承HttpServlet类(或[Ctrl+N]搜索Servlet);
    b. 重写doGet()、doPost()方法(一般只写doGet(), 然后doPost()调用doGet());
    c. Servlet3.0以下需要配置web.xml; Servlet3.0及以上需要配置Java类注解@WebServlet(···);
<!-- 若使用eclipse自动生成的Servlet, 则请求名称需为创建的Servlet类名, 也可按Step2自行配置 -->
Step2. 配置Servlet(基础配置):
    a. Servlet3.0以下需在web.xml中增加如下内容:
        <servlet>
            <servlet-name>与servlet-mapping中相同即可, 一般写请求名称</servlet-name>
            <servlet-class>要执行的具体类的全类名</servlet-class>
        </servlet>
        <servlet-mapping>
            <servlet-name>与servlet中相同即可, 一般写请求名称</servlet-name>
            <!-- 此处"访问路径"指链接的"href"或表单的"action"中所设置的url, 区别于Struts2; -->
        	<url-pattern>访问路径(一般为"/+请求名称")</url-pattern>
        </servlet-mapping>
    b. Servlet3.0及以上需要为Servlet类添加注解@WebServlet(···)并在其中设置value="访问路径(一般为'/+请求名称')"
    	形如:@WebServlet(value="/+请求名称")

<!--Tip: 
    servlet中可以直接调用request及response对象
    out对象: PrintWriter out = response.getWriter();
    session对象: HttpSession session = request.getSession();
    application对象: ServletContext application=request.getServletContext();
-->
<!--注:
    在页面中通过连接或表但请求servlet, 实质是发出一次新的请求, 所以会丢失之前页面中存在的request域中的数据, 但可以在action中向request域中封装数据, 通过"请求转发"在其他servlet或jsp页面中提取封装的数据!
-->
```

---

### Servlet—过滤器

```jsp
<!-- 过滤器的作用是为了拦截客户端向服务端发送的请求, 以及服务端对客户端的响应, 对请求和响应做出验证, 验证通过则放行, 执行请求和响应的操作 -->
Step1. 创建Filter:
    a. 工程 –> Java Resources –> src(classpath)目录下新建一个类实现Filter接口(或[Ctrl+N]搜索Filter);
    b. 重写doFilter()的方法, 方法包含类型分别为ServletRequest(包含用户请求信息), ServletResponse(包含服务器响应信息), FilterChain(代表当前Filter对象, 用于执行放行操作)的三个参数, 在方法中写明验证逻辑;
    c. Servlet3.0以下需要配置web.xml; Servlet3.0及以上需要配置Java类注解@WebFilter(···);
<!-- 如使用eclipse自动生成的过滤器, 拦截路径默认为"/"+"过滤器类名", 也可按Step2自行配置 -->
Step2. 配置Filter(基础配置):
    a. Servlet3.0以下需在web.xml中增加如下内容:
        <filter>
            <filter-name>与"filter-mapping"标签中的名字相同即可</filter-name>
            <filter-class>过滤器的具体驱动类的全类名</filter-class>
        </filter>
        <filter-mapping>
            <filter-name>与"filter"标签中的名字相同即可</filter-name>
            <url-pattern>拦截路径("/*"为拦截所有内容)</url-pattern>
        </filter-mapping>
    b. Servlet3.0及以上需要在为Filter类添加注解@WebFilter(···)并在其中设置value="拦截路径("/*"为拦截所有内容)"
    	形如: @WebFilter(value="/*")  
```

> > ##### 例 :(本例过滤器创建的目的是为了检查当前用户是否处于登录状态, 若是则放行, 若不是则返回登录界面)

```jsp
<!--Filter类中的doFilter方法:-->
<%
    // 该拦截器创建的目的是为了检查当前用户是否处于登录状态, 若是则放行, 若不是则返回登录界面
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        // 获取jsp的request和response对象
        HttpServletRequest requestHttp = (HttpServletRequest) request;
        HttpServletResponse responseHttp = (HttpServletResponse) response;
        String loginPage = "login.jsp";
        String loginServlet = "loginServlet";
        HttpSession session = requestHttp.getSession();
        Object username = session.getAttribute("username");
        if (username != null) {
            chain.doFilter(request, response);
        } else {
            // 获取用户的请求路径
            StringBuffer requestUrl = requestHttp.getRequestURL();
            // 判断用户请求的是否为登录页面或由登录页面发送的请求, 是则放行, 不是则重定向到登录页面
            if (requestUrl.indexOf(loginPage) > -1 || requestUrl.indexOf(loginServlet) > -1) {
                System.out.println("验证通过");
                chain.doFilter(request, response);
            } else {
                System.out.println("验证未通过");
                responseHttp.sendRedirect(loginPage);
            }
        }
    }
%>
<!--loginServlet的doGet方法:-->
<%
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        if (username.equals("abc") && password.equals("123")) {
        	request.getSession().setAttribute("username", username);
        } else {
            System.out.println("返回登陆页。。。");
            response.sendRedirect("login.jsp");
        }
    }
%>
<!--login.jsp的表单内容:-->
    <form action="loginServlet" method="post">
        <input type="text" name="username">
        <input type="password" name="password">
        <input type="submit" value="登录">
    </form>
```

---

### Servlet监听器

```jsp
<!-- Servlet监听器用于监听 application > session > request 三种与对象的变化 -->
Step1. 创建Listener:
    a. 工程 –> Java Resources –> src(classpath)目录下新建一个类实现相应的监听器接口(或[Ctrl+N]搜索Listener);
        <!--
        1.监听域对象创建和销毁的接口:                           
            application ——> ServletContextListener                            
            session ——> HttpSessionListener
            request ——> ServletRequestListener
        2.监听域对象中属性变更的接口: 
            application ——> ServletContextAttributeListener
            session ——> HttpSessionAttributeListener
            request ——> ServletRequestAttributeListener
        -->
    b. 重写接口中的方法: 
        <!--
        1.监听域对象的创建和销毁的接口各包含两种方法分别监听域对象的创建与销毁(参数代表当前域对象的信息对象): 
            ServletContextListener: 
            contextInitialized(ServletContextEvent sce)
            contextDestroyed(ServletContextEvent sce)
            HttpSessionListener:
            sessionCreated(HttpSessionEvent se)
            sessionDestroyed(HttpSessionEvent se)
            ServletRequestListener:
            requestDestroyed(ServletRequestEvent sre)
            requestInitialized(ServletRequestEvent sre)
        2.监听域对象中属性的变更的接口各包含三种方法分别监听域对象中属性的添加、修改、与删除(参数代表当前操作域对象的属性): 
            ServletContextAttributeListener: 
            attributeAdded(ServletContextAttributeEvent scae)
            attributeReplaced(ServletContextAttributeEvent scae)
            attributeRemoved(ServletContextAttributeEvent scae)
            HttpSessionAttributeListener:
            attributeAdded(HttpSessionBindingEvent se)
            attributeReplaced(HttpSessionBindingEvent se)
            attributeRemoved(HttpSessionBindingEvent se)
            ServletRequestAttributeListener:
            attributeAdded(ServletRequestAttributeEvent srae)
            attributeReplaced(ServletRequestAttributeEvent srae)
            attributeRemoved(ServletRequestAttributeEvent srae)
        -->
Step2. 配置Listener(基础配置):
    a. Servlet3.0以下需在web.xml中增加如下内容:
        <listener>
        <listener-class>监听器的具体驱动类的全类名</listener-class>
        </listener>
    b. Servlet3.0及以上需要在为Listener类添加注解@WebListener
```

---

### Servlet—文件上传

```java
两个必需jar包: commons-fileupload-Xxx.jar、commons-fileupload-Xxx.jar;
Step1. 通过ServletFileUpload.isMultipartContent(request)返回一个boolean类型, 判断前台的form是否声明enctype="multipart/form-data";
Step2. 如果Step1为true, 创建文件上传环境;
Step3. 创建文件上传解析器, 解析文件上传环境中的内容;
Step4. 获取解析结果, 返回的是一个List<FileItem>集合, 每一个FileItem对应一个Form表单的输入项;
Step5. 对解析结果返回的List<FileItem>集合进行遍历, 判断每一个FileItem的类型是否为普通输入项;
Step6. 为普通输入项书写普通输入项的执行代码
Step7. 为文件输入项书写上传逻辑:在服务器上创建文件—>将本地文件上传到服务器上;
```

> #### 模板

```java
/*以下代码书写在doGet()方法中*/
/*Step1:*/    
    // 判断用户请求是否包含多媒体上传, 即前台form标签是否声明enctype="multipart/form-data"
    boolean isMultipart = ServletFileUpload.isMultipartContent(request);
    if (isMultipart) {
/*Step2:*/  
        // 创建文件上传环境
        DiskFileItemFactory factory = new DiskFileItemFactory();
        // 创建一个文件用于作为文件上传的缓冲区
        String tempPath = "文件缓冲路径";
        File tempFile = new File(tempPath);
        // 为文件上传环境添加缓冲区
        factory.setRepository(tempFile);
        // 设置缓冲区的大小
        factory.setSizeThreshold(int 单位字节);
        // 创建文件上传解析器
        ServletFileUpload upload = new ServletFileUpload(factory);
        // 设置单个文件上传的大小限制, 单位字节
        upload.setFileSizeMax(int 单位字节);
/*Step3:*/  
        // 创建文件上传解析器
        ServletFileUpload upload = new ServletFileUpload(factory);
        // 限制单个上传文件大小, 单位字节
        upload.setFileSizeMax(int 单位字节);
        // 限制总上传文件大小, 单位字节
        upload.setSizeMax(int 单位字节);
/*Step4:*/  
        // 获取解析结果, 返回的是一个List<FileItem>集合, 每一个FileItem对应一个Form表单的输入项
        List<FileItem> items = upload.parseRequest(request);
        if(items != null && items.size() > 0) {
        	for (FileItem item:items) {
/*Step5:*/  
				if(item.isFormField()){// 如果当前输入项为普通输入项
/*Step6:*/  
                    // 获取该输入项的名称, 即input的name属性值
                    String itemName = item.getFieldName();
                    // 获取该输入项的值,getString()中参数设置编码格式
                    String itemValue = item.getString("UTF-8");
                    System.out.println("普通输入项: " + itemName + "=" + itemValue);
                } else {// 如果当前输入项为文件输入项
/*Step7:*/  
                    // 获取文件名
                    // 先创建FiLe对象的原因是,由于某些浏览器获取的文件名是带路径的, 所以进一步截取, 只保留文件名
                    String fileName = new File(item.getName()).getName();
                    // 或fileName = fileName.substring(item.getName().lastIndexOf("\\")+1);
                    // 获取文件扩展名
                    String fileExt = fileName.substring(fileName.lastIndexOf(".")+1);
                    System.out.println("文件扩展名: " + fileExt);
                    // 获取文件的MIME类型
                    String fileType = item.getContentType();
                    System.out.println("文件MIME类型: " + fileType);
                    // 在服务器上创建存储路径
                    String serverFilePath = "文件的存放路径"
                    // 判断文件上传目录是否存在, 不存在则创建
                    File serverFileDirectory = new File(serverFilePath);
                    if (!serverFileDirectory.exists()) {
                        serverFileDirectory.mkdirs();
                    }
                    // 在服务器上创建完整文件路径
                    File serverFile = new File(serverFilePath,fileName);
                    // 开始上传
                    item.write(serverFile);
                    System.out.println(fileName + "上传成功！");
                }
            }
        }
    }
```

---

### Servlet—文件下载

```java
Step1. 设置响应头消息;
Step2. 创建输入流, 将文件转为输入流读到Servlet中;
Step3. 创建输出流, 通过输出流将已经转为输入流的文件输出给用户;
Step3. 关闭输出流与输入流;
```

> #### 模板

```java
/*以下代码书写在doGet()方法中*/
	String fileName = "文件名";
    String filePath = "文件在服务器的存放的路径";
/*Step1:*/
    // 设置响应头消息, 告知浏览器文件的MIME类型,"application/octet-stream"表示任意二进制文件
    response.setContentType("APPLICATION/OCTET-STREAM");
    // 或 response.addHeader("content-Type","application/octet-stream" );
    // 设置响应头消息, 告知浏览器下载文件, 以及要显示的文件名称
    response.addHeader("content-Disposition","attachement;filename="+fileName );
/*Step2:*/
    // Servlet通过文件的地址将文件转为输入流读到Servlet中
    InputStream inputStreamName = new FileInputStream(filePath + "\\" + fileName);
/*Step3:*/
    // 创建输出流, 通过输出流将已经转为输入流的文件输出给用户
    ServletOutputStream outputStreamName = response.getOutputStream();
    // 设置缓冲区, 单位字节
    byte[] bs = new byte[int 单位字节];
    int len=inputStreamName.read(bs); 
    while(len != -1) {
        outputStreamName.write(bs);
        len = inputStreamName.read(bs);
    }
/*Step3:*/
    // 关闭输出流与输入流
    outputStreamName.close();
    inputStreamName.close();
```

---

---

## <center>Struts2</center>

### Struts2的使用

``` jsp
Step1. 导入相应版本的Struts2的jar包(可从解压的示例文件的lib目录中复制):
    <!--必要jar包:
        asm-Xxx.jar
        asm-commons-Xxx.jar
        asm-tree-Xxx.jar
        commons-fileupload-Xxx.jar
        commons-io-Xxx.jar
        commons-lang-Xxx.jar
        commons-lang3-Xxx.jar
        commons-logging-Xxx.jar
        freemarker-Xxx.jar
        Javassist-Xxx-GA.jar
        log4j-api-Xxx.jar
        ognl-Xxx.jar
        struts2-core-Xxx.jar
        在较低版本的Struts2中无log4j-api-Xxx.jar, 且需导入xwork-core-Xxx.jar
    -->
```

```xml
Step2. 在web.xml中配置Struts2的过滤器(可从解压的示例文件的web.xml文件中复制):
    <filter>
        <filter-name>与"filter-mapping"中内容设置相同即可(一般设为struts2)</filter-name>
        <filter-class>过滤器的的具体驱动类的全类名</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>与"filter"中内容设置相同即可(一般设为struts2)</filter-name>
        <url-pattern>拦截路径(一般设置为"/*",即拦截所有内容)</url-pattern>
    </filter-mapping>
```

```java
Step3. 在src(classpath)目录下创建action(Java类):
    action编写有三种方式:
    /*
    一个action类中可以设置多个方法, 具体调用哪个需在struts.xml详细配置, 默认默认调用方法execute(), 返回值如果设置为"none", 则视为无返回值, 不需要在struts.xml为其配置result标签
    */
        1. 创建普通类, 这个类不继承任何类, 不实现任何接口:
            如:
            public class ActionDemo{

                public String execute(){
                	···
                }

                public String action1(){
                	···
                }

                public String action2(){
                	···
                }
            }
        2. 创建类, 实现接口 Action(需导入包com.opensymphony.xwork2.Action) // 该方式必须实现execute()方法
            如:
            public class ActionDemo implements Action{

                public String execute(){
                	···
                }

                public String action1(){
                	···
                }

                public String action2(){
                	···
                }
            }  
        3. 创建类, 继承类 ActionSupport (需导入包com.opensymphony.xwork2.ActionSupport)//推荐使用该方法
            如:
            public class ActionDemo extends ActionSupport{

                public String execute(){
                	···
                }

                public String action1(){
                	···
                }

                public String action2(){
                	···
                }
            } 
```

```xml
Step4. 在src(classpath)直接目录下创建并配置struts2的核心配置文件即"struts.xml": 
    a. 引入dtd约束(可从解压的示例文件的struts.xml文件中复制):
        <!--形如: 
            <!DOCTYPE struts PUBLIC
            "-//Apache Software Foundation//DTD Struts Configuration xxx//EN"
            "http://struts.apache.org/dtds/struts-xxx.dtd">
        -->

    b. 配置相关action: 
        <struts>
            <constant name="struts2的常量属性名" value="为常量属性设置属性值" />
            <!-- 
            通过constant标签可更改struts2的默认常量(字符编码等), 一个constant标签设置一种常量属性;
            查看struts2的默认常量:struts2-core-xxx.jar ——> org.apache.struts2 ——> default.properties;
            -->
            <package name="为该板块起名字" extends="要继承的包" namespace="与action中name属性值构成访问路径(默认为空)" strict-method-invocation="false">
            <!--package标签属性: 
                name ——> package标签的唯一标识
                extends ——> 要继承的package的name值, 多个包之间用"逗号"分隔, 一般设定为"struts-default";
                namespace ——> package的命名空间, 影响请求路径的搜索与页面的跳转; 一般设置为"/" + 链接的"href"或表单的"action"中所设置的url(不包含根目录)中最后一个"/"之前的内容;如果使用默认值, 则不需要考虑路径问题, 只要action存在就可以访问, 但含有多个package标签时, namespace为空的package标签的优先级最低, 即不同package标签存在相同的action, 会优先执行namespace不为空的package标签下的action;
                strict-method-invocation="false" ——> 目的是使action中可以使用通配符"*";
            -->
                <action name="请求名称" class="要执行的具体类的全类名" method="要调用的类中的方法名(默认为execute)">
                <!--action标签属性: 
                    name ——> action名称(请求名称), action中name可以使用通配符"*"进行配置, *可以为要执行的方法; 此处"请求名称"指链接的"href"或表单的"action"中所设置的url中最后一个"/"之后的内容, 区别于servlet;  
                    class ——> 对应的类的路径, 要执行的具体类的全类名
                    method ——> 要调用的类中的方法名, 可通过"{通配符的索引(从1开始)}"来设置要调用的类中的方法名;
                -->
                <result name="方法执行后的返回值" type="设定执行操作的方式(默认为转发dispatcher)">
                	根据返回值所要跳转的页面路径或执行其他"action"请求路径
                    <!--Tip: 
                        1. 如果路径为相对路径, 会在在相对路径前加上package标签的namespace构成跳转路径
                        2. 如果路径为绝对路径即以"/"开头, 则忽略package标签的namespace的设置
                    -->
                </result> 
                <!--result标签中type属性常见类型: 
                    dispatcher————>请求转发到一个页面(默认)
                    redirect—————>响应重定向到一个页面
                    chain————>一个action请求转发至另一个action(一般不用, 存在缓存问题)
                    redirectAction—————>一个action响应重定向至另一个action
                    stream————>文件下载
                -->
                <!-- 一个action标签中可以设置多个result标签 -->
                </action>
                <!-- 一个package标签中可以设置多个action标签 -->
            </package>
        </struts>

<!--命名空间namespace和请求路径的关系: 
假设请求路径为http://localhost:8080/projectName/path1/path2/path3/test.action, 访问过程如下: 
	1. 首先寻找namespace为/path1/path2/path3的package, 如果不存在这个package则执行步骤2; 如果存在这个package, 则在这个package中寻找名字为test的action, 当在该package下寻找不到action时就会直接跑到默认namaspace的package里面去寻找action, 如果在默认namaspace的package里面还寻找不到该action, 页面提示找不到action 

    2．寻找namespace为/path1/path2的package, 如果不存在这个package, 则转至步骤3; 如果存在这个package, 则在这个package中寻找名字为test的action, 当在该package中寻找不到action时就会直接跑到默认namaspace的package里面去找名字为test的action, 如果在默认namaspace的package里面还寻找不到该action, 页面提示找不到action 

    3．寻找namespace为/path1的package, 如果不存在这个package则执行步骤4; 如果存在这个package, 则在这个package中寻找名字为test的action, 当在该package中寻找不到action时就会直接跑到默认namaspace的package里面去找名字为test的action, 如果在默认namaspace的package里面还寻找不到该action, 页面提示找不到action 

    4．寻找namespace为/的package, 如果存在这个package, 则在这个package中寻找名字为test的action, 当在package中寻找不到action或者不存在这个package时, 都会去默认namaspace的package里面寻找action, 如果还是找不到, 页面提示找不到action。
-->
```

---

### Struts2—action获取Jsp对象

> #### Method1——使用ActionContext类获取jsp对象

```java
a. 使用ActionContext类获取jsp对象:
    // 获取ActionContext对象(可通过该对象向request中存储数据但不可获取数据)
    ActionContext context = ActionContext.getContext();
    // 获取response对象
    HttpServletResponse response = (HttpServletResponse) context.get(StrutsStatics.HTTP_RESPONSE);
    // 获取out对象     	   
    PrintWriter out = response.getWriter();
    // 获取request对象
    HttpServletRequest request = (HttpServletRequest)context.get(StrutsStatics.HTTP_REQUEST);
    // 获取session对象
    HttpSession session = request.getSession();
    // 获取application对象
    ServletContext application = (ServletContext) context.get(StrutsStatics.SERVLET_CONTEXT);
    // 获取request映射
    Map<String, Object> request = (Map<String, Object>) context.get("request");
    // 获取session映射
    Map<String, Object> session = context.getSession();
    // 获取application映射
    Map<String, Object> applation = context.getApplication();
/*
各映射可通过执行".put(String name,Object obj)"、".get(String name)"、".remove(String name)"向三种范围对象存储、获取以及删除数据, 注意区别于jsp对象！
*/
b. 使用ActionContext类获取表单数据:
    // 获取表单数据, key是表单输入项name属性值, value是输入的值
    Map<String, Parameter> params = context.getParameters();
    // 获取表单key值数组
    Set<String> keys = params.keySet();
    for (String key : keys) {
        //根据key得到value
        Parameter value = params.get(key);
        ···
    }
```

> #### Method2——使用ServletActionContext类获取jsp对象

```java
// 获取response对象     	   
HttpServletResponse response = ServletActionContext.getResponse();
// 获取out对象     	   
PrintWriter out = response.getWriter();
// 获取request对象
HttpServletRequest request = ServletActionContext.getRequest();
// 获取session对象
HttpSession session = request.getSession();
// 获取application对象
ServletContext application = ServletActionContext.getServletContext();
```

> #### 注意

```java
1. 无法通过request.getRequestDispatcher的请求转发的方式访问一个action！
2. 在页面中通过连接或表单访问action, 实质是发出一次新的请求, 所以会丢失之前页面中存在的request域中的数据, 但可以在action中向request域中封装数据, 通过"请求转发"在其他action或jsp页面中可以提取到封装的数据！
```

---

### Struts2—action封装表单提交数据

> #### Method1.1——属性封装(将表单数据封装到单一变量中)

```jsp
步骤:
    a. 声明访问权限为private的各成员变量属性(变量的名称和表单输入项name属性值一样)
    b. 通过Source –> Generate Getters and Setters为每个变量属性创建Getter和Setter方法
    例:
    action类actionDemo.Java:
    <%
        public class actionDemo extends ActionSupport{
            //变量的名称和表单输入项name属性值一样
            private String username;
            private String password;
            // 为每个变量属性创建Getter和Setter方法
            public String getUsername() {
            	return username;
            }
            public void setUsername(String username) {
            	this.username = username;
            }
            public String getPassword() {
            	return password;
            }
            public void setPassword(String password) {
            	this.password = password;
            }
            public String execute() throws Exception {
                ···
                System.out.print(username);
                System.out.print(password);
                return NONE;
            }
        }
    %>
    jsp中表单示例("注意input标签的name属性值"):
        <form action="actionName.action" method="post">
            username:<input type="text" name="username"/>
            <br/>
            password:<input type="text" name="password"/>
            <br/>
            <input type="submit" value="提交"/>
        </form>
```
> #### Method1.2——属性封装(将表单数据封装到Array数组中)

```jsp
步骤:
    a. 声明访问权限为private的Array数组(变量的名称和表单输入项name属性值一样); 
    b. 通过Source –> Generate Getters and Setters为每个变量属性创建Getter和Setter方法; 
    例:
    action类actionDemo.Java:
    <%
        public class actionDemo extends ActionSupport{
            //变量的名称和表单输入项name属性值一样
            private String[] users;
            // 为每个变量属性创建Getter和Setter方法
            public String[] getUsers() {
            	return users;
            }
            public void setUsers(String[] users) {
            	this.users = users;
            }
            @Override
            public String execute() throws Exception {
                ···
                for (String user : users) {
                	System.out.println(user);
                }
                return NONE;
            }
        }
    %>
    jsp中表单示例("注意input标签的name属性值"):
        <form action="actionName.action" method="post">
            username:<input type="text" name="users"/>
            <br/>
            password:<input type="text" name="users"/>
            <br/>
            <input type="submit" value="提交"/>
        </form>
```
> #### Method1.3——属性封装(将表单数据封装到List集合中)

```jsp
步骤:
    a. 声明访问权限为private的List集合(变量的名称和表单输入项name属性值一样); 
    b. 通过Source –> Generate Getters and Setters为每个变量属性创建Getter和Setter方法; 
    c. 在表单中的输入项name属性值后加上"[从0开始的索引]";
    例:
    action类actionDemo.Java:
    <%
        public class actionDemo extends ActionSupport{
            //变量的名称和表单输入项name属性值一样
            private List<String> listName = new ArrayList<String>();
            // 为List集合创建Getter和Setter方法
            public List<String> getListName() {
            	return listName;
            }
            public void setListName(List<String> listName) {
            	this.listName = listName;
            }
            @Override
            public String execute() throws Exception {
                ···
                for (String user:listName) {
                System.out.println(user);
            }
            	return NONE;
            }
        }
    %>
    jsp中表单示例("注意input标签的name属性值"):
        <form action="actionName.action" method="post">
            username:<input type="text" name="listName[0]"/>
            <br/>
            password:<input type="text" name="listName[1]"/>
            <br/>
            <input type="submit" value="提交"/>
        </form>

```
> #### Method1.4——属性封装(将表单数据封装到Map映射中)

```jsp
步骤:
    a. 声明访问权限为private的Map映射(变量的名称和表单输入项name属性值一样);
    b. 通过Source –> Generate Getters and Setters为每个变量属性创建Getter和Setter方法;
    c. 在表单中的输入项name属性值后加上"['key值']";
    例:
    action类actionDemo.Java:
    <%
    public class actionDemo extends ActionSupport{
        //变量的名称和表单输入项name属性值一样
        private Map<String, String> users;
        // 为每个变量属性创建Getter和Setter方法
        public Map<String, String> getUsers() {
        	return users;
        }
        public void setUsers(Map<String, String> users) {
        	this.users = users;
        }
        @Override
        public String execute() throws Exception {
            ···
            System.out.println(users.get("username"));
            System.out.println(users.get("password"));
            return NONE;
        }
    }
    %>
    jsp中表单示例("注意input标签的name属性值"):
        <form action="actionName.action" method="post">
            username:<input type="text" name="users['username']"/>
            <br/>
            password:<input type="text" name="users['password']"/>
            <br/>
            <input type="submit" value="提交"/>
        </form>
```
> #### Method2(推荐)——模型驱动封装(将表单数据封装到单一的实体类中)

```jsp
步骤:
    a. 创建一个实体类, 实体类中变量的名称和表单输入项name属性值一样;
    b. 创建action类实现接口 ModelDriven<T>("T"为a创建的实体类的名称);
    c. 在action里面创建实体类对象;
    d. 实现接口里面的方法 getModel方法, 并在方法中将上一步创建的的实体类对象返回;
    例:
    实体类User.Java:
    <%
        public class User {
            // 变量的名称和表单输入项name属性
            private String username;
            private String password;
            public String getUsername() {
            	return username;
            }
            public void setUsername(String username) {
            	this.username = username;
            }
            public String getPassword() {
            	return password;
            }
            public void setPassword(String password) {
            	this.password = password;
            }
        }
    %>
    action类actionDemo.Java:
    <%
        // 实现接口 ModelDriven<T>, 并引入实体类
        public class actionDemo extends ActionSupport implements ModelDriven<User>{
            // 创建实体类对象
            User user = new User();
            @Override
            public User getModel() {
                // 将创建的的实体类对象返回
                return user;
            }
            @Override
            public String execute() throws Exception {
                ···
                System.out.print(user.getUsername());
                System.out.print(user.getPassword());
                return NONE;
            }
        } 
    %>
    jsp中表单示例("注意input标签的name属性值"):
        <form action="actionName.action" method="post">
            username:<input type="text" name="username"/>
            <br/>
            password:<input type="text" name="password"/>
            <br/>
            <input type="submit" value="提交"/>
        </form>
```

> ####  Method3——表达式封装(将表单数据封装到实体类中, 可同时封装至多个不同的实体类)

```jsp
步骤:
    a. 创建一个实体类, 实体类中变量的名称和表单输入项name属性值一样;
    b. 在action里面"声明"实体类对象; ("注意是声明不是创建");
    c. 为声明的实体类对象创建Getter和Setter方法(Source –> Generate Getters and Setters);
    d. 在表单中的输入项name属性值前加上"声明的实体类对象.";
    例:
    <%
    实体类User.Java:
        public class User {
            // 变量的名称和表单输入项name属性
            private String username;
            private String password;
            public String getUsername() {
            	return username;
            }
            public void setUsername(String username) {
            	this.username = username;
            }
            public String getPassword() {
            	return password;
            }
            public void setPassword(String password) {
            	this.password = password;
            }
        }
    action类actionDemo.Java:
        public class actionDemo extends ActionSupport{
            // 声明实体类对象
            private User user;
            // 声明的实体类对象创建Getter和Setter方法
            public User getUser() {
            	return user;
            }
            public void setUser(User user) {
            	this.user = user;
            }
            @Override
            public String execute() throws Exception {
                ···
                System.out.print(user.getUsername());
                System.out.print(user.getPassword());
                return NONE;
            }
        }
    %>
    jsp中表单示例("注意input标签的name属性值"):
        <form action="actionName.action" method="post">
            username:<input type="text" name="user.username"/>
            <br/>
            password:<input type="password" name="user.password"/>
            <br/>
            <input type="submit" value="提交"/>
        </form>
```

> #### Method4——将数据封装到实体类后在封装到List集合中(将多组表单数据分别封装到实体类后, 在封装到List集合中)

```jsp
步骤:
    a. 创建一个实体类, 实体类中变量的名称和表单输入项name属性值一样;
    b. 在action里面"声明"一个List集合;
    c. 为List集合创建Getter和Setter方法(Source –> Generate Getters and Setters);
    d. 在表单中的输入项name属性值前加上"声明的的List集合[从零开始的索引].";
    例:
    <%
    实体类User.Java:
        public class User {
            // 变量的名称和表单输入项name属性
            private String username;
            private String password;
            public String getUsername() {
            	return username;
            }
            public void setUsername(String username) {
            	this.username = username;
            }
            public String getPassword() {
            	return password;
            }
            public void setPassword(String password) {
            	this.password = password;
            }
        }
    action类actionDemo.Java:
        public class actionDemo extends ActionSupport{
            // "声明"一个List集合
            private List<User> listName = new ArrayList<User>();
            // 为List集合创建Getter和Setter方法
            public List<User> getListName() {
            	return listName;
            }
            public void setListName(List<User> listName) {
            	this.listName = listName;
            }
            @Override
            public String execute() throws Exception {
                ···
                User user1 = listName.get(0);
                User user2 = listName.get(0);
                String username1 = user1.getUsername();
                String username2 = user2.getUsername();
                System.out.println(username1);
                System.out.println(username2);
                return NONE;
            }
        }
    %>
    jsp中表单示例("注意input标签的name属性值"):
        <form action="actionName.action" method="post">
            username:<input type="text" name="listName[0].username"/>
            <br/>
            password:<input type="password" name="listName[0].password"/>
            <br/>
            username:<input type="text" name="listName[1].username"/>
            <br/>
            password:<input type="password" name="listName[1].password"/>
            <br/>
            <input type="submit" value="提交"/>
        </form>
```

> #### Method5——将数据封装到实体类后在封装到Map映射中(将多组表单数据分别封装到实体类后, 在封装到Map中)

```jsp
步骤:
    a. 创建一个实体类, 实体类中变量的名称和表单输入项name属性值一样;
    b. 在action里面"声明"一个Map映射;
    c. 为Map映射创建Getter和Setter方法(Source –> Generate Getters and Setters);
    d. 在表单中的输入项name属性值前加上"声明的的Map映射['key值'].";
    例:
    <%
    实体类User.Java:
        public class User {
            // 变量的名称和表单输入项name属性
            private String username;
            private String password;
            public String getUsername() {
            	return username;
            }
            public void setUsername(String username) {
            	this.username = username;
            }
            public String getPassword() {
            	return password;
            }
            public void setPassword(String password) {
            	this.password = password;
            }
        }
    action类actionDemo.Java:
        public class actionDemo extends ActionSupport{
            // "声明"一个Map映射
            private Map<String, User> mapName;
            // 为Map映射创建Getter和Setter方法
            public Map<String, User> getMapName() {
            	return mapName;
            }
            public void setMapName(Map<String, User> mapName) {
            	this.mapName = mapName;
            }	
            @Override
            public String execute() throws Exception {
                ···
                User user1 = mapName.get("user1");
                User user2 = mapName.get("user2");
                String username1 = user1.getUsername();
                String username2 = user2.getUsername();
                System.out.println(username1);
                System.out.println(username2);
                return NONE;
            }
        }
    %>
    jsp中表单示例("注意input标签的name属性值"):
        <form action="actionName.action" method="post">
            username:<input type="text" name="mapName['user1'].username"/>
            <br/>
            password:<input type="password" name="mapName['user1'].password"/>
            <br/>
            username:<input type="text" name="mapName['user2'].username"/>
            <br/>
            password:<input type="password" name="mapName['user2'].password"/>
            <br/>
            <input type="submit" value="提交"/>
        </form>
```

---

### Struts2—拦截器

```jsp
<!--
拦截器的使用是为了拦截用户向action发送的请求, 对请求进行验证, 验证通过方可执行action中的方法！！！
区别与过滤器, 拦截器只对action起作用, 对jsp, html等页面请求不起作用！！！
-->
Step1. 创建拦截器的类, 继承MethodFilterInterceptor类;
Step2. 在拦截器中重写doIntercept方法并声明ActionInvocation值, 在方法中写拦截器逻辑过程;
Step3. 若验证通过返回"ActionInvocation值.invoke()"即执行放行操作, 否则返回一个字符串, 效果同action类的返回值相同; 
Step4-1. 在struts.xml中配置拦截器(注册拦截器)—— 针对action标签的设置;
    a. 在要拦截的action标签所在的package标签里面声明拦截器;
        <interceptors>
            <interceptor name="设置拦截器的名称" class="该拦截器所在的具体驱动类的全类名"></interceptor>
            ···
            <!-- 一个interceptors标签下可以声明多个拦截器, 即使用多个interceptor标签 -->
        </interceptors>
    b. 在具体的action标签中重新引入struts2的默认拦截器;
    	<interceptor-ref name="defaultStack"></interceptor-ref>
    c. 在具体的action标签中引入声明的拦截器;
    	<interceptor-ref name="interceptors标签下声明的拦截器名称"></interceptor-ref>
    d. 在action标签中引入的拦截器默认会拦截该action类中所有的方法, 如果有不想拦截的方法, 需要在"interceptor-ref"标签下设置name="excludeMethods"的"param"标签添中添加不拦截的方法名;
        <interceptor-ref name="interceptors标签下声明的拦截器名称">
        <param name="excludeMethods">方法名1, 方法名2, ···</param>
        </interceptor-ref>    

Step4-2. 在struts.xml中配置截器(注册拦截器)—— 针对package标签的设置;
    a. 在package标签里面声明拦截器, 并配置拦截器栈
        <interceptors>
            <!-- 声明拦截器 -->
            <interceptor name="设置拦截器的名称" class="该拦截器所在的具体驱动类的全类名"></interceptor>
            <!-- 一个interceptors标签下可以声明多个拦截器, 即使用多个interceptor标签 -->
            ···
            <!-- 配置拦截器栈 -->
            <interceptor-stack name="设置拦截器栈的名称">
                <!-- 引入struts2的默认拦截器 -->
                <interceptor-ref name="defaultStack"/>
                <!-- 引入自定义的拦截器, 可引入多个 -->
                <interceptor-ref name="interceptors标签下声明的拦截器名称"></interceptor-ref>
            </interceptor-stack>
        </interceptors>
    b-1. 在package标签里将默认拦截器栈修改为我们自己配置的拦截器栈;
        <default-interceptor-ref name="<interceptors>中配置的拦截器栈的名称"/>
        该方式配置的拦截器会拦截该package下所有action的所有方法, 如果有不想拦截的方法, 需要在标签"interceptor-stack"下"interceptor-ref"标签下设置name="excludeMethods"的"param"标签添中添加不拦截的方法名;
            <interceptor-ref name="interceptors标签下声明的拦截器名称">
            <param name="excludeMethods">方法名1, 方法名2, ···</param>
        </interceptor-ref>   
    b-2. 也可在在具体的action标签中引入配置的拦截器栈
        <interceptor-ref name="<interceptors>中配置的拦截器栈的名称"></interceptor-ref>
        该方式配置的拦截器会拦截该action中的所有方法, 如果有不想拦截的方法, 需要在"interceptor-ref"标签下设置name="excludeMethods"的"param"标签添中添加不拦截的方法名;
            <interceptor-ref name="<interceptors>中配置的拦截器栈的名称">
            <param name="excludeMethods">方法名1, 方法名2, ···</param>
        </interceptor-ref>
```

> > ##### 例:(本例拦截器创建的目的是为了检查当前用户是否处于登录状态, 若是则放行, 若不是则返回登录界面)


```jsp
Step1-Step2-Step3(构建拦截器类):
    <%
        // Step1;
        public class loginintercept extends MethodFilterInterceptor{
            @Override
            // Step2;
            protected String doIntercept(ActionInvocation invocation) throws Exception {
                HttpServletRequest request = ServletActionContext.getRequest();
                HttpSession session = request.getSession();
                Object user = session.getAttribute("username");
                // Step3;
                if (user != null) {
                	return invocation.invoke();
                } else {
                	return "loginFail";
                }
            }
        }
    %>
Step4-Step5(配置struts.xml): 
    <struts>
        <package name="interceptorTest" extends="struts-default" namespace="/" strict-method-invocation="false">
            <!-- a.在的package标签里面声明拦截器 -->
            <interceptors>
            	<interceptor name="loginintercept" class="interceptor.loginintercept"></interceptor>
            </interceptors>
            <action name="login_*" class="interceptorAction.logIn" method="{1}">
                <!-- b.引入拦截器 -->
                <interceptor-ref name="loginintercept">
                    <!-- 不拦截Check方法 -->
                    <param name="excludeMethods">Check</param>
                </interceptor-ref>			
                <!-- c.重新引入struts2的默认拦截器 -->
                <interceptor-ref name="defaultStack"></interceptor-ref>
                <result name="loginSuccess">/hello.jsp</result>
                <result name="loginFail">/login.jsp</result>   
            </action>    
        </package>
    </struts>
例子中的action类:
    <%
        public class logIn {
            public String Check() {
                HttpServletRequest request = ServletActionContext.getRequest();
                HttpSession session = request.getSession();
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                if (username.equals("2283592023") && password.equals("52Cy0820.")) {
                    session.setAttribute("username", username);
                    return "loginSuccess";
                } else {
                    return "loginFail";
                }		
            }
        }
    %>
login.jsp的表单内容:
    <form action="login_Check.action" method="post">
        <input type="text" name="username">
        <input type="password" name="password">
        <input type="submit" value="登录">
    </form>
```

---

### Struts2—值栈

> #### 理解

```java
a. 值栈是Struts2的一种存储机制, 可以类比于jsp中的request域对象; 在action里面把数据放到值栈里面, 可以在通过action转发的页面中获取到值栈中的数据
b. 每个action对象里面都会有唯一一个值栈对象！！！
c. 先进栈的对象位于栈底, 后进栈的对象位于栈顶！！！
```

> #### 向值栈中存放数据(三种方式)

> > ##### 方式1

```java
// 获取值栈对象
ValueStack stack = ActionContext.getContext().getValueStack();
// 通过值栈对象中的push方法向值栈中存放数据
stack.push(Object value);

/*Tip:
    该方式每调用一次push方法, 都将在值栈中开辟一个新的空间来存放数据
*/
```

> > ##### 方式2

```java
// 获取值栈对象
ValueStack stack = ActionContext.getContext().getValueStack();
// 通过值栈对象中的set方法向值栈中存放数据
stack.set(String key, Object value);

/*Tip:
    该方式将数据封装到一个HashMap中在存放到值栈中, 相邻的set方法存储的数据, 将存放到同一个HashMap中(例如: 前两次向值栈中存放数据都是通过set方法, 第三次调用的是push方法, 第四次再次调用set方法; 最终, 前两次的数据存放在同一个HashMap中, 第四次的数据单独存放在一个HashMap中, 两个HashMap之间被第三次通过push方法存放的对象间隔)
*/
```

> > ##### 方式3

```java
Step1. 在action声明成员变量并未该成员变量创建getter方法
Step2. 执行方法里面为成员变量赋值(也可以在声明变量时直接赋值)
/*Tip:
该方式直接将该成员变量存进了值栈中原有的action的引用对象中, 这种方式的好处就是避免了值栈中存储空间的浪费, 不用为每个值都分别设置存储空间
*/
```

> #### jsp页面获取值栈中的数据

```jsp
<!-- 引入Struts2的标签库 -->
<%@ taglib uri="/struts-tags" prefix="s">
```

```jsp
<!-- 获取push方法存放的数据 -->
<s:property value="[数据在值栈中的索引(从栈顶开始从0开始)].top"/>
```

```jsp
<!-- 获取set方法存放的数据 -->
<s:property value="set方法中的key值"/>
```

```jsp
<!-- 获取成员变量方法存放的数据 -->
<s:property value="成员变量的属性名"/>
```

```jsp
<!--Tip: 若值栈中存放的是复杂对象<s:property>标签中的value支持级联属性-->
```

---

### Struts2—文件上传

```jsp
Step1. 在action定义三个成员变量"上传文件"(File类型,且名称需要是"表单里面文件上传项的name值")、"文件名称"(String类型,名称为"表单里面文件上传项的name值"+"FileName")以及"文件MIME类型"(String类型,名称为"表单里面文件上传项的name值"+"ContentType",该变量可以省略);
Step2. 为两个成员变量属性创建Getter和Setter方法(Source –> Generate Getters and Setters);
Step3. 在具体的action的方法里面写上传逻辑:在服务器上创建文件—>将本地文件拷贝到服务器上;
Step4. 如果对文件上传大小的限制超过2M,则需在struts.xml中配置常量"struts.multipart.maxSize":
	<constant name="struts.multipart.maxSize" value="单位字节(-1表示没有限制)"/>
Step5. 如果对文件上传类型有限制需求,则需在struts.xml中配置action下的默认拦截器:
    <interceptor-ref name="defaultStack">
        <param name="fileUpload.allowedExtensions">文件扩展名1,文件扩展名2,···</param>
        <param name="fileUpload.allowedTypes">MIME类型1,MIME类型2,···</param>
        <!-- 以上两种限制方式取其一即可 -->
    </interceptor-ref> 

<!--Tip: 
    1. 当上传的文件类型不符合要求或文件大小超出限制时, action默认返回"input"结果, 因此涉及文件上传常需要为该结果设置跳转页面！！！
    2. 有时不同版本的tomcat与struts2之间存在兼容性问题, tomcat中server.xml的<Connector>标签设置中有一属性属性为"maxSwallowSize" 默认为2097152即2M, 如果上传文件的实际大小减去Struts2设置的大小得到的值超过该设置的大小, 会出现文件超过大小限制无法跳转至指定"input"页面, 浏览器提示连接已重置, 无法访问此网站的问题; 若出现此问题需要将"maxSwallowSize"设置为较大的范围或直接设置为"-1"即没有限制
-->
```
> #### 模板

``` jsp
Step1-Step2-Step3(设置文件上传的action):
    <%
        public class fileUploadDemo extends ActionSupport{
            // step1;
            private File upload;
            private String uploadFileName;
            private String uploadContentType;
            // step2;
            public File getUpload() {
            	return upload;
            }
            public void setUpload(File upload) {
            	this.upload = upload;
            }
            public String getUploadFileName() {
            	return uploadFileName;
            }
            public void setUploadFileName(String uploadFileName) {
            	this.uploadFileName = uploadFileName;
            }
            public String getUploadContentType() {
            	return uploadContentType;
            }
            public void setUploadContentType(String uploadContentType) {
            	this.uploadContentType = uploadContentType;
            }
            @Override
            public String execute() throws Exception {
                // step3;
                String serverFilePath = "文件的存放路径"
                // 判断文件上传目录是否存在, 不存在则创建(该部可以省略, struts的FileUtils.copyFile方法会自行判断并创建目录及文件)
                File serverFileDirectory = new File(serverFilePath);
                if (!serverFileDirectory.exists()) {
                	serverFileDirectory.mkdirs();
                }
                File serverFile = new File(serverFilePath, uploadFileName);
                //把上传文件复制到服务器文件里面
                FileUtils.copyFile(upload, serverFile);
                return NONE;
            }
        }
    %>
Step4(更改struts.xml, 此例将文件大小限制为10M即10485760B):
    <constant name="struts.multipart.maxSize" value="10485760"/>
Step5(设置文献类型的限制, 此例设置为只允许上传png,jpg类型的图片):
    <action name="fileUpload" class="file.fileUploadDemo" >
        <interceptor-ref name="defaultStack">
            <param name="fileUpload.allowedExtensions">png,jpg</param>
            <param name="fileUpload.allowedTypes">image/png,image/jpeg</param>
        </interceptor-ref>    
    </action>
html表单样式:
    <form action="fileUpload.action" method="post" enctype="multipart/form-data">
        <input type="file" name="upload"/>
        <br/>
        <input type="submit" value="提交"/>
    </form> 
```

---

### Struts2—文件下载

```jsp
Step1. 在action定义两个成员属性"文件输入流"(InputStream类型)以及"文件名称"(String类型);
Step2. 为两个成员变量属性创建Getter方法(Source –> Generate Getters and Setters);
Step3. 在具体的action的方法里面为两个成员属性赋值;
Step4. 在struts.xml中配置result标签:
    <result name="ancton返回值" type="stream">
        <!-- 设置缓冲区大小 -->
        <param name="bufferSize">单位字节</param>
        <param name="inputName">action中文件输入流的名称</param>
        <!-- 设置响应头消息, 告知浏览器文件的MIME类型 -->
        <param name="contentType">application/octet-stream</param>
        <!-- 设置响应头消息, 告知浏览器下载文件, 以及要显示的文件名称 -->
        <param name="contentDisposition">attachment;filename=${action中文件名称}</param>
    </result>
<!--Tip: Step1、Step2是为了Step4中struts.xml可以通过get方法获取action中的两个成员属性的值 -->
```
> #### 模板
```jsp
Step1-Step2-Step3(设置文件下载的action):
    <%
        public class fileDownloadDemo extends ActionSupport{
            // step1;
            private InputStream inputStreamName;
            private String fileName;
            // step2;
            public InputStream getInputStreamName() {
            	return inputStreamName;
            }
            public String getFileName() {
            	return fileName;
            }
            @Override
            public String execute() throws Exception {
                // step3;
                fileName = "文件名";
                // 当fileName存在中文时, 必须进行转码
                fileName = URLEncoder.encode(fileName, "UTF-8");
                String filePath = "文件在服务器的存放的路径";
                // 创建文件输入流, 将文件从服务器下载到本地
                inputStreamName = new FileInputStream(filePath + "\\" + fileName); 
                return SUCCESS;
            }
        }
    %>
Step4(设置struts.xml中的result标签):
    <result name="success" type="stream">
        <param name="bufferSize">1024</param>
        <param name="inputName">inputStreamName</param>
        <param name="contentType">application/octet-stream</param>
        <param name="contentDisposition">attachment;filename=${fileName}</param>
    </result>
```

---

---
## <center>Hibernate</center>

### Hibernate配置

> #### Step1.引入必要的jar包

```java
/*
1. Hibernate官方文件"lib/required"目录下的所有jar包
2. 数据库驱动jar
*/
```

> #### Step2.创建Hibernate核心配置文件(**一般命名为hibernate.cfg.xml, 且必须建立在src(classpath)目录下**)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--引入dtd约束, 可在jar包的hibernate-core-Xxx.final.jar包的最下面寻找, 形式如下-->
<!DOCTYPE hibernate-configuration PUBLIC
	"-//Hibernate/Hibernate Configuration DTD Xxx//EN"
	"http://www.hibernate.org/dtd/hibernate-configuration-Xxx.dtd">
<hibernate-configuration>
	<session-factory>
        <!-- 配置数据库信息 -->
        <property name="hibernate.dialect">指定SQL方言类的全类名(如: org.hibernate.dialect.MySQL[57|8]Dialect)</property>
        <property name="hibernate.connection.driver_class">具体驱动类的全类名</property>
        <property name="hibernate.connection.url">数据库连接字符串</property>
        <property name="hibernate.connection.username">数据库用户名</property>
        <property name="hibernate.connection.password">数据库密码</property>
        <!-- 其他配置信息(可在Hibernate官方文件project/etc目录下的hibernate.properties.template文件中的"Miscellaneous Settings"板块查看, 本处只添加三个常用调试设置) -->
        <property name="hibernate.show_sql">true</property> <!-- 在控制台显示执行的sql语句 -->
        <property name="hibernate.format_sql">true</property> <!-- 格式化sql语句 -->
        <property name="hibernate.hbm2ddl.auto">update</property> <!-- 开启自动建表功能 -->
        <!-- 加载映射文件, 可加载多个 -->
        <mapping resource="xml映射文件路径(相对路径)"/>
        <!-- 加载映射注解类, 可加载多个 -->
		<mapping class="注解类的全类名"/>
	</session-factory>
</hibernate-configuration>
```

---
### Hibernate配置数据源(连接池)

```java
Hibernate支持的数据源(连接池)有三种, 分别是"JDBC(hibernate自维护)"、"C3p0"、"Proxool"、"JNDI"
```

> #### 配置JDBC(hibernate自维护)数据源

```xml
<!-- 在Hibernate核心配置文件中设置数据源的属性: -->
<property name="hibernate.connection.pool_size">连接池中允许保持空闲状态的最大连接数量, 默认1</property>
```

> #### 配置C3P0数据源

```java
/*导入Hibernate官方文件"lib/optional/c3p0"目录下的所有jar包*/
```

```xml
<!-- 在Hibernate核心配置文件中设置C3P0数据源的属性: -->
<!-- 不同版本的hibernate的"C3P0ConnectionProvider"类的全类名不同 -->
<property name="hibernate.connection.provider_class">org.hibernate.c3p0.internal.C3P0ConnectionProvider</property>
<property name="hibernate.c3p0.min_size">连接池中允许保持空闲状态的最小连接数量, 默认2</property>
<property name="hibernate.c3p0.max_size">连接池中允许保持空闲状态的最大连接数量, 超过的空闲连接将被释放, 默认2</property>
<property name="hibernate.c3p0.max_statements">缓存PreparedStatement对象的数量, 默认100</property>
<property name="hibernate.c3p0.timeout">连接的最大空闲时间(单位秒), 连接池中空闲时间超过该设置的连接将会被释放, 默认5000</property>
<property name="hibernate.c3p0.idle_test_period">检查连接池中所有空闲连接的间隔时间(单位秒), 通过比较池中连接最后一次被使用时间和当前时间的时间差来和timeout做对比, 进而决定是否销毁这个连接对象, 默认3000(不可大于timeout的设置)</property>
<property name="hibernate.c3p0.acquire_increment">当数据库连接池中的连接耗尽时, 同一时刻获取多少个新的数据连接, 默认2</property>
```

> #### 配置Proxool数据源

```java
/*导入Hibernate官方文件"lib/optional/proxool"目录下的所有jar包*/
/*在src(classpath)目录创建并配置Proxool的xml配置文件, 一般命名为:proxoolconf.xml*/
```

```xml
<!-- 在Hibernate核心配置文件中引入Proxool数据源: -->
<!-- 不同版本的hibernate的"ProxoolConnectionProvider"类的全类名不同 -->
<property name="hibernate.connection.provider_class">org.hibernate.proxool.internal.ProxoolConnectionProvider</property>
<property name="hibernate.proxool.pool_alias">Proxool的xml配置文件中"proxool"标签下"alias"标签的内容</property>
<property name="hibernate.proxool.xml">Proxool的xml配置文件路径(相对路径)</property>
```

> #### 配置JNDI数据源

```xml
<!-- 在Hibernate核心配置文件中引入JNDI数据源: -->
<property name="connection.datasource">服务器的JNDI目录/context.xml中Resource标签的name值</property>

<!--Tip:
    1. tomcat服务器JNDI目录为java:/comp/env
    2. 使用JNDI数据源不可以在Hibernate核心配置文件中设置数据库的连接信息, 否则会由于冲突而报错
-->
```

---
### Hibernate的使用

> #### 配置数据库表与实体类的对应关系

> > ##### Step1.创建与数据库表相对应的实体类(最好实现序列化接口Serializable)

```java
// 类名————表名(推荐)
// 各成员属性名—————表中各属性名(推荐)
// 为各成员属性声明setter与getter方法

"实体类属性建议不使用基本数据类型, 使用基本数据类型对应的包装类"
"hibernate要求数据库表至少有一个主键"
```

> > ##### Step2_1(xml版).创建xml映射文件并在核心配置文件中引入该映射文件(文件名一般为"表名+hbm.xml")

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!--引入dtd约束, 可在jar包的hibernate-core-Xxx.final.jar包的最下面寻找, 形式如下-->
<!DOCTYPE hibernate-mapping PUBLIC 
    "-//Hibernate/Hibernate Mapping DTD Xxx//EN"
    "http://www.hibernate.org/dtd/hibernate-mapping-Xxx.dtd">
<hibernate-mapping>
	<class name="实体类的全类名" table="数据库表名">
        
		<!-- 单一主键配置 -->
		<id name="实体类中主键对应的属性名" column="sql中主键对应的字段名">
			<generator class="主键生成策略"/>
      <!-- 一但设置了主键生成策略, 则每条数据的主键值将由hibernate自动生成, 不受使用者管理(自行管理主键可不设置该属性) -->
            <!--主键生成策略常用的两个值:
                1. native: 根据使用的数据库帮选择适合的主键自增策略(要求主键为数值型)
                2. uuid: 由hibernate生成一段32为的十六进制字符串作为主键字段(要求主键为字符型)
			-->
		</id>
        <!-- 联合主键配置(使用联合主键的前提是实体类必须实现序列化接口Serializable, 同时最好重写实体类(涉及各主键属性)的equals()和hashCode()方法)-->
        <composite-id>
			<key-property name="实体类中主键对应的属性名" column="sql中主键对应的字段名"/>
			···
		</composite-id>
        <!-- 非主键字段配置 -->
		<property name="实体类中非主键对应的属性名" column="sql中主键对应的字段名" ></property>
			···
        <!-- Tip: 
            1. 当实体类中属性名与数据库表中属性名保持一致时, 可以省略"column"属性
            2. 除"name"、"column"外还有很多其他属性, 如type属性, 用于指定数据映射类型, "integer"、"string"等, 可省略该配置, 由hibernate自动识别; 再例如unique属性, 决定是否对该字段设置唯一约束, 默认"false"
 		-->
	</class>
</hibernate-mapping>
```

> > ##### Step2_2(注解版).按需求为实体类添加下列注解并设置注解的各属性

|                常用注解                |  作用对象  | 等同于xml映射文件的标签或属性 |
| :------------------------------------: | :--------: | :---------------------------: |
|                @Entity                 |     类     |           \<class\>           |
|                 @Table                 |     类     |   \<class\>标签的table属性    |
|                  @Id                   |  主键属性  |   \<id\>、\<composite-id\>    |
| @GeneratedValue与@GenericGenerator联用 |  主键属性  |         \<generator\>         |
|                @Column                 | 非主键属性 |      各标签的column属性       |
|                 @Type                  |    属性    |  \<property\>标签的type属性   |

```java
/*注解的常用属性如下:*/

/*@Table:
    name ——> 实体类对应的数据库表名
*/

/*@GeneratedValue:
    generator ——> @GenericGenerator的name属性值
*/

/*GenericGenerator:
    name ——> 自定义名称
    strategy ——> 要使用的主键生成策略, 如"native"、"uuid"等
*/

/*@Column:
    name ——> 属性所对应表中的字段名, 若不设置则默认属性名与字段名相同
    unique  ——> 决定是否对该字段设置唯一约束, 默认false
*/

/*@Type:
type ——> 用于指定数据映射类型, "integer"、"string"等, 可省略该配置, 由hibernate自动识别
*/
```

> #### Java操作代码

```java
// 1. 加载配置文件
    Configuration cfg = new Configuration();
    cfg.configure("核心配置文件路径");
    /*若核心配置文件名为"hibernate.cfg.xml", 且建立在"src(classpath)直接目录"下, 可直接通过cfg.configure()加载*/
// 2. 创建SessionFactory对象, 相当于创建一个连接池
    SessionFactory sessionFactory = cfg.buildSessionFactory();
// 3. 获取Session与数据库建立连接, 当于jdbc连接数据库中的connection对象
    Session session = sessionFactory.openSession();
// 4. 开启事务
    Transaction tx = session.beginTransaction();
    // 此处相当于执行如下代码: 
    // Transaction tx = session.getTransaction();
    // tx.begin();
// 5. 写具体逻辑(CRUD操作)
		try {
			··· // 操作代码(后期讲解)
// 6. 提交事务
			tx.commit();
		} catch (Exception e) {
            e.printStackTrace();
			tx.rollback(); // 程序发生异常进行事务回滚
		} finally {
// 7. 关闭资源
			session.close();
            sessionFactory.close(); // web项目一般不会关闭sessionFactory, 并且sessionFactory对象全局创建一次！
		}
```
---

### Hibernate实体对象的四大状态

> #### 临时(瞬时)态(Transient)

```java
创建Session后, 由new操作符创建, 且尚未与Hibernate Session关联的对象
```

> #### 持久态(Persistent)

```java
指得是与Hibernate Session关联并存放至hibernate一级缓存中的对象, 即经过"增"、"改"、"查"操作进而存放到一级缓存的对象:
    "增" : 对象由"临时态"转变为"持久态";
    "改" : 对象由"瞬时态"转变为"持久态" 或 由"旧持久态"转变为"新持久态";
    "查" : 对象由"数据库"提取至"缓存"从而转变为"持久态";
持久态的对象如果在事务提交前发生改变, 缓存中对应的数据也随之发生改变, 在事务提交后, 对象的变化也将被提交至数据库, 表中的记录也会做出相应的改变
```

> #### 游离(脱管)态(Detached)

```java
持久态的对象被从缓存中清除或所在的Session被关闭后或, 对象由"持久态"转变为"游离态";
```

> #### 删除态(Removed)

```java
经过"删"操作的对象, 即调用Session的delete方法之后的对象: 
    "new创建" ——> "删" : 对象由"临时态"转变为"删除态"
    "查" ——> "删" : 对象由"数据库"提取至"缓存"从而转变为"持久态"在转变为"删除态"(同时缓存中的数据也将被删除)
```

---

### Hibernate增删改查(CRUD)

> #### 增删改

> > ##### 增

```java
void Session对象.save("表对应的实体类对象"); // 若将单一主键交由hibernate管理, 则实体类对象对象中不需要设置主键信息, 即便设置也将被忽略!
void Session对象.persist("表对应的实体类对象"); // 若将单一主键交由hibernate管理, 则实体类对象对象中不可以设置主键信息, 否则会报错！

/*注意:
    当设置主键自动增长且将其交由hibernate管理时, 执行save或persist方法会立刻向数据库发送insert语句(为了给数据添加主键信息), 而不是在事务提交时才发送sql语句, 此时不需要提交事务, 当Session关闭时也可完成数据的插入操作
*/
```
> > ##### 删

```java
void Session对象.delete("表对应的实体类对象"); // 实体类对象对象中只需要设置主键信息, 根据主键信息删除对应的数据; 要确保数据库中确实包含该主键对应的数据, 否则会报错！
```

> > ##### 改

```java
void Session对象.update("表对应的实体类对象"); // 实体类对象对象中必需设置主键信息并确保数据库中确实包含该主键对应的数据, 而一级缓存中不能包含相同主键对应的"其他"实体类对象, 否则会报错！

/*Tip:
	不能试图通过该方式修改主键字段值, 否则会报错
*/
```

> > ##### 增或改

```java
void Session对象.saveOrUpdate("表对应的实体类对象"); // 若实体类中不包含主键信息, 调用save方法; 若包含主键信息, 则查看数据库中是否有该主键信息对应的记录, 若无该主键信息对应的记录, 则调用save方法(当主键生成策略由hibernate管理, 且"非"主键自增策略, 则报错); 若有该主键信息对应的记录且存在非主键字段与当前实体类不同, 调用update方法！
Object Session对象.merge("表对应的实体类对象"); // 若实体类中不包含主键信息, 调用persist方法; 若包含主键信息, 则查看数据库中是否有该主键信息对应的记录, 若无该主键信息对应的记录, 则忽略主键信息调用persist方法; 若有该主键信息对应的记录且存在非主键字段与当前实体类不同, 调用update方法！

/*执行update方法的区别:
    在操作持久态(Persistent)的数据时, 二者没有区别; 在操作瞬时态(Transient)或脱管态(Detached)的数据时, saveOrUpdate是将原操作对象转换为持久态(Persistent); 而merge是先调用select方法查找对应的主键数据, 重新返回一个实体类对象, 并将原操作对象的各属性赋值给新生成的实体类对象, 并将新生成的对象转变为持久态(Persistent), 而原操作对象保持之前的状态不变
*/
```

> #### 查

> > ##### 根据主键查询单条数据

```java
实体类 Session对象.get("实体类(表).class","单一主键值"|"包含联合主键信息的实体类对象"); 
实体类 Session对象.load("实体类(表).class","单一主键值"|"包含联合主键信息的实体类对象"); 

/*区别:
    1. get方法执行后立刻向数据库发送查询语句, 根据主键信息将查到的数据封装至实体类, 并返回实体类对象; 而load方法执行后不会立刻向数据库发送查询语句, 而是先返回一个实体类的代理对象, 当使用改对象时, 才会向数据库发送查询语句, 根据主键信息将查到的数据封装至实体类代理对象, 对代理对象进行初始化
    2. load方法要求进行查询的主键信息必须存在于数据库中, 否则会报错
*/
```
> > ##### 本地SQL查询: 语句查询

```java
/*SQL语句的占位符使用不同于jdbc*/
SQL语句中使用占位符形式为"?+数值索引"或":+别名", 需要注意的是"数值索引之间必须连续", 向占位符位置赋值的方式为: 
	set数据类型("数值索引" 或 "别名", 要替换的内容) // 与jdbc的另一区别为"setObject"更换为"setParameter"
```

```java
/*创建并预编译HQL语句SQL语句*/
String sql = "···";
NativeQuery nativeQuery = session.createSQLQuery(sql);
/*如果语句中包含占位符, 需要向占位符位置进行赋值
	set数据类型("数值索引" 或 "别名", 要替换的内容)
*/
```

```java
/*全字段(属性)查询封装*/
nativeQuery.addEntity("实体类(表).class"); // 当且仅当查询表中全部字段(属性)时方可使用, 即告知hibernate将查询结果封装至表对应的实体类对象中

/*查询返回的数据类型: 
    1. 如果是"单"字段查询, 则返回数据的类型为字段(或属性)的数据类型; 例: select unm from t_user where ··· ——> String
    2. 如果是"多"字段查询, 则返回数据的类型为Object[]; 例: select unm, pwd from t_user where ··· ——> Object[]{元素顺序为所查字段顺序}
*/
 
```

```java
/*分页查询(页码"n", 页面容量"m")*/
"注: 本地SQL查询的分页查询可以使用sql语句的方式进行操作, 如MySQL的'limit'关键字, 也可使用以下方法进行分页设置: "
nativeQuery.setFirstResult((n-1)*m); // 从第"(n-1)*m"开始
nativeQuery.setMaxResults(m); // 取出m条数据
```

```java
/*发送查询语句并获取查询结果*/
1. T qureyResult =  nativeQuery.getSingleResult(); // 查询单条数据,  T为返回数据的类型
2. List<T> qureyResult =  nativeQuery.getResultList(); // 查询多条数据,  T为返回数据的类型
```

```java
/*可以执行"增删改"操作*/
// 如果"sql"为"增删改"语句, 可通过如下方式执行"增删改"操作: 
nativeQuery.executeUpdate();
```

> > ##### HQL查询: 语句查询

```java
/*HQL语句与SQL语句的区别*/
1. HQL语句中使用的不是数据库的表名与字段名, 而是数据库表对应的实体类类名与类中的属性名, 并且区分大小写;
2. 当查询所有条目时不支持"select *"而是直接从"from"开始, 其他操作可以从"select"开始进行书写;
3. HQL语句中使用同本地SQL查询, 占位符形式为"?+数值索引"或":+别名", 需要注意的是"数值索引之间必须连续", 向占位符位置赋值的方式为: 
    set数据类型("数值索引" 或 "别名", 要替换的内容) // 与jdbc的另一区别为"setObject"更换为"setParameter"
```

```java
/*创建HQL语句*/
String hql = "···";
/*语句的内容决定返回数据的类型: 
	1. 如果语句直接从"from"开始, 则返回数据的类型为表对应的实体类；例: from User where ··· ——> User
    2. 如果从"select"开始: 
        a. "select"后为实体类(表)的别名, 则返回数据的类型为表对应的实体类; 例: select u from User u where ··· ——> User
        b. "select"后为"单"字段查询, 则返回数据的类型为字段(或属性)的数据类型; 例: select username from User where ··· ——> String
        c. "select"后为"多"字段查询, 则返回数据的类型为Object[]; 例: select username, password from User where ··· ——> Object[]{元素顺序为所查字段顺序}
    3. 可以在"HQL"语句中使用构造方法来决定返回数据的类型;
        a. 实体类(表)的构造方法; 例: select new User(username, password) from User where ··· ——> User
        b. hibernate提供的Map构造方法: 
            b_1. 查询字段无别名, 则map中的key为从"0"开始的索引; 
        		例: select new Map(username, password) from User where ··· ——> Map{0=?, 1=?}
            b_2. 查询字段有别名(必须通过"as"设置), 则map中的key为字段的别名; 
            	例: select new Map(username as unm, password as pwd) from User where ··· ——> Map{unm=?, pwd=?}
*/
```

```java
/*预编译HQL语句*/
Query query = session.createQuery(hql);
/*如果语句中包含占位符, 需要向占位符位置进行赋值
	set数据类型("数值索引" 或 "别名", 要替换的内容)
*/
```

```java
/*分页查询(页码"n", 页面容量"m")*/
"注:  HQL查询的分页查询无法使用sql语句的方式进行操作, 如不能使用MySQL的'limit'关键字, 只能通过以下方法进行分页设置: "
query.setFirstResult((n-1)*m); // 从第"(n-1)*m"开始
query.setMaxResults(m); // 取出m条数据
```

```java
/*发送查询语句并获取查询结果*/
1. T qureyResult =  query.getSingleResult(); // 查询单条数据, T为返回数据的类型
2. List<T> qureyResult =  query.getResultList(); // 查询多条数据, T为返回数据的类型
```
```java
/*式执行"删改"操作*/
query.executeUpdate();
```

> > ##### QBC查询: 非语句查询

```java
CriteriaBuilder criteriaBuilder = session.getCriteriaBuilder(); // 获取安全查询创建工厂CriteriaBuilder对象
CriteriaQuery<T> criteriaQuery = criteriaBuilder.createQuery("T.class"); // 创建CriteriaQuery<T>对象, 告知hibernate查询结果中的每条数据对应的数据类型
```

```java
/*设定查询对象(表)*/
Root<X> root = criteriaQuery.from("X.class");  //  根据实体类(表)"X"告知hibernate从数据库的哪个表进行查询;
```

```java
/*建立映射关系(要查询的字段)*/
1. criteriaQuery.select(root); // 相当于SQL: SELECT * FROM TABLENAME
2. criteriaQuery.select(Seliction<?> selection); // 单属性查询, 相当于SQL: SELECT colName FROM tableName
3. criteriaQuery.multiselect(Seliction<?>··· selections); // 多属性查询, 相当于SQL: SELECT colName1,colName2,··· FROM tableName

/*Seliction<?>类型的对象可以为: 
    (1) Path<X> path = root.get("表对应的实类属性名");
    (2) Expression<T> expression = criteriaBuilder.?(path); // "?"可选值见下表(仅展示常用方法)
*/

/*注意:*/
如果"CriteriaQuery<T>"中"T"为表对应的实体类, 则"multiselect"中所选的字段(属性), 必须在实体类中有相应的构造方法且与构造方法中参数的顺序保持一致, 否则无法将查询的数据封装至对应的实体类或发生属性匹配混乱的现象(类型匹配、字段不匹配); 如果无法封装至实体类, 则会将每条数据的查询结果按"selections"顺序封装到一个Object[]数组中
```

|    方法名     |     等效SQL函数     | 获取数据对应的Java类型 |
| :-----------: | :-----------------: | :--------------------: |
|      max      |      max(···)       |         Number         |
|      min      |      min(···)       |         Number         |
|      avg      |      avg(···)       |         Double         |
|      sum      |      sum(···)       |         Number         |
|     count     |     count(···)      |          Long          |
| countDistinct | count(distinct ···) |          Long          |

```java
/*设定查询的限制条件*/
Path<X> path = root.get("表对应的实类属性名"); // 定义限制条作用的字段(属性), X为该属性的类型
Predicate predicate = criteriaBuilder.?(path, ···其他参数···); // 声明限制条, "?"可选值见下表
```

|  方法名  |     等效SQL符号     | 其他参数个数 |      参数类型       |
| :------: | :-----------------: | :----------: | :-----------------: |
|   and    |         and         |   可遍参数   | Predicate(限制条件) |
|    or    |         or          |   可遍参数   | Predicate(限制条件) |
| between  | between ··· and ··· |      2       |        数值         |
|    gt    |          >          |      1       |        数值         |
|    ge    |         >=          |      1       |        数值         |
|    lt    |          <          |      1       |        数值         |
|    le    |         <=          |      1       |        数值         |
|  equal   |          =          |      1       |    数值、字符串     |
| notEqual |         !=          |      1       |    数值、字符串     |
|   like   |        like         |      1       |       字符串        |
| notLike  |      not like       |      1       |       字符串        |

```java
/*限制条件的组装*/
criteriaQuery.where(Predicate··· predicates); // 相当于通过"and"将各predicate连接起来
```
```java
/*对第一字段(属性)进行去重处理*/
criteriaQuery.distinct(boolean arg); // 默认false, 即不去重
```

```java
/*排序*/
Path<X> path = root.get("表对应的实类属性名"); // 定义排序依据的字段(属性), X为该属性的类型
Order orderName = criteriaBuilder.asc(path) // 升序
Order orderName = criteriaBuilder.desc(path) // 降序
criteriaQuery.orderBy(Order··· orders) // 按传入的"orders"顺序进行排序规则的制订
```
``` java
/*预编译查询语句*/
Query<R> query = session.createQuery(criteriaQuery); // R为返回数据的类型, 需与"CriteriaQuery<T>"中的"T"保持一致
```

```java
/*分页查询(页码"n", 页面容量"m")*/
query.setFirstResult((n-1)*m); // 从第"(n-1)*m"开始
query.setMaxResults(m); // 取出m条数据
```

```java
/*发送查询语句并获取查询结果*/
1. T qureyResult =  query.getSingleResult(); // 查询单条数据, T需与"Query<R>"中的"R"以及"CriteriaQuery<T>"中的"T"保持一致
2. List<T> qureyResult =  query.getResultList(); // 查询多条数据, T需与"Query<R>"中的"R"以及"CriteriaQuery<T>"中的"T"保持一致
```


---

### Hibernate调用存储过程或存储函数

```java
"hibernate并没有提供已经封装好的调用存储过程或存储函数的操作, 因此想要调用存储过程或存储函数, 需要获取原生的数据库连接, 通过数据库连接以普通的JDBC的方式调用存储过程或存储函数"
```

```java
/*Hibernate获取原生数据库连接*/
Session对象.doWork(new Work() {
    @Override
    public void execute(Connection connection) throws SQLException {
        /*通过connection以普通的jdbc方式调用存储过程或存储函数或进行其他操作*/
    }
});
```

---

### Hibernate获取与线程绑定的Session

```xml
<!-- 在Hibernate核心配置文件中设置Session的管理方式: -->
<property name="hibernate.current_session_context_class">thread</property>
```

```java
/*获取当前线程绑定的Session对象*/
Session session = sessionFactory.getCurrentSession(); // 若有与当前线程绑定的Session对象则返回该对象, 否则新建一个Session对象将其与当前线程绑定并返回

/*Tip:
    使用与当前线程绑定的Session对象时不能手动执行close()方法关闭Session对象, 与当前线程绑定的Session会在执行commit()或rollback()方法后自动关闭并与当前线程解除绑定关系(如果未开启事务单纯的执行查询操作, 依然需要手动执行close()方法来关闭Session对象)
*/
```

---

### Hibernate内置缓存

> #### 一级缓存

```java
/*Hibernate默认开起一级缓存且无法关闭*/
	" 一级缓存的默认作用域为*同一个*Session对象 "
/*清空或刷新一级缓存的方式*/
	Session对象.evict(Object obj);// 清空一级缓存中指定的对象; 
	Session对象.clear();// 清空一级缓存中所有的对象; 
/*同步缓存信息至数据库*/
	Session对象.flush();// 将一级缓存中的对象发送至数据库, 使数据库中的数据与缓存数据进行同步(当提交事务后完成同步); 如果进行事务回滚, 数据还是照样会被回滚的; 在执行commit()方法时, 会自动先执行一次Session对象.flush();

/*注意:*/
"同一个一级缓存中不能同时存在两个或以上主键相同的对象"
```

> #### 二级缓存

```java
/*Hibernate默认关闭二级缓存, 若开启则必须结合第三方插件使用(常用Ehcache)*/
	" 一级缓存的默认作用域为*同一个*SessionFactory对象 "
/*清空或刷新二级缓存的方式*/
	a. 执"增删改"操作之后, 自动刷新二级缓存
	b. 当SessionFactory对象关闭时, 自动清空该SessionFactory对象下的所有缓存
	c. SessionFactory对象.evict("实体类(表).class")  清除所有实体类(表)对象
	d. SessionFactory对象.evict("实体类(表).class","主键值")  清除指定实体类(表)对象
```

```xml
<!-- 使用二级缓存(Ehcache): -->
    1. 导入Hibernate官方文件"lib/optional/ehcache"目录下的所有jar包
    2. 在src(classpath)直接目录下创建并配置Ehcache配置文件"ehcache.xml"
    3. 在Hibernate核心配置文件中启用二级缓存: 
    	<property name="hibernate.cache.use_second_level_cache">true</property>
    4. 在Hibernate核心配置文件中配置二级缓存使用的插件:
    	<property name="hibernate.cache.region.factory_class">
            <!-- 该值具体设置为EhcacheRegionFactory的全类名, 不同版本包路径不同 -->
    		org.hibernate.cache.ehcache.internal.EhcacheRegionFactory
    	</property>
    5-a. 在Hibernate核心配置文件中配置对哪些类(表)使用二级缓存:
		<!-- 一个实体类(表)对应一个"class-cache"标签, 该标签要设置在"mapping"标签之后 -->
		<class-cache usage="事务隔离级别(推荐read-write)" class="实体类对应的全类名" region="···"/>
	5-b. 也可以在实体类(表)对应的映射文件配置该类(表)使用二级缓存,在"class"标签下添加:
		<cache usage="事务隔离级别(推荐read-write)" region="···"/>

<!--对于"class-cache"或"cache"标签中的"region"属性的设置: 
    1. 不设置该属性, 则使用ehcache.xml中defaultCache模块所设置的缓存策略;
    2. 设置该属性, 则在ehcache.xml中寻找并使用name值与其设置的值相匹配的自定义缓存策略, 找不到则使用defaultCache模块所设置的缓存策略;
    3. 若ehcache.xml存在name值为该实体类(表)的全类名的自定义缓存策略, 则可以不配置该属性, 自动使用与全类名相匹配的缓存策略;
-->
```

>  #### 查询缓存

```java
"SQL本地查询、HQL查询以及QBC查询是无法直接使用hibernate的一级缓存与二级缓存的, 如果想使用一级缓存或二级缓存需要进行额外配置"
```

```xml
<!-- 在Hibernate核心配置文件中启用查询缓存: -->
<property name="hibernate.cache.use_query_cache">true</property>
```

```java
/*使用查询缓存(每条查询需单独设置)*/
HQL查询: Query对象.setCacheable(true);
QBC查询: Query<R>对象.setCacheable(true);
SQL本地查询: NativeQuery对象.setCacheable(true);

"注: SQL本地查询使用缓存的条件是必须为全字段查询且经过实体类(表)的封装, 否则使用缓存会产生异常"
```

---
---
## <center>MyBatis</center>

### MyBatis配置

>#### Step1.引入必要的jar包
```java
/*
Mybatis-Xxx.jar
数据库驱动jar
*/
```
>#### Step2.创建Mybatis核心配置文件(一般命名为Mybatis-config.xml, **且必须建立在src(classpath)目录下**)
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!--引入dtd约束, 可在Mybatis压缩包的pdf中寻找, 形式如下-->
<!DOCTYPE configuration
PUBLIC "-//Mybatis.org//DTD Config Xxx//EN"
"http://Mybatis.org/dtd/Mybatis-Xxx-config.dtd">
<configuration>
<!-- 加载属性文件: 其他标签中可通过"${properties文件中的属性名}"来获取对应的属性值 -->
<properties resource="properties文件路径">
    <!-- 还可通过以下标签配置一些properties文件中不存在的属性名和属性值 -->
	<property name="key值" value="value值"/>
</properties>
    
<!-- 全局配置参数, 需要时再设置 -->
<settings>
<!-- 通过以下标签修改MyBatis默认设置, 可修改的设置众多, 详情请见官网 -->
    <setting name="设置名" value="true"/>
</settings>
 
<!-- 设置单个/多个别名: 若不配置此项, 则xml映射文件各实体类类型要写该类的全类名 -->
<typeAliases>
    <!-- 单个别名(别名忽略大小写), 配置后xml映射文件中该类可直接引用"别名"而非该类的"全类名" -->
    <typeAlias type="实体类全类名" alias="实体类别名"/>
     <!-- 批量定义别名及类名(别名忽略大小写), 配置后xml映射文件中该类可直接引用该类的"类名"而非该类的"全类名" -->
    <package name="实体类所在包"/>
</typeAliases>

<!-- 配置数据类型转换器 -->
<typeHandlers>
    <typeHandler handler="转换器的全类名" JavaType="转换的Java类型" jdbcType="转换的jdbc类型" />
</typeHandlers>
 
<!-- 配置数据库运行环境: 通过environments的default值从其下的environment标签的id中选择, 用于指定MyBatis运行时默认的数据库环境-->
<environments default="···">
    <!-- 添加数据库运行环境(可配置多个), id为该数据库运行环境的唯一标识 -->
    <environment id="···">
         <!-- type指定事务提交方式: 
                JDBC:利用JDBC方式处理事务
                MANAGED: 将事务交由其他组件去托管
         -->
        <transactionManager type="JDBC" />
        <!-- type指定数据源类型: 
                UNPOOLED:传统的JDBC模式
                POOLED: 使用数据库连接池(Mybatis自带, 推荐)
                JNDI: 使用从服务器上查找配置的连接池(不同服务器类型之间存在差异)
                其他第三方数据源全类名: (必须继承"UnpooledDataSourceFactory"类并在无参构造方法中创建相应的数据源赋给从父类继承的dataSource属性, 即"this.dataSource = 创建的数据源DataSource对象")
        -->
         <!-- 配置jdbc模式 -->
        <dataSource type="UNPOOLED">
            <property name="driver" value="具体驱动类的全类名" />
            <property name="url" value="数据库连接字符串" />
            <property name="username" value="数据库用户名" />
            <property name="password" value="数据库用户密码" />
        </dataSource>

         <!-- 配置Mybatis自带连接池模式 -->
        <dataSource type="POOLED">
            <property name="driver" value="具体驱动类的全类名" />
            <property name="url" value="数据库连接字符串" />
            <property name="username" value="数据库用户名" />
            <property name="password" value="数据库用户密码" />
                <!-- Mybatis自带连接池的部分常用属性 -->
            <property name="poolMaximumActiveConnections" value="连接池在同一时间能够分配的最大活动连接的数量, 默认10" />
            <property name="poolMaximumIdleConnections" value="连接池中允许保持空闲状态的最大连接数量, 默认5" />
            <property name="poolMaximumCheckoutTime" value="单位毫秒, 默认20000; 当活动连接达到最大限制是, 此使用户获取连接, 会检查活动连接中最老的一个连接使用时长是否超过该设置, 若超过, 则另该链接失效, 并将其返回给新用户使用" />
            <property name="poolTimeToWait" value="单位毫秒, 默认20000; 获取连接时最大等待时间, 若等待时间超过该设置, 则尝试重新获取一个连接" />
        </dataSource>

         <!-- 配置JNDI连接池模式 -->
        <dataSource type="JNDI">
            <property name="initial_context" value="服务器的JNDI目录(tomcat服务器JNDI目录为java:/comp/env)"/>
            <property name="data_source" value="context.xml中Resource标签的name值"/>
        </dataSource>

         <!-- 配置第三方数据源模式 -->
        <dataSource type="数据源全类名">
            <property name="数据源属性名" value="属性值"/>
                ···
            <!-- 也可在数据源类的无参构造中对创建的数据源根据setter方法对各属性进行赋值或者通过与各自配置文件相结合的方式对各属性进行配置 -->
        </dataSource>
    </environment>
</environments>

<!-- 加载映射文件, 可加载多个 -->
<mappers>
    <!-- 逐个引入xml映射文件 -->
    <mapper resource="xml映射文件路径(相对路径)" />
        ···
     <!-- 逐个引入映射接口类 -->
    <mapper class="映射接口类的全类名"/>
        ···
    <!-- 批量引入 -->
    <package name="xml映射文件/映射接口类所在的包路径(如: org.wh.Mybatis.mapper)"/>
</mappers>
</configuration>
```
### MyBatis基础方式实现增删改查(CRUD)

>#### Sep1.创建与数据库中表相对应的实体类(最好实现序列化接口Serializable)
```java
// 类名————表名(推荐)
// 各成员属性名—————表中各属性名/查询语句结果包含的字段名(若未保持一致, 则需要在xml映射文件中配置resultMap)
/*Tip: 需为各成员属性声明setter与getter方法, 以及生成构造方法*/
```
>#### Step2.创建xml映射文件并在核心配置文件中\<mappers\>标签下引入该映射文件(文件名一般为"表名+Mapper.xml")
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!--引入dtd约束, 可在Mybatis压缩包的pdf中寻找, 形式如下-->
<!DOCTYPE mapper
PUBLIC "-//Mybatis.org//DTD Mapper Xxx//EN"
"http://Mybatis.org/dtd/Mybatis-Xxx-mapper.dtd">
<!--根标签mapper, namespace的值表示该xml映射文件的 唯一标识-->
<mapper namespace="sqlPersonMapper">
	<select id="···">sql查询语句</select>
	<insert id="···">sql增加语句</insert>
	<delete id="···">sql删除语句</delete>
	<update id="···">sql更改语句</update>
 	···每种sql标签不限个数···
    <!--属性设置: 
    id: 该条sql语句的唯一标识

    statementType: 标记操作SQL的对象, 取值说明如下:  
        1. STATEMENT: 直接操作sql, 不进行预编译————Statement 
        2. PREPARED(默认): 预处理, 参数进行预编译————PreparedStatement
        3. CALLABLE: 执行存储过程或存储函数————CallableStatement 

    parameterType: 输入参数的类型(Java数据类型,没有输入参数可忽略该属性,若输入参数为一个实体类, 类型要写该实体类的全类名【若已在maybatis配置文件中为该实体类配置别名, 则写别名即可, 且别名忽略大小写】)

    resultType: 查询语句返回结果值的类型(Java数据类型, 没有返回结果可忽略该属性, 若返回结果为一个实体类, 类型要写该实体类的全类名【若已在maybatis配置文件中为该实体类配置别名, 则写别名即可, 且别名忽略大小写】; 不论查询结果是单一数据还是list集合数据, 都写单条数据的数据类型), 若返回结果为实体类或一个实体类的集合且该实体类成员属性名与表中字段名未完全保持一致, 需要在SQL查询语句中为sql的表的字段名起一个"别名", 且"别名"要与实体类的成员属性名保持一致,不能与resultMap同时使用！！！

    resultMap: 查询语句返回结果映射, 该属性应用于返回结果为实体类或一个实体类的集合且该实体类成员属性名与表中字段名未完全保持一致的情况, 形式为【resultMap="为该实体类配置的resultMap的id值"】, 不能与resultType同时使用！！!
    ···

    Tip: resultType与resultMap均只能在<select>标签中使用, 因为其他三种标签默认返回操作成功的数据条数, 即一个"int"类型
    -->

    <!--参数的输入格式为 "#{···}或${···}" 相当于prepareStatement的占位符"?":
        1. 若sql语句中仅含有一个输入参数, "···" 可以为任何值;
        2. 若sql语句中含有多个输入参数:
            a. 将所有参数封装到一个实体类中, parameterType值为该实体类的全类名(或别名), 而各 "···" 需为实体类中对应的成员属性名; 
            b. 将所有参数封装到一个Map或HashMap中, parameterType值为Map或HashMap, 而各 "···" 需为Map或HashMap中对应的"key值"; 
        3. 当"···"为"_parameter"时, 代表获取当前输入的参数

        Tip1: #{···}或${···}支持级联属性！
        Tip2: 若属性"statementType"设置为"STATEMENT", 则不能使用"#{···}",仅可使用"${···}"！！！
        Tip3: #{···}默认会为参数两端加上单引号后在输出, 可以防止SQL注入; ${···}默认将参数原样输出, 不能防止SQL注入, 且不适用于数字以外的参数类型, 需要手动添加单引号, 因此最好写成【'${···}'】; 因此, #{···}不能作为sql字段名和表名的占位符, 而${···}可以！！！
        Tip4: #{···}可以为参数设置其他属性(mode、javaType、jdbcType、···), 而${···}没有该功能
    -->

    <!--为成员属性名与表中字段名未保持一致的实体类配置resultMap-->
    <resultMap type="实体类的全类名/配置文件该类的别名" id="该resultMap的唯一标识">
          <!-- 指定类中的属性和表中的字段名的对应关系 -->
          <id property="实体类中主键对应的成员属性名"  column="sql中主键对应的字段名" />
          <result property="实体类中非主键对应的属性名"  column="sql中非主键对应的字段名" />
          <!--id与result标签不限个数, 只需要配置不一致的字段, 二者一致的字段不需要配置-->
    </resultMap>
</mapper>
```
>#### Step3.Java操作代码
```java
// 1. 加载核心配置文件
Reader reader = Resources.getResourceAsReader("Mybatis配置文件路径"); 
/*或 InputStream inputStream = Resources.getResourceAsStream("Mybatis配置文件路径")*/
// 2. 根据配置文件创建SqlSessionFactory, 相当于创建一个连接池
SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader,"若不想使用配置文件默认的数据库运行环境, 可在此处设置environment标签的id,使用默认则忽略该参数");
/*或 = new SqlSessionFactoryBuilder().build(inputStream,"同上")*/
// 3. 获取SqlSession与数据库建立连接并开启事务, 当于jdbc连接数据库中的connection对象
SqlSession sqlSession = sqlSessionFactory.openSession();
/*或 = sqlsessionFactory.opensession(true)*/ // 设置事务自动提交
try {
    String statement = "xml映射文件的namespace值" + "." + "映射文件的SQL语句标签的id值"; 
    // 4. 增删改操作, 默认返回操作成功的数据条数
    int count = sqlSession.insert(statement, "要传入的参数(没有则忽略)"); // 增
    int count = sqlSession.delete(statement, "要传入的参数(没有则忽略)"); // 删
    int count = sqlSession.update(statement, "要传入的参数(没有则忽略)"); // 改
    // 切记: 增删改操作时, 要执行commit操作提交事务, 若之前设置opensession(true), 则不需要此操作
    sqlSession.commit();
    // 4. 查询操作*/
    ReturnType queryResult = sqlSession.selectOne(statement, "要传入的参数(没有则忽略)");// 返回单条数据
    List<T> queryResult = sqlSession.selectList(statement, "要传入的参数(没有则忽略)");// 返多条数据的集合
	} catch (Exception e) {
        e.printStackTrace();
        sqlSession.rollback(); // 程序发生异常进行事务回滚(若将sqlSession设置为自动提交事务, 则不可以使用)
    } finally {
        // 5. 关闭连接
		sqlSession.close();
    }
```
---

### MyBatis动态代理方式实现实现增删改查(CRUD)

>#### Method1. 接口类结合xml映射文件的方式(推荐)


```java

/*与基础方式的区别:
    1. 需要创建一个Java接口(习惯命名为"数据库表名+Mapper");
    2. 对应xml映射文件的namespace值为Java接口的"全类名";
    3. Java接口中各方法名要与xml映射文件中SQL语句标签的id值一致;
    4. 方法的输入参数类型要与xml映射文件中SQL语句标签的parameterType类型一致;
    5. 方法的返回值类型要与xml映射文件中SQL语句标签的resultType类型一致(注意若返回多条数据, 则返回类型为泛型为resultType类型的List集合);
*/

/*Tip: 习惯上将Java接口与对应的xml文件放在一个包下*/
```

> #### Method2. 接口类纯注解的方式

|  MyBatis常用注解   | 作用对象 | 等同于xml映射文件标签  |
| :----------------: | :------: | :--------------------: |
|  @CacheNamespace   |    类    |       \<cache\>        |
| @CacheNamespaceRef |    类    |      \<cacheRef\>      |
|      @Results      |   方法   |     \<resultMap\>      |
|      @Result       |   方法   |   \<result\>、\<id\>   |
|     @ResultMap     |   方法   | sql标签的resultMap属性 |
|      @Insert       |   方法   |       \<insert\>       |
|      @Update       |   方法   |       \<update\>       |
|      @Delete       |   方法   |       \<delete\>       |
|      @select       |   方法   |       \<select\>       |
|      @Options      |   方法   |   设置sql标签的属性    |

```jsp
<%
/*与基础方式的区别:*/
// Step1.需要创建一个Java接口(习惯命名为"数据库表名+Mapper");
// Step2.在xml配置文件中<mappers>标签中需要引入该接口类; 
// Step3.接口注解使用形式
	@Select("sql查询语句")/@Insert("sql插入语句")/@Delete("sql删除语句")/@Update("sql更新语句")
	public 返回值类型 methodName(传入的参数);

    // 等同于映射文件的<resultMap>的注解@Resultse
    @Results(id="该注解的唯一标识, 可以省略", value={
        @Result( id=···,property="···",column="···",typeHandler =···),
        @Result( id=···,property="···",column="···",typeHandler =···),
        ···
    })
        /*参数分析: 
            id: true/false, 指明该字段在数据库中是否为主键, 默认为false; 
            properter: 实体类中主键对应的成员属性名; 
            column: sql中主键对应的字段名; 
            typeHandler: 区别于xml映射文件, 从此处值应为*转换器类的全类名+.class*
       */
    // 可以通过下列注解引用其他方法的@Results设置, 以便提高代码的重复利用
    @ResultMap(value="@Results的id值")
%>

<!--Tip:  
    1. 如果使用纯注解注解方式进行数据库的操作, 则在MyBatis配置文件的<mappers>标签中不能同时引namespace为该注解接口类全类名的xml映射文件！
    2. 注解方式的输入参数的使用同xml映射文件中的"#{···}"与"${···}"
-->
```

>#### Java操作代码
```java
// 1. 加载核心配置文件
Reader reader = Resources.getResourceAsReader("Mybatis配置文件路径"); 
/*或 InputStream inputStream = Resources.getResourceAsStream("Mybatis配置文件路径")*/
// 2. 根据配置文件创建SqlSessionFactory, 相当于创建一个连接池
SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader,"若不想使用配置文件默认的数据库运行环境, 可在此处设置environment标签的id,使用默认则忽略该参数");
/*或 = new SqlSessionFactoryBuilder().build(inputStream,"同上")*/
// 3. 获取SqlSession与数据库建立连接并开启事务, 当于jdbc连接数据库中的connection对象
SqlSession sqlSession = sqlSessionFactory.openSession();
/*或 SqlSession sqlSession = sqlsessionFactory.opensession(true)*/ // 设置事务自动提交
try {
    InterfaceName interfaceName = sqlSession.getMapper(InterfaceName.class);
    //4. 增删改查操作
    ReturnType resultName = interfaceName.methodName(···);
    //切记: 增删改操作时, 要执行commit操作提交事务, 若之前设置opensession(true), 则不需要此操作
    sqlSession.commit();
    } catch (Exception e) {
        e.printStackTrace();
        sqlSession.rollback(); // 程序发生异常进行事务回滚(若将sqlSession设置为自动提交事务, 则不可以使用)
    } finally {
        // 5. 关闭连接
		sqlSession.close();
    }
```

> #### MyBatis动态代理方式多参传入

```java
"方法1.直接通过接口函数传多个参数:
	public 返回值类型 methodName(参数1, 参数2, ···);
    // 该方法sql语句中"#{···}"与"${···}"中"···"只能是"arg+参数从0开始的索引"或"param+参数从1开始的索引"
    // 例: 
        注解接口方法: public void insertDataparmas(int id,String name,int age,int sex);
        sql语句: insert into person(id,name,age,sex) values(#{arg0},#{arg1},#{arg2},#{arg3})
        sql语句: insert into person(id,name,age,sex) values(#{param1},#{param2},#{param3},#{param4})
"方法2.使用参数注解为参数设置别名传参:
    public 返回值类型 methodName(@Param("参数别名")参数1, @Param("参数别名")参数2, ···);
    // 该方法sql语句中"#{···}"与"${···}"中"···"只能是每个参数注解中所设置的"参数别名"
    // 例: 
        注解接口方法: public void insertDataparmas(@Param("pId")int id,@Param("pName")String name,@Param("pAge")int age,@Param("pSex")int sex);
        sql语句: insert into person(id,name,age,sex) values(#{pId},#{pName},#{pAge},#{pSex})
  
            
/*Tip: 
	如果使用多参传入, 且使用的是xml映射文件而不是sql标签注解的方式, 则在映射文件对应的sql标签中不要配置parameterType
*/
```

---

### MyBatis调用存储过程或存储函数

>
>#### 代码书写位置: 
```java
/*根据存储过程或存储函数的作用不同, 应将代码的书写位置至于不同的SQL标签中: 
    a. 执行查询操作 ————> <select>标签下(若有select结果的输出则需配置resultType,无则忽略)
    b. 执行数据插入操作 ————> <insert>标签下
    c. 执行数据更新操作 ————> <update>标签下
    d. 执行数据删除操作 ————> <delete>标签下
    e. 其他(如计算数字加和等非针对数据库的操作)————>任意标签下, 推荐放在<select>标签下
*/
```
>
>#### 代码书写格式: 
```xml
<!--存储过程-->
<sql标签 id="该条sql语句的唯一标识" statementType="CALLABLE"  parameterType="Map">
    {
        call 存储过程名(
            #{输入参数1(map传参中的key值),mode=IN,jdbcType=参数的JDBC类型},
            #{输入参数2(map传参中的key值),mode=IN,jdbcType=参数的JDBC类型},
            ···
            #{输出结果名1(map接收输出结果的key值),mode=OUT,jdbcType=参数的JDBC类型},
            ···
        )
    }
    </sql标签>

<!--存储函数-->
<sql标签 id="该条sql语句的唯一标识" statementType="CALLABLE"  parameterType="Map">
    {
        #{返回结果名(map接收返回结果的key值),mode=OUT,jdbcType=参数的JDBC类型} = call 存储函数名(
            #{输入参数1(map传参中的key值),mode=IN,jdbcType=参数的JDBC类型},
            #{输入参数2(map传参中的key值),mode=IN,jdbcType=参数的JDBC类型},
            ···
        )
    }
</sql标签>

<!--Tip:
    调用存储过程或存储函数的标签statementType属性必需为"CALLABLE", parameterType必须为"Map(HashMap)"
-->
```
>#### Java操作代码
```java
/*
大体代码与"MyBatis基础方式实现增删改查(CRUD)"以及"MyBatis接口开发方式实现实现增删改查(CRUD)"两种方式相同, 主要区别在于传参形式必须为Map(HashMap)以及返回结果的获取上
*/

// 创建map映射
Map<String, Object> paramsMap = new HashMap<String, Object>();
// 像其中增加输入参数, 要与key值要与"#{···}"中所设置的内容保持一致
map.put("输入参数1", value1);
map.put("输入参数1", value2);
···
// 执行存储过程或存储函数
/*此处与执行增删改查的方式相同(传入参数为paramsMap且各操作无返回值, select存在例外)*/
// 获取存储过程或存储函数的返回结果
Object result = paramsMap.get("输出结果名/返回结果名") 

/*Tip: 
    若存储过程或存储函数为查询操作, 并存在select返回数据, 则必须为selet标签配置resultType/resultMap, 同时可以在Java中通过返回值获取结果;
    注意: select返回数据并非"存储过程out类型参数"或"存储函数的return结果"的区别,而是由于在函数体内执行查询操作但并未将结果赋给其他变量而输出的数据, 例如在存储过程的中, 常在最后通过"select out类参数"来将结果进行输出！
*/
```
---

### MyBatis获取与线程绑定的SqlSession

```java
/*实例化SqlSessionManager对象(一般将其设置为全局变量)*/
SqlSessionManager sqlSessionManager = SqlSessionManager.newInstance("SqlSessionFactory对象");
```

```java
if (!sqlSessionManager.isManagedSessionStarted()) {// 判断当前线程中是否有已经绑定的SqlSession对象, 如果没有则执行如下操作: 
    sqlSessionManager.startManagedSession(); // 创建一个SqlSession对象并与当前线程绑定, 同时开启事务
    /*或 sqlSessionManager.startManagedSession(true)*/ // 创建一个SqlSession对象并与当前线程绑定, 并将其设置为事务自动提交
}
```

```java
经过上面的设置, 便可以将"sqlSessionManager"当作"SqlSession对象"执行对数据库的操作以及对事务的处理, 在调用方法时会自动获取与当前线程绑定的SqlSession对象执行响应的操作!
```

```java
/*关闭连接并解除绑定*/
sqlSessionManager.close(); // 关闭当前线程绑定的SqlSession对象, 之后解除绑定关系
```

---

### MyBatis动态SQL常用标签

>#### set、where、trim
```xml
<set>
    ···
    <!-- 作用等同与sql的"set"字段但是它能只能删掉语句末尾额外的逗号, 常用于更新语句 -->
</set>

<where>
    ···
    <!-- 作用等同与sql的"where"字段但是它能智能删除开头多余的"AND" 或 "OR" -->
</where>

<trim prefix="拼接的前缀" suffix="拼接的后缀" prefixoverride="需要去除的开头字符" suffixOverrides="需要去除的结尾字符">
    ···
</trim>

<!-- 例子:  -->
<select id="queryPersonUseWhere" parameterType="entity.sqlPerson" resultType="entity.sqlPerson">
    select *from person
    <where>
        <if test="id!=null">id = #{id}</if>
        <if test="name!=null">and name = #{name}</if>
        <if test="age!=null">and age = #{age}</if>
        <if test="sex!=null">and sex = #{sex,typeHandler=converter.sexConverter}</if>
    </where>
</select>
<update id="updatePersonUseSet" parameterType="entity.sqlPerson">
    update person
    <set>
        <if test="name!=null">name=#{name},</if>
        <if test="age!=null">age=#{age},</if>
        <if test="sex!=null">sex=#{sex,typeHandler=converter.sexConverter}</if>
    </set>
    where id = #{id}
</update>
<select id="queryPersonUseTrim" parameterType="sqlperson" resultMap="testMap">
    <trim prefix="select *from person where" prefixOverrides="and">
        <if test="id!=null">id = #{id}</if>
        <if test="name!=null">and name like #{name}</if>
        <if test="age!=null">and age = #{age}</if>
        <if test="sex!=null">and sex = #{sex,typeHandler=converter.sexConverter}</if>
    </trim>
</select>
<update id="updatePersonUseTrim" parameterType="entity.sqlPerson">
    <trim prefix="update person set" suffix="where id = #{id}" suffixOverrides=",">
        <if test="name!=null">name=#{name},</if>
        <if test="age!=null">age=#{age},</if>
        <if test="sex!=null">sex=#{sex,typeHandler=converter.sexConverter}</if>
    </trim>
</update>
```
>#### if、choose(when、otherwise)、foreach
```xml
<if test="判断依据">···满足条件的时拼接的语句</if>

<choose>
	<when test="判断依据1">···满足依据1时拼接的语句</when>
    <when test="判断依据2">···满足依据2时拼接的语句</when>
    <otherwise>···其他情况拼接的语句</otherwise>
</choose>

<!-- 
判断语句中使用的变量为该变量在传入的实体类中的属性名或Map映射中的key值, 若要直接使用传入的参数, 则变量为"_parameter";判断依据中"与或"逻辑要用"and和or"连接, 而不是"&&和||"
-->

<foreach collection="要执行的循环体" item="为循环体中的单个元素值起个别名" index="元素在集合数组中索引号(0,1,···)或在map映射的key值" separator="设置单个元素之间的拼接字符,分隔符(可选)" open="整个循环的前缀字符串(可选)" close="整个循环的后缀字符串(可选)" >
    <!-- 
        取值: #{item值}或${item值} 
        取索引或Map的key: #{index值}或${index值} 
    -->
    ···
</foreach>



<!--parameterType与<if>、<when>test属性中变量名以及<foreach>collection属性对应关系: 

    a. 若要执行的循环体为一个Array数组, 则parameterType可以为该数组的数据类型(如int)或该数组的数组类型(如int[]),若为实体类对象数组, 数据类型可以写该实体类的全类名或别名, 但数组类型必须为"Object[]",或者直接写成"ArrayList",<if>、<when>test属性中变量名以及<foreach>标签中的collection必为"array";

    b. 若要执行的循环体为一个List集合, 则parameterType可以为该集合的数据类型(如int)或直接为"list",<if>、<when>test属性中变量名以及<foreach>标签中的collection必为"list";

    c. 若要执行的循环体为一个Map映射, 则该Map映射必须先封装在一个"实体类或Map"中, 在进行传入, 即parameterType应该为该Map映射的父级实体类或父级Map映射, <if>、<when>test属性中变量名以及<foreach>标签中的collection为"该map映射在其父级元素中对应的属性名或key值";

    d. 若循环体的类型为封装在"实体类或map"中的List集合或Array数组或Map映射, 即parameterType为一个实体类或Map(HashMap), <if>、<when>test属性中变量名以及<foreach>标签中的collection值为List集合或Array数组或Map映射在"实体类或map"中对应的属性名或key值; 

    e. _parameter代表当前的输入参数

-->


<!-- 例 -->
<!--Array:
	该例传入参数为一个实体类数组, 在Java中传入的是sqlPerson[] 
-->
<select id="queryPersonWithObjectArray" parameterType="Object[]" resultType="entity.sqlPerson">
    select * from person where
    <if test="array!=null and array.length>0">
        <foreach collection="array" open=" id in (" close=")"
            item="person" separator=",">
            #{person.id}
        </foreach>
    </if>
</select>
<!--List:
该例传入参数为一个整数List集合, 在Java中传入的是List<Integer>
-->
<select id="queryPersonWithList" parameterType="List" resultType="entity.sqlPerson">
    select * from person where
    <if test="list!=null and list.size>0">
        <foreach collection="list" open=" id in (" close=")"
            item="id" separator=",">
            #{id}
        </foreach>
    </if>
</select>
<!--Map:
该例传入参数为一个map映射, 在Java中传入的是HashMap<String,Object:{message:HashMap<String,Object>,id:id值}
-->
<update id="updatePersonWithMap" parameterType="map">
    update person set
    <if test="message!=null and !message.isEmpty()">
        <foreach collection="message" item="value" index="key"
            separator=",">
            ${key} = #{value}
        </foreach>
    </if>
     where id = #{id}
</update>
```
---

### MyBatis自定义数据类型转换器

>#### 转换器功能介绍
```java
/*
MyBatis类型转换器的作用是为了实现数据的Java类型与jdbc类型之间的转换, 如默认: 
        Java(long)————>JDBC(BIGINT)
        Java(Java.sql.Date)————>JDBC(DATE)
        Java(Java.sql.Time)————>JDBC(TIME)
        Java(int,Integer)————>JDBC(INTEGER)
        Java(double)————>JDBC(FLOAT,DOUBLE)
        Java(String)————>JDBC(CHAR,VARCHAR,LONGVARCHAR)
        ···

*/
"我们使用自定义数据类型转换器的目的是为了实现默认转换器中不存在的数据类型的对应关系, 并设置自己期望的数据内容"
```
>#### Step1. 创建类型转换器继承BaseTypeHandler<T>类, 并重写其下的方法
```java
// T为期望的Java类型
public class converterName extends BaseTypeHandler<T>{

	@Override// 从数据库获取到的值设定为期望的数据类型和内容
	public T getNullableResult(ResultSet paramResultSet, String paramString) throws SQLException {
        // paramResultSet: 相当于返回的单条数据结果集m
        // paramString: 相当于sql表中的columnNamem
        // 通过 paramResultSet.get[Type](paramString) 获取返回的内容
        ···
	}

	@Override// 从数据库获取到的值设定为期望的数据类型和内容
	public T getNullableResult(ResultSet paramResultSet, int paramInt) throws SQLException {
        // paramResultSet: 相当于返回的单条数据结果集
        // paramInt: 相当于sql表中的columnName所在的索引号
        // 通过 paramResultSet.get[Type](paramInt) 获取返回的内容
        ···
	}

	@Override// 从数据库获取到的值设定为期望的数据类型和内容
	public T getNullableResult(CallableStatement paramCallableStatement, int paramInt) throws SQLException {
        // paramCallableStatement: 相当于jdbc执行的存储过程或存储函数返回的结果集
        // paramInt: 相当于存储过程或存储函数返回值的的索引号
        // 通过 paramCallableStatement.get[Type](paramInt) 获取返回的内容
        ···
	}

	@Override// 向数据库传值由期望的JavaType转为期望的JDBCType和内容
	public void setNonNullParameter(PreparedStatement paramPreparedStatement, int paramInt, T paramT, JdbcType paramJdbcType) throws SQLException {
        // paramCallableStatement: 相当于jdbc的prepareStatement版本的带占位符的SQL语句
        // paramInt: 相当于SQL语句占位符的索引号
        // paramT: 相当于为Java要向数据库传入的内容
        // paramJdbcType: 会根据T自动识别应该转换的jdbc类型
        // 通过 paramCallableStatement.set[Type](paramInt, "期望内容") 设置传入内容
        ···
	}

}

/*Tip: 类中提到的get与set方法均同jdbc操作数据库取值赋值的get和set方法相同*/
```
> > ##### 例: 

```java
/*
该转换器是为了实现将Java(String)与JDBC(INTEGER) 相对应, 数据库的"sex性别"存为"0/1",在Java中获取时转为"女/男", 当Java向数据库传"女/男"时, 自动转存为"0/1"
*/
public class sexConverter extends BaseTypeHandler<String> {

	@Override
	public String getNullableResult(ResultSet arg0, String arg1) throws SQLException {
		int sex = arg0.getInt(arg1);
		return sex == 1 ? "男" : "女";
	}

	@Override
	public String getNullableResult(ResultSet arg0, int arg1) throws SQLException {
		int sex = arg0.getInt(arg1);
		return sex == 1 ? "男" : "女";
	}

	@Override
	public String getNullableResult(CallableStatement arg0, int arg1) throws SQLException {
		int sex = arg0.getInt(arg1);
		return sex == 1 ? "男" : "女";
	}

	@Override
	public void setNonNullParameter(PreparedStatement arg0, int arg1, String arg2, JdbcType arg3) throws SQLException {
		if ("男".equals(arg2)) {
			arg0.setInt(arg1, 1);
		} else {
			arg0.setInt(arg1, 0);
		}
	}
    
}
```

>#### Step2.更改与数据库表对应的实体类中的属性类型为期望类型, 而非默认对应的数据类型
```java
/*例: */
"如上述转换器例子中sex类型的对应关系被自定义为: 
Java(String,'女/男') ———— JDBC(INTEGER,'0/1')
"则在对应的实体类中sex的属性类型应为String而非int
private String sex; // 正确
private int sex; //  ！！错误 ！！
```
>
>#### Step3-1.在xml配置文件的\<configuration\>标签下配置转换器——全局注册
```xml
<configuration>
    <!-- 配置数据类型转换器 -->
 	<typeHandlers>
		<typeHandler handler="转换器的全类名" JavaType="转换的Java类型" jdbcType="转换的jdbc类型" />
        <!-- 可通过多个<typeHandler>标签配置多个转换器 -->
 	</typeHandlers>
···
</configuration>

<!--Tip:
该方式引入的数据类型转换器作用域是全局性的, 即凡是满足转换器的转换类型的数据, 都会执行该转换器
-->
```
> > ##### 例

```xml
<configuration>
    <typeHandlers>
		<typeHandler handler="sexConverter全类名" JavaType="String" jdbcType="INTEGER" />
	</typeHandlers>
    ···
</configuration>
```

>#### Step3-2.通过resultMap配置转换器——局部注册
```xml
<resultMap type="实体类的全类名/配置文件该类的别名" id="该resultMap的唯一标识">
    <!-- 指定类中的属性和表中的字段名的对应关系 -->
    <id property="实体类中主键对应的成员属性名"  column="sql中主键对应的字段名" typeHandler="转换器的全类名"/>
    <result property="实体类中非主键对应的属性名"  column="sql中非主键对应的字段名" typeHandler="转换器的全类名"/>
    <!--id与result标签不限个数, 只需要配置名称不一致或涉及到自定义类型转换器的字段-->
</resultMap>

<!--Tip:
    该方式引入的数据类型转换器作用域是局部性的, 即只有在使用配置了转换器的resultMap时, 才会触发类型转换器 ！！
-->
```
> > ##### 例

```xml
<resultMap type="sqlPerson" id="sexMap">
	<result property="sex"  column="sex" JavaType="String" jdbcType="INTEGER"/>
</resultMap>
<select id="queryOne" parameterType="int" resultMap="sexMap">
	select * from person where id = #{id}
</select>
```

>#### Step4.若执行的语句的参数中包含转换的类型, 要在#{···}中配置
```xml
<!-- 使用全局转换器(前提必须已经配置全局转换器) -->
#{涉及使用转换器的参数, JavaType=转换的Java类型, jdbcType=转换的JDBC类型}
<!-- 局部使用转换器 -->
#{涉及使用转换器的参数, typeHandler=转换器的全类名}
```
> > ##### 例

```xml
<insert id="insert" parameterType="sqlPerson">
    insert into person(id,name,age,sex) values(
    #{id},
    #{name},
    #{age},
    #{sex,javaType=String,jdbcType=INTEGER})
</insert>
	
<update id="update" parameterType="sqlPerson">
	update person set sex = #{sex,typeHandler=sexConverter的全类名} 
	where id = #{id}
</update>
```

---

### MyBatis内置缓存

>#### 一级缓存

````java
/*MyBatis默认开起一级缓存且无法关闭*/
	" 一级缓存的默认作用域为*同一个*SqlSession对象
/*清空一级缓存的方式*/
	a. SqlSession对象.clearCache();
	b. SqlSession对象.commit();// 因此执行"增删改"操作必然会清空一次当前SqlSession对象的一级缓存
````

```xml
<!-- 可在MyBatis的xml配置文件中<settings>标签下配置一级缓存的作用域 -->
<settings>
    <setting name="localCacheScope" value="SESSION " />
    <!-- 可设置的作用域: 
        SESSION ——> 默认, 作用域为*同一个*SqlSession对象, 即会缓存一个会话中执行的所有查询
        STATEMENT ——> 作用域为仅用于同一次执行的语句, 可以简单的理解为"关闭"一级缓存。
    -->
</settings>
```

> #### 二级缓存

```java
/*MyBatis默认关闭二级缓存, 需要手动开启*/
	" 二级缓存的默认作用域为*同一个*SqlSessionFactory对象下调用的*同一个*xml映射文件或接口类
/*清空一级缓存的方式*/
    a. "增删改"操作执行commit()方法之后, 自动清空该方法所在的xml映射文件或注解接口类的二级缓存
    b. 当SqlSessionFactory对象销毁时, 自动清空该SqlSessionFactory对象下的所有缓存
    
/*Tip:
    1. 开启二级缓存后, 相关的实体类必需要实现序列化接口Serializable, 否则会报错
    2. 当执行SqlSession对象.commit()或SqlSession对象.close()时, 才会将数据从一级缓存转移到二级缓存
*/
```

```xml
Step1.
<!-- 在MyBatis的xml配置文件中<settings>标签下开启二级缓存的总开关(默认开启) -->
<settings>
    <setting name="cacheEnabled" value="true" />
</settings>
```

```jsp
Step2.
<!-- 在对应的xml映射文件或注解接口类中开启二级缓存 -->
 a. 若使用的是xml映射文件操作数据库, 需要在映射文件中通过加入<cache/>标签开启并配置自身的二级缓存或通过<cache-ref>引用其他的映射文件的二级缓存, 与之共有相同的二级缓存
    <mapper namespace="···">
        <!-- 开启或设置当前Mapper的二级缓存 -->
        <cache/>
        <!-- 与其他Mapper的共用同一个二级缓存 -->
        <cache-ref namespace="其他xml映射文件的namespace值/接口类映射的全类名"/>
        ···
    </mapper>
    <!-- <cache/>的属性: 
        type ——> 用于指定缓存的实现类,  默认是PERPETUAL(Mybatis自带), 若使用第三方缓存类(必须实现org.apache.ibatis.cache.Cache接口)需要配置该属性(第三方缓存类中的各属性可通过<property name="属性名" value="属性值" />标签进行配置或覆盖)
        size ——> 设置可缓存数据的最大数目, 默认为1024条数据
        eviction ——> 设置缓存数量超出size的范围后, 数据的回收策略[LRU(默认,移除最长时间不被使用的对象)  |FIFO(按对象进入缓存的顺序来移除它们) | SOFT(软引用) | WEAK(若引用)]
        flushInterva ——> 设置缓存自动刷新间隔时间(单位ms), 默认永不刷新
        readOnly ——> 只读属性可以被设置为 true 或 false(默认), 设置true: 用户从缓存中取出对象之后, 对其进行修改, 缓存中的对象也会随之发生变化(不安全); 设置为false: 用户从缓存中取出的是缓存对象的拷贝, 对其进行修改, 不影响缓存中里面的对象。
        blocking ——> 阻塞, 默认值为false, 当指定为 true 时将采用 BlockingCache 进行封装。(使用 BlockingCache 当多线程并发查找同一条数据时, 如果缓存中没有该条数据, BlockingCache会对该条数据的查询进行锁定, 阻止所有线程同时访问数据库, 只通过第一个线程对数据库进行访问, 将查询结果返回并存放到缓存中, 同时解除对该查询的锁定, 其他线程从缓存中获取该查询结果 这样可以阻止并发情况下多个线程同时查询数据库。)
    -->
b. 若使用的是纯注解方式操作数据库, 接口类中通过注解@CacheNamespace注解开启并配置自身的二级缓存或通过类注解@CacheNamespaceRef引用其他的映射文件的二级缓存, 与之共有相同的二级缓存
    <%
        // 开启或设置当前Mapper的二级缓存
        @CacheNamespace
        // 与其他Mapper的共用同一个二级缓存
        @CacheNamespaceRef(name="其他xml映射文件的namespace值"/value="其他接口类的类名.class")
        public interface 接口名 {
            ···
        }
        /*@CacheNamespace的属性: 
            implementation ——> (class)用于指定缓存的实现类,  默认是PerpetualCache.class(Mybatis自带), 若使用第三方缓存类(必须实现org.apache.ibatis.cache.Cache接口)需要配置该属性
            properties ——> (Property[])用于配置或覆盖第三方缓存类中的属性, 配置方式为 properties = {@Property(name = "属性名", value = "属性值"),@Property(name = "属性名", value = "属性值"),···}
            size ——> (int)设置可缓存数据的最大数目, 默认为1024条数据
            eviction ——> (class)设置缓存数量超出size的范围后, 数据的回收策略[LruCache.class(默认,移除最长时间不被使用的对象) | FifoCache.class(按对象进入缓存的顺序来移除它们) | SoftCache.class(软引用) | WeakCache.class(若引用)]
            flushInterva ——> (long)设置缓存自动刷新间隔时间(单位ms), 默认永不刷新
            readWrite ——> (bolean)读写属性可以被设置为 true(默认) 或 false, 设置true: 用户从缓存中取出的是缓存对象的拷贝, 对其进行修改, 不影响缓存中里面的对象; 设置为false: 用户从缓存中取出对象之后, 对其进行修改, 缓存中的对象也会随之发生变化(不安全)。
            blocking ——> (bolean)阻塞, 默认值为false, 当指定为 true 时将采用 BlockingCache 进行封装。(使用 BlockingCache 当多线程并发查找同一条数据时, 如果缓存中没有该条数据, BlockingCache会对该条数据的查询进行锁定, 阻止所有线程同时访问数据库, 只通过第一个线程对数据库进行访问, 将查询结果返回并存放到缓存中, 同时解除对该查询的锁定, 其他线程从缓存中获取该查询结果 这样可以阻止并发情况下多个线程同时查询数据库。)
        */
    %>
```

> #### 开启二级缓存后设置某些语句禁用二级缓存(如分页查询操作)

```jsp
<!-- 对于xml映射文件不想使用二级缓存功能的语句: 将属性useCache设置为"false" -->
<select id="···" parameterType="···" resulType="···" useCache="false">
    ···
</select>
<%
/*对于纯注解方式接口类中不想使用缓存功能的语句: 可通过方法注解@Options将useCache设置为"false"*/
@Select("sql查询语句")
@Options(useCache = false)
public 返回值类型 methodName(传入的参数);
%>
```

---

---

## <center>Spring</center>

### Spring准备工作

```xml
<!-- eclipse安装Spring插件 -->
        1. 下载Spring Roo Project文件 -> "https://projects.Spring.io/Spring-roo/#download-widget"
        2. 解压下载的Spring Roo文件
        3. 打开eclipse, Help -> Install New Software, 点击Manage -> Import
        4. 选中2所解压的文件目录 /conf/sts-sites-bookmarks.xml, 点击 Open -> Apply and close
        5. 在Work with 中选择 Spring Roo Xxx (Release) -> Select All -> Next
        6. 完成安装后重启eclipse
        7. 在右击 New-> Other 中多出了Spring -> Spring Bean Configuration File 
<!-- 导入Spring必要jar包 -->
        Spring-aop-Xxx.jar
        Spring-beans-Xxx.jar
        Spring-context-Xxx.jar
        Spring-core-Xxx.jar
        Spring-expression-Xxx.jar 
        commons-logging-Xxx.jar //第三方提供的日志jar(需单独下载)
<!-- 创建Spring IOC容器, 并注入bean -->
```

---

### Spring IOC 容器

> #### 两种IOC容器——Spring配置文件

```xml
<!--xml版本IOC容器:
在src(classpath)目录通过新建Spring Bean Configuration File创建xml文件即创建Spring IOC容器, 习惯将其命名为"applicationContext.xml"  
-->
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.Springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.Springframework.org/schema/beans
                           http://www.Springframework.org/schema/beans/Spring-beans.xsd">
    
	<!-- 加载属性文件(可省): 其他标签中可通过"${properties文件中的属性名}"来获取对应的属性值 -->
    <context:property-placeholder location="properties文件路径"/>
	···
</beans>
```

```java
/*java版本IOC容器:
创建一个Java类(习惯将类名设置为"applicationContext"), 并为其添加类注解"@Configuration"用于声明该类为Spring IOC容器
*/
@Configuration
@PropertySource("properties文件路径") //  加载属性文件(可省): 主角中可通过"${properties文件中的属性名}"来获取对应的属性值
public class applicationContext {
    ···
}

```

> ####  向Spring IOC容器(xml版本)中注入bean

```xml
<!-- set注入: 通过调用方法setter方法setXxx()赋值 -->
<bean id="该bean的唯一标识" class="class的全类名">
    <property name="setXxx()中首字母小写的Xxx部分" value="设置属性值"/>
 	<property name="setXxx()中首字母小写的Xxx部分" ref="该复杂类对应的bean的id"/>
</bean>

<!-- 构造器注入: 通过构造方法赋值(该方式如果顺序与构造方法的参数一致, 可以不name参数) -->
<bean id="该bean的唯一标识" class="class的全类名">
    <constructor-arg value="设置参数值" name="class中构造方法的普通类型参数的参数名"/>
    <constructor-arg ref="该复杂类对应的bean的id" name="class中构造方法的复杂类型参数的参数名"/>
    <!-- 除了可以用name属性指定参数名来识别外, 可以通过以下两种属性识别参数:
        type ——> 指定参数类型, 复杂类使用全类名
        index ——> 指定参数在构造方法的索引号, 从0开始
    -->
</bean>
	
<!-- p命名空间注入: 需要先通在头文件引入p命名空间【xmlns:p="http://www.Springframework.org/schema/p"】-->
<bean id="该bean的唯一标识" class="class的全类名" p:简单类型成员属性名="设置属性值" p:复杂类型成员属性名-ref="该复杂类对应的bean的id"/>

<!-- 设置自动装配(仅适用于复杂类型的成员属性):设置<bean>标签的autowire属性 -->
<bean id="该bean的唯一标识" class="class的全类名" autowire="自动装配方式">
    <!--autowire可设置的属性值: 
        a. no: 默认值, 即不启用自动装配
        b. byName: 通过类的成员属性名在IOC容器中寻找id与之相匹配的bean, 找不到则将该成员属性设为缺省值
        c. byType: 通过类的成员属性的数据类型在IOC容器中寻找class与之相匹配的Bean, 找不到则将该成员属性设为缺省值, 找到多个则报错！
        d. constructor: 与byType类似, 但应用于该类的构造方法, 依据构造方法的参数类型在IOC容器中寻找class与之相匹配的Bean, 若<bean>中使用<constructor-arg>, 则(可以通过<constructor-arg>标签为构造方法的参数赋值, 其他的参数自动装配, 找不到或找到多个都将报错);若<bean>中未使用<constructor-arg>标签, 则(当且仅当该构造方法的所有参数均找到才会对属性赋值, 否则设为缺省值, 找不到或找到多个都将该成员属性设为缺省值); 
    -->
</bean>

<!--Tip:
    1. Spring中bean的注入相当于在ICO容器中创建(new)了一个该bean的class类, 并为其成员属性赋值; 
    2. 若注入的bean为一个方法类没有成员变量, 可以不为其配置参数; 
    3. 如果为实体类创建了构造方法, 那么必须同时为其创建无参构造, 否则无法使用set注入和p命名空间注入; 
    4. bean标签还可以设置name属性, 为该bean设置别名, 可同时设置多个, 不同的别名可以分号、空格或逗号隔开;
-->
```

```xml
<!-- 各种集合的注入 -->

<bean id="该bean的唯一标识" class="class的全类名">
    <!-- Array、List、Set三种集合的注入方式 -->
    <[property|constructor-arg] name="class中[集合类型setXxx()方法中首字母小写的Xxx部分 | 在构造方法中的参数名]">
        <[array|list|set]>
            <!-- 字符串或数值集合 -->
            <value>value1</value>
            <value>value2</value>
            ···
            <!-- 复杂类型的集合 -->
            <ref bean="复杂元素1对应bean的id"/>
            <ref bean="复杂元素2对应bean的id"/>
            ···
            </[array|list|set]>
        </[property|constructor-arg]>
    <!-- Map集合的注入方式 -->
    <[property|constructor-arg] name="class中[集合类型setXxx()方法中首字母小写的Xxx部分 | 在构造方法中的参数名]">
        <map>
            <!-- 字符串或数值映射 -->
            <entry key="key值1" value="key值1对应的value"/>
            <entry key="key值2" value="key值2对应的value"/>
            <!-- 复杂类型的映射 -->
            <entry key="key值1" value-ref="key值1对应的复杂元素对应bean的id"/>
            <entry key="key值2" value-ref="key值2对应的复杂元素对应bean的id"/>
            ···
        </map>
        </[property|constructor-arg]>
    <!-- Properties集合的注入方式 -->
    <[property|constructor-arg] name="class中[集合类型setXxx()方法中首字母小写的Xxx部分 | 在构造方法中的参数名]">
        <props>
            <prop key="key值1">key值1对应的value</prop>
            <prop key="key值2">key值2对应的value</prop>
            ···
        </props>
        </[property|constructor-arg]>
</bean>
```

> #### 向Spring IOC容器(java类版本)中注入bean

```java
// 复杂成员属性自行创建的方式:
@Bean(value = "为该bean设置name值"/name = "为该bean设置name值")
public returnType methodName() {
    直接创建(new)一个returnType类型的对象
    通过setter方法或构造方法对其成员属性赋值
    return 创建的对象名;	
}

// 复杂成员属性引入相应bean的方式:
@Bean(value = "为该bean设置name值"/name = "为该bean设置name值")
public returnType methodName(paramType1 paramName,paramType2 paramName,···) {
    直接创建(new)一个returnType类型的对象
    可以通过对象的setter方法或构造方法使用方法中的参数来对其成员属性赋值(赋值时, 会自动在IOC容器中寻找class为paramType类型的bean, 找不到则报错(若不想报错可以在参数前添加注解@Autowired并将其属性required设为false, 如此若找不到class匹配的bean, 则赋值为缺省值); 若IOC容器中同时存在多个class符合要求的bean,则按paramName寻找id匹配的bean, 找不到则报错(可为参数添加注解@Qualifier(value = "beanId"), 在多个class匹配的bean中选择指定id匹配的bean)
    return 创建的对象名;	
}
/*TIP: 
    1. 如果不设置@bean的value/name属性, 则默认value/name值为该方法的方法名;
    2. value/name可同时设置多个值, 形如{"name1","name2","···"}, value/name设置一个即可, 若同时设置, 必须保证二者内容完全一致;
    3. 该方式相当于xml中设置<bean name="@bean的value属性值" class="returnType的全类名"/>;
*/
```

> #### 三层注解(功能注解)方式向Spring IOC容器中注入bean

```jsp
<!-- 准备工作 -->
使用注解方式向IOC容器进行依赖注入需要Spring xml头文件中引入context命名空间之后开启注解扫描功能, 并指明使用注解类所在的"包路径"以便Spring识别注解, 即: 
<!-- 若使用xml版本IOC容器, 需要在xml配置文件中添加如下标签来开启扫描组件用于识别Spring注解 -->
<context:component-scan base-package="需要扫描的包路径(如需扫描多个包, 各路径之间通过","相隔)"/>
<%
/*若使用配置类版本的IOC容器, 则需要在java配置类中添加如下类注解标签来开启扫描组件*/
 @ComponentScan(basePackages = {"需要扫描的包路径"(如需扫描多个包, 各路径之间通过","相隔)})
%>
```

```java
/*向IOC容器中注入bean的注解:*/
    @Service("设置id值") ——> 用于标注业务层组件
    @Controller("设置id值") ——> 用于标注控制层组件(如struts中的action)
    @Repository("设置id值") ——> 用于标注数据访问组件, 即DAO组件
    @Component("设置id值") ——> 泛指组件, 当组件不好归类的时候, 我们可以使用这个注解进行标注
/*Tip:
    以上四种类注解作用完全相同, 相当于在Spring xml文件中做如下操作: 
        <bean id="id值" class="使用注解的类的全类名"/>
    若注解中设置了"id值"则<bean>的id值为所设置的id值, 若注解中未设置"id值"则<bean>的id值该类的类名且"首字母小写"
*/
 
/*向类中成员属性赋值的注解:*/
    @Value("属性值") ——> 用于基本类型的成员属性(String、int、···) 
    @Autowired() ——> 用于复杂类型的成员属性, 开启自动装配, 且为按数据类型装配, 自动在IOC容器中寻找class为该成员属性数据类型的全类名的bean, 找不到则报错(若将其属性required值设置为false, 找不到class与之匹配的bean时则不会报错, 而是将该成员属性设置为缺省值), 若IOC容器中同时存在多个class符合要求的bean,则按成员属性的属性名寻找id匹配的bean, 找不到则报错！
    @Qualifier(value = "beanId") ——> 与@Autowired()联用, 可以指定要查找的bean的id值, 防止单独使用@Autowired()遇到IOC容器中同时存在多个class符合要求的bean而报错的情况！
    @Resource(name = "beanId",type = 属性类型.class) ——> 用于复杂类型的成员属性, 自动在IOC容器中寻找id为name值, class为type值[去掉.class]的全类名bean,找不到则报错(注意: type仅可设置为与该成员属性数据类型的类型, 或其子类型, 否则即便查找到符合要求的bean, 也会因与设定的成员属性的数据类型不符而报错); 也可以只配指其中一个属性, 按bean的id或class查找相应的bean, 若仅按id查找, 匹配到bean后依然会判断其class是否满足要求(即判断该bean的class是否与成员属性的数据类型一致, 或者为其子类, 不符则报错), 若仅按class查找则也会存在因IOC容器中同时存在多个class符合要求的bean而报错的情况; 若两个属性都不配置, 则先寻找id为成员属性的属性名的bean(匹配到依然会对class进行判断), 找不到则寻找class为该成员属性数据类型全类名的bean, 找不到或找到多个, 都报错！
/*TIP:
    1. 注解方式为成员属性赋值不需要在类中创建setter方法以及构造方法
    2. @Resource注解是J2EE的注解, 需要导入jar包: annotations-api.jar, 因此, 建议使用@Resource注解, 以减少代码和Spring之间的耦合
    3. 对于自动装配未匹配到id值, 但同时匹配到多个class满足条件的bean而报错的情况, 可以通过将其中一个bean设置为默认选项来解决(如此当匹配到多个时自动选择默认bean): 
        对于通过xml<bean>标签导入的bean: 在<bean>标签中设置属性primary="true"
        对于通过配置类@Bean导入的bean: 为其添加方法注解@Primary(添加该注解的bean的优先级高于通过属性名匹配的id)
        对于三层注解导入的bean: 为其添加类注解@Primary(添加该注解的bean的优先级高于通过属性名匹配的id)
*/      
```

> #### 在Java代码中调用

````java

/*获取并初始化xml版本Spring ICO容器*/
ApplicationContext context = new ClassPathXmlApplicationContext("Spring的xml配置文件的路径");
/*获取并初始化Java配置类版本Spring ICO容器*/
ApplicationContext context = new AnnotationConfigApplicationContext("javap配置类的类名".class);
/*从Spring ICO容器中获取对象并强转为bean标签中配置的对象类型(class), 仅给出最常用的获取方式*/
bean的class类型 objectName = (bean的class类型)context.getBean("配置文件bean标签的id值(或name中包含的别名)");
````

> > ###### 注

```java
对于接口的实现类, 再将其注入IOC容器时虽然使用的是实现类的全类名, 但是在获取对象时, 不能用实现类接收增强类对象, 只能用接口接收
```

> > ##### 例

```java
/*实体类Person*/
package entity;

import java.util.Arrays;

public class Person {

	private String name;
	private int age;
	private Address address;
	private String[] hobby;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public Address getAddress() {
		return address;
	}

	public void setAddress(Address address) {
		this.address = address;
	}

	public String[] getHobby() {
		return hobby;
	}

	public void setHobby(String[] hobby) {
		this.hobby = hobby;
	}

	@Override
	public String toString() {
		return "Person [name=" + name + "; age=" + age + "; address=[homeAdress: " + address.getHomeAddress()
				+ ", schooAdress:" + address.getSchoolAddress() + "; hobby=" + Arrays.toString(hobby) + "]";
	}

}

```

```java
/*实体类Address*/
package entity;

public class Address {
	private String homeAddress;
	private String schoolAddress;

	public String getHomeAddress() {
		return homeAddress;
	}

	public void setHomeAddress(String homeAddress) {
		this.homeAddress = homeAddress;
	}

	public String getSchoolAddress() {
		return schoolAddress;
	}

	public void setSchoolAddress(String schoolAddress) {
		this.schoolAddress = schoolAddress;
	}

	public Address() {
	}

	public Address(String homeAddress, String schoolAddress) {
		super();
		this.homeAddress = homeAddress;
		this.schoolAddress = schoolAddress;
	}
}

```

```xml
<!-- xml配置文件(applicationContext.xml) -->
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.Springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:p="http://www.Springframework.org/schema/p"
	xsi:schemaLocation="http://www.Springframework.org/schema/beans http://www.Springframework.org/schema/beans/Spring-beans.xsd">

	<bean id="whAddress" class="entity.Address">
		<constructor-arg value="黑龙江省哈尔滨医科大学"
			name="schoolAddress" />
		<constructor-arg value="黑龙江省密山市" name="homeAddress" />
	</bean>

	<bean id="wh" class="entity.Person">
		<property name="name" value="王浩" />
		<property name="age" value="21" />
		<property name="address" ref="whAddress" />
		<property name="hobby">
			<array>
				<value>吃</value>
				<value>喝</value>
				<value>玩</value>
				<value>乐</value>
				<value>编程</value>
			</array>
		</property>
	</bean>
    
</beans>
```

```java
/*java配置类(applicationContext.java)*/
package javaIOC;

import org.Springframework.context.annotation.Bean;
import org.Springframework.context.annotation.Configuration;
import entity.Address;
import entity.Person;

@Configuration
public class applicationContext {
 
    @Bean
	public Address address() {
		Address address = new Address("黑龙江省密山市", "黑龙江省哈尔滨医科大学");
		return address;
	}
	
	@Bean
	public String[] hobby() {
		String[] hobby = new String[] {"吃","喝","玩","乐","编程"};
		return hobby;
	}
	
	@Bean(name = "wh")
	public Person MyPerson(Address address,String[] hobby) {
		Person person = new Person();
		person.setName("王浩");
		person.setAge(21);
		person.setAddress(address);
		person.setHobby(hobby);
		return person;	
	}
    
/*成员属性不引用bean的注入方式: 
	@Bean(name = "wh")
	public Person MyPerson() {
		Person person = new Person();
		person.setName("王浩");
		person.setAge(21);
		Address address = new Address("黑龙江省密山市", "黑龙江省哈尔滨医科大学");
		person.setAddress(address);
		person.setHobby(new String[] {"吃","喝","玩","乐","编程"});
		return person;	
	}
*/ 

}

```

```java
/*Java调用*/
package test;

import org.Springframework.context.ApplicationContext;
import org.Springframework.context.support.ClassPathXmlApplicationContext;
import entity.Person;

public class SpringDemo1 {
	public static void main(String[] args) {
          ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
          //  = new AnnotationConfigApplicationContext(applicationContext.class); 
          Person person = (Person) context.getBean("wh");
          System.out.println(person);
	}
}
```

```java
/*结果展示*/
Person [name=王浩; age=21; address=[homeAdress: 黑龙江省密山市, schooAdress:黑龙江省哈尔滨医科大学; hobby=[吃, 喝, 玩, 乐, 编程]]
```

---

### Spring IOC容器的合并

> #### 基于xml的IOC容器的合并

```xml
<!--
在Spring xml版IOC容器中可以通过如下标签引入其他的Spring xml配置文件(每个标签只能引入一个文件)
-->
<import resource="其他Spring xml文件的路径"/>

<!-- 
如果想在xml版本的IOC容器中引入配置类版本的IOC容器, 只需要将配置类当成普通的bean在XML中进行声明即可(可以省略id属性), 并且开启注解激活！！！
-->
<context:annotation-config/>
<!-- 该标签是用于开启注解激活, 用于识别bean中包含的注解, 如果已经配置过扫描组件, 即<context:component-scan>标签, 则可省略该标签, 因为扫描组件默认开启注解激活功能 -->
<bean class="配置类的全类名"/>
```

> #### 基于Java配置类的IOC容器的合并

```java
/*
在Spring 配置类的IOC容器中, 可以使用以下类注解引入其他的Spring Java配置类或xml配置文件
*/
@Import(value = {其他配置类的全类名.class(多个配置类之间用","分隔)})
@ImportResource(locations = {其他xml配置文件的路径(多个配置类之间用","分隔)})
```

> #### 区别: 

```jsp
    a. xml配置文件中引入其他文件的方式, 默认在哪里引入文件, 就将被引入文件中的<bean>依次放在什么位置上！
    b. Java配置类中引入其他文件, 默认将被引入的文件的<bean>, 依次存放在本文件所有<bean>之后！  
<!-- 
      因此要避免个文件中存在有相同id的bean, 否则以位置靠后的bean为准！！！
-->
```

---

### Spring IOC容器中引入属性文件

```xml
xml版本IOC容器中引入propeerties属性文件
<context:property-placeholder location="文件路径1,文件路径2,···">
<!--Tip: 注意要在xml头文件中引入context命名空间 -->
```

```java
Java配置类版本IOC容器中引入propeerties属性文件
/*添加类注解*/
@PropertySource(value = {"文件路径1","文件路径2","···"})
```

```jsp
由于propeerties属性文件的性质, 只能将其value值赋给基本类型的属性:

<property name="···" value="${propeerties文件中的key值}" />

<%
@Value("${propeerties文件中的key值}")
 %>

<!-- Tip: 
使用IOC容器合并时, 仅需向其中一个容器中引入propeerties属性文件即可, 所有合并的IOC容器所包含的所有子IOC容器中可以共同使用
-->
```

---

### Spring bean的作用域

```xml
Spring <bean>标签有一个属性"scope"决定该<bean>的作用域[注解方式可以通过类注解@Scope("···")设置], 即决定该<bean>是单实例还是多实例, 其可设置的参数值如下:
    
    a. singleton ——> 默认值, 表明该<bean>为单实例, 默认在IOC容器初始化时将该<bean>实例化, 之后由Spring负责管理该<bean>的整个生命周期, 即如果在外部获取该<bean>并对其进行修改, 则IOC容器中的<bean>也会随之改变, 再次请求获取该<bean>时, 得到的是被修改后<bean>
    <!-- 若不想单实例的bean在IOC容器初始化时被实例化, 可以通过将<bean>标签的属性lazy-init设置为"true"的为其开启延迟加载(注解方式可以通过添加类注解@Lazy开启延迟加载), 即只有在第一次调用该bean时才会被实例化, 之后一直存放在IOC容器中！值得注意的是, lazy-init属性只对作用域为singleton的<bean>起作用, 因为其他作用域的<bean>本身在IOC容器初始化的时候就不会被实例化！！ -->

    b. prototype ——> 表明该<bean>为多实例, 默认在IOC容器初始化时不会将该<bean>实例化,Spring不负责管理该<bean>的整个生命周期, 每获取一次该<bean>, 都会重新对该<bean>进行一次实例化, 即如果在外部获取该<bean>并对其进行修改, 则IOC容器中的<bean>不会发生变化, 再次请求获取该<bean>时, 得到的依然时IOC容器重新实例化的<bean>

    c. request ——> 仅能在web项目中使用且需要其他配置, 表明该<bean>在不同请求之间为多实例, 同一个请求(请求转发)之内为单实例, 即在不同请求中获取该<bean>都为IOC容器重新实例化的<bean>, 而在一次请求中获取该<bean>并对其进行修改, 在请求转发后再次获取该<bean>,得到的是被修改后<bean>

    d. session ——> 仅能在web项目中使用且需要其他配置, 表明该<bean>在不同session之间为多实例, 同一个session之内为单实例, 即在不同的会话之间获取该<bean>都为IOC容器重新实例化的<bean>, 而在同一次会话之内, 一切请求都共享同一个该<bean>,该<bean>在被某一次的请求修改后, 其他请求获取的该<bean>,得到的是被修改后<bean>
     
    
<!--Tip:
    <bean>的作用域建立在从同一个Spring IOC容器中调用的基础上(同一个IOC容器指同一个ApplicationContext对象)
-->
```

```xml
<!-- request和session需要做的配置: -->
1. 需要在web.xml中配置Spring-web的两个个预设监听器: 
    <!-- 第一个监听器请参考Spring整合web项目的配置, 用于初始化Spring IOC容器 -->
    <!-- 第二个监听器如下: (该监听器监听request对象,用于识别用户通过requst获取<bean>) -->
    <listener>
    <listener-class>org.Springframework.web.context.request.RequestContextListener</listener-class>
    </listener>
2. 如果scope设置为session, 还需要在相应的<bean>标签中加入<aop:scoped-proxy/>, 形如: 
    <bean id="···" class="···" scope="session">
		<aop:scoped-proxy />
         ···
    </bean>
```

---

### Spring bean的生命周期

```java
/*bean的生命周期*/
创建 ——> 初始化(实例化) ——> 销毁
    创建: 即bean在IOC容器中完成对象的创建
    初始化: 在bean创建完成后执行的操作
    销毁: 当IOC容器关闭时执行的操作(仅限作用域为"singleton"的bean)
因此我们可以为bean设置初始化方法, 和销毁方法: 

/*Tip: 
    销毁方法的使用仅限作用域为"singleton"的bean, 因为Spring IOC容器不负责其他作用域的bean的完整的声明周期, 仅负责它们的创建和初始化
*/
```

> #### 自定义初始化和销毁方法

```java
Step1. 在bean对象的类中自行创建方法(方法名随意)
Step2. 配置bean的初始化和销毁的方法

    a. 若使用的是xml中通过<bean>标签向Spring IOC注入的bean, 需要配置"init-method"和"destroy-method"两个属性: 
    <bean id="···" class="···" init-method="类中自定义的初始化方法名" destroy-method="类中自定义的销毁方法名">
    </bean>

    b. 若使用的是Java配置类@Bean注解向Spring IOC注入的bean, 需要配置"initMethod"和"destroyMethod"两个属性:
    @Bean(name = "为该bean设置id值", initMethod = "类中自定义的初始化方法名", destroyMethod = "类中自定义的销毁方法名") 

    c. 若使用的是三层注解方式向Spring IOC容器中注入的bean, 需要在类中为自定义方法添加注解"@PostConstruct(表明该方法为初始化方法)"和"@PreDestroy(表明该方法为销毁方法)"
        
```

> #### 接口实现初始化和销毁方法

```java
Step1. 对于bean对象的类实现接口"InitializingBean(初始化)"和"DisposableBean(销毁)"
Step2. 重写两个接口中的方法"afterPropertiesSet()"和"destroy()"
```

---

### Spring AOP——面向切面编程

> #### AOP个人理解

```java
通过AOP可以实现在目标方法"执行前、执行后或执行过程发生异常时"执行指定的方法, 将该指定的方法称为"通知"！
    "通知"可分为: 
        a. 前置通知: 即在目标方法执行前执行的通知方法; 
        b. 最终通知: 即在目标方法执行(不论有无异常)后执行的通知方法; 
        c. 异常通知: 即在目标方法执行过程中因发生异常而终止时, 执行的通知方法; 
        d. 后置通知: 即在目标方法顺利执行(无异常发生)后执行的通知方法; 
        e. 环绕通知——拦截器: 即作在目标方法的前后、异常发生时、最终等各个地方都可以执行的通知方法——最强大的一个通知; 可以获取目标方法的全部控制权(可以决定目标方法是否执行以及目标方法的返回值); 
    
必要jar包: 
        aopalliance-Xxx.jar
        aspectjweaver-Xxx.jar
```

---

### Spring AOP切入点表达式

> #### 作用

```java
用于识别目标方法, 即用于判断通知方法作用的方法对象
```

> #### 形式

| 可用的通配符 |                         通配符的定义                         |
| :----------: | :----------------------------------------------------------: |
|    *****     |                    表示匹配任何数量的字符                    |
|    **+**     |   仅能作为后缀放在类型模式后边, 匹配指定类型(接口)的子类型   |
|   **···**    | 类型模式中匹配任何数量的子包; 而在方法参数模式中匹配任何数量的参数 |

```java
切入点表达式的一般形式为 "execution([注解?] [修饰符(public)?] [返回值类型(int,string,···)] [类路径.?][方法名](参数类型列表) [抛出异常类型?])", 注意是"参数类型列表"而非"参数列表", 只需要写名每个参数的类型以逗号分割, 如果参数的类型是自己创建的实体类, 需写名该类的全类名！其中带?的是可选参数！！！

/*例: 
    execution(* *.*(···))或execution(* *(···)) ——> 全通配, 任何方法

    execution(public * *(···)) ——> 任何公共方法的

    execution(returnType methodName(paramType1,paramType2,···)) ——> 目标方法为返回类型为returnType、方法名为methodName且第一个参数的类型为paramType1,第二个参数的类型为paramType2,···的方法;

    execution(public * classQualifiedName.methodName(···)) ——> 目标方法为公共方法、返回类型为任意类型、位于classQualifiedName类下, 方法名为methodName的任意方法;

    execution(public returnType packageName1.methodName(···)) ——> 目标方法为公共方法、返回类型为returnType、位于包packageName1或其子包下所有类中方法名为methodName的任意方法;

    execution(public returnType interfaceName+.*(···)) ——> 目标方法为公共方法、返回类型为returnType、实现接口interfaceName的类下的任意方法;
*/
```

> #### 同一个切入点配置多个表达式

```java
同一个切入点可以设置多个切入点表达式, xml中切入表达式之间的逻辑关系可以用"and、or、not"进行连接, Java注解中切入表达式之间的逻辑关系可以用"&&、||、!"进行连接

/*例: 
    xml: "execution(目标方法表达式1) or execution(目标方法表达式2)"
    注解: "execution(目标方法表达式1) || execution(目标方法表达式2)"
*/
```

---

### 基于接口的方式实现AOP

> #### 通过接口创建"通知"类

| 通知类型 |               需要实现的接口类               |
| :------: | :------------------------------------------: |
| 前置通知 |  org.springframework.aop.MethodBeforeAdvice  |
| 最终通知 |            没有最终通知的实现接口            |
| 异常通知 |     org.springframework.aop.ThrowsAdvice     |
| 后置通知 | org.springframework.aop.AfterReturningAdvice |
| 环绕通知 | org.aopalliance.intercept.MethodInterceptor  |

```java
/*前置通知*/
public class LogBeforeName  implements MethodBeforeAdvice{
	//重写接口方法
	@Override
	public void before(Method method, Object[] args, Object target) throws Throwable {
        // method ——> 目标方法
        // args ——> 目标方法的参数列表
        // target ——> 目标方法所在的对象
	}	
}
```

```java
/*异常通知*/
public class LogException implements ThrowsAdvice {
	//异常通知的具体方法, 接口中没有默认方法, 但源码注释中提示必须写如下两种方法中的一个
    // 方法一:
	public void afterThrowing(Method method, Object[] args, Object target, Throwable e){
		// method ——> 目标方法
		// args ——> 目标方法的参数列表
		// target ——> 目标方法所在的对象
		// e ——> 目标方法执行过程中捕获的异常
	}
    // 方法二:
    public void afterThrowing(Throwable e){
		// e ——> 目标方法执行过程中捕获的异常
	}
}
```
```java
/*后置通知*/
public class LogAfterName implements AfterReturningAdvice{
	//重写接口方法
    @Override
	public void afterReturning(Object returnValue, Method method, Object[] args, Object target) throws Throwable {
		// returnValue ——> 目标方法执行后的返回值
		// method ——> 目标方法
		// args ——> 目标方法的参数列表
		// target ——> 目标方法所在的对象
	}
}
```

```java
/*环绕通知——拦截器*/
public class LogAroundName  implements MethodInterceptor{
    //重写接口方法
	@Override
	public Object invoke(MethodInvocation invocation) throws Throwable {
        /*可以从invocation中获取目标方法的信息: 
                a. invocation.getThis() ——> 目标方法所在的对象
                b. invocation.getMethod() ——> 目标方法
                c. invocation.getArguments() ——> 目标方法的参数列表
       */
		Object result  = null; 
		try {
			/*前置通知域*/
			 result  = invocation.proceed(); //控制着目标方法的执行, 并获取返回结果
			/*后置通知域*/
		} catch(Throwable e) {
			/*异常通知域*/
		} finally {
			/*最终通知域*/
		}
		return result;//目标方法的返回值(*此处的返回结果可以覆盖目标方法的真实返回结果*)
	}

}
```

> #### 在Spring的xml配置文件中建立AOP关联

```xml
<!--
需要先通在头文件引入aop命名空间: 
-->

<beans xmlns="http://www.Springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:p="http://www.Springframework.org/schema/p"
	xmlns:aop="http://www.Springframework.org/schema/aop"
	xsi:schemaLocation="http://www.Springframework.org/schema/beans
                        http://www.Springframework.org/schema/beans/Spring-beans.xsd
                        http://www.Springframework.org/schema/aop
                        http://www.Springframework.org/schema/aop/Spring-aop-4.3.xsd">
    
    <!-- 将业务类(目标方法所在类)、通知类(通知方法所在的类)纳入SpringIOC容器——即创建<bean> -->
    <bean id="···" class="业务类全类名"/>
    <bean id="···" class="通知类全类名"/>
    <!-- 配置aop -->
    <aop:config>
        <aop:pointcut expression="切入点表达式execution(···)" id="该pointcut标签的唯一标识"/>
        <aop:advisor advice-ref="通知类的beanId值" pointcut-ref="<aop:pointcut>的id值"/> 
        <!-- 以上<aop:advisor>标签除了可以通过"pointcut-ref"引用切入点外, 也可以通过"pointcut"属性结合切入点表达式直接设置切入点 -->
        <!-- 可存在多个pointcut和advisor标签 -->
    </aop:config>
    
</beans>
```


> > ##### 例

```java
/*前置通知类*/
public class LogBefore implements MethodBeforeAdvice{
	@Override
	public void before(Method method, Object[] args, Object target) throws Throwable {
		System.out.println("==============Befor Log Start================");
		System.out.println("目标方法所在对象: " + target + "\n目标方法名: " + method.getName() + "\n参数个数: " + args.length);
		System.out.println("===============Befor Log End=================");
	}
}

/*异常通知类*/
public class LogException implements ThrowsAdvice{
	public void afterThrowing(Throwable e) {
		System.out.println("==============Exception Log Start================");
		System.out.println("异常信息: " + e.getMessage());
		System.out.println("===============Exception Log End=================");
	}
}

/*后置通知类*/
public class LogAfter implements AfterReturningAdvice{
	@Override
	public void afterReturning(Object returnValue, Method method, Object[] args, Object target) throws Throwable {
		System.out.println("==============After Log Start================");
		System.out.println("目标方法所在对象: " + target + "\n目标方法名: " + method.getName() + "\n参数个数: " + args.length + "\n返回结果: " + returnValue);
		System.out.println("===============After Log End=================");	
	}
}

/*环绕通知类*/
public class LogAround implements MethodInterceptor {
	@Override
	public Object invoke(MethodInvocation invocation) throws Throwable {
		Object result = null;
		try {
			System.out.println("==============Around Befor Log Start================");
			System.out.println("目标方法所在对象: " + invocation.getThis() + "\n目标方法名: " + invocation.getMethod().getName() + "\n参数个数: " + invocation.getArguments().length);
			System.out.println("===============Around Befor Log End=================");
            
			result = invocation.proceed();
            
			System.out.println("==============Around After Log Start================");
			System.out.println("目标方法所在对象: " + invocation.getThis() + "\n目标方法名: " + invocation.getMethod().getName() + "\n参数个数: " + invocation.getArguments().length + "\n返回结果: " + result);
			System.out.println("===============Around After Log End=================");
		} catch (Throwable e) {
			System.out.println("==============Around Exception Log Start================");
			System.out.println("异常信息: " + e.getMessage());
			System.out.println("===============Around Exception Log End=================");
			e.printStackTrace();
		} finally {
			System.out.println("==============Around Finally Log End================");
			System.out.println("最终通知: 程序正常运行结束或因异常终止");
			System.out.println("===============Around Finally Log End=================");
		}
		return result;
	}
}
```

```java
/*目标方法类*/
public class AOPtest {
	public void test1() {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		Person person = (Person) context.getBean("wh");
		System.out.println(person);
	}
}
```

```xml
<!-- 在"Spring的使用"示例的xml基础上追加以<beans>标签下的内容(注意头文件的区别) -->
<beans xmlns="http://www.Springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:p="http://www.Springframework.org/schema/p"
	xmlns:aop="http://www.Springframework.org/schema/aop"
	xsi:schemaLocation="http://www.Springframework.org/schema/beans http://www.Springframework.org/schema/beans/Spring-beans.xsd
		http://www.Springframework.org/schema/aop http://www.Springframework.org/schema/aop/Spring-aop-4.3.xsd">
    
        <bean id="ADPtest" class="test.AOPtest"/>
        <bean id="logBefore" class="Log.LogBefore"/>
        <bean id="LogException" class="Log.LogException"/>
        <bean id="logAfter" class="Log.LogAfter"/>
        <bean id="logAround" class="Log.LogAround"/>

        <aop:config>
            <aop:pointcut expression="execution(public * test.AOPtest.test1(···))" id="pointcut"/>
            <aop:advisor advice-ref="logBefore" pointcut-ref="pointcut"/>
            <aop:advisor advice-ref="logAfter" pointcut-ref="pointcut"/>
            <aop:advisor advice-ref="LogException" pointcut-ref="pointcut"/>
            <aop:advisor advice-ref="logAround" pointcut-ref="pointcut"/>
        </aop:config>
    
</beans>
```

```java
/*测试类*/
public class SpringDemo1 {
	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		AOPtest aopTest = (AOPtest) context.getBean("ADPtest");
		aopTest.test1();
	}
}
```

```java
/*结果展示*/
==============Befor Log Start================
目标方法所在对象: test.AOPtest@2584b82d
目标方法名: test1
参数个数: 0
===============Befor Log End=================
==============Around Befor Log Start================
目标方法所在对象: test.AOPtest@2584b82d
目标方法名: test1
参数个数: 0
===============Around Befor Log End=================
Person [name=王浩; age=21; address=[homeAdress: 黑龙江省密山市, schooAdress:黑龙江省哈尔滨医科大学; hobby=[吃, 喝, 玩, 乐, 编程]]
==============Around After Log Start================
目标方法所在对象: test.AOPtest@2584b82d
目标方法名: test1
参数个数: 0
返回结果: null
===============Around After Log End=================
==============Around Finally Log End================
最终通知: 程序正常运行结束或因异常终止
===============Around Finally Log End=================
==============After Log Start================
目标方法所在对象: test.AOPtest@2584b82d
目标方法名: test1
参数个数: 0
返回结果: null
===============After Log End=================
```

---

### 基于注解实现AOP

> #### 通过注解创建"通知"类

|      注解       | 注解对象 |                 作用                 |
| :-------------: | :------: | :----------------------------------: |
|     @Aspect     |  Java类  | 声明该类为切面类, 即通知方法所在的类 |
|     @Before     |   方法   |        声明该方法为"前置通知"        |
|     @After      |   方法   |        声明该方法为"最终通知"        |
| @AfterThrowing  |   方法   |        声明该方法为"异常通知"        |
| @AfterReturning |   方法   |        声明该方法为"后置通知"        |
|     @Around     |   方法   |        声明该方法为"环绕通知"        |

```java
/*声明切面类——通知类*/
@Aspect
public class LogAnnotationClassName {
    
    /*
    设置切入点, 该注解标识的方法的"方法名()"视为该pointcut的唯一标识
    相当于在xml中设置<aop:pointcut expression="切入点表达式execution(···)" id="pcName()"/>
    可以在同类下通知注解中通过"方法名()"引用切入点, 注意要有括号, 否则会报错
   */
    @Pointcut("切入点表达式execution(···)")
    private void pcName() {}
    
	/*前置通知*/
    @Before("切入点表达式execution(···)"|"pcName()")
	public void beforeLogAnnotationName(JoinPoint paramName) {

	}

	/*最终通知*/
    @After("切入点表达式execution(···)"|"pcName()")
	public void finallyLogAnnotationName(JoinPoint paramName) {

	}
    
	/*异常通知*/
    @AfterThrowing(pointcut = "切入点表达式execution(···)"|"pcName()",throwing = "异常对象的别名")
	public void exceptionLogAnnotationName(JoinPoint paramName,Throwable 注解中throwing的值) {

	}
    
    /*后置通知*/
    @AfterReturning(pointcut = "切入点表达式execution(···)"|"pcName()",returning = "返回结果对象的别名")
	public void afterLogAnnotationName(JoinPoint paramName,Object 注解中returning的值) {

	}
/*以上五种通知方法均可设置一个类型为"JoinPoint"的参数, 该参数包含了目标方法执行的信息:
    a. paramName.getTarget() ——> 目标方法所在对象
    b. paramName.getSignature() ——> 目标方法
    c. paramName.getArgs() ——> 目标方法的参数列表
*/
    
	/*环绕通知*/
    @Around("切入点表达式execution(···)"|"pcName()")
	public Object roundLogAnnotationName(ProceedingJoinPoint paramName) {
        /*环绕通知需设置一个类型为"ProceedingJoinPoint"的参数, 可从其中获取目标方法执行的信息:
            a. paramName.getTarget() ——> 目标方法所在对象
            b. paramName.getSignature() ——> 目标方法
            c. paramName.getArgs() ——> 目标方法的参数列表
		*/
        Object result  = null; 
		try {
			/*前置通知域*/
			 result  = paramName.proceed(); //控制着目标方法的执行, 并获取返回结果
			/*后置通知域*/
		} catch(Throwable e) {
			/*异常通知域*/
		} finally {
			/*最终通知域*/
		}
		return result;//目标方法的返回值(*此处的返回结果可以覆盖目标方法的真实返回结果*)
	}

}

/*Tip: 可以设置多个切入点一级同类型的通知, 只要方法名不重复即可！！！*/
```

> #### 在Spring的配置文件中建立AOP关联

```xml
xml版本
<!--
需要先通在头文件引入aop命名空间: 
-->

<beans xmlns="http://www.Springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:p="http://www.Springframework.org/schema/p"
	xmlns:aop="http://www.Springframework.org/schema/aop"
	xsi:schemaLocation="http://www.Springframework.org/schema/beans
                        http://www.Springframework.org/schema/beans/Spring-beans.xsd
                        http://www.Springframework.org/schema/aop
                        http://www.Springframework.org/schema/aop/Spring-aop-4.3.xsd">
    
    <!-- 将业务类(目标方法所在类)、通知类(通知方法所在的类)纳入SpringIOC容器 -->
    <bean id="···" class="业务类全类名"/>
    <bean id="···" class="通知类全类名"/>
    <!-- 开启aop注解自识别(注意: 此处区别于"接口实现"的方法) -->
    <aop:aspectj-autoproxy></aop:aspectj-autoproxy> <!-- 或<aop:aspectj-autoproxy/> -->

</beans>
```

```java
java配置类版本
/*将业务类(目标方法所在类)、通知类(通知方法所在的类)纳入SpringIOC容器*/
/*为配置类添加如下类注解开启aop注解自识别:*/
    @EnableAspectJAutoProxy
```

> > ##### 例

``` java
/*声明切面类*/
@Aspect
public class LogAnnotation {
    /*前置通知方法*/
	@Before("execution(public * test.AOPtest.test1(···))")
	public void beforeLogAnnotation(JoinPoint jp) {
		System.out.println("======Annotation Befor Log Start======");
		System.out.println("目标方法所在对象: " + jp.getTarget() + "\n目标方法名: " + jp.getSignature().getName() + "\n参数个数: " + jp.getArgs().length);
		System.out.println("=======Annotation Befor Log End=======");
	}
    
	/*最终通知方法*/
    @After("execution(public * test.AOPtest.test1(···))")
	public void finallyLogAnnotation(JoinPoint jp) {
		System.out.println("======Annotation finally Log Start======");
		System.out.println("目标方法所在对象: " + jp.getTarget() + "\n目标方法名: " + jp.getSignature().getName() + "\n参数个数: " + jp.getArgs().length);
		System.out.println("=======Annotation finally Log End=======");
	}
    
    /*异常通知方法*/
    @AfterThrowing(pointcut = "execution(public * test.AOPtest.test1(···))",throwing = "e")
	public void exceptionLogAnnotation(JoinPoint jp,Throwable e) {
		System.out.println("======Annotation Exception Log Start======");
		System.out.println("异常信息: " + e.getMessage());
		System.out.println("=======Annotation Exception Log End=======");
	}
    
	/*后置通知方法*/
    @AfterReturning(pointcut = "execution(public * test.AOPtest.test1(···))",returning = "result")
	public void afterLogAnnotation(JoinPoint jp,Object result) {
		System.out.println("======Annotation After Log Start======");
		System.out.println("目标方法所在对象: " + jp.getTarget() + "\n目标方法名: " + jp.getSignature().getName() + "\n参数个数: " + jp.getArgs().length + "\n返回结果: " + result);
		System.out.println("=======Annotation After Log End=======");
	}

	/*前置通知方法*/
    @AfterThrowing(pointcut = "execution(public * test.AOPtest.test1(···))",throwing = "e")
	public void exceptionLogAnnotation(JoinPoint jp,Throwable e) {
		System.out.println("======Annotation Exception Log Start======");
		System.out.println("异常信息: " + e.getMessage());
		System.out.println("=======Annotation Exception Log End=======");
	}

	/*环绕通知方法*/
    @Around("execution(public * test.AOPtest.test1(···))")
	public Object roundLogAnnotation(ProceedingJoinPoint pjp) {
		Object result = null;
		try {
			System.out.println("======Annotation Around Befor Log Start========");
			System.out.println("目标方法所在对象: " + pjp.getTarget() + "\n目标方法名: " + pjp.getSignature().getName() + "\n参数个数: " + pjp.getArgs().length);
			System.out.println("=======Annotation Around Befor Log End=========");
            
			result = pjp.proceed();
			
			System.out.println("======Annotation Around After Log Start========");
			System.out.println("目标方法所在对象: " + pjp.getTarget() + "\n目标方法名: " + pjp.getSignature().getName() + "\n参数个数: " + pjp.getArgs().length + "\n返回结果: " + result);
			System.out.println("=======Annotation Around After Log End=========");
		} catch (Throwable e) {
			System.out.println("======Annotation Around Exception Log Start========");
			System.out.println("异常信息: " + e.getMessage());
			System.out.println("=======Annotation Around Exception Log End=========");
			e.printStackTrace();
		} finally {
			System.out.println("======Annotation Around Finally Log End========");
			System.out.println("目标方法所在对象: " + pjp.getTarget() + "\n目标方法名: " + pjp.getSignature().getName() + "\n参数个数: " + pjp.getArgs().length);
			System.out.println("=======Annotation Around Finally Log End=========");
		}
		return result;
	}

}
```

```java
/*目标方法类*/
public class AOPtest {
	public void test1() {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		Person person = (Person) context.getBean("wh");
		System.out.println(person);
	}
}
```

```xml
<!-- 在"Spring的使用"示例的xml基础上追加以<beans>标签下的内容(注意头文件的区别) -->
<beans xmlns="http://www.Springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:p="http://www.Springframework.org/schema/p"
	xmlns:aop="http://www.Springframework.org/schema/aop"
	xsi:schemaLocation="http://www.Springframework.org/schema/beans http://www.Springframework.org/schema/beans/Spring-beans.xsd
		http://www.Springframework.org/schema/aop http://www.Springframework.org/schema/aop/Spring-aop-4.3.xsd">
    
        <bean id="ADPtest" class="test.AOPtest"/>
        <bean id="LogAnnotation" class="Log.LogAnnotation"/>

        <aop:aspectj-autoproxy/>
    
</beans>
```

```java
/*测试类*/
public class SpringDemo1 {
	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		AOPtest aopTest = (AOPtest) context.getBean("ADPtest");
		aopTest.test1();
	}
}
```

```java
/*结果展示*/
======Annotation Around Befor Log Start========
目标方法所在对象: test.AOPtest@2205a05d
目标方法名: test1
参数个数: 0
=======Annotation Around Befor Log End=========
======Annotation Befor Log Start======
目标方法所在对象: test.AOPtest@2205a05d
目标方法名: test1
参数个数: 0
=======Annotation Befor Log End=======
Person [name=王浩; age=21; address=[homeAdress: 黑龙江省密山市, schooAdress:黑龙江省哈尔滨医科大学; hobby=[吃, 喝, 玩, 乐, 编程]]
======Annotation Around After Log Start========
目标方法所在对象: test.AOPtest@2205a05d
目标方法名: test1
参数个数: 0
返回结果: null
=======Annotation Around After Log End=========
======Annotation Around Finally Log Start========
目标方法所在对象: test.AOPtest@2205a05d
目标方法名: test1
参数个数: 0
=======Annotation Around Finally Log End=========
======Annotation Finally Log Start======
目标方法所在对象: test.AOPtest@2205a05d
目标方法名: test1
参数个数: 0
=======Annotation Finally Log End=======
======Annotation After Log Start======
目标方法所在对象: test.AOPtest@2205a05d
目标方法名: test1
参数个数: 0
返回结果: null
=======Annotation After Log End=======
```

---

### 基于Schema方式实现AOP

> #### 创建"通知"类

```java
public class LogSchemaClassName {
    
	/*前置通知*/
	public void beforeLogSchemaName(JoinPoint paramName) {

	}

	/*最终通知*/
	public void finallyLogSchemaName(JoinPoint paramName) {

	}
    
	/*异常通知*/
	public void exceptionLogSchemaName(JoinPoint paramName,Throwable xml中<aop:after-throwing>标签设置的throwing的值) {

	}
    
    /*后置通知*/
	public void afterLogSchemaName(JoinPoint paramName,Object xml中<aop:after-returning>标签设置的returning的值) {

	}
/*以上五种通知方法均可设置一个类型为"JoinPoint"的参数, 该参数包含了目标方法执行的信息:
    a. paramName.getTarget() ——> 目标方法所在对象
    b. paramName.getSignature() ——> 目标方法
    c. paramName.getArgs() ——> 目标方法的参数列表
*/
    
	/*环绕通知*/
	public Object roundLogSchemaName(ProceedingJoinPoint paramName) {
        /*环绕通知需设置一个类型为"ProceedingJoinPoint"的参数, 可从其中获取目标方法执行的信息:
            a. paramName.getTarget() ——> 目标方法所在对象
            b. paramName.getSignature() ——> 目标方法
            c. paramName.getArgs() ——> 目标方法的参数列表
		*/
        Object result  = null; 
		try {
			/*前置通知域*/
			 result  = paramName.proceed(); //控制着目标方法的执行, 并获取返回结果
			/*后置通知域*/
		} catch(Throwable e) {
			/*异常通知域*/
		} finally {
			/*最终通知域*/
		}
		return result;//目标方法的返回值(*此处的返回结果可以覆盖目标方法的真实返回结果*)
	}

}
```

> #### 在Spring的xml配置文件中建立AOP关联

```xml
<!--
需要先通在头文件引入aop命名空间:
-->

<beans xmlns="http://www.Springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:p="http://www.Springframework.org/schema/p"
	xmlns:aop="http://www.Springframework.org/schema/aop"
	xsi:schemaLocation="http://www.Springframework.org/schema/beans
                        http://www.Springframework.org/schema/beans/Spring-beans.xsd
                        http://www.Springframework.org/schema/aop
                        http://www.Springframework.org/schema/aop/Spring-aop-4.3.xsd">
    
    <!-- 将业务类(目标方法所在类)、通知类(通知方法所在的类)纳入SpringIOC容器——即创建<bean> -->
    <bean id="···" class="业务类全类名"/>
    <bean id="···" class="通知类全类名"/>
    <!-- 配置AOP -->
    <aop:config>
		<aop:pointcut expression="切入点表达式execution(···)" id="该pointcut的唯一标识" />
		<aop:aspect ref="通知类对应的beanId">
			<aop:before method="通知类中前置通知的方法名" pointcut-ref="<aop:pointcut>的id"/>
			<aop:after method="通知类中最终通知的方法名" pointcut-ref="<aop:pointcut>的id"/>
			<aop:after-throwing method="通知类中异常通知的方法名" throwing="设置异常通知的异常对象参数的别名" pointcut-ref="<aop:pointcut>的id"/>
			<aop:after-returning method="通知类中后置通知的方法名" returning="设置后置通知的返回结果对象参数的别名" pointcut-ref="<aop:pointcut>的id"/>
			<aop:around method="通知类中环绕通知的方法名" pointcut-ref="<aop:pointcut>的id"/>
            <!-- 以上各种通知的标签处理可以通过"pointcut-ref"引用切入点外, 也可以通过"pointcut"属性结合切入点表达式直接设置切入点 -->
		</aop:aspect>
	</aop:config>
    
</beans>
```

> > ##### 例

```java
/*创建切面类——通知类*/
public class LogSchema {
	
	/*前置通知*/
    public void beforeLogSchema(JoinPoint jp) {
		System.out.println("======Schema Befor Log Start======");
		System.out.println("目标方法所在对象: " + jp.getTarget() + "\n目标方法名: " + jp.getSignature().getName() + "\n参数个数: " + jp.getArgs().length);
		System.out.println("=======Schema Befor Log End=======");
	}

	/*最终通知*/
    public void finallyLogSchema(JoinPoint jp) {
		System.out.println("======Schema Finally Log Start======");
		System.out.println("目标方法所在对象: " + jp.getTarget() + "\n目标方法名: " + jp.getSignature().getName() + "\n参数个数: " + jp.getArgs().length);
		System.out.println("=======Schema Finally Log End=======");
	}

	/*异常通知*/
    public void exceptionLogSchema(JoinPoint jp,Throwable e) {
		System.out.println("======Schema Exception Log Start======");
		System.out.println("异常信息: " + e.getMessage());
		System.out.println("=======Schema Exception Log End=======");
	}

	/*后置通知*/
    public void afterLogSchema(JoinPoint jp,Object result) {
		System.out.println("======Schema After Log Start======");
		System.out.println("目标方法所在对象: " + jp.getTarget() + "\n目标方法名: " + jp.getSignature().getName() + "\n参数个数: " + jp.getArgs().length + "\n返回结果: " + result);
		System.out.println("=======Schema After Log End=======");
	}

	/*环绕通知*/
    public Object roundLogSchema(ProceedingJoinPoint pjp) {
		Object result = null;
		try {
			System.out.println("======Schema Around Befor Log Start========");
			System.out.println("目标方法所在对象: " + pjp.getTarget() + "\n目标方法名: " + pjp.getSignature().getName() + "\n参数个数: " + pjp.getArgs().length);
			System.out.println("=======Schema Around Befor Log End=========");
            
			result = pjp.proceed();
			
			System.out.println("======Schema Around After Log Start========");
			System.out.println("目标方法所在对象: " + pjp.getTarget() + "\n目标方法名: " + pjp.getSignature().getName() + "\n参数个数: " + pjp.getArgs().length + "\n返回结果: " + result);
			System.out.println("=======Schema Around After Log End=========");
		} catch (Throwable e) {
			System.out.println("======Schema Around Exception Log Start========");
			System.out.println("异常信息: " + e.getMessage());
			System.out.println("=======Schema Around Exception Log End=========");
			e.printStackTrace();
		} finally {
			System.out.println("======Schema Around Finally Log Start========");
			System.out.println("目标方法所在对象: " + pjp.getTarget() + "\n目标方法名: " + pjp.getSignature().getName() + "\n参数个数: " + pjp.getArgs().length);
			System.out.println("=======Schema Around Finally Log End=========");
		}
		return result;
	}

}
```

```java
/*目标方法类*/
public class AOPtest {
	public void test1() {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		Person person = (Person) context.getBean("wh");
		System.out.println(person);
	}
}
```

```xml
<!-- 在"Spring的使用"示例的xml基础上追加以<beans>标签下的内容(注意头文件的区别) -->
<beans xmlns="http://www.Springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:p="http://www.Springframework.org/schema/p"
	xmlns:aop="http://www.Springframework.org/schema/aop"
	xsi:schemaLocation="http://www.Springframework.org/schema/beans http://www.Springframework.org/schema/beans/Spring-beans.xsd
		http://www.Springframework.org/schema/aop http://www.Springframework.org/schema/aop/Spring-aop-4.3.xsd">
    
        <bean id="ADPtest" class="test.AOPtest"/>
        <bean id="LogSchema" class="Log.LogSchema" />
    
        <aop:config>
            <aop:pointcut expression="execution(public * test.AOPtest.test1(···))" id="pointcutSchema" />
            <aop:aspect ref="LogSchema">
                <aop:before method="beforeLogSchema" pointcut-ref="pointcutSchema"/>
                <aop:after method="finallyLogSchema" pointcut-ref="pointcutSchema"/>
                <aop:after-throwing method="exceptionLogSchema" throwing="e" pointcut-ref="pointcutSchema"/>
                <aop:after-returning method="afterLogSchema" returning="result" pointcut-ref="pointcutSchema"/>
                <aop:around method="roundLogSchema" pointcut-ref="pointcutSchema"/>
            </aop:aspect>
        </aop:config>
    
</beans>
```

```java
/*测试类*/
public class SpringDemo1 {
	public static void main(String[] args) {
		ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
		AOPtest aopTest = (AOPtest) context.getBean("ADPtest");
		aopTest.test1();
	}
}
```

```java
/*结果展示*/
======Schema Befor Log Start======
目标方法所在对象: test.AOPtest@376a0d86
目标方法名: test1
参数个数: 0
=======Schema Befor Log End=======
======Schema Around Befor Log Start========
目标方法所在对象: test.AOPtest@376a0d86
目标方法名: test1
参数个数: 0
=======Schema Around Befor Log End=========
Person [name=王浩; age=21; address=[homeAdress: 黑龙江省密山市, schooAdress:黑龙江省哈尔滨医科大学; hobby=[吃, 喝, 玩, 乐, 编程]]
======Schema Around After Log Start========
目标方法所在对象: test.AOPtest@376a0d86
目标方法名: test1
参数个数: 0
返回结果: null
=======Schema Around After Log End=========
======Schema Around Finally Log Start========
目标方法所在对象: test.AOPtest@376a0d86
目标方法名: test1
参数个数: 0
=======Schema Around Finally Log End=========
======Schema After Log Start======
目标方法所在对象: test.AOPtest@376a0d86
目标方法名: test1
参数个数: 0
返回结果: null
=======Schema After Log End=======
======Schema Finally Log Start======
目标方法所在对象: test.AOPtest@376a0d86
目标方法名: test1
参数个数: 0
=======Schema Finally Log End=======
```

---

### Spring配置数据源

> #### 通用数据源配置

```xml
<!-- xml版IOC容器 -->
<bean id="dataSource" class="数据源对应类的全类名">
    配置数据源的各属性(驱动类、连接url、用户名、密码等···)
    ···
    <!-- Spring常用数据源的全类名:
        Spring—jdbc数据源 ——> org.Springframework.jdbc.datasource.DriverManagerDataSource(非连接池)
        MyBatis数据源 ——> org.apache.ibatis.datasource.pooled.PooledDataSource(连接池)
        DBCP数据源 ——> org.apache.commons.dbcp.BasicDataSource(连接池)
        C3P0数据源 ——> com.mchange.v2.c3p0.ComboPooledDataSource(连接池)
        Druid数据源 ——> com.alibaba.druid.pool.DruidDataSource(连接池)
    -->
</bean>
```

```java
/*配置类版本IOC容器*/
@Bean(name = "datasource")
public DataSource dataSource() {
		数据源类型 ds = new 数据源类型(); // 不同数据源不同
		ds.setXxx(···); // 通过setter方法 配置数据源的各属性(驱动类、连接url、用户名、密码等···)
		···
		return ds;
	}
```

> #### 获取JNDI数据源

```xml
<!-- xml版IOC容器 -->
<!-- 方式1: 通过bean标签配置 -->
<bean id="dataSource" class="org.Springframework.jndi.JndiObjectFactoryBean">       
    <property name="jndiName" value="java:comp/env/(context.xml中Resource标签的name值)"/>       
</bean>
<!-- 方式有2: 通过jee命名空间配置(配置类IOC中无法实现) -->
<jee:jndi-lookup id="dataSource" jndi-name="java:comp/env/(context.xml中Resource标签的name值)"/>

<!--Tip: Java:/comp/env为tomcat服务器默认的JNDI目录, 不同服务器JNDI目录不同 -->
```

```java
/*配置类版本IOC容器*/
@Bean("dataSource")
public DataSource dataSource() {
    JndiObjectFactoryBean ds = new JndiObjectFactoryBean();
    ds.setJndiName("java:comp/env/(context.xml中Resource标签的name值)");
    return (DataSource)ds;
}

/*Tip: Java:/comp/env为tomcat服务器默认的JNDI目录, 不同服务器JNDI目录不同*/
```

---

### Spring事务管理

> #### 理解

```java
为了简化代码, 以及提升数据库操作的安全性, 通常将数据库的事务交由Spring管理, 常用于service层！！！由Spring负责事务的开启、提交、回滚以及连接的关闭！！！
    
增加jar包: Spring-tx-Xxx.jar
```

> #### 纯xml方式管理事务

```xml
Step1. 配置数据源
<!-- 假设数据源的bean id为"datasource" -->
Step2. 创建事务管理器(以jdbc事务管理器为例), 并注入数据源
<bean id="transactionManager" class="org.Springframework.jdbc.datasource.DataSourceTransactionManager">
		<property name="dataSource" ref="dataSource(数据源对应的been id)" />
</bean>
Step3. 配置事务通知
<tx:advice id="···" transaction-manager="transactionManager(事务管理器的been id)">
    <tx:attributes>
        <tx:method name="接受事务管理器管理的方法1(可使用通配符*)"/>
        <tx:method name="接受事务管理器管理的方法2(可使用通配符*)"/>
        ···
        <!-- tx:method可设置的其他属性
            isolation ——> 设置事务隔离级别, 默认DEFAULT, 即使用数据库的默认隔离级别(不同数据库之间有差异)
            propagation ——> 设置事务传播行为, 默认REQUIRED(支持当前事务, 如果当前没有事务, 就新建一个事务); 当使用查询方法时, 推荐使用SUPPORTS(支持当前事务, 如果当前没有事务, 就以非事务方式执行), 以便提高运行效率
            timeout ——> 设置事务超时的时间(以秒为单位), 默认-1, 即永不超时
            read-only ——> 设置事务是否只读, 默认false, 即事务可读写; 设置为true仅可用于查询操作
            rollback-for ——> 设置触发事务回滚的异常类型(各类型之间以逗号分开), 没有默认值, 即任何异常都回滚
            no-rollback-for ——> 设置不触发事务回滚的异常类型(各类型之间以逗号分开), 没有默认值, 即任何异常都回滚
 		-->
    </tx:attributes>
</tx:advice>
Step4. 配置aop
<aop:config>
    <!-- 设置切入点表达式(切入点表达式中映射的方法要包含<tx:method>中的方法, 常配置在service层) -->
    <aop:pointcut id="···" expression="execution(···)" />
    <!-- 将事务通知与切入点表达式建立关联 -->
    <aop:advisor advice-ref="标签tx:advice的id值" pointcut-ref="标签aop:pointcut的id值" />
</aop:config>
```

> #### 注解结合xml的方式管理事务

```xml
Step1. 配置数据源
<!-- 假设数据源的bean id为"datasource" -->
Step2. 创建事务管理器(以jdbc事务管理器为例), 并注入数据源
<bean id="transactionManager"
		class="org.Springframework.jdbc.datasource.DataSourceTransactionManager">
		<property name="dataSource" ref="dataSource(数据源对应的been id)" />
</bean>
Step3. 开启注解事务支持
<tx:annotation-driven transaction-manager="transactionManager(事务管理器的been id)"/>
Step4. 在需要事务的地方使用@Transactional注解(需要开启注解识别)
<!-- @Transactional注解的作用对象(优先级:就近原则): 
        写在接口上, 表示该接口的所有实现类都有事务。
        写在类上, 表示该类中所有方法都有事务。
        写在方法, 表示该方法有事务。
-->
<!-- @Transactional注解的属性:  
        isolation ——> (Isolation)设置事务隔离级别, 默认Isolation.DEFAULT, 即使用数据库的默认隔离级别(不同数据库之间有差异)
        propagation ——> (Propagation)设置事务传播行为, 默认Propagation.REQUIRED(支持当前事务, 如果当前没有事务, 就新建一个事务); 当使用查询方法时, 推荐使用Propagation.SUPPORTS(支持当前事务, 如果当前没有事务, 就以非事务方式执行), 以便提高运行效率
        timeout ——> (int)设置事务超时的时间(以秒为单位), 默认-1, 即永不超时
        readOnly ——> (boolean)设置事务是否只读, 默认false, 即事务可读写; 设置为true仅可用于查询操作
        rollbackFor ——> (class[])设置触发事务回滚的异常类型, 没有默认值, 即任何异常都回滚
        rollbackForClassName ——> (String[])设置触发事务回滚的异常类型, 没有默认值, 即任何异常都回滚
        noRollbackFor ——> (class[])设置不触发事务回滚的异常类型, 没有默认值, 即任何异常都回滚
        noRollbackForClassName ——> (String[])设置不触发事务回滚的异常类型, 没有默认值, 即任何异常都回滚
-->
```

> #### 纯注解方式管理事务

```java
Step1. 在配置类版本的IOC容器中配置数据源
Step2. 在配置类版本的IOC容器中配置事务管理器
Step3. 为配置类添加类注解"@EnableTransactionManagement"开启注解事务支持
Step4. 在需要事务的地方使用"@Transactional"注解(需要开启注解识别) // 使用方法同上
/*
当配置类中配置了多个事务管理器时, 可通过@Transactional的value属性指定要使用的事务管理器, 形如: 
    @Transactional(value = "事务管理器对应的bean id")
*/
```

> > ###### 提示

```java
1. "以上三种事务管理的前提是要将要管理的方法所在的类注入IOC容器中"
2. "在要管理的方法中获取数据库连接要通过DataSourceUtils.getConnection(DataSource dataSource)来获连接, 之后进行jdbc的相关操作, 否则Spring事务管理不生效; 而且不应在该方式获取的连接上调用commit()、rollback()或close()方法, 会对数据库的操作产生影响"
3. "MyBatis要使用通过Spring IOC容器中的SqlSessionFactory获取sqlSession进行操作, 否则Spring事务管理不生效; 而且如果由Spring管理Mybatis事务, 则不应在Spring IOC容器中的SqlSessionFactory获取sqlSession上调用commit()、rollback()或close()方法, 这些方法将失去作用没有任何意义"
```

---

### Spring整合Hibernate

> #### 核心思想

```java
/*将Hibernate的核心类SessionFactory交给Spring管理*/
必要jar包: Spring-orm-Xxx.jar
```

> #### 配置Hibernate的核心类SessionFactory(以xml版本的IOC容器为例)

```xml
Step1. 在Spring IOC容器中配置数据源——数据库连接池: 
<!-- 假设数据源的bean id为"datasource" -->
Step2. 在Spring IOC容器配置SessionFactory(该类可以直接强转为SessionFactory, 不同版本的Hibernate有所不同, 此处以Hibernate5为例): 
<bean id="sessionFactory" class="org.Springframework.orm.hibernate5.LocalSessionFactoryBean">
    <!-- 引入数据源 -->
    <property name="dataSource" ref="dataSource" />
    <!-- 配置hibernate(不能配置数据源以及表的映射相关的设置) --!>
    <!-- 方法一: 通过configLocation导入hibernate配置文件(不能包含数据源以及表的映射相关的设置) -->
    <property name="configLocation" value="classpath:hibernate.cfg.xml" />
    <!-- 方法二: 通过hibernateProperties配置与hibernate相关设置(如方言类, 是否格式化sql语句等) -->
    <property name="hibernateProperties">
        <props>
            <prop key="hibernate配置文件property标签的name值">对应属性值</prop>
            ···
        </props>
    </property>
    <!-- 导入数据库表对应的实体类或实体类映射xml文件的相关配置 -->
    <!-- 方式一: 导入xml映射文件 -->
    <property name="mappingLocations">
        <list>
            <value>xml映射文件的相对路径(支持通配符*)</value>
            ···
        </list>
    </property>
    <!-- 方式二: 扫描注解实体类所在的包 -->
    <property name="packagesToScan">
        <list>
            <value>实体类所在包的包路径</value>
            ···
        </list>
    </property>
</bean>
```

> #### Hibernate的Spring事务管理器(区别于Mybatis)

```xml
<!-- 配置Hibernate的事务管理器(不同版本的Hibernate有所不同, 此处以Hibernate5为例) -->
<bean id="transactionManager" class="org.Springframework.orm.hibernate5.HibernateTransactionManager">
    <property name="sessionFactory" ref="SessionFactory类的been id" />
</bean>
```

> #### HibernateTemplate的使用(以xml版本的IOC容器为例)

```java
1. HibernateTemplate是Spring提供的一个持久层访问模板, 类似于一个精简版的Session类, 使用HibernateTemplate对数据库进行"增删改"操作时, 必须将事务交由Spring管理
2. HibernateTemplate的使用方式与Session相同, 但可使用的方法却远少于Session
```

> > ###### 方法一:  使用HibernateTemplate

```xml
<!-- 依据不同版本的Hibernate有所不同, 此处以Hibernate5为例 -->
<bean id="hibernateTemplate" class="org.springframework.orm.hibernate5.HibernateTemplate">
    <property name="sessionFactory" ref="essionFactory类的beanId" />
</bean>
```

> > ###### 方法二:  使用HibernateDaoSupport

```java
// 该方式要求要使用HibernateTemplate的类继承"HibernateDaoSupport"类且类中不可以配置SessionFactory以及HibernateTemplate两成员属性
public class DaoImpl extends HibernateDaoSupport implements IDao {
    ···
}
```

```xml
<bean id="···" class="HibernateDaoSupport类的子类的全类名">
    <property name="sessionFactory" ref="SessionFactory类的beanId"/>
    <!-- 或 <property name="hibernateTemplate" ref="方法一中hibernateTemplate对应的beanId"/> -->
</bean>

<!-- 该方式实际是通过父类的sessionFactory和hibernateTemplate的setter方法进行赋值, 如果两个属性均被赋值, 那么sqlSessionFactory将被忽略 -->
```

```java
// 使用时在子类的方法中通过调用getHibernateTemplate()方法即可获得HibernateTemplate对象:
HibernateTemplate hibernateTemplate = getHibernateTemplate();
```

> ###### 注

```java
对于Spring整合的Hibernate, 对于获取的与线程绑定的Session对象, 必须在事务范围内使用(必须使用Spring管理事务), 否则程序会出现错误
```

---

### Spring整合MyBatis

> #### 核心思想

```java
/*将MyBatis的核心类SqlSessionFactory交给Spring管理*/
必要jar包: Mybatis-Spring-Xxx.jar
```

> #### 配置MyBatis的核心类SqlSessionFactory(以xml版本的IOC容器为例)

```xml
Step1. 在Spring IOC容器中配置数据源——数据库连接池: 
<!-- 假设数据源的bean id为"datasource" -->
Step2. 在Spring IOC容器配置SqlSessionFactory(该类可以直接强转为SqlSessionFactory): 
<bean id="sqlSessionFactory" class="org.Mybatis.Spring.SqlSessionFactoryBean">
    <!-- 引入数据源 -->
    <property name="dataSource" ref="数据源所在的beanId" />
    <!-- 加载Mybatis配置文件(经过Spring的整合数据源, Mybatis配置文件中<environments>中的配置将会失效)  -->
    <property name="configLocation" value="classpath:Mybatis配置文件的路径" />
    <!-- 如果不想使用Spring的管理事务, 并必须配置transactionFactory属性以使用基本的MyBatis事务管理(JDBC基础方式), 同若设置此项, 则Spring的事务管理将失去作用 -->
    <property name="transactionFactory">
    	<bean class="org.apache.ibatis.transaction.jdbc.JdbcTransactionFactory" />
   </property>  
    ···
</bean>
```

```
注: MyBatis的Spring事务管理器与基本的JDBC Spring事务管理器相同(区别于Hibernate)
```

> #### 配置MyBatis的SqlSession(以xml版本的IOC容器为例)

> > ###### 方法一:  使用SqlSessionTemplate(可直接强转为SqlSession)

```xml
<!-- 固定配置方式 -->
<bean id="sqlSession" class="org.Mybatis.Spring.SqlSessionTemplate">
    <constructor-arg index="0" ref="SqlSessionFactory类的beanId" />
</bean>
```

> > ###### 方法二:  使用SqlSessionDaoSupport

```java
// 该方式要求要使用SqlSession的类继承"SqlSessionDaoSupport"类且类中不可以配置sqlSessionFactory和sqlSession两个成员属性
    public class DaoImpl extends SqlSessionDaoSupport implements IDao {
      		···
    }
```

```XML
<bean id="···" class="SqlSessionDaoSupport类的子类的全类名">
    <property name="sqlSessionFactory" ref="SqlSessionFactory类的beanId"/>
    <!-- 或 <property name="sqlSessionTemplate" ref="方法一中sqlSession对应的beanId"/> -->
</bean>

<!-- 该方式实际是通过父类的sqlSessionFactory和sqlSession的setter方法进行赋值, 如果两个属性均被赋值, 那么sqlSessionFactory将被忽略 -->
```

```java
// 使用时在子类的方法中通过调用getSqlSession()方法即可获得SqlSession对象:
	SqlSession sqlSession = getSqlSession();
```

> > ###### 注

```java
通过以上两种方式配置得到的sqlSession对象是线程安全的, 即是与当前线程绑定的, 且必须使用Spring事务管理器对Mybatis进行事务管理, 否则程序报错; 并且不能对通过这两种方式得到的sqlSession对象, 调用commit()、rollback()或close()方法, 否则也会报错！！！
```

---

### Spring整合Web项目

> #### 核心思想

```java
/*在Web项目初始化时自动加载Spring ICO容器*/
必要jar包: Spring-web-Xxx.jar
```

> #### 配置Spring-web自带的监听器

```jsp
Step1. 为了使Servlet初始化的时候自动加载Spring ICO 容器, 需要在web.xml为其配置Spring-web中预设的一个监听器, 该监听器监听对象为application对象, 因此会在项目初始化时自动执行(在web.xml中加入如下内容)
    <!-- 修改监听器类的默认参数contextConfigLocation -->
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>
            <!-- xml版IOC容器的配置方式 -->
            classpath:Spring xml配置文件1路径(若配置文件在src(classpath)目录下需要加上"classpath:"),
            Spring xml配置文件2路径(若配置文件在WebContent目录下, 直接写相对路径),
            ···
            <!-- Java配置类版IOC容器的配置方式 -->
            配置类的全类名1,
            配置类的全类名2,
            ···
        </param-value>
    </context-param>
 	<!-- 指定初始化IOC容器使用的类(该配置仅限使用Java配置类版本的IOC容器): 
	如果使用Java配置类版本的IOC容器, 还需要更改监听器类的参数contextClass, 因为该参数默认使用的是处理xml版本模式的类, 因此需要从新指定其为处理Java配置类版本模式的类 -->
	<context-param>
        <param-name>contextClass</param-name>
        <param-value>
            org.Springframework.web.context.support.AnnotationConfigWebApplicationContext
        </param-value>
    </context-param>
    <!-- 配置监听器 -->
    <listener>
        <listener-class>org.Springframework.web.context.ContextLoaderListener</listener-class>
    </listener>

Step2. 在servlet中从Spring IOC容器中获取对象: 
    <%
    /*获取Spring ICO容器*/
    ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(application对象);
    /*从Spring ICO容器中获取对象并强转为bean标签中配置的对象类型(class)*/
    bean的class类型 objectName = (bean的class类型)context.getBean("配置文件bean标签的id值(或name中包含的别名)");
    %>
```

---

### Spring整合Struts2

> #### 核心思想

``` java
/*将Struts2的action存放到Spring IOC容器中, 用户访问action时, 从Spring IOC容器中调用*/
必要jar包: struts2-Spring-plugin-Xxx.jar
```

> #### 配置(以xml版本的IOC容器为例)

```xml
<!-- 将Struts2的action类注入Spring IOC容器中 -->
<bean id="···" class="action类的全类名" scope="prototype" />
```

```xml
<!-- 将Struts2的配置文件struts.xml中<action>标签的class属性修改为Spring配置文件中相应的beanId -->
<action name="···" class="该action类在Spring IOC容器中对应的bean的id值(或name中包含的别名)">
    ···
</action>
```

---

---

## <center>Others</center>

### 服务器返回JSON字符串数据

> #### Servlet与Struts2通用方式(通过jsp内置out对象返回json字符串)

> > ##### Method1. 通过JSONObject对象返回JSON字符串数据

```java
Step1. 导入所需的6个jar包
        commons-beanutils-Xxx.jar
        commons-collections-Xxx.jar
        commons-lang-Xxx.jar
        commons-logging-Xxx.jar
        ezmorph-Xxx.jar
        json-lib-Xxx-jdk15.jar
        // ezmorph-Xxx.jar, json-lib-Xxx-jdk15.jar需要单独下载, 其余的jar包可在struts2压缩包中找到
Step2. 创建JSONObject对象, 将要返回的数据对象通过put()方法以键值对的方式存放到JSONObject对象中:
        JSONObject jsonObject = new JSONObject();
        jsonObject.put(Object key, Object value);
        ···
Step3. 将JSONObject对对象转变为JSON字符串: 
        String jsonString = jsonObject.toString();
Step4. 获取jsp内置out对象, 输出JSON字符串数据; 
        PrintWriter out = response.getWriter();
        out.println(jsonString);
```

> > ##### Method2. 使用Gson返回JSON字符串数据

```java
Step1. 导入所需的jar包:
        gson-Xxx.jar
Step2. 创建Gsont对象, 通过toJson()方法将要返回的数据对象转换为JSON字符串数据:
        Gson gson = new Gson();
        // src为要转换为json的对象
        String jsonString = gson.toJson(Object src);
        ···
Step3. 获取jsp内置out对象, 输出JSON字符串数据:  
        PrintWriter out = response.getWriter();
        out.println(jsonString);
```
>#### Struts2独有方式

> > ##### Method3. 返回整体JSON字符串数据

```jsp
Step1. 导入所需的jar包:
        struts2-json-plugin-Xxx.jar
Step2. 在action类中声明成员变量属性的数据对象(如Map映射):
        private Object objectName; 
Step3. 为数据对象创建Getter和Setter方法(Source –> Generate Getters and Setters):
Step4. 在action方法中将要返回的数据封装到声明的数据对象中:
Step5. 配置struts.xml文件:
        a. <package>标签的extends属性需要添加或设置为"json-default";
        b. action对应的<result>标签的type属性必须为"json";
        c. 在<result>标签下添加:
			<param name="root">objectName</param>; 
```

> > ##### Method4. 将多组数据封装到"{  }"中返回

```jsp
Step1. 导入所需的jar包:
		struts2-json-plugin-Xxx.jar
Step2. 为action类声明成员变量属性的各个要传的回JSON字符串数据(必须为String类型):
        private String jsonString1;
        private String jsonString2;
        ···
Step3. 为各个成员变量创建Getter和Setter方法(Source –> Generate Getters and Setters):
Step4. 在action方法使用Gson将各个要返回的数据对象转换为JSON字符串, 并赋值给声明的成员变量:
        Gson gson = new Gson();
        jsonString1 = gson.toJson(Object1);
        jsonString2 = gson.toJson(Object2);
		···
Step5. 配置struts.xml文件:
        a. <package>标签的extends属性需要添加或设置为"json-default";
        b. action对应的<result>标签的type属性必须为"json";
        c. 在<result>标签下添加:
			<param name="includeProperties">jsonString1,jsonString2,···</param>; 

<!--Tip: 
    1. 该种方法返回的数据格式为"{"jsonString1":jsonString1,"jsonString2":jsonString2,···}";
    2. 整体通过js的JSON.parse()解析之后, 获取的jsonString依然是未被解析的JSON字符串,需要进行二次解析！！！
--> 
```
>#### 注意
```java
1. 以上所有方法中所提到的返回的数据对象类型可以为(数值/字符串/数组/List表单/Map映射/实体类/···);
2. Method1-Method3都是将不同对象封装到一个整体后在转换为一个JSON字符串数据, 而Method4是将不同对象分别换为JSON字符串后, 在将对象名与转换都的JSON字符串以键值对儿的方式封装到一个"{}"中进行输出;
3. Method1-Method3输出的JSON字符串数据在JS中只需解析一次, 而Method4至少需要解析两次; 
```

---

### JavaScript—Ajax请求


| XMLHttpRequest对象属性 |                           属性描述                           |
| :--------------------: | :----------------------------------------------------------: |
|   onreadystatechange   | 定义当 readyState 属性发生变化时被调用的函数(同步请求[async=false]时不可使用) |
|       readyState       |       存有 XMLHttpRequest 的状态, 从 0 到 4 发生变化。       |
|         status         |                返回请求的状态号(200,404,···)                 |
|       statusText       |           返回请求的状态文本(“OK”,“Not Found”,···)           |
|      responseText      | 以字符串返回响应数据, 可通过JSON.parse()解析返回的JSON字符串数据 |
|      responseXML       |                    以XML数据返回响应数据                     |

```js
/*使用Ajax的目的是为了不重新加载整个页面的情况下, 可以与服务器交换数据并更新部分网页内容。*/
//Step1. 创建XMLHttpRequest对象
		const xmlHttpRequest = new XMLHttpRequest();
//Step2. 定义XMLHttpRequest对象的onreadystatechange事件(一个回调函数)
        xmlHttpRequest.onreadystatechange = callBack(回调函数的函数名, 或直接使用匿名函数);
//Step3. 向服务器发送请求
    a. Get方法:
        xmlHttpRequest.open("GET", url+"?"+"param1=value1&param2=value12&···", async);
        xmlHttpRequest.send();
    b. Post方法:
        xmlHttpRequest.open("POST", url, async);
        xmlHttpRequest.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        // 当没有数据需要向服务器发送时, 不需要设置setRequestHeader !!!
        xmlHttpRequest.send("param1=value1&param2=value12&···");
/*
    url: 请求或文件路径
    async: true(异步)或 false(同步)
*/
```

> > ##### 例 :(本例为了为了验证用户注册的用户名和电话号是否已被注册过)

```jsp
<!-- form表单样式: -->
    <form action="Javascript:void(0)" onsubmit="ajaxPost()">
        phoneNumber: <input id="phoneNumber" type="text" name="phoneNumber">
        <br/>
        username: <input id="username" type="text" name="username">
        <br/>
        password: <input id="password" type="password" name="password">
        <br/>
        <input type="submit" value="注册" >
    </form>
<!-- JavaScript—Ajax: -->
    <script>
        /*Step1.*/
        const xmlHttpRequest = new XMLHttpRequest();  

        function ajaxPost() {
            const username = document.getElementById("username").value;
            const phoneNumber = document.getElementById("phoneNumber").value;
        	/*Step2.*/
            xmlHttpRequest.onreadystatechange = callBack;
        	/*Step3(Post方式).*/
            xmlHttpRequest.open("POST","servletDemo",true);
            xmlHttpRequest.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
            xmlHttpRequest.send("username="+username+"&phoneNumber="+phoneNumber);
        }

        function ajaxGet() {
            const username = document.getElementById("username").value;
            const phoneNumber = document.getElementById("phoneNumber").value;
        	/*Step2.*/
            xmlHttpRequest.onreadystatechange = callBack;
        	/*Step3(Get方式).*/
            xmlHttpRequest.open("GET","servletDemo?"+"username="+username+"&phoneNumber="+phoneNumber,true);
            xmlHttpRequest.send(null); 
        }

        function callBack() {
            if(xmlHttpRequest.readyState===4 && xmlHttpRequest.status===200){
                //接收服务端返回的字符串数据
                const data = xmlHttpRequest.responseText; 
                if(data === "usernameExisted"){
                    alert("该用户名已存在");
                }else if (data === "phoneNumberExisted"){
                    alert("该电话号码已注册");
                }else if (data === "informationIncomplete"){
                    alert("请补全信息");
                }else {
                    alert("注册成功");
                }
            }
        }
    </script>
<!-- servletDemo的doGet()方法: -->
    <%
        protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            System.out.println("servletDemo");
            String username = request.getParameter("username");
            String phoneNumber = request.getParameter("phoneNumber");
            PrintWriter out = response.getWriter();
            if (username != "" ||  phoneNumber != ""){
                if (username.equals("Wh")) {
                	out.write("usernameExisted");
                }else if (phoneNumber.equals("18888888888")) {
                	out.write("phoneNumberExisted");
                }else {
                	out.write("registerSuccess");
                }
            }else {
            out.write("informationIncomplete");
            }
        }
    %>
```
---

---

