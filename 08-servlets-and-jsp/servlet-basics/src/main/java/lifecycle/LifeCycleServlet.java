package lifecycle;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/lifecycle")
public class LifeCycleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private int requestCount = 0;

    public LifeCycleServlet() {
        System.out.println("[LifeCycle] 1. Constructor called");
    }

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        System.out.println("[LifeCycle] 2. init() called once");
    }

    @Override
    protected void service(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("[LifeCycle] 3. service() called for request");
        super.service(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        requestCount++;
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h1>Servlet Life Cycle</h1>");
        out.println("<p>This servlet has served " + requestCount + " request(s).</p>");
        out.println("<p>Look at the Tomcat console to see the life-cycle logs.</p>");
    }

    @Override
    public void destroy() {
        System.out.println("[LifeCycle] 4. destroy() called once");
    }
}
