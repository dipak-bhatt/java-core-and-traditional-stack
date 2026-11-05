<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if ("logout".equals(request.getParameter("action"))) {
        session.invalidate();
        response.sendRedirect("session.jsp");
        return;
    }

    Integer visits = (Integer) session.getAttribute("visits");
    visits = (visits == null) ? 1 : visits + 1;
    session.setAttribute("visits", visits);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JSP Session</title>
</head>
<body>
    <h1>Session Example</h1>

    <p>Session ID: <strong><%= session.getId() %></strong></p>
    <p>Visits in this session: <strong><%= visits %></strong></p>
    <p>Created at: <%= new java.util.Date(session.getCreationTime()) %></p>
    <p>Last accessed: <%= new java.util.Date(session.getLastAccessedTime()) %></p>
    <p>Max inactive interval: <%= session.getMaxInactiveInterval() %> seconds</p>

    <p><a href="session.jsp">Reload</a> |
       <a href="session.jsp?action=logout">Invalidate session</a> |
       <a href="index.html">Back to home</a></p>
</body>
</html>
