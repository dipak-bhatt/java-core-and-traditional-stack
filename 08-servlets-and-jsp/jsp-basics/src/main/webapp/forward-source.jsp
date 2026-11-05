<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setAttribute("message", "Hello from forward-source.jsp");
        request.getRequestDispatcher("/forward-target.jsp").forward(request, response);
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forward</title>
</head>
<body>
    <h1>Forward Example</h1>
    <p>A POST request is forwarded on the server. The browser URL does not change.</p>

    <form method="post" action="forward-source.jsp">
        <input type="submit" value="Forward to target">
    </form>

    <p><a href="index.html">Back to home</a></p>
</body>
</html>
