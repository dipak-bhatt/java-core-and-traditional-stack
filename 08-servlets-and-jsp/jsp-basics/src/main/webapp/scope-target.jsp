<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Scope Target</title>
</head>
<body>
    <h1>Accessing Scope Values After Forward</h1>

    <p>Page scope: <%= pageContext.getAttribute("pageMsg") %></p>
    <p>Request scope: <%= request.getAttribute("requestMsg") %></p>
    <p>Session scope: <%= session.getAttribute("sessionMsg") %></p>
    <p>Application scope: <%= application.getAttribute("appMsg") %></p>

    <h2>Explanation</h2>
    <ul>
        <li><strong>Page scope</strong> is lost because it belongs to the original page only.</li>
        <li><strong>Request scope</strong> survives because the request was forwarded.</li>
        <li><strong>Session scope</strong> survives for the user session.</li>
        <li><strong>Application scope</strong> survives for the whole application.</li>
    </ul>

    <p><a href="scope-source.jsp">Run again</a> | <a href="index.html">Back to home</a></p>
</body>
</html>
