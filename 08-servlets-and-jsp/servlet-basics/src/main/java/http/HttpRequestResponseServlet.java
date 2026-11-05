package http;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/http-demo")
public class HttpRequestResponseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer visits = (Integer) session.getAttribute("visits");
        visits = (visits == null) ? 1 : visits + 1;
        session.setAttribute("visits", visits);

        response.setContentType("text/html");
        response.setHeader("X-Demo-Header", "Hello-Student");
        response.setStatus(HttpServletResponse.SC_OK);

        PrintWriter out = response.getWriter();
        out.println("<h1>HTTP Request and Response</h1>");
        out.println("<p>Session ID: " + session.getId() + "</p>");
        out.println("<p>Visits in this session: " + visits + "</p>");
        out.println("<p>Request method: " + request.getMethod() + "</p>");
        out.println("<p>Context path: " + request.getContextPath() + "</p>");
        out.println("<p>Client address: " + request.getRemoteAddr() + "</p>");
        out.println("<p>Browser: " + request.getHeader("User-Agent") + "</p>");
        out.println("<p><a href='http-demo'>Reload</a></p>");
    }
}
