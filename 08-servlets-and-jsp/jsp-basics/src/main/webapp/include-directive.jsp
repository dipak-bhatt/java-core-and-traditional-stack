<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Include Directive</title>
</head>
<body>
    <%@ include file="header.jsp" %>

    <h1>Static Include (include directive)</h1>
    <p>The header and footer are copied into this page at translation time.</p>
    <ul>
        <li>Only one JSP is compiled.</li>
        <li>The included file shares variables and imports with this page.</li>
        <li>The included content cannot change at request time.</li>
    </ul>

    <%@ include file="footer.jsp" %>
</body>
</html>
