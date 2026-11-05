package params;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/params")
public class ParameterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h2>Student Form</h2>");
        out.println("<form method='post' action='params'>");
        out.println("Name: <input type='text' name='studentName'><br><br>");
        out.println("Marks: <input type='text' name='marks'><br><br>");
        out.println("Subjects:<br>");
        out.println("<input type='checkbox' name='subject' value='Java'> Java<br>");
        out.println("<input type='checkbox' name='subject' value='DBMS'> DBMS<br>");
        out.println("<input type='checkbox' name='subject' value='Web'> Web<br><br>");
        out.println("<input type='submit' value='Submit'>");
        out.println("</form>");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("studentName");
        String marks = request.getParameter("marks");
        String[] subjects = request.getParameterValues("subject");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<h2>Received Parameters</h2>");
        out.println("<p>Name: " + name + "</p>");
        out.println("<p>Marks: " + marks + "</p>");

        out.print("<p>Subjects: ");
        if (subjects == null || subjects.length == 0) {
            out.print("none selected");
        } else {
            for (String subject : subjects) {
                out.print(subject + " ");
            }
        }
        out.println("</p>");

        out.println("<h3>All parameter names</h3><ul>");
        Enumeration<String> names = request.getParameterNames();
        while (names.hasMoreElements()) {
            out.println("<li>" + names.nextElement() + "</li>");
        }
        out.println("</ul>");

        out.println("<p><a href='params'>Try again</a></p>");
    }
}
