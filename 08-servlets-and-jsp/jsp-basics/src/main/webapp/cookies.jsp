<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String action = request.getParameter("action");

    if ("delete".equals(action)) {
        Cookie cookie = new Cookie("username", "");
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        response.sendRedirect("cookies.jsp");
        return;
    }

    if ("set".equals(action)) {
        Cookie cookie = new Cookie("username", "Dipak");
        cookie.setMaxAge(60 * 60 * 24);
        response.addCookie(cookie);
        response.sendRedirect("cookies.jsp");
        return;
    }

    String username = "not set";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("username".equals(cookie.getName())) {
                username = cookie.getValue();
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JSP Cookies</title>
</head>
<body>
    <h1>Cookie Example</h1>

    <p>username cookie = <strong><%= username %></strong></p>

    <p>
        <a href="cookies.jsp?action=set">Set cookie</a> |
        <a href="cookies.jsp?action=delete">Delete cookie</a> |
        <a href="cookies.jsp">Read cookie</a>
    </p>

    <p><a href="index.html">Back to home</a></p>
</body>
</html>
