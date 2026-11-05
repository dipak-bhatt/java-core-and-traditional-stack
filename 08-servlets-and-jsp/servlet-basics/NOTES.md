# Java Servlets — Notes with Executable Examples

> Simple, topic-wise notes for students. Every example in this folder can be
> compiled and run on **Apache Tomcat 9** using `javax.servlet.*`.
>
> Files in this folder:
>
> ```
> servlet-basics/
> ├── NOTES.md
> └── src/main/
>     ├── java/
>     │   ├── basics/SimpleServlet.java
>     │   ├── lifecycle/LifeCycleServlet.java
>     │   ├── javaxservlet/GenericServletDemo.java
>     │   ├── javaxservlet/LogFilter.java
>     │   ├── javaxservlet/AppContextListener.java
>     │   ├── params/ParameterServlet.java
>     │   ├── http/HttpRequestResponseServlet.java
>     │   ├── http/LoginDemoServlet.java
>     │   ├── http/WelcomeServlet.java
>     │   ├── http/LogoutServlet.java
>     │   ├── cookies/CookieServlet.java
>     │   ├── session/SessionTrackingServlet.java
>     │   └── session/SessionTracker.java
>     └── webapp/
>         ├── index.html
>         └── WEB-INF/web.xml
> ```

## Table of Contents

0. [Before You Start: Eclipse, Tomcat, and Your First Servlet](#before-you-start-eclipse-tomcat-and-your-first-servlet)
1. [Background](#1-background)
2. [The Life Cycle of a Servlet](#2-the-life-cycle-of-a-servlet)
3. [A Simple Servlet](#3-a-simple-servlet)
4. [The Servlet API](#4-the-servlet-api)
5. [The `javax.servlet` Package](#5-the-javaxservlet-package)
6. [Reading Servlet Parameters](#6-reading-servlet-parameters)
7. [The `javax.servlet.http` Package](#7-the-javaxservlethttp-package)
8. [Handling HTTP Requests and Responses](#8-handling-http-requests-and-responses)
9. [Using Cookies](#9-using-cookies)
10. [Run a Servlet Project with Tomcat in Eclipse](#10-run-a-servlet-project-with-tomcat-in-eclipse)

---

## Before You Start: Eclipse, Tomcat, and Your First Servlet

The examples in this folder need **Eclipse (Enterprise edition)** and **Apache
Tomcat 9**. Do these steps once; after that, every example in this folder can
run on the server.

> This is the quick start. [Section 10](#10-run-a-servlet-project-with-tomcat-in-eclipse)
> covers the same setup in more detail and lists more troubleshooting.

### Step 1: Install the JDK and Tomcat 9

1. Install a JDK (Java 8 or newer; the reference project uses Java 21).
2. Download **Tomcat 9** from <https://tomcat.apache.org/download-90.cgi>.
   Choose the **Core** ZIP file (for example `apache-tomcat-9.0.x.zip`).
3. Extract it to a simple path with no spaces, for example:
   - Windows: `C:\apache-tomcat-9.0.x`
   - macOS / Linux: `/opt/apache-tomcat-9.0.x`
4. (Optional) Check that Tomcat can start by itself:
   - Windows: run `bin\startup.bat`
   - macOS / Linux: run `bin/startup.sh`
   - Open <http://localhost:8080>. You should see the Tomcat welcome page.
   - Stop it with `bin\shutdown.bat` (Windows) or `bin/shutdown.sh`
     (macOS / Linux).

> If `startup.bat` opens and closes immediately, set `JAVA_HOME` to your JDK
> folder, for example `C:\Program Files\Java\jdk-21`. Also, do **not** leave
> this standalone Tomcat running when you start Tomcat from Eclipse — both use
> port 8080 and will conflict.

### Step 2: Add Tomcat to Eclipse

1. Open Eclipse.
2. **Window -> Preferences**.
3. Go to **Server -> Runtime Environments**.
4. Click **Add...**.
5. Select **Apache Tomcat v9.0** -> **Next**.
6. Set **Tomcat installation directory** to the folder from Step 1.
7. Set **JRE** to your installed JDK.
8. Click **Finish**, then **Apply and Close**.

### Step 3: Create the Dynamic Web Project

1. **File -> New -> Dynamic Web Project**.
2. Project name: `servlet-basics`.
3. **Target runtime**: `Apache Tomcat v9.0`.
4. **Dynamic web module version**: `4.0`.
5. Click **Next -> Next**.
6. Optionally tick **Generate web.xml deployment descriptor**.
7. Click **Finish**.

> If **Dynamic Web Project** is missing from the New menu, you are using the
> plain Java edition of Eclipse. Install **Eclipse IDE for Enterprise Java and
> Web Developers** instead (see section 10.1).

### Step 4: Create your first servlet

1. Right-click **Java Resources -> src/main/java** (or `src`) ->
   **New -> Class**.
2. Package: `basics`.
3. Name: `FirstServlet`.
4. Superclass: `javax.servlet.http.HttpServlet` (or click **Browse** and search
   for `HttpServlet`).
5. Click **Finish** and replace the class body with:

```java
package basics;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/first")
public class FirstServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        response.getWriter().println("<h1>My first servlet works!</h1>");
    }
}
```

`@WebServlet("/first")` means the servlet answers at `/first`. You do not need
to edit `web.xml` when you use the annotation.

> The same pattern is used by `basics/SimpleServlet.java` (section 3). If you
> copied the example folder into the project, open `/hello` as well.

### Step 5: Run it on Tomcat

1. Right-click the project -> **Run As -> Run on Server**.
2. Select **Tomcat v9.0 Server at localhost** -> **Finish**.
   If no server exists yet, choose **Manually define a new server** ->
   **Apache -> Tomcat v9.0 Server** -> **Next** -> set the installation
   directory -> **Finish**.
3. Eclipse starts Tomcat, deploys the project, and opens
   `http://localhost:8080/servlet-basics/`.
4. Open `http://localhost:8080/servlet-basics/first`.
   You should see **My first servlet works!**
5. Open the **Console** view to see Tomcat's log messages. Use the **Servers**
   view (**Window -> Show View -> Servers**) to start, stop, or restart the
   server.

Your first run is successful when:

- The browser shows **My first servlet works!**
- The Console shows `Server startup in ... ms`.
- The Servers view shows Tomcat as **Started**.

### First-use problems

| Symptom | Likely cause / fix |
|---------|--------------------|
| `Dynamic Web Project` missing | You have plain Java Eclipse; install the Enterprise edition. |
| `The import javax.servlet cannot be resolved` | The project does not target Tomcat 9. Open project **Properties -> Targeted Runtimes** and tick **Apache Tomcat v9.0**. |
| `404 Not Found` | The URL must be `http://localhost:8080/servlet-basics/first`; the context path is the project name. |
| Server fails to start / port 8080 in use | Stop the standalone Tomcat from Step 1, or change the port in the Servers view. |
| `ClassNotFoundException` or an old page | **Project -> Clean**, then restart the server. |
| Tomcat 10 installed | Tomcat 10 uses `jakarta.servlet`; install Tomcat 9 or change every import. |

Once this works, continue with [section 1](#1-background), or jump to
[section 10](#10-run-a-servlet-project-with-tomcat-in-eclipse) for the full
reference.

---

## 1. Background

### How a web application works

A web application has two sides:

- **Client** — a browser (Chrome, Firefox, Edge) that sends an **HTTP request**.
- **Server** — a program that receives the request and sends back an **HTTP response**.

```
Browser  ---- HTTP request ---->  Web Server / Servlet Container
         <--- HTTP response ----  (Tomcat)
```

### Static page vs dynamic page

| Type | What the user sees | Who creates it |
|------|--------------------|----------------|
| Static | Same content every time | An HTML file on disk |
| Dynamic | Content can change (time, user, database) | A program running on the server |

A **servlet** is the Java program that creates dynamic web pages.

### What is a Servlet?

A **servlet** is a Java class that:

1. Runs inside a **servlet container** (also called a **servlet engine**), e.g. Apache Tomcat.
2. Receives a request and produces a response.
3. Is managed by the container (the container creates it, calls it, and destroys it).

You do **not** write a `main()` method. The container calls your servlet.

### Why servlets instead of CGI?

Old CGI programs started a new operating-system **process** for every request.
Servlets run as **threads** inside one JVM, so they are:

- **Fast** — no process creation per request.
- **Portable** — plain Java, runs on any OS with a servlet container.
- **Scalable** — many requests share the same servlet object.
- **Secure** — the container handles many security concerns.
- **Stateful** — sessions and cookies allow remembering a user.

### What the container does for you

- Loads the servlet class and creates the object.
- Calls `init()`, `service()`, and `destroy()` at the right times.
- Turns raw HTTP bytes into `HttpServletRequest` / `HttpServletResponse` objects.
- Manages threading, sessions, cookies, filters, and listeners.
- Maps URLs to servlets.

> **Important:** Tomcat 9 uses `javax.servlet.*`. Tomcat 10+ uses
> `jakarta.servlet.*`. This folder uses **Tomcat 9 + `javax.servlet`**.
> If you use Tomcat 10 or newer, change every `javax.servlet` import to
> `jakarta.servlet`.

---

## 2. The Life Cycle of a Servlet

The container controls the whole life of a servlet. There are four stages:

```
1. Loading & Instantiation   -> constructor runs (once)
2. Initialization            -> init(ServletConfig) runs (once)
3. Request Handling          -> service() runs (once per request)
4. Destruction               -> destroy() runs (once, before removal)
```

### Stage-by-stage

| Stage | Method | Called how many times | Purpose |
|-------|--------|-----------------------|---------|
| Load & instantiate | constructor | 1 | Create the servlet object |
| Initialize | `init(ServletConfig)` | 1 | Read config, open resources |
| Serve | `service(ServletRequest, ServletResponse)` | many | Handle every request |
| Destroy | `destroy()` | 1 | Close resources |

`HttpServlet.service()` looks at the HTTP method and calls the matching
method for you:

```
GET     -> doGet()
POST    -> doPost()
PUT     -> doPut()
DELETE  -> doDelete()
HEAD    -> doHead()
OPTIONS -> doOptions()
TRACE   -> doTrace()
```

### Life cycle diagram

```
Container starts
      |
      v
  constructor()        <-- object created
      |
      v
    init()             <-- runs once
      |
      v
 service()  <--->  doGet()/doPost()   (runs for every request)
      |
      v
    destroy()          <-- runs once when container stops / app undeployed
      |
      v
  garbage collected
```

### Executable example — `lifecycle/LifeCycleServlet.java`

```java
package lifecycle;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/lifecycle")
public class LifeCycleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private int requestCount = 0;

    public LifeCycleServlet() {
        System.out.println("[LifeCycle] 1. Constructor called");
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("[LifeCycle] 2. init() called once");
    }

    @Override
    protected void service(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("[LifeCycle] 3. service() called for request");
        super.service(request, response);       // calls doGet/doPost
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        requestCount++;
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h1>Servlet Life Cycle</h1>");
        out.println("<p>This servlet has served " + requestCount + " request(s).</p>");
        out.println("<p>Look at the Tomcat console to see the life-cycle logs.</p>");
    }

    @Override
    public void destroy() {
        System.out.println("[LifeCycle] 4. destroy() called once");
    }
}
```

**Try it:** open `http://localhost:8080/servlet-basics/lifecycle` several times.
The console shows one `init()` message but many `service()` messages. Stop the
server to see `destroy()`.

> **Note:** `requestCount` is shared by all users because there is only one
> servlet object. Use a session (see section 7) for per-user data.

---

## 3. A Simple Servlet

Three things are needed to write a servlet:

1. Extend `HttpServlet`.
2. Override `doGet()` and/or `doPost()`.
3. Give it a URL (annotation `@WebServlet` or `web.xml`).

### Executable example — `basics/SimpleServlet.java`

```java
package basics;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/hello")
public class SimpleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");   // tell browser it is HTML
        PrintWriter out = response.getWriter(); // write the response body

        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Hello Servlet</title></head><body>");
        out.println("<h1>Hello from a Servlet!</h1>");
        out.println("<p>Current time on the server: " + new java.util.Date() + "</p>");
        out.println("<a href='index.html'>Back to home</a>");
        out.println("</body></html>");
    }
}
```

**Open:** `http://localhost:8080/servlet-basics/hello`

### Alternative URL mapping with `web.xml`

Instead of `@WebServlet`, you can register the servlet in
`WEB-INF/web.xml`:

```xml
<servlet>
    <servlet-name>simple</servlet-name>
    <servlet-class>basics.SimpleServlet</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>simple</servlet-name>
    <url-pattern>/hello</url-pattern>
</servlet-mapping>
```

> Use **either** `@WebServlet` **or** `web.xml` for the same URL. Do not map
> both, or Tomcat will report a duplicate mapping error.

### URL anatomy

```
http://localhost:8080/servlet-basics/hello
       --------------- --------------- -----
            host          context path   servlet mapping
```

- **Context path** = the deployed project name.
- **Servlet mapping** = the value inside `@WebServlet`.

---

## 4. The Servlet API

The Servlet API is a set of **interfaces** and **classes** in two main packages:

- `javax.servlet` — generic, protocol-independent classes.
- `javax.servlet.http` — HTTP-specific classes.

### Core interfaces

| Interface | What it represents |
|-----------|--------------------|
| `Servlet` | The basic contract: `init()`, `service()`, `destroy()`, `getServletConfig()` |
| `ServletConfig` | Configuration for **one** servlet (init parameters) |
| `ServletContext` | Configuration and shared attributes for the **whole application** |
| `ServletRequest` | Data coming from the client |
| `ServletResponse` | Data going back to the client |
| `RequestDispatcher` | Forwards a request to another resource (`forward`, `include`) |
| `Filter` | Intercepts requests/responses before/after a servlet |
| `FilterChain` | Passes control to the next filter or servlet |
| `ServletContextListener` | Notified when the app starts/stops |
| `ServletRequestListener` | Notified for every request |
| `HttpSessionListener` | Notified when sessions are created/destroyed |

### Core classes

| Class | Purpose |
|-------|---------|
| `GenericServlet` | Abstract class implementing `Servlet` + `ServletConfig`; protocol independent |
| `HttpServlet` | Extends `GenericServlet`; adds `doGet`, `doPost`, etc. |
| `ServletInputStream` / `ServletOutputStream` | Binary input / output streams |
| `ServletRequestWrapper` / `ServletResponseWrapper` | Wrap and modify request/response objects |

### Class hierarchy

```
Servlet (interface)
   |
GenericServlet (abstract class)
   |
HttpServlet (abstract class)
   |
YourServlet
```

### ServletConfig vs ServletContext

| | `ServletConfig` | `ServletContext` |
|--|-----------------|------------------|
| Scope | One servlet | Whole application |
| Parameters | `<init-param>` inside `<servlet>` | `<context-param>` at app level |
| Retrieved by | `getServletConfig()` | `getServletContext()` |
| Typical use | Servlet-specific settings | Shared data, DB config, resources |

Example init parameters in `web.xml`:

```xml
<!-- one servlet -->
<servlet>
    <servlet-name>simple</servlet-name>
    <servlet-class>basics.SimpleServlet</servlet-class>
    <init-param>
        <param-name>company</param-name>
        <param-value>D2DEX</param-value>
    </init-param>
</servlet>

<!-- whole application -->
<context-param>
    <param-name>appName</param-name>
    <param-value>Servlet Basics</param-value>
</context-param>
```

---

## 5. The `javax.servlet` Package

This package contains the protocol-independent part of the API. The most
useful members for beginners are `GenericServlet`, `Filter`, and listeners.

### 5.1 `GenericServlet`

`GenericServlet` handles any protocol. You implement only `service()`.

Executable example — `javaxservlet/GenericServletDemo.java`:

```java
package javaxservlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.GenericServlet;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebServlet;

@WebServlet("/generic")
public class GenericServletDemo extends GenericServlet {
    private static final long serialVersionUID = 1L;

    @Override
    public void service(ServletRequest request, ServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        ServletContext context = getServletContext();

        // Application-wide value set by AppContextListener
        Object message = context.getAttribute("globalMessage");

        out.println("<h1>GenericServlet Example</h1>");
        out.println("<p>" + message + "</p>");
        out.println("<p>Context path: " + context.getContextPath() + "</p>");
    }
}
```

> `HttpServlet` is used far more often because it already knows HTTP
> methods. `GenericServlet` is useful to understand the API and for
> non-HTTP protocols.

### 5.2 Filter

A **filter** runs **before** and **after** a servlet. Uses:

- Logging
- Login / authorization checks
- Compression
- Setting common headers
- Blocking bad requests

Executable example — `javaxservlet/LogFilter.java`:

```java
package javaxservlet;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;

@WebFilter("/generic")
public class LogFilter implements Filter {

    @Override
    public void init(FilterConfig config) throws ServletException {
        String value = config.getInitParameter("message");
        if (value == null) {
            value = "no init-param set (using annotation)";
        }
        System.out.println("[Filter] init, message = " + value);
    }

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        System.out.println("[Filter] before servlet");
        chain.doFilter(request, response);   // must call, or servlet never runs
        System.out.println("[Filter] after servlet");
    }
}
```

> **Golden rule:** always call `chain.doFilter(request, response)`, otherwise
> the request stops at the filter.

### 5.3 Listeners

Listeners react to application events.

| Listener | Event |
|----------|-------|
| `ServletContextListener` | App start / stop |
| `ServletRequestListener` | Request start / end |
| `HttpSessionListener` | Session create / destroy |

Executable example — `javaxservlet/AppContextListener.java`:

```java
package javaxservlet;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent event) {
        ServletContext context = event.getServletContext();
        context.setAttribute("globalMessage",
                "This value is shared by every servlet in the application.");
        System.out.println("[Listener] Application started");
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        System.out.println("[Listener] Application stopped");
    }
}
```

### 5.4 Wrapper (short note)

A `ServletRequestWrapper` lets you change data on the way in, for example
making every parameter uppercase. This is an advanced topic; the reference
project has `MyServletRequestWrapper4` as an example.

---

## 6. Reading Servlet Parameters

Parameters are values sent by the client, usually from an HTML form:

```html
<form method="post" action="params">
    Name: <input type="text" name="studentName">
    Marks: <input type="text" name="marks">
    <input type="submit" value="Send">
</form>
```

When submitted, the browser sends `studentName=...&marks=...` to the servlet.
Read them with `HttpServletRequest`:

| Method | Returns |
|--------|---------|
| `getParameter("name")` | First value as `String`, or `null` |
| `getParameterValues("name")` | `String[]` (for checkboxes / multi-select) |
| `getParameterNames()` | `Enumeration<String>` of all names |
| `getParameterMap()` | `Map<String, String[]>` of everything |

### Executable example — `params/ParameterServlet.java`

```java
package params;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/params")
public class ParameterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Shows the form on a normal GET request
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h2>Student Form</h2>");
        out.println("<form method='post' action='params'>");
        out.println("Name: <input type='text' name='studentName'><br><br>");
        out.println("Marks: <input type='text' name='marks'><br><br>");
        out.println("Subjects:<br>");
        out.println("<input type='checkbox' name='subject' value='Java'> Java<br>");
        out.println("<input type='checkbox' name='subject' value='DBMS'> DBMS<br>");
        out.println("<input type='checkbox' name='subject' value='Web'> Web<br><br>");
        out.println("<input type='submit' value='Submit'>");
        out.println("</form>");
    }

    // Reads the submitted values
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");   // support non-English text

        String name = request.getParameter("studentName");
        String marks = request.getParameter("marks");
        String[] subjects = request.getParameterValues("subject"); // many values

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<h2>Received Parameters</h2>");
        out.println("<p>Name: " + name + "</p>");
        out.println("<p>Marks: " + marks + "</p>");

        out.print("<p>Subjects: ");
        if (subjects == null || subjects.length == 0) {
            out.print("none selected");
        } else {
            for (String subject : subjects) {
                out.print(subject + " ");
            }
        }
        out.println("</p>");

        // List every parameter name (useful for debugging)
        out.println("<h3>All parameter names</h3><ul>");
        Enumeration<String> names = request.getParameterNames();
        while (names.hasMoreElements()) {
            out.println("<li>" + names.nextElement() + "</li>");
        }
        out.println("</ul>");

        out.println("<p><a href='params'>Try again</a></p>");
    }
}
```

**Open:** `http://localhost:8080/servlet-basics/params`

> **Safety:** always check for `null` before using a parameter. A user can
> submit the form without filling a field.

---

## 7. The `javax.servlet.http` Package

This package adds HTTP-specific classes.

| Class / interface | Purpose |
|-------------------|---------|
| `HttpServlet` | Base class for HTTP servlets; provides `doGet`, `doPost`, ... |
| `HttpServletRequest` | HTTP request: parameters, headers, cookies, session, URL |
| `HttpServletResponse` | HTTP response: status, headers, content type, cookies, redirect |
| `HttpSession` | Per-user session data on the server |
| `Cookie` | Small text data stored in the browser |
| `HttpSessionListener` | Notified when sessions are created/destroyed |
| `HttpSessionEvent` | Event object for session listeners |

### Sessions in one minute

HTTP is **stateless**: the server does not remember the previous request.
A **session** lets the server remember a user.

```java
HttpSession session = request.getSession();      // create or get
session.setAttribute("username", "Dipak");       // store
String user = (String) session.getAttribute("username"); // read
session.invalidate();                            // logout / destroy
```

The container gives the browser a cookie named `JSESSIONID`. The browser sends
it back on every request so the server can find the right session.

### Executable example — `http/HttpRequestResponseServlet.java`

```java
package http;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/http-demo")
public class HttpRequestResponseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();  // create if missing
        Integer visits = (Integer) session.getAttribute("visits");
        visits = (visits == null) ? 1 : visits + 1;
        session.setAttribute("visits", visits);

        response.setContentType("text/html");
        response.setHeader("X-Demo-Header", "Hello-Student"); // custom header
        response.setStatus(HttpServletResponse.SC_OK);        // 200

        PrintWriter out = response.getWriter();
        out.println("<h1>HTTP Request and Response</h1>");
        out.println("<p>Session ID: " + session.getId() + "</p>");
        out.println("<p>Visits in this session: " + visits + "</p>");
        out.println("<p>Request method: " + request.getMethod() + "</p>");
        out.println("<p>Context path: " + request.getContextPath() + "</p>");
        out.println("<p>Client address: " + request.getRemoteAddr() + "</p>");
        out.println("<p>Browser: " + request.getHeader("User-Agent") + "</p>");
        out.println("<p><a href='http-demo'>Reload</a></p>");
    }
}
```

**Open:** `http://localhost:8080/servlet-basics/http-demo`

### Session tracking techniques

Because HTTP is **stateless**, the server needs a way to recognize the same
user across requests. This is called **session tracking**. The main techniques
are:

| Technique | Where the data lives | How the server identifies the user |
|-----------|----------------------|------------------------------------|
| Cookies | Browser | A cookie (usually `JSESSIONID`) is sent on every request |
| Hidden form field | HTML form | The session ID is submitted with the form |
| URL rewriting | URL | The session ID is appended to links (`;jsessionid=...`) |
| `HttpSession` | Server memory | The container stores attributes for each user |

`HttpSession` is the usual choice. Cookies, hidden fields, and URL rewriting
are ways to carry the session ID when cookies are unavailable.

```java
HttpSession session = request.getSession();      // create or get
session.setAttribute("visits", visitCount);      // store data on the server
session.getMaxInactiveInterval();                // timeout in seconds
session.getId();                                 // unique session ID
session.getCreationTime();                       // when the session began
session.getLastAccessedTime();                   // last request time
session.invalidate();                            // destroy (logout)
```

Session listeners receive life-cycle events:

```java
@WebListener
public class SessionTracker implements HttpSessionListener {
    public void sessionCreated(HttpSessionEvent event) {
        System.out.println("Created: " + event.getSession().getId());
    }
    public void sessionDestroyed(HttpSessionEvent event) {
        System.out.println("Destroyed: " + event.getSession().getId());
    }
}
```

Executable examples:

- `session/SessionTrackingServlet.java` shows all four techniques in one page.
  It has a visit counter, prints the `JSESSIONID` cookie, submits the session ID
  as a hidden form field, generates a URL with `response.encodeURL()`, and can
  invalidate the session.
- `session/SessionTracker.java` logs `sessionCreated` and `sessionDestroyed`
  events to the Tomcat console.

**Open:** `http://localhost:8080/servlet-basics/session-tracking`

> URL rewriting only adds `;jsessionid=...` when the container thinks cookies
> are not available. With cookies enabled, the generated URL looks normal.

### Useful `HttpServletRequest` methods

| Method | Meaning |
|--------|---------|
| `getMethod()` | `GET`, `POST`, ... |
| `getParameter(name)` | Form / query value |
| `getHeader(name)` | HTTP header value |
| `getCookies()` | Array of cookies |
| `getSession()` | Current session (creates one if needed) |
| `getContextPath()` | Application path |
| `getRequestURI()` | Full path after the host |

### Useful `HttpServletResponse` methods

| Method | Meaning |
|--------|---------|
| `setContentType("text/html")` | Response type |
| `getWriter()` | Print text |
| `setHeader(name, value)` | Custom header |
| `addCookie(cookie)` | Send a cookie |
| `sendRedirect(url)` | Redirect to another URL (new request) |
| `setStatus(code)` | HTTP status code |

---

## 8. Handling HTTP Requests and Responses

### GET vs POST

| Feature | GET | POST |
|---------|-----|------|
| Data location | URL query string | Request body |
| Visible in URL | Yes | No |
| Size limit | Limited | Large |
| Bookmarkable | Yes | No |
| Sensitive data | Never use | Preferred |
| Typical use | Read / search | Create / login / update |

### The request/response cycle

```
Browser
  |
  |-- GET /app/hello HTTP/1.1
  |   Host: localhost:8080
  |
  v
Tomcat -> HttpServlet.service()
              |
              |-- method is GET --> doGet(request, response)
              |
              v
         response.setContentType("text/html")
         response.getWriter().println("...")
              |
  |<-- HTTP/1.1 200 OK
  |    Content-Type: text/html
  |    <html>...</html>
```

### Forward vs Redirect vs Include

These three confuse many students. Learn the difference.

| | `forward()` | `sendRedirect()` | `include()` |
|--|-------------|------------------|-------------|
| Where it happens | Same server | Browser asks a new URL | Same server |
| URL in browser | Does **not** change | **Changes** | Does **not** change |
| Request attributes | Kept | Lost (new request) | Kept |
| Can go to another site | No | Yes | No |
| Typical use | MVC (servlet -> JSP) | After login/logout | Headers, footers |

```java
// Forward (same request)
request.getRequestDispatcher("/welcome").forward(request, response);

// Redirect (new request, URL changes)
response.sendRedirect("welcome");

// Include (add another resource's output)
request.getRequestDispatcher("/header.html").include(request, response);
```

### Handling both GET and POST in one servlet

```java
@Override
protected void doPost(HttpServletRequest request,
                      HttpServletResponse response)
        throws ServletException, IOException {
    doGet(request, response);   // reuse the same logic
}
```

### Executable example — a mini login (GET form + POST check)

This combines request handling, response redirect, and sessions. It is the
same pattern used in the reference project's `lab7` package.

```java
package http;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginDemoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h2>Login</h2>");
        out.println("<form method='post' action='login'>");
        out.println("Username: <input type='text' name='username'><br><br>");
        out.println("Password: <input type='password' name='password'><br><br>");
        out.println("<input type='submit' value='Login'>");
        out.println("</form>");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if ("admin".equals(username) && "admin".equals(password)) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            response.sendRedirect("welcome");   // new request, URL changes
        } else {
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<h2>Login failed</h2>");
            out.println("<a href='login'>Try again</a>");
        }
    }
}
```

> The matching `WelcomeServlet` and `LogoutServlet` are included in
> `src/main/java/http/`, so this login demo runs as-is. The reference project
> implements the same idea in `lab7/WelcomeUserServlet.java` and
> `lab7/SignOutServlet.java`.

---

## 9. Using Cookies

### What is a cookie?

A **cookie** is a small piece of text that the server sends to the browser.
The browser stores it and sends it back with later requests. Cookies are
stored on the **client**.

Common uses:

- Remember a username
- Remember a theme (dark / light)
- Track visits
- Shopping cart (small data)

> Cookies are limited in size (about 4 KB each) and are not secure by
> default. Do not store passwords in a cookie.

### How cookies work

```
1. Server:  response.addCookie(new Cookie("username", "Dipak"))
2. Browser: stores   username=Dipak
3. Browser: sends    Cookie: username=Dipak   on every later request
4. Server:  request.getCookies()  -> read it
```

### Cookie operations

**Create / set**

```java
Cookie cookie = new Cookie("username", "Dipak");
cookie.setMaxAge(60 * 60 * 24);   // 1 day, in seconds
response.addCookie(cookie);
```

**Read**

```java
Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie c : cookies) {
        if ("username".equals(c.getName())) {
            String value = c.getValue();
        }
    }
}
```

**Delete**

```java
Cookie cookie = new Cookie("username", "");
cookie.setMaxAge(0);            // 0 = delete now
response.addCookie(cookie);
```

### Executable example — `cookies/CookieServlet.java`

```java
package cookies;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/cookies")
public class CookieServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Delete cookie if requested
        if ("delete".equals(action)) {
            Cookie cookie = new Cookie("username", "");
            cookie.setMaxAge(0);
            response.addCookie(cookie);
            response.sendRedirect("cookies");
            return;
        }

        // Set cookie if requested
        if ("set".equals(action)) {
            Cookie cookie = new Cookie("username", "Dipak");
            cookie.setMaxAge(60 * 60 * 24);   // 1 day
            response.addCookie(cookie);
            response.sendRedirect("cookies");
            return;
        }

        // Read all cookies
        String username = "not set";
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName())) {
                    username = cookie.getValue();
                }
            }
        }

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h2>Cookie Example</h2>");
        out.println("<p>username cookie = <b>" + username + "</b></p>");
        out.println("<p><a href='cookies?action=set'>Set cookie</a></p>");
        out.println("<p><a href='cookies?action=delete'>Delete cookie</a></p>");
        out.println("<p><a href='cookies'>Read cookie</a></p>");
    }
}
```

**Open:** `http://localhost:8080/servlet-basics/cookies`

### Cookie vs Session

| | Cookie | Session |
|--|--------|---------|
| Stored on | Client (browser) | Server |
| Size | Small (~4 KB) | Larger |
| Security | User can see/edit | User sees only the ID |
| Lifetime | Controlled by `setMaxAge` | Until timeout or `invalidate()` |
| Default lifetime | Until browser closes | Default 30 minutes |

Typical design: store only a **session ID** in a cookie (this is what
`JSESSIONID` does) and keep real data on the server.

---

## 10. Run a Servlet Project with Tomcat in Eclipse

> For a short zero-to-running walkthrough, see
> [Before You Start](#before-you-start-eclipse-tomcat-and-your-first-servlet)
> at the top. This section repeats the steps with more detail and
> troubleshooting.

This section matches the reference project `BCAVI`: a **Dynamic Web Project**
with **Tomcat 9** and `javax.servlet`.

### 10.1 What you need

1. **JDK** (Java 8 or newer). The reference project uses Java 21.
2. **Eclipse IDE for Enterprise Java and Web Developers** (not the plain
   Java IDE). Download from <https://www.eclipse.org/downloads/>.
3. **Apache Tomcat 9** installed on your computer (a normal ZIP is enough).

> Match the versions:
> - Tomcat 9 -> `javax.servlet.*`
> - Tomcat 10 / 11 -> `jakarta.servlet.*`
> If you use Tomcat 10+, all code in this folder must change imports.

### 10.2 Add Tomcat to Eclipse

1. Open Eclipse.
2. Go to **Window -> Preferences**.
3. Open **Server -> Runtime Environments**.
4. Click **Add...**.
5. Select **Apache Tomcat v9.0** -> **Next**.
6. Set:
   - **Tomcat installation directory** = your Tomcat 9 folder
   - **JRE** = your JDK
7. Click **Finish**, then **Apply and Close**.

### 10.3 Create the project

1. **File -> New -> Dynamic Web Project**.
2. Enter a project name, e.g. `servlet-basics`.
3. **Target runtime**: `Apache Tomcat v9.0`.
4. **Dynamic web module version**: `4.0`.
5. Click **Next -> Next**, tick **Generate web.xml deployment descriptor**
   if you want to use XML mapping.
6. Click **Finish**.

### 10.4 Project structure

A Dynamic Web Project looks like this:

```
servlet-basics/
├── src/main/java/            <- Java source files (servlets)
│   └── basics/SimpleServlet.java
├── src/main/webapp/          <- public web files
│   ├── index.html
│   ├── WEB-INF/
│   │   ├── web.xml
│   │   └── lib/              <- extra .jar files
│   └── META-INF/
└── build/classes/            <- compiled .class files
```

> The folder name `src/main/java` is the convention used by the reference
> project. Eclipse's default may be `src`; that is fine too, as long as the
> source folder is on the build path.

### 10.5 Add the JAR files (if needed)

Tomcat's servlet API is provided by the runtime, so you usually do **not**
need to add `servlet-api.jar` manually.

If Eclipse shows "The import javax.servlet cannot be resolved", fix the
targeted runtime:

1. Right-click the project -> **Properties**.
2. **Targeted Runtimes** -> tick **Apache Tomcat v9.0**.
3. **Java Build Path -> Libraries** -> ensure **Server Runtime** is present.
4. Click **Apply and Close**.

For extra libraries (e.g. `ojdbc6-11.jar` in the reference project):

- Copy the `.jar` into `src/main/webapp/WEB-INF/lib/`, **or**
- **Properties -> Java Build Path -> Libraries -> Add External JARs...**

### 10.6 Copy the examples into the project

1. Copy the package folders from
   `08-servlets-and-jsp/servlet-basics/src/main/java/` into your Eclipse
   project's source folder.
2. Copy `index.html` and `WEB-INF/web.xml` from `src/main/webapp/`.
3. Right-click the project -> **Refresh**.
4. Fix any error markers (usually the target runtime from step 10.5).

### 10.7 Run on the server

1. Right-click the project -> **Run As -> Run on Server**.
2. Select **Tomcat v9.0 Server** -> **Finish**.
3. Eclipse starts Tomcat and deploys the project.
4. The internal browser (or your browser) opens:
   `http://localhost:8080/servlet-basics/`

If the browser shows a welcome page, open a servlet URL directly:

```
http://localhost:8080/servlet-basics/hello
http://localhost:8080/servlet-basics/lifecycle
http://localhost:8080/servlet-basics/params
http://localhost:8080/servlet-basics/http-demo
http://localhost:8080/servlet-basics/cookies
http://localhost:8080/servlet-basics/generic
http://localhost:8080/servlet-basics/login
```

### 10.8 Useful Eclipse buttons

| Button | Meaning |
|--------|---------|
| Green **Play** | Start the server |
| Red **Stop** | Stop the server |
| **Restart** | Restart the server |
| **Publish** | Copy updated files to the server |

The **Servers** view is at the bottom. If it is closed:
**Window -> Show View -> Servers**.

### 10.9 Common problems and fixes

| Problem | Fix |
|---------|-----|
| `404 Not Found` | Check the URL: context path + `@WebServlet` value must match. |
| `The import javax.servlet cannot be resolved` | Add the Tomcat runtime (10.5). |
| `Port 8080 already in use` | Stop the other Tomcat, or change the port in the Servers view (double-click the server -> Ports). |
| `Duplicate mapping` | Use only one of `@WebServlet` / `web.xml` for a URL. |
| `ClassNotFoundException` | Project was not rebuilt/published. Do **Project -> Clean**, then restart the server. |
| Browser shows old page | Clear browser cache or do **Project -> Clean** and restart. |
| `HTTP Status 500` | Read the stack trace in the Eclipse **Console** view. |
| Changes are not visible | **Project -> Clean**, then **Run on Server** again. |

### 10.10 How deployment works (quick picture)

```
Eclipse project
   |  build + publish
   v
Tomcat webapps/servlet-basics/
   ├── index.html
   ├── WEB-INF/
   │   ├── web.xml
   │   ├── classes/          <- your compiled .class files
   │   └── lib/              <- your .jar files
   └── ...
        |
        v
http://localhost:8080/servlet-basics/...
```

### 10.11 Manual run without Eclipse (optional)

If you want to run without Eclipse:

1. Compile the servlets with Tomcat's `servlet-api.jar` on the classpath.
2. Copy the compiled classes and web files into a folder named after your
   app inside Tomcat's `webapps/` directory.
3. Start Tomcat (`bin/startup.bat` on Windows, `bin/startup.sh` on Linux/macOS).
4. Open `http://localhost:8080/<app-name>/`.

---

## Quick Revision Checklist

- [ ] A servlet runs inside a container like Tomcat; no `main()` method.
- [ ] Life cycle: constructor -> `init()` -> `service()` -> `destroy()`.
- [ ] `init()` and `destroy()` run once; `service()` runs per request.
- [ ] `HttpServlet` calls `doGet()` / `doPost()` based on the HTTP method.
- [ ] `@WebServlet("/path")` maps a URL; `web.xml` can do the same.
- [ ] `ServletConfig` = one servlet; `ServletContext` = whole application.
- [ ] Read input with `request.getParameter()`; check for `null`.
- [ ] `forward()` keeps the URL; `sendRedirect()` changes the URL.
- [ ] Cookies live in the browser; sessions live on the server.
- [ ] Session tracking: cookies, hidden form fields, URL rewriting, `HttpSession`.
- [ ] Delete a cookie with `setMaxAge(0)`.
- [ ] Tomcat 9 = `javax.servlet`; Tomcat 10+ = `jakarta.servlet`.

---

## Reference Mapping

These notes mirror the working examples in the `BCAVI` reference project:

| Topic | Reference file |
|-------|----------------|
| Simple servlet | `src/main/java/firstServlet.java` |
| HTTP package / cookies / session | `httpServletPackage/HttpServletExample.java` |
| Session listener | `httpServletPackage/SessionTracker.java` |
| `javax.servlet` GenericServlet | `javaxServletPackage/MyGenericServlet5.java` |
| Filter | `javaxServletPackage/MyFilter3.java` |
| Context listener | `javaxServletPackage/MyServletContextListener1.java` |
| Request listener | `javaxServletPackage/MyServletRequestListener2.java` |
| Request wrapper | `javaxServletPackage/MyServletRequestWrapper4.java` |
| Login / session / cookie notes | `lab7/SignInServlet.java`, `WelcomeUserServlet.java`, `SignOutServlet.java` |
