<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Enumeration" %>
<%
    request.setCharacterEncoding("UTF-8");

    String name = request.getParameter("studentName");
    String marks = request.getParameter("marks");
    String[] subjects = request.getParameterValues("subject");
    boolean submitted = name != null || marks != null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reading Parameters in JSP</title>
</head>
<body>
    <h1>Reading Request Parameters in JSP</h1>

    <% if (!submitted) { %>
        <h2>Student Form</h2>
        <form method="post" action="params.jsp">
            Name: <input type="text" name="studentName"><br><br>
            Marks: <input type="text" name="marks"><br><br>
            Subjects:<br>
            <input type="checkbox" name="subject" value="Java"> Java<br>
            <input type="checkbox" name="subject" value="DBMS"> DBMS<br>
            <input type="checkbox" name="subject" value="Web"> Web<br><br>
            <input type="submit" value="Submit">
        </form>
    <% } else { %>
        <h2>Received Parameters</h2>
        <p>Name: <strong><%= name %></strong></p>
        <p>Marks: <strong><%= marks %></strong></p>
        <p>Subjects:
            <%
                if (subjects == null || subjects.length == 0) {
                    out.print("none selected");
                } else {
                    for (String subject : subjects) {
                        out.print(subject + " ");
                    }
                }
            %>
        </p>

        <h3>All parameter names</h3>
        <ul>
            <%
                Enumeration<String> names = request.getParameterNames();
                while (names.hasMoreElements()) {
                    out.println("<li>" + names.nextElement() + "</li>");
                }
            %>
        </ul>

        <p><a href="params.jsp">Try again</a></p>
    <% } %>

    <p><a href="index.html">Back to home</a></p>
</body>
</html>
