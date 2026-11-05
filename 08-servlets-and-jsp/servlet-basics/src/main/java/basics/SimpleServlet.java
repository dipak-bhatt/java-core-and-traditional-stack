package basics;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/hello")
public class SimpleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Hello Servlet</title></head><body>");
        out.println("<h1>Hello from a Servlet!</h1>");
        out.println("<p>Current time on the server: " + new java.util.Date() + "</p>");
        out.println("<a href='index.html'>Back to home</a>");
        out.println("</body></html>");
    }
}
