package session;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/session-tracking")
public class SessionTrackingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }
            response.sendRedirect("session-tracking");
            return;
        }

        HttpSession session = request.getSession();
        Integer visits = (Integer) session.getAttribute("visits");
        visits = (visits == null) ? 1 : visits + 1;
        session.setAttribute("visits", visits);

        String token = request.getParameter("token");
        String hiddenFieldResult;
        if (token == null) {
            hiddenFieldResult = "not submitted yet";
        } else if (token.equals(session.getId())) {
            hiddenFieldResult = "token matches the session (hidden form field tracking works)";
        } else {
            hiddenFieldResult = "token does not match the current session";
        }

        String cookieValue = "none";
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("JSESSIONID".equals(cookie.getName())) {
                    cookieValue = cookie.getValue();
                }
            }
        }

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String trackingUrl = response.encodeURL("session-tracking");

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Session Tracking</title></head><body>");
        out.println("<h1>Session Tracking</h1>");
        out.println("<p>Session ID: <b>" + session.getId() + "</b></p>");
        out.println("<p>Visits in this session: <b>" + visits + "</b></p>");
        out.println("<p>Created: " + format.format(new Date(session.getCreationTime())) + "</p>");
        out.println("<p>Last accessed: " + format.format(new Date(session.getLastAccessedTime())) + "</p>");
        out.println("<p>Max inactive interval: " + session.getMaxInactiveInterval() + " seconds</p>");

        out.println("<h2>1. Cookie tracking</h2>");
        out.println("<p>JSESSIONID cookie received from the browser: <b>" + cookieValue + "</b></p>");

        out.println("<h2>2. HttpSession tracking</h2>");
        out.println("<p>The visit counter is stored on the server in the HttpSession object.</p>");

        out.println("<h2>3. Hidden form field tracking</h2>");
        out.println("<p>Result: " + hiddenFieldResult + "</p>");
        out.println("<form method='post' action='session-tracking'>");
        out.println("<input type='hidden' name='token' value='" + session.getId() + "'>");
        out.println("<input type='submit' value='Submit hidden field'>");
        out.println("</form>");

        out.println("<h2>4. URL rewriting</h2>");
        out.println("<p><a href='" + trackingUrl + "'>Reload with URL rewriting</a></p>");
        out.println("<p>Generated URL: <code>" + trackingUrl + "</code></p>");

        out.println("<p><a href='session-tracking?action=logout'>Invalidate session (logout)</a></p>");
        out.println("<p><a href='index.html'>Back to home</a></p>");
        out.println("</body></html>");
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
