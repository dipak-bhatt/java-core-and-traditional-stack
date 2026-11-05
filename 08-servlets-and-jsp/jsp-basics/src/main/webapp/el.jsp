<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setAttribute("message", "Hello from request scope");
    session.setAttribute("username", "Dipak");
    pageContext.setAttribute("count", 3);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Expression Language</title>
</head>
<body>
    <h1>Expression Language (EL)</h1>

    <h2>Reading values</h2>
    <p>Request attribute: ${message}</p>
    <p>Session attribute: ${sessionScope.username}</p>
    <p>Page attribute: ${pageScope.count}</p>
    <p>Query parameter: ${param.name}</p>

    <h2>Operators</h2>
    <p>Arithmetic: ${2 + 3 * 4}</p>
    <p>Comparison: ${count > 2}</p>
    <p>Empty check: ${empty param.name}</p>
    <p>Ternary: ${empty param.name ? 'No name supplied' : param.name}</p>

    <h2>Try it</h2>
    <form method="get" action="el.jsp">
        Name: <input type="text" name="name">
        <input type="submit" value="Send">
    </form>

    <p><a href="index.html">Back to home</a></p>
</body>
</html>
