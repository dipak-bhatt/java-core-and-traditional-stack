<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    pageContext.setAttribute("pageMsg", "This is Page Scope");
    request.setAttribute("requestMsg", "This is Request Scope");
    session.setAttribute("sessionMsg", "This is Session Scope");
    application.setAttribute("appMsg", "This is Application Scope");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JSP Scopes</title>
</head>
<body>
    <h1>JSP Object Scopes</h1>
    <p>Values are set here and then the request is forwarded to another JSP.</p>

    <h2>Values on this page</h2>
    <p>Page scope: <%= pageContext.getAttribute("pageMsg") %></p>
    <p>Request scope: <%= request.getAttribute("requestMsg") %></p>
    <p>Session scope: <%= session.getAttribute("sessionMsg") %></p>
    <p>Application scope: <%= application.getAttribute("appMsg") %></p>

    <jsp:forward page="scope-target.jsp" />
</body>
</html>
