<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Include Action</title>
</head>
<body>
    <jsp:include page="header.jsp" />

    <h1>Dynamic Include (include action)</h1>
    <p>The included page runs as a separate JSP at request time.</p>
    <ul>
        <li>Each included page is compiled separately.</li>
        <li>Request and session attributes are visible to the included page.</li>
        <li>The included content can change for every request.</li>
    </ul>

    <jsp:include page="footer.jsp" />
</body>
</html>
