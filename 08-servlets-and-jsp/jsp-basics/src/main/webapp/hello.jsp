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
