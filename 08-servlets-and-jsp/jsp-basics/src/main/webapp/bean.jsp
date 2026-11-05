<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="beans.User" %>
<jsp:useBean id="user" class="beans.User" scope="session" />
<jsp:setProperty name="user" property="*" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JavaBeans in JSP</title>
</head>
<body>
    <h1>JavaBeans in JSP</h1>

    <h2>What is a JavaBean?</h2>
    <ul>
        <li>Implements <code>Serializable</code>.</li>
        <li>Has a public no-argument constructor.</li>
        <li>Provides getters and setters for its properties.</li>
    </ul>

    <% if ("POST".equalsIgnoreCase(request.getMethod())) { %>
        <h2>User Information</h2>
        <p>Name: <jsp:getProperty name="user" property="name" /></p>
        <p>Age: <jsp:getProperty name="user" property="age" /></p>
        <p>Using EL: ${sessionScope.user.name}, age ${sessionScope.user.age}</p>
        <p><a href="bean.jsp">Go back to the form</a></p>
    <% } else { %>
        <h2>User Information Form</h2>
        <form action="bean.jsp" method="post">
            <label>Name:</label>
            <input type="text" name="name" required><br><br>

            <label>Age:</label>
            <input type="number" name="age" required><br><br>

            <input type="submit" value="Submit">
        </form>
    <% } %>

    <p><a href="index.html">Back to home</a></p>
</body>
</html>
