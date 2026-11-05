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
