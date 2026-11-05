<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
         isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error Page</title>
</head>
<body>
    <h1>Error Handler (ErrorHandler.jsp)</h1>

    <p>This page uses <code>&lt;%@ page isErrorPage="true" %&gt;</code>, so the
       <code>exception</code> implicit object is available.</p>

    <h2>Error Details</h2>
    <ul>
        <li><strong>Exception type:</strong>
            <%= exception == null ? "unknown" : exception.getClass().getName() %></li>
        <li><strong>Message:</strong>
            <%= exception == null ? "unknown" : exception.getMessage() %></li>
        <li><strong>Requested URI:</strong>
            <%= request.getAttribute("javax.servlet.error.request_uri") %></li>
        <li><strong>Status code:</strong>
            <%= request.getAttribute("javax.servlet.error.status_code") %></li>
    </ul>

    <h2>How Error Handling Works</h2>
    <ol>
        <li>An error occurs in <code>DivisionCalculator.jsp</code>.</li>
        <li>The container forwards the request to the page named in <code>errorPage</code>.</li>
        <li>The error page reads the <code>exception</code> object and shows a friendly message.</li>
    </ol>

    <p><a href="DivisionCalculator.jsp">Go back</a> | <a href="index.html">Back to home</a></p>
</body>
</html>
