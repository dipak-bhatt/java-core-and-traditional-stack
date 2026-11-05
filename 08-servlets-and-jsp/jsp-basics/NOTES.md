# JavaServer Pages (JSP) — Notes with Executable Examples

> Simple, topic-wise notes for students. Every example in this folder can be
> compiled and run on **Apache Tomcat 9** using `javax.servlet.jsp.*`.
>
> These notes follow the same section order as `../servlet-basics/NOTES.md`,
> so you can study Servlets first and then compare every idea with JSP.
>
> Files in this folder:
>
> ```
> jsp-basics/
> ├── NOTES.md
> └── src/main/
>     ├── java/
>     │   ├── beans/User.java
>     │   └── crud/
>     │       ├── StudentInformation.java
>     │       └── DataAccess.java
>     └── webapp/
>         ├── index.html
>         ├── WEB-INF/web.xml
>         ├── hello.jsp
>         ├── lifecycle.jsp
>         ├── elements.jsp
>         ├── header.jsp
>         ├── footer.jsp
>         ├── include-directive.jsp
>         ├── include-action.jsp
>         ├── params.jsp
>         ├── implicit-objects.jsp
>         ├── forward-source.jsp
>         ├── forward-target.jsp
>         ├── redirect-source.jsp
>         ├── redirect-target.jsp
>         ├── error-demo.jsp
>         ├── error-page.jsp
>         ├── DivisionCalculator.jsp
>         ├── ErrorHandler.jsp
>         ├── cookies.jsp
>         ├── session.jsp
>         ├── scope-source.jsp
>         ├── scope-target.jsp
>         ├── bean.jsp
>         ├── el.jsp
>         └── student_crud.jsp
> ```

## Table of Contents

1. [Background](#1-background)
2. [The Life Cycle of a JSP](#2-the-life-cycle-of-a-jsp)
3. [A Simple JSP](#3-a-simple-jsp)
4. [The JSP API](#4-the-jsp-api)
5. [The `javax.servlet.jsp` Package](#5-the-javaxservletjsp-package)
6. [Reading Request Parameters in JSP](#6-reading-request-parameters-in-jsp)
7. [JSP Implicit Objects](#7-jsp-implicit-objects)
8. [Handling HTTP Requests and Responses](#8-handling-http-requests-and-responses)
9. [Using Cookies and Sessions](#9-using-cookies-and-sessions)
10. [JavaBeans, EL and JSTL](#10-javabeans-el-and-jstl)
11. [JSP + JDBC CRUD](#11-jsp--jdbc-crud)
12. [Run a JSP Project with Tomcat in Eclipse](#12-run-a-jsp-project-with-tomcat-in-eclipse)

---

## 1. Background

### How a web application works

A web application has two sides:

- **Client** — a browser (Chrome, Firefox, Edge) that sends an **HTTP request**.
- **Server** — a program that receives the request and sends back an **HTTP response**.

```
Browser  ---- HTTP request ---->  Web Server / Servlet & JSP Container
         <--- HTTP response ----  (Tomcat)
```

### Static page vs dynamic page

| Type | What the user sees | Who creates it |
|------|--------------------|----------------|
| Static | Same content every time | An HTML file on disk |
| Dynamic | Content can change (time, user, database) | A program running on the server |

A **servlet** is a Java program that creates dynamic pages by writing HTML
inside Java code. A **JSP** creates dynamic pages by writing Java inside HTML.
Both are translated into the same kind of servlet at run time.

### What is JSP?

**JavaServer Pages (JSP)** is a technology that lets you embed Java code in an
HTML file. The file has a `.jsp` extension and runs inside a **JSP container**
(Tomcat is both a servlet container and a JSP container).

A JSP page can contain:

- normal HTML and CSS,
- Java code inside special tags (`<% %>`, `<%= %>`, `<%! %>`),
- JSP directives (`<%@ %>`),
- JSP actions (`<jsp:... />`),
- Expression Language (`${...}`),
- tag libraries such as JSTL.

### JSP vs Servlet

| Aspect | Servlet | JSP |
|--------|---------|-----|
| Definition | A Java class that handles HTTP requests and responses | A web page containing Java code inside HTML |
| Syntax | Pure Java; HTML is written with `out.println(...)` | HTML is normal; Java is embedded in tags |
| Ease of use | More complex for large pages | Easier for presentation |
| Performance | Fast; already a compiled class | Slightly slower on first request because it is translated first |
| Best for | Processing: forms, business logic, controllers | Presentation: displaying dynamic data |
| Life-cycle methods | `init()`, `service()`, `destroy()` | `jspInit()`, `_jspService()`, `jspDestroy()` |
| Compiled into | Your servlet class | A generated servlet class |

> **Key idea:** a JSP is not interpreted. The container translates it into a
> Java servlet source file, compiles that file, and then runs it like any other
> servlet. JSP is a convenient way to **write** a servlet for HTML output.

### Model 1 vs Model 2 (MVC)

| Style | How it works | When to use |
|-------|--------------|-------------|
| Model 1 | JSP does everything: input, logic, database, output | Small learning examples |
| Model 2 (MVC) | Servlet is the controller, JavaBean is the model, JSP is the view | Real applications |

This folder uses small Model 1 pages so each feature is easy to see. Section 11
shows the same CRUD logic you would later move into a servlet.

### What the container does for you

- Translates a `.jsp` file into a `.java` servlet source file.
- Compiles the generated source into a `.class` file.
- Creates the JSP object and calls `jspInit()`, `_jspService()`, `jspDestroy()`.
- Creates the implicit objects (`request`, `response`, `out`, `session`, ...).
- Manages threading, sessions, cookies, error pages, includes, and tag libraries.
- Recompiles the page when the JSP file changes (in development mode).

> **Important:** Tomcat 9 uses `javax.servlet.*` and `javax.servlet.jsp.*`.
> Tomcat 10+ uses `jakarta.servlet.*` and `jakarta.servlet.jsp.*`.
> This folder uses **Tomcat 9**.
> If you use Tomcat 10 or newer, change every `javax.servlet` import and every
> tag library URI to the `jakarta` version.

---

## 2. The Life Cycle of a JSP

The container controls the whole life of a JSP. There are five stages:

```
1. Translation       .jsp                -> .java servlet source
2. Compilation       .java               -> .class
3. Initialization    jspInit()           -> runs once
4. Request handling  _jspService()       -> runs once per request
5. Destruction       jspDestroy()        -> runs once before unload
```

### Stage-by-stage

| Stage | What happens | Called how many times |
|-------|--------------|-----------------------|
| Translation | JSP text + Java is converted to a servlet source file | once per version of the JSP |
| Compilation | The generated source is compiled | once per version of the JSP |
| Initialization | `jspInit()` runs | 1 |
| Request handling | `_jspService(request, response)` runs | many (every request) |
| Destruction | `jspDestroy()` runs | 1 |

The generated class extends `HttpJspBase` (in Tomcat) and implements
`HttpJspPage`. You can override `jspInit()` and `jspDestroy()`, but you must
**not** override `_jspService()` — the container generates it from your HTML
and Java tags.

### Life cycle diagram

```
First request for hello.jsp
      |
      v
  translate hello.jsp  ->  hello_jsp.java
      |
      v
  compile              ->  hello_jsp.class
      |
      v
  constructor          <-- object created
      |
      v
  jspInit()            <-- runs once
      |
      v
  _jspService()  <--->  runs for every request
      |
      v
  jspDestroy()         <-- runs once when the app stops / JSP is unloaded
      |
      v
  garbage collected
```

### Executable example — `lifecycle.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    private int hitCount = 0;

    @Override
    public void jspInit() {
        System.out.println("[JSP LifeCycle] 1. jspInit() called once");
    }

    @Override
    public void jspDestroy() {
        System.out.println("[JSP LifeCycle] 3. jspDestroy() called once");
    }
%>
<%
    hitCount++;
    System.out.println("[JSP LifeCycle] 2. _jspService() called for request");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JSP Life Cycle</title>
</head>
<body>
    <h1>JSP Life Cycle</h1>

    <p>This JSP has served <strong><%= hitCount %></strong> request(s).</p>
    <p>Look at the Tomcat console to see <code>jspInit()</code>,
       <code>_jspService()</code> and <code>jspDestroy()</code> messages.</p>

    <h2>Execution Flow</h2>
    <ol>
        <li>Translation: <code>lifecycle.jsp</code> becomes a Java servlet source file.</li>
        <li>Compilation: the generated servlet source is compiled to a <code>.class</code> file.</li>
        <li>Initialization: <code>jspInit()</code> runs once.</li>
        <li>Request handling: <code>_jspService()</code> runs for every request.</li>
        <li>Destruction: <code>jspDestroy()</code> runs before the JSP is unloaded.</li>
    </ol>

    <p><a href="lifecycle.jsp">Reload</a> | <a href="index.html">Back to home</a></p>
</body>
</html>
```

**Try it:** open `http://localhost:8080/jsp-basics/lifecycle.jsp` several times.
The console shows one `jspInit()` message and many `_jspService()` messages.
Stop the server to see `jspDestroy()`.

> **Note:** `hitCount` is shared by all users because there is only one JSP
> object. Use a session (section 9) for per-user data, or an `AtomicInteger` if
> many users can hit the page at the same time.

### Where is the generated servlet?

On Tomcat the translated file is stored under the work directory, for example:

```
<Tomcat>/work/Catalina/localhost/jsp-basics/org/apache/jsp/lifecycle_jsp.java
<Tomcat>/work/Catalina/localhost/jsp-basics/org/apache/jsp/lifecycle_jsp.class
```

If you open the `.java` file you will see `jspInit()`, `_jspService()`,
`jspDestroy()`, the implicit objects, and your HTML turned into `out.write(...)`
calls. This is the best way to understand what JSP really does.

---

## 3. A Simple JSP

Three things are needed to write a JSP:

1. Save the file with a `.jsp` extension under the web application folder.
2. Put HTML in the page and use `<%= ... %>` where a dynamic value is needed.
3. Open it through the container, e.g. `/jsp-basics/hello.jsp`.

No `@WebServlet`, no `web.xml` mapping, and no `main()` method are required.
The container detects the `.jsp` file by its extension.

### Executable example — `hello.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hello JSP</title>
</head>
<body>
    <h1>Hello from a JSP!</h1>

    <p>Current time on the server: <%= new java.util.Date() %></p>
    <p>Expression result: 2 + 3 = <%= 2 + 3 %></p>

    <p><a href="index.html">Back to home</a></p>
</body>
</html>
```

**Open:** `http://localhost:8080/jsp-basics/hello.jsp`

### What the container generates (simplified)

A JSP like `hello.jsp` becomes a servlet similar to this:

```java
public final class hello_jsp extends org.apache.jasper.runtime.HttpJspBase {
    public void _jspService(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException, ServletException {

        JspWriter out = response.getWriter();

        out.write("<!DOCTYPE html>\n<html>\n<head>...");
        out.write("<h1>Hello from a JSP!</h1>");
        out.print(new java.util.Date());
        // ... the rest of the HTML ...
    }
}
```

This is why JSP can do everything a servlet can do.

### URL anatomy

```
http://localhost:8080/jsp-basics/hello.jsp
       --------------- ----------- ---------
            host        context path   JSP file
```

- **Context path** = the deployed project name.
- **JSP file** = the path inside `src/main/webapp`.

### Default imports

Every JSP automatically imports:

```java
java.lang.*
javax.servlet.*
javax.servlet.jsp.*
javax.servlet.http.*
```

That is why `request`, `response`, `session`, `out`, `Cookie`, and
`ServletException` are available without an import. Use the `page` directive
`import` attribute for anything else (`java.util.List`, `crud.DataAccess`, ...).

---

## 4. The JSP API

The JSP API is the set of classes and interfaces in:

- `javax.servlet.jsp` — core JSP classes (`JspPage`, `HttpJspPage`, `JspWriter`, `PageContext`, ...).
- `javax.servlet.jsp.tagext` — support for custom tags (`Tag`, `SimpleTag`, `TagSupport`, ...).

### Core interfaces and classes

| Type | What it represents |
|------|--------------------|
| `JspPage` | Basic JSP contract: `jspInit()`, `_jspService()`, `jspDestroy()` |
| `HttpJspPage` | HTTP version of `JspPage`; used by Tomcat-generated classes |
| `JspWriter` | The `out` object; a buffered `PrintWriter`-like writer |
| `PageContext` | Gives access to all scopes and implicit objects |
| `JspFactory` | Creates `PageContext` instances (container internal) |
| `JspEngineInfo` | Information about the JSP engine (container internal) |
| `JspApplicationContext` | Registers EL resolvers |
| `Tag` / `SimpleTag` | Interfaces for custom tag libraries |
| `TagSupport` / `SimpleTagSupport` | Base classes for writing custom tags |

### Class hierarchy

```
JspPage (interface)
   |
HttpJspPage (interface)
   |
HttpJspBase (Tomcat class)
   |
your_jsp (generated class for hello.jsp)
```

### The building blocks of a JSP

| Element | Syntax | Purpose |
|---------|--------|---------|
| Directive | `<%@ page ... %>` | Page settings, imports, error page |
| Include directive | `<%@ include file="..." %>` | Static include at translation time |
| Scriptlet | `<% java code %>` | Java statements |
| Expression | `<%= expression %>` | Print a value (no semicolon) |
| Declaration | `<%! int x = 0; %>` | Fields and methods of the servlet class |
| JSP comment | `<%-- comment --%>` | Removed at translation time |
| Action | `<jsp:include ... />` | Dynamic include, forward, beans |
| EL | `${expression}` | Short way to read values |
| JSTL | `<c:forEach ...>` | Tag library for loops, conditions, formatting |

### How a JSP becomes a servlet

```
hello.jsp
   |  translation
   v
hello_jsp.java   (HTML -> out.write, <%= %> -> out.print)
   |  compilation
   v
hello_jsp.class  (a servlet)
   |  jspInit() once, _jspService() per request
   v
response to the browser
```

---

## 5. The `javax.servlet.jsp` Package

This section covers the most useful JSP elements for beginners: directives,
scripting elements, and includes.

### 5.1 The `page` directive

```jsp
<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.util.*, crud.DataAccess"
         session="true"
         errorPage="error-page.jsp" %>
```

| Attribute | Meaning | Default |
|-----------|---------|---------|
| `language` | Scripting language | `java` |
| `contentType` | Response MIME type and charset | `text/html; charset=ISO-8859-1` |
| `pageEncoding` | Charset of the JSP file itself | ISO-8859-1 |
| `import` | Classes to import (comma separated) | default JSP imports |
| `session` | Create the `session` object? | `true` |
| `buffer` | Output buffer size | `8kb` |
| `autoFlush` | Flush buffer automatically? | `true` |
| `isErrorPage` | Make this page an error handler? | `false` |
| `errorPage` | Page to show when this page throws an exception | none |
| `isELIgnored` | Ignore `${...}` expressions? | `false` |
| `info` | Description text for the page | none |

> Always set `pageEncoding` and the charset in `contentType` to `UTF-8`. Without
> it, non-English text can become `????`.

### 5.2 The `include` directive (static include)

```jsp
<%@ include file="header.jsp" %>
```

- Runs at **translation time**.
- The included file is copied into the page before compiling.
- One servlet is produced.
- Great for headers, footers, and navigation bars.

### 5.3 The `taglib` directive

```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
```

- Declares a tag library.
- JSTL is covered in section 10.

### 5.4 Scripting elements

| Element | Example | Notes |
|---------|---------|-------|
| Declaration | `<%! private int count = 0; %>` | Becomes a field/method of the servlet class |
| Scriptlet | `<% count++; %>` | Java statements executed in `_jspService()` |
| Expression | `<%= count %>` | Prints a value; no semicolon inside |
| JSP comment | `<%-- hidden --%>` | Not sent to the browser |

### Executable example — `elements.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    private int declarationCounter = 0;

    private String shout(String text) {
        return text == null ? "" : text.toUpperCase();
    }
%>
<%
    declarationCounter++;
    String name = request.getParameter("name");
    if (name == null || name.trim().isEmpty()) {
        name = "Student";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JSP Scripting Elements</title>
</head>
<body>
    <h1>JSP Scripting Elements</h1>

    <h2>1. Declaration &lt;%! %&gt;</h2>
    <p>Declarations become fields or methods of the generated servlet class.</p>
    <p>Declaration counter (shared by all users): <strong><%= declarationCounter %></strong></p>

    <h2>2. Scriptlet &lt;% %&gt;</h2>
    <p>Scriptlets contain normal Java statements.</p>
    <ul>
        <%
            for (int i = 1; i <= 3; i++) {
                out.println("<li>Line " + i + " generated by a scriptlet</li>");
            }
        %>
    </ul>

    <h2>3. Expression &lt;%= %&gt;</h2>
    <p>Expression result: <strong><%= 10 * 5 %></strong></p>
    <p>Method call: <strong><%= shout(name) %></strong></p>

    <h2>4. Comments</h2>
    <%-- This JSP comment is removed at translation time and is NOT sent to the browser. --%>
    <!-- This HTML comment IS sent to the browser. -->

    <p><a href="elements.jsp?name=dipak">Reload with name=dipak</a> |
       <a href="index.html">Back to home</a></p>
</body>
</html>
```

**Open:** `http://localhost:8080/jsp-basics/elements.jsp`

### 5.5 Include directive vs include action

| | `<%@ include file="..." %>` | `<jsp:include page="..." />` |
|--|-----------------------------|------------------------------|
| When | Translation time | Request time |
| Compiled | One servlet | Separate JSP / servlet |
| Can change per request | No | Yes |
| Shares variables | Yes | No (use request attributes) |
| Typical use | Header, footer, layout | Dynamic blocks, ads, menus |

Executable examples:

- `include-directive.jsp` uses `<%@ include file="header.jsp" %>`.
- `include-action.jsp` uses `<jsp:include page="header.jsp" />`.
- `header.jsp` and `footer.jsp` are small reusable fragments.

**Open:**

- `http://localhost:8080/jsp-basics/include-directive.jsp`
- `http://localhost:8080/jsp-basics/include-action.jsp`

---

## 6. Reading Request Parameters in JSP

Parameters are values sent by the client, usually from an HTML form:

```html
<form method="post" action="params.jsp">
    Name: <input type="text" name="studentName">
    Marks: <input type="text" name="marks">
    <input type="submit" value="Send">
</form>
```

A JSP reads them from the `request` implicit object. The methods are exactly the
same as in a servlet:

| Method | Returns |
|--------|---------|
| `request.getParameter("name")` | First value as `String`, or `null` |
| `request.getParameterValues("name")` | `String[]` (checkboxes / multi-select) |
| `request.getParameterNames()` | `Enumeration<String>` of all names |
| `request.getParameterMap()` | `Map<String, String[]>` of everything |

### Executable example — `params.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Enumeration" %>
<%
    request.setCharacterEncoding("UTF-8");

    String name = request.getParameter("studentName");
    String marks = request.getParameter("marks");
    String[] subjects = request.getParameterValues("subject");
    boolean submitted = name != null || marks != null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reading Parameters in JSP</title>
</head>
<body>
    <h1>Reading Request Parameters in JSP</h1>

    <% if (!submitted) { %>
        <h2>Student Form</h2>
        <form method="post" action="params.jsp">
            Name: <input type="text" name="studentName"><br><br>
            Marks: <input type="text" name="marks"><br><br>
            Subjects:<br>
            <input type="checkbox" name="subject" value="Java"> Java<br>
            <input type="checkbox" name="subject" value="DBMS"> DBMS<br>
            <input type="checkbox" name="subject" value="Web"> Web<br><br>
            <input type="submit" value="Submit">
        </form>
    <% } else { %>
        <h2>Received Parameters</h2>
        <p>Name: <strong><%= name %></strong></p>
        <p>Marks: <strong><%= marks %></strong></p>
        <p>Subjects:
            <%
                if (subjects == null || subjects.length == 0) {
                    out.print("none selected");
                } else {
                    for (String subject : subjects) {
                        out.print(subject + " ");
                    }
                }
            %>
        </p>

        <h3>All parameter names</h3>
        <ul>
            <%
                Enumeration<String> names = request.getParameterNames();
                while (names.hasMoreElements()) {
                    out.println("<li>" + names.nextElement() + "</li>");
                }
            %>
        </ul>

        <p><a href="params.jsp">Try again</a></p>
    <% } %>

    <p><a href="index.html">Back to home</a></p>
</body>
</html>
```

**Open:** `http://localhost:8080/jsp-basics/params.jsp`

> **Safety:** always check for `null` before using a parameter. A user can
> submit the form without filling a field, or call the URL directly.
>
> **Encoding:** `request.setCharacterEncoding("UTF-8")` must run before you read
> parameters, and it only affects the POST body, not the URL query string.

---

## 7. JSP Implicit Objects

The container creates nine objects for every JSP. You do not declare them.

| Object | Type | What it gives you |
|--------|------|-------------------|
| `request` | `HttpServletRequest` | Parameters, headers, cookies, session, attributes |
| `response` | `HttpServletResponse` | Status, headers, content type, redirect, cookies |
| `out` | `JspWriter` | Write HTML to the response |
| `session` | `HttpSession` | Per-user data on the server |
| `application` | `ServletContext` | Data shared by the whole application |
| `config` | `ServletConfig` | Init parameters for this JSP |
| `pageContext` | `PageContext` | Access to all scopes and other implicit objects |
| `page` | `Object` | The generated servlet instance (`this`) |
| `exception` | `Throwable` | The error; only available on an error page |

The first four (`request`, `response`, `out`, `session`) are used in almost
every page. `application` is shared by all users. `pageContext` is the most
powerful because it can reach every scope.

### The four scopes

| Scope | Object | Lifetime | Visible to |
|-------|--------|----------|------------|
| Page | `pageContext` | Until the page finishes | Only this JSP |
| Request | `request` | Until the response is sent | This JSP + forwarded/included pages |
| Session | `session` | Until timeout or `invalidate()` | All pages for one user |
| Application | `application` | Until the application stops | All users and all pages |

### Executable example — `implicit-objects.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JSP Implicit Objects</title>
</head>
<body>
    <h1>JSP Implicit Objects</h1>
    <p><em>Implicit objects are variables the container creates for you in every JSP.</em></p>

    <h2>1. request</h2>
    <%
        String username = request.getParameter("username");
        if (username == null) {
            username = "Guest";
        }
        out.println("Hello, " + username + "!");
    %>

    <h2>2. response</h2>
    <%
        response.setContentType("text/html");
        out.println("Content type: " + response.getContentType());
    %>

    <h2>3. out</h2>
    <%
        out.println("This text was written with the out object.");
    %>

    <h2>4. session</h2>
    <%
        session.setAttribute("user", username);
        out.println("Session user: " + session.getAttribute("user"));
        out.println("<br>Session ID: " + session.getId());
    %>

    <h2>5. application</h2>
    <%
        application.setAttribute("appName", "JSP Basics");
        out.println("Application name: " + application.getAttribute("appName"));
        out.println("<br>Context path: " + application.getContextPath());
    %>

    <h2>6. config</h2>
    <%
        String configParam = config.getInitParameter("myConfigParam");
        if (configParam != null) {
            out.println("Config parameter: " + configParam);
        } else {
            out.println("No config parameter found (open /implicit to use the web.xml mapping).");
        }
    %>

    <h2>7. pageContext</h2>
    <%
        pageContext.setAttribute("pageMessage", "Hello from PageContext");
        out.println("Page message: " + pageContext.getAttribute("pageMessage"));
    %>

    <h2>8. page</h2>
    <%
        out.println("This JSP is an instance of: " + page.getClass().getName());
    %>

    <h2>9. exception</h2>
    <%
        if (exception != null) {
            out.println("Exception: " + exception.getMessage());
        } else {
            out.println("No exception on this page.");
        }
    %>

    <p><a href="index.html">Back to home</a></p>
</body>
</html>
```

**Open:** `http://localhost:8080/jsp-basics/implicit-objects.jsp`

### Giving a JSP a `config` init-parameter

A JSP normally has no `init-param`. To add one, register the JSP as a servlet in
`WEB-INF/web.xml` using `<jsp-file>`:

```xml
<servlet>
    <servlet-name>implicit-objects</servlet-name>
    <jsp-file>/implicit-objects.jsp</jsp-file>
    <init-param>
        <param-name>myConfigParam</param-name>
        <param-value>Hello from JSP config</param-value>
    </init-param>
</servlet>
<servlet-mapping>
    <servlet-name>implicit-objects</servlet-name>
    <url-pattern>/implicit</url-pattern>
</servlet-mapping>
```

**Open:** `http://localhost:8080/jsp-basics/implicit` — now `config.getInitParameter("myConfigParam")` returns a value.

> `isErrorPage="true"` is set on `implicit-objects.jsp` only so the
> `exception` variable exists. On a normal page the `exception` implicit object
> is not available at all.

### Executable example — the four scopes

`scope-source.jsp` sets one value in each scope and forwards to
`scope-target.jsp`:

```jsp
<%
    pageContext.setAttribute("pageMsg", "This is Page Scope");
    request.setAttribute("requestMsg", "This is Request Scope");
    session.setAttribute("sessionMsg", "This is Session Scope");
    application.setAttribute("appMsg", "This is Application Scope");
%>
...
<jsp:forward page="scope-target.jsp" />
```

`scope-target.jsp` prints the same four values. Page scope is lost; the other
three survive.

**Open:** `http://localhost:8080/jsp-basics/scope-source.jsp`

The page you see is the target page, because a forward replaces the response.
This is the same request, so request scope survives.

---

## 8. Handling HTTP Requests and Responses

### No `doGet()` or `doPost()` in JSP

A JSP does not define `doGet()` or `doPost()`. The container generates
`_jspService(HttpServletRequest, HttpServletResponse)`, which is called for
every HTTP method. You read the method yourself when it matters:

```jsp
<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // handle form submission
    } else {
        // show form
    }
%>
```

### Forward vs Redirect vs Include

| | `forward` | `sendRedirect` | `include` |
|--|-----------|----------------|-----------|
| Where | Same server | Browser asks a new URL | Same server |
| URL in browser | Does **not** change | **Changes** | Does **not** change |
| Request attributes | Kept | Lost (new request) | Kept |
| Can go to another site | No | Yes | No |
| Typical use | MVC (JSP -> view) | After login/logout or form save | Header, footer, widgets |

```jsp
<%-- Same request, URL unchanged --%>
<jsp:forward page="forward-target.jsp" />

<%-- New request, URL changes --%>
<% response.sendRedirect("redirect-target.jsp"); %>

<%-- Run another resource and add its output --%>
<jsp:include page="header.jsp" />
```

### Executable example — forward

`forward-source.jsp` forwards a POST request to `forward-target.jsp`:

```jsp
<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setAttribute("message", "Hello from forward-source.jsp");
        request.getRequestDispatcher("/forward-target.jsp").forward(request, response);
        return;
    }
%>
```

**Open:** `http://localhost:8080/jsp-basics/forward-source.jsp`

After clicking the button the browser still shows `forward-source.jsp`, and the
target page can read the `message` request attribute.

### Executable example — redirect

`redirect-source.jsp` sends the browser to `redirect-target.jsp`:

```jsp
<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("redirect-target.jsp");
        return;
    }
%>
```

**Open:** `http://localhost:8080/jsp-basics/redirect-source.jsp`

After clicking the button the browser URL changes to `redirect-target.jsp`.

### Error handling in JSP

Two page-directive attributes connect a page with its error page:

```jsp
<%-- The page that may fail --%>
<%@ page errorPage="error-page.jsp" %>

<%-- The page that shows the error --%>
<%@ page isErrorPage="true" %>
```

On the error page the `exception` implicit object is available, and the
container also sets these request attributes:

| Attribute | Meaning |
|-----------|---------|
| `javax.servlet.error.status_code` | HTTP status code |
| `javax.servlet.error.exception` | The exception object |
| `javax.servlet.error.request_uri` | URI that failed |
| `javax.servlet.error.servlet_name` | Servlet name |

You can also map errors globally in `web.xml`:

```xml
<error-page>
    <error-code>500</error-code>
    <location>/error-page.jsp</location>
</error-page>
```

### Executable example — `error-demo.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         errorPage="error-page.jsp" %>
...
<%
    int numerator = 10;
    int denominator = 0;
    int result = numerator / denominator;
    out.println("Result: " + result);
%>
```

**Open:** `http://localhost:8080/jsp-basics/error-demo.jsp`

### Executable example — `DivisionCalculator.jsp`

This is the same example as `crud/DivisionCalculator.jsp` in the BCAVI
reference project. It reads two numbers, divides them, and lets the exception
flow to `ErrorHandler.jsp`:

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         errorPage="ErrorHandler.jsp" %>
...
<%
    String numStr = request.getParameter("numerator");
    String denStr = request.getParameter("denominator");

    if (numStr != null && denStr != null) {
        try {
            int numerator = Integer.parseInt(numStr);
            int denominator = Integer.parseInt(denStr);
            int result = numerator / denominator;
            out.println("<h3>Result: " + numerator + " / " + denominator + " = " + result + "</h3>");
        } catch (Exception e) {
            throw new ServletException("An error occurred while processing the division.", e);
        }
    }
%>
```

**Open:** `http://localhost:8080/jsp-basics/DivisionCalculator.jsp`, enter a
denominator of `0`, and you get the friendly error page.

> **Rule:** once the response has been committed (for example after a large
> amount of HTML or an explicit `out.flush()`), you cannot forward or redirect.
> Keep the logic before the HTML, or use a servlet controller.

---

## 9. Using Cookies and Sessions

### Sessions in one minute

HTTP is **stateless**: the server does not remember the previous request.
A **session** lets the server remember a user. In JSP the session is ready to
use — no `request.getSession()` needed unless you disabled it.

```jsp
<%
    session.setAttribute("username", "Dipak");            // store
    String user = (String) session.getAttribute("username"); // read
    session.removeAttribute("username");                  // remove one value
    session.invalidate();                                 // logout / destroy
%>
```

The container gives the browser a cookie named `JSESSIONID`. The browser sends
it back on every request so the server can find the right session.

If a page does not need a session, disable it to save memory:

```jsp
<%@ page session="false" %>
```

### Executable example — `session.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if ("logout".equals(request.getParameter("action"))) {
        session.invalidate();
        response.sendRedirect("session.jsp");
        return;
    }

    Integer visits = (Integer) session.getAttribute("visits");
    visits = (visits == null) ? 1 : visits + 1;
    session.setAttribute("visits", visits);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JSP Session</title>
</head>
<body>
    <h1>Session Example</h1>

    <p>Session ID: <strong><%= session.getId() %></strong></p>
    <p>Visits in this session: <strong><%= visits %></strong></p>
    <p>Created at: <%= new java.util.Date(session.getCreationTime()) %></p>
    <p>Last accessed: <%= new java.util.Date(session.getLastAccessedTime()) %></p>
    <p>Max inactive interval: <%= session.getMaxInactiveInterval() %> seconds</p>

    <p><a href="session.jsp">Reload</a> |
       <a href="session.jsp?action=logout">Invalidate session</a> |
       <a href="index.html">Back to home</a></p>
</body>
</html>
```

**Open:** `http://localhost:8080/jsp-basics/session.jsp`

### What is a cookie?

A **cookie** is a small piece of text that the server sends to the browser.
The browser stores it and sends it back with later requests. Cookies are
stored on the **client**.

```jsp
<%
    // Create / set
    Cookie cookie = new Cookie("username", "Dipak");
    cookie.setMaxAge(60 * 60 * 24);   // 1 day, in seconds
    response.addCookie(cookie);

    // Read
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if ("username".equals(c.getName())) {
                String value = c.getValue();
            }
        }
    }

    // Delete
    Cookie gone = new Cookie("username", "");
    gone.setMaxAge(0);                // 0 = delete now
    response.addCookie(gone);
%>
```

### Executable example — `cookies.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String action = request.getParameter("action");

    if ("delete".equals(action)) {
        Cookie cookie = new Cookie("username", "");
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        response.sendRedirect("cookies.jsp");
        return;
    }

    if ("set".equals(action)) {
        Cookie cookie = new Cookie("username", "Dipak");
        cookie.setMaxAge(60 * 60 * 24);
        response.addCookie(cookie);
        response.sendRedirect("cookies.jsp");
        return;
    }

    String username = "not set";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("username".equals(cookie.getName())) {
                username = cookie.getValue();
            }
        }
    }
%>
...
<p>username cookie = <strong><%= username %></strong></p>
```

**Open:** `http://localhost:8080/jsp-basics/cookies.jsp`

### Session tracking techniques

| Technique | Where the data lives | How the server identifies the user |
|-----------|----------------------|------------------------------------|
| Cookies | Browser | A cookie (usually `JSESSIONID`) is sent on every request |
| Hidden form field | HTML form | The session ID is submitted with the form |
| URL rewriting | URL | The session ID is appended to links (`;jsessionid=...`) |
| `HttpSession` | Server memory | The container stores attributes for each user |

`HttpSession` is the usual choice. Cookies, hidden fields, and URL rewriting are
ways to carry the session ID when cookies are unavailable.

### Cookie vs Session

| | Cookie | Session |
|--|--------|---------|
| Stored on | Client (browser) | Server |
| Size | Small (~4 KB) | Larger |
| Security | User can see/edit | User sees only the ID |
| Lifetime | Controlled by `setMaxAge` | Until timeout or `invalidate()` |
| Default lifetime | Until browser closes | Default 30 minutes |

> Never store passwords or sensitive data in a cookie. Store only a session ID
> (this is what `JSESSIONID` does) and keep real data on the server.

---

## 10. JavaBeans, EL and JSTL

### What is a JavaBean?

A JavaBean is a reusable Java class that follows three rules:

1. Implements `Serializable`.
2. Has a public no-argument constructor.
3. Exposes properties through `getXxx()` and `setXxx()` methods.

Executable example — `src/main/java/beans/User.java`:

```java
package beans;

import java.io.Serializable;

public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private String name;
    private int age;

    public User() {
    }

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
}
```

### The three JSP bean actions

| Action | Purpose |
|--------|---------|
| `<jsp:useBean id="user" class="beans.User" scope="session" />` | Create or find a bean |
| `<jsp:setProperty name="user" property="*" />` | Fill bean properties from request parameters |
| `<jsp:getProperty name="user" property="name" />` | Print a bean property |

`property="*"` matches every request parameter whose name equals a bean
property. That is why the form fields in `bean.jsp` are named `name` and `age`.

### Executable example — `bean.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="beans.User" %>
<jsp:useBean id="user" class="beans.User" scope="session" />
<jsp:setProperty name="user" property="*" />
...
<% if ("POST".equalsIgnoreCase(request.getMethod())) { %>
    <h2>User Information</h2>
    <p>Name: <jsp:getProperty name="user" property="name" /></p>
    <p>Age: <jsp:getProperty name="user" property="age" /></p>
    <p>Using EL: ${sessionScope.user.name}, age ${sessionScope.user.age}</p>
<% } else { %>
    <form action="bean.jsp" method="post">
        <label>Name:</label>
        <input type="text" name="name" required><br><br>
        <label>Age:</label>
        <input type="number" name="age" required><br><br>
        <input type="submit" value="Submit">
    </form>
<% } %>
```

**Open:** `http://localhost:8080/jsp-basics/bean.jsp`

### Expression Language (EL)

EL is a short syntax for reading values and doing small operations:

```jsp
${message}
${sessionScope.username}
${param.name}
${2 + 3 * 4}
${empty param.name}
${empty param.name ? 'No name supplied' : param.name}
```

| EL object | What it reads |
|-----------|---------------|
| `pageScope` | Page-scope attributes |
| `requestScope` | Request-scope attributes |
| `sessionScope` | Session-scope attributes |
| `applicationScope` | Application-scope attributes |
| `param` | Request parameter (single value) |
| `paramValues` | Request parameter (all values) |
| `header` / `headerValues` | HTTP headers |
| `cookie` | Cookies |
| `initParam` | Context init parameters |
| `pageContext` | The `PageContext` object |

EL looks in page, request, session, and application scope automatically when no
scope prefix is given.

### Executable example — `el.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setAttribute("message", "Hello from request scope");
    session.setAttribute("username", "Dipak");
    pageContext.setAttribute("count", 3);
%>
...
<p>Request attribute: ${message}</p>
<p>Session attribute: ${sessionScope.username}</p>
<p>Page attribute: ${pageScope.count}</p>
<p>Query parameter: ${param.name}</p>

<p>Arithmetic: ${2 + 3 * 4}</p>
<p>Comparison: ${count > 2}</p>
<p>Empty check: ${empty param.name}</p>
<p>Ternary: ${empty param.name ? 'No name supplied' : param.name}</p>
```

**Open:** `http://localhost:8080/jsp-basics/el.jsp?name=Dipak`

### JSTL (short note)

JSTL = **JSP Standard Tag Library**, a set of tags for loops, conditions,
formatting, and database access. It is **not** built into Tomcat. Add
`jstl-1.2.jar` to `WEB-INF/lib` (Tomcat 9 / `javax`) and declare it:

```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:forEach var="student" items="${students}">
    <p>${student.name}</p>
</c:forEach>

<c:if test="${empty param.name}">
    <p>No name was supplied.</p>
</c:if>
```

> On Tomcat 10+ use the Jakarta JSTL jars and the URI `jakarta.tags.core`.
> JSTL is optional for this folder; the examples above run without it.

---

## 11. JSP + JDBC CRUD

The BCAVI reference project contains a complete CRUD page:
`crud/student_crud.jsp` with `crud/DataAccess.java` and
`crud/StudentInformation.java`. This folder includes the same page, but with an
**in-memory** `DataAccess` so it runs without a database.

### What the page does

```
GET  student_crud.jsp            -> show form + list all students
POST action=create               -> insert, then redirect to the list
POST action=update               -> update, then redirect to the list
POST action=delete               -> delete, then redirect to the list
POST action=edit                 -> load one student into the form
```

After every write it calls `response.sendRedirect("student_crud.jsp")`, so the
browser URL is clean and a refresh does not submit the form again
(Post/Redirect/Get pattern).

### The model — `crud/StudentInformation.java`

```java
package crud;

public class StudentInformation {
    protected int id;
    protected String name;
    protected String email;
    protected String country;

    public StudentInformation() {
    }

    public StudentInformation(int id, String name, String email, String country) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.country = country;
    }

    // getters and setters ...
}
```

### The DAO — `crud/DataAccess.java`

The important methods match the reference project exactly:

| Method | Purpose |
|--------|---------|
| `insertUser(StudentInformation)` | Add a student |
| `selectStudent(int id)` | Find one student |
| `selectAllStudents()` | List every student |
| `updateStudent(StudentInformation)` | Update one student |
| `deleteStudent(int id)` | Delete one student |

In this folder the storage is a `static List`, so data lasts until the server
restarts. In the reference project the same methods use JDBC with a
`PreparedStatement`:

```java
private static final String INSERT_USERS_SQL =
    "INSERT INTO studentInformation (id, name, email, country) VALUES (?, ?, ?, ?)";
private static final String SELECT_USER_BY_ID =
    "select id, name, email, country from studentInformation where id = ?";
private static final String SELECT_ALL_USERS =
    "select * from studentInformation";
private static final String DELETE_USERS_SQL =
    "delete from studentInformation where id = ?";
private static final String UPDATE_USERS_SQL =
    "update studentInformation set name = ?, email = ?, country = ? where id = ?";
```

The Oracle table used by the reference project:

```sql
CREATE TABLE studentInformation (
    id      NUMBER PRIMARY KEY,
    name    VARCHAR2(100),
    email   VARCHAR2(150),
    country VARCHAR2(100)
);
```

To switch to a real database:

1. Add the JDBC driver jar to `WEB-INF/lib` (for Oracle, `ojdbc6-11.jar`).
2. Replace the in-memory method bodies with the JDBC code from the reference.
3. Update the URL, username, and password in `DataAccess`.

### The view — `student_crud.jsp`

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="crud.DataAccess, crud.StudentInformation, java.util.List" %>
<%
    String action = request.getParameter("action");
    String idParam = request.getParameter("id");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String country = request.getParameter("country");

    DataAccess dao = new DataAccess();

    if (action != null) {
        if ("create".equals(action)) {
            StudentInformation student = new StudentInformation();
            student.setName(name);
            student.setEmail(email);
            student.setCountry(country);
            try {
                dao.insertUser(student);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect("student_crud.jsp");
            return;
        }
        // update, delete, edit ...
    }
%>
...
<%
    List<StudentInformation> list = dao.selectAllStudents();
    for (StudentInformation student : list) {
%>
    <tr>
        <td><%= student.getId() %></td>
        <td><%= student.getName() %></td>
        <td><%= student.getEmail() %></td>
        <td><%= student.getCountry() %></td>
        <td>
            <!-- Edit and Delete forms -->
        </td>
    </tr>
<%
    }
%>
```

**Open:** `http://localhost:8080/jsp-basics/student_crud.jsp`

### Notes for real applications

- This is **Model 1**: the JSP does input, logic, and output. It is fine for
  learning, but a real application uses **Model 2 (MVC)**: a servlet handles the
  request, calls the DAO, stores data in request scope, and forwards to a JSP
  that only displays it.
- Use `PreparedStatement`, never string concatenation, to avoid SQL injection.
- Do not put database credentials directly in source code in production; use a
  connection pool and configuration.
- Escape user-provided text before printing it into HTML to avoid XSS. JSTL
  `<c:out>` does this automatically.

---

## 12. Run a JSP Project with Tomcat in Eclipse

This section matches the reference project `BCAVI`: a **Dynamic Web Project**
with **Tomcat 9** and `javax.servlet`.

### 12.1 What you need

1. **JDK** (Java 8 or newer). The reference project uses Java 21.
2. **Eclipse IDE for Enterprise Java and Web Developers** (not the plain Java
   IDE). Download from <https://www.eclipse.org/downloads/>.
3. **Apache Tomcat 9** installed on your computer (a normal ZIP is enough).

> Match the versions:
> - Tomcat 9 -> `javax.servlet.*`, `javax.servlet.jsp.*`
> - Tomcat 10 / 11 -> `jakarta.servlet.*`, `jakarta.servlet.jsp.*`
> If you use Tomcat 10+, all imports and tag library URIs must change.

### 12.2 Add Tomcat to Eclipse

1. Open Eclipse.
2. Go to **Window -> Preferences**.
3. Open **Server -> Runtime Environments**.
4. Click **Add...**.
5. Select **Apache Tomcat v9.0** -> **Next**.
6. Set:
   - **Tomcat installation directory** = your Tomcat 9 folder
   - **JRE** = your JDK
7. Click **Finish**, then **Apply and Close**.

### 12.3 Create the project

1. **File -> New -> Dynamic Web Project**.
2. Enter a project name, e.g. `jsp-basics`.
3. **Target runtime**: `Apache Tomcat v9.0`.
4. **Dynamic web module version**: `4.0`.
5. Click **Next -> Next**, tick **Generate web.xml deployment descriptor**.
6. Click **Finish**.

### 12.4 Project structure

A Dynamic Web Project looks like this:

```
jsp-basics/
├── src/main/java/            <- Java source files (beans, DAO, servlets)
│   ├── beans/User.java
│   └── crud/DataAccess.java
├── src/main/webapp/          <- public web files
│   ├── index.html
│   ├── hello.jsp
│   ├── ...
│   ├── WEB-INF/
│   │   ├── web.xml
│   │   └── lib/              <- extra .jar files (JSTL, JDBC driver)
│   └── META-INF/
└── build/classes/            <- compiled .class files
```

> The folder name `src/main/java` is the convention used by the reference
> project. Eclipse's default may be `src`; that is fine too, as long as the
> source folder is on the build path.

### 12.5 Add the JAR files (if needed)

Tomcat provides the servlet and JSP APIs at run time, so you usually do **not**
need to add `servlet-api.jar` or `jsp-api.jar` manually.

If Eclipse shows "The import javax.servlet cannot be resolved":

1. Right-click the project -> **Properties**.
2. **Targeted Runtimes** -> tick **Apache Tomcat v9.0**.
3. **Java Build Path -> Libraries** -> ensure **Server Runtime** is present.
4. Click **Apply and Close**.

Extra libraries:

- Copy the `.jar` into `src/main/webapp/WEB-INF/lib/`, **or**
- **Properties -> Java Build Path -> Libraries -> Add External JARs...**

Examples from the reference project: `ojdbc6-11.jar` (Oracle JDBC) and
`jstl-1.2.jar` (JSTL).

### 12.6 Copy the examples into the project

1. Copy the package folders from
   `08-servlets-and-jsp/jsp-basics/src/main/java/` into your Eclipse project's
   source folder.
2. Copy every `.jsp`, `index.html`, and `WEB-INF/web.xml` from
   `src/main/webapp/`.
3. Right-click the project -> **Refresh**.
4. Fix any error markers (usually the target runtime from step 12.5).

### 12.7 Run on the server

1. Right-click the project -> **Run As -> Run on Server**.
2. Select **Tomcat v9.0 Server** -> **Finish**.
3. Eclipse starts Tomcat and deploys the project.
4. The internal browser (or your browser) opens:
   `http://localhost:8080/jsp-basics/`

If the browser shows the home page, open a JSP directly:

```
http://localhost:8080/jsp-basics/hello.jsp
http://localhost:8080/jsp-basics/lifecycle.jsp
http://localhost:8080/jsp-basics/elements.jsp
http://localhost:8080/jsp-basics/params.jsp
http://localhost:8080/jsp-basics/implicit-objects.jsp
http://localhost:8080/jsp-basics/forward-source.jsp
http://localhost:8080/jsp-basics/redirect-source.jsp
http://localhost:8080/jsp-basics/error-demo.jsp
http://localhost:8080/jsp-basics/cookies.jsp
http://localhost:8080/jsp-basics/session.jsp
http://localhost:8080/jsp-basics/scope-source.jsp
http://localhost:8080/jsp-basics/bean.jsp
http://localhost:8080/jsp-basics/el.jsp
http://localhost:8080/jsp-basics/student_crud.jsp
```

### 12.8 Useful Eclipse buttons

| Button | Meaning |
|--------|---------|
| Green **Play** | Start the server |
| Red **Stop** | Stop the server |
| **Restart** | Restart the server |
| **Publish** | Copy updated files to the server |

The **Servers** view is at the bottom. If it is closed:
**Window -> Show View -> Servers**.

### 12.9 Common problems and fixes

| Problem | Fix |
|---------|-----|
| `404 Not Found` | Check the context path and the `.jsp` file name (case matters). |
| `The import javax.servlet cannot be resolved` | Add the Tomcat runtime (12.5). |
| `Port 8080 already in use` | Stop the other Tomcat, or change the port in the Servers view (double-click the server -> Ports). |
| `HTTP Status 500` | Read the stack trace in the Eclipse **Console** view and in the generated `_jspService`. |
| JSP changes are not visible | **Project -> Clean**, delete the Tomcat work folder, then restart. |
| `isErrorPage` / `exception` missing | Add `isErrorPage="true"` to the error page. |
| `exception` is null | The page was opened directly instead of through an `errorPage`. |
| Non-English characters show as `????` | Set `pageEncoding="UTF-8"` and `contentType="text/html; charset=UTF-8"`. |
| `javax.servlet.jsp.JspException` on include | Check the included file name and path. |
| JSTL tags are unknown | Add `jstl-1.2.jar` and the correct `taglib` URI. |
| Old page keeps appearing | Clear the browser cache, do **Project -> Clean**, restart the server. |

### 12.10 How deployment works (quick picture)

```
Eclipse project
   |  build + publish
   v
Tomcat webapps/jsp-basics/
   ├── index.html
   ├── *.jsp
   ├── WEB-INF/
   │   ├── web.xml
   │   ├── classes/          <- your compiled .class files
   │   └── lib/              <- your .jar files
   └── ...
        |
        v
http://localhost:8080/jsp-basics/...
```

At run time Tomcat also creates:

```
Tomcat/work/Catalina/localhost/jsp-basics/
   └── org/apache/jsp/
       ├── hello_jsp.java
       ├── hello_jsp.class
       └── ...
```

Those files are generated; never edit them.

### 12.11 Manual run without Eclipse (optional)

If you want to run without Eclipse:

1. Compile the Java classes (beans, DAO) into `WEB-INF/classes`.
2. Copy the web files and `WEB-INF` into a folder named after your app inside
   Tomcat's `webapps/` directory.
3. Start Tomcat (`bin/startup.bat` on Windows, `bin/startup.sh` on Linux/macOS).
4. Open `http://localhost:8080/<app-name>/`.

JSP files do not need manual compilation; Tomcat translates and compiles them on
first access.

---

## Quick Revision Checklist

- [ ] A JSP is translated into a servlet, then compiled and executed.
- [ ] Life cycle: translation -> compilation -> `jspInit()` -> `_jspService()` -> `jspDestroy()`.
- [ ] `jspInit()` and `jspDestroy()` run once; `_jspService()` runs per request.
- [ ] `<%! %>` = declaration, `<% %>` = scriptlet, `<%= %>` = expression.
- [ ] `<%-- --%>` is a JSP comment; it is not sent to the browser.
- [ ] `<%@ page ... %>` sets imports, encoding, session, and error pages.
- [ ] `<%@ include %>` is static; `<jsp:include>` is dynamic.
- [ ] Nine implicit objects: `request`, `response`, `out`, `session`, `application`, `config`, `pageContext`, `page`, `exception`.
- [ ] Four scopes: page, request, session, application.
- [ ] Read input with `request.getParameter()`; check for `null`.
- [ ] `forward` keeps the URL; `sendRedirect` changes the URL.
- [ ] `errorPage` names the handler; `isErrorPage="true"` enables `exception`.
- [ ] Cookies live in the browser; sessions live on the server.
- [ ] Delete a cookie with `setMaxAge(0)`.
- [ ] Use `<jsp:useBean>`, `<jsp:setProperty>`, `<jsp:getProperty>` for beans.
- [ ] EL reads values with `${...}` and implicit objects like `${param.name}`.
- [ ] JSTL needs `jstl-1.2.jar` on Tomcat 9.
- [ ] Tomcat 9 = `javax.servlet`; Tomcat 10+ = `jakarta.servlet`.

---

## Servlet Section → JSP Section Map

| Servlet Basics section | JSP Basics section |
|------------------------|--------------------|
| 1. Background | 1. Background |
| 2. The Life Cycle of a Servlet | 2. The Life Cycle of a JSP |
| 3. A Simple Servlet | 3. A Simple JSP |
| 4. The Servlet API | 4. The JSP API |
| 5. The `javax.servlet` Package | 5. The `javax.servlet.jsp` Package |
| 6. Reading Servlet Parameters | 6. Reading Request Parameters in JSP |
| 7. The `javax.servlet.http` Package | 7. JSP Implicit Objects |
| 8. Handling HTTP Requests and Responses | 8. Handling HTTP Requests and Responses |
| 9. Using Cookies | 9. Using Cookies and Sessions |
| 10. Run a Servlet Project with Tomcat in Eclipse | 12. Run a JSP Project with Tomcat in Eclipse |

Extra JSP sections: **10. JavaBeans, EL and JSTL** and **11. JSP + JDBC CRUD**.

---

## Reference Mapping

These notes mirror the working JSP files in the `BCAVI` reference project:

| Topic | Reference file |
|-------|----------------|
| JSP life cycle | `src/main/webapp/JspLifeCycle.jsp` |
| Implicit objects | `src/main/webapp/implicit_objects.jsp` |
| Form handling | `src/main/webapp/formHandler.jsp` |
| JavaBean integration | `src/main/webapp/javaBeanAndJspIntegration.jsp`, `src/main/java/beans/User.java` |
| Scope demonstration | `src/main/webapp/scope-main.jsp`, `scope-main-display.jsp` |
| Forward / include / header / footer | `redirect_one_send_redirect_or_forward.jsp`, `redirect_one_welcome_include_directive.jsp`, `jsp_header.jsp`, `jsp_footer.jsp` |
| Error handling | `src/main/java/crud/DivisionCalculator.jsp`, `ErrorHandler.jsp` |
| JSP CRUD | `src/main/java/crud/student_crud.jsp`, `DataAccess.java`, `StudentInformation.java` |

> In the reference project the JSP files also exist under
> `src/main/java/crud/`. In a Dynamic Web Project they belong under
> `src/main/webapp/` (or a subfolder) so the container can serve them. The copies
> in this folder are placed in `src/main/webapp/`.
