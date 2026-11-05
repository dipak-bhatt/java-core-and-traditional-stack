<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error Page</title>
</head>
<body>
    <h1>Error Handler</h1>
    <p>This page is declared with <code>isErrorPage="true"</code>.</p>

    <h2>Error Details</h2>
    <ul>
        <li><strong>Exception type:</strong>
            <%= exception == null ? "unknown" : exception.getClass().getName() %></li>
        <li><strong>Message:</strong>
            <%= exception == null ? "unknown" : exception.getMessage() %></li>
        <li><strong>Requested URI:</strong>
            <%= request.getAttribute("javax.servlet.error.request_uri") %></li>
        <li><strong>Status code:</strong>
            <%= request.getAttribute("javax.servlet.error.status_code") %></li>
    </ul>

    <p><a href="error-demo.jsp">Try again</a> | <a href="index.html">Back to home</a></p>
</body>
</html>
