<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("redirect-target.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Redirect</title>
</head>
<body>
    <h1>Redirect Example</h1>
    <p>A redirect sends the browser to a new URL and creates a new request.</p>

    <form method="post" action="redirect-source.jsp">
        <input type="submit" value="Redirect to target">
    </form>

    <p><a href="index.html">Back to home</a></p>
</body>
</html>
