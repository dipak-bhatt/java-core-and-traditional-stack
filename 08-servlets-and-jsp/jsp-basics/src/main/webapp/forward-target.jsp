<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forward Target</title>
</head>
<body>
    <h1>Forward Target</h1>
    <p>Request attribute: <strong><%= request.getAttribute("message") %></strong></p>
    <p>The URL in the browser still shows <code>forward-source.jsp</code>.</p>
    <p><a href="index.html">Back to home</a></p>
</body>
</html>
