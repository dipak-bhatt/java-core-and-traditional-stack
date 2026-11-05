<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    private int hitCount = 0;

    @Override
    public void jspInit() {
        System.out.println("[JSP LifeCycle] 1. jspInit() called once");
    }

    @Override
    public void jspDestroy() {
        System.out.println("[JSP LifeCycle] 3. jspDestroy() called once");
    }
%>
<%
    hitCount++;
    System.out.println("[JSP LifeCycle] 2. _jspService() called for request");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JSP Life Cycle</title>
</head>
<body>
    <h1>JSP Life Cycle</h1>

    <p>This JSP has served <strong><%= hitCount %></strong> request(s).</p>
    <p>Look at the Tomcat console to see <code>jspInit()</code>,
       <code>_jspService()</code> and <code>jspDestroy()</code> messages.</p>

    <h2>Execution Flow</h2>
    <ol>
        <li>Translation: <code>lifecycle.jsp</code> becomes a Java servlet source file.</li>
        <li>Compilation: the generated servlet source is compiled to a <code>.class</code> file.</li>
        <li>Initialization: <code>jspInit()</code> runs once.</li>
        <li>Request handling: <code>_jspService()</code> runs for every request.</li>
        <li>Destruction: <code>jspDestroy()</code> runs before the JSP is unloaded.</li>
    </ol>

    <p><a href="lifecycle.jsp">Reload</a> | <a href="index.html">Back to home</a></p>
</body>
</html>
