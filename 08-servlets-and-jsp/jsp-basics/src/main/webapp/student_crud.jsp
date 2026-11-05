<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="crud.DataAccess, crud.StudentInformation, java.util.List" %>
<%
    String action = request.getParameter("action");
    String idParam = request.getParameter("id");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String country = request.getParameter("country");

    DataAccess dao = new DataAccess();

    if (action != null) {
        if ("create".equals(action)) {
            StudentInformation student = new StudentInformation();
            student.setName(name);
            student.setEmail(email);
            student.setCountry(country);
            try {
                dao.insertUser(student);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect("student_crud.jsp");
            return;
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(idParam);
            StudentInformation student = new StudentInformation(id, name, email, country);
            try {
                dao.updateStudent(student);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect("student_crud.jsp");
            return;
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(idParam);
            try {
                dao.deleteStudent(id);
            } catch (Exception e) {
                e.printStackTrace();
            }
            response.sendRedirect("student_crud.jsp");
            return;
        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(idParam);
            StudentInformation student = dao.selectStudent(id);
            request.setAttribute("student", student);
        }
    }

    StudentInformation editStudent = (StudentInformation) request.getAttribute("student");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Management</title>
</head>
<body>
    <h1>Student Management</h1>

    <h2><%= editStudent == null ? "Add Student" : "Edit Student" %></h2>

    <form action="student_crud.jsp" method="post">
        <input type="hidden" name="action" value="<%= editStudent == null ? "create" : "update" %>">
        <input type="hidden" name="id" value="<%= editStudent != null ? editStudent.getId() : "" %>">

        <label>Name:</label>
        <input type="text" name="name"
               value="<%= editStudent != null ? editStudent.getName() : "" %>" required><br><br>

        <label>Email:</label>
        <input type="text" name="email"
               value="<%= editStudent != null ? editStudent.getEmail() : "" %>" required><br><br>

        <label>Country:</label>
        <input type="text" name="country"
               value="<%= editStudent != null ? editStudent.getCountry() : "" %>" required><br><br>

        <input type="submit" value="<%= editStudent == null ? "Create" : "Update" %>">
    </form>

    <h2>Student List</h2>

    <table border="1" width="70%">
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Country</th>
            <th>Action</th>
        </tr>
        <%
            List<StudentInformation> list = dao.selectAllStudents();
            for (StudentInformation student : list) {
        %>
        <tr>
            <td><%= student.getId() %></td>
            <td><%= student.getName() %></td>
            <td><%= student.getEmail() %></td>
            <td><%= student.getCountry() %></td>
            <td>
                <form style="display:inline;" action="student_crud.jsp" method="post">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="id" value="<%= student.getId() %>">
                    <input type="submit" value="Edit">
                </form>
                <form style="display:inline;" action="student_crud.jsp" method="post">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%= student.getId() %>">
                    <input type="submit" value="Delete">
                </form>
            </td>
        </tr>
        <%
            }
        %>
    </table>

    <p><a href="index.html">Back to home</a></p>
</body>
</html>
