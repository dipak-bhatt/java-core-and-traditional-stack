package javaxservlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.GenericServlet;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebServlet;

@WebServlet("/generic")
public class GenericServletDemo extends GenericServlet {
    private static final long serialVersionUID = 1L;

    @Override
    public void service(ServletRequest request, ServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        ServletContext context = getServletContext();
        Object message = context.getAttribute("globalMessage");

        out.println("<h1>GenericServlet Example</h1>");
        out.println("<p>" + message + "</p>");
        out.println("<p>Context path: " + context.getContextPath() + "</p>");
    }
}
