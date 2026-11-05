<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         errorPage="ErrorHandler.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Division Calculator</title>
</head>
<body>
    <h1>Division Calculator</h1>

    <p>Enter a numerator and a denominator, then click Calculate.</p>
    <p>If the denominator is zero, the request is sent to <code>ErrorHandler.jsp</code>.</p>

    <form method="post">
        <label>Numerator:</label>
        <input type="number" name="numerator" required><br><br>

        <label>Denominator:</label>
        <input type="number" name="denominator" required><br><br>

        <button type="submit">Calculate</button>
    </form>

    <hr>

    <%
        String numStr = request.getParameter("numerator");
        String denStr = request.getParameter("denominator");

        if (numStr != null && denStr != null) {
            try {
                int numerator = Integer.parseInt(numStr);
                int denominator = Integer.parseInt(denStr);
                int result = numerator / denominator;
                out.println("<h3>Result: " + numerator + " / " + denominator + " = " + result + "</h3>");
            } catch (Exception e) {
                throw new ServletException("An error occurred while processing the division.", e);
            }
        }
    %>

    <p><a href="index.html">Back to home</a></p>
</body>
</html>
