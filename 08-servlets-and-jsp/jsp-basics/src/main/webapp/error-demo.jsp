<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         errorPage="error-page.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error Page Demo</title>
</head>
<body>
    <h1>Error Page Demo</h1>
    <p>Dividing by zero below. The request is sent to <code>error-page.jsp</code>.</p>

    <%
        int numerator = 10;
        int denominator = 0;
        int result = numerator / denominator;
        out.println("Result: " + result);
    %>
</body>
</html>
