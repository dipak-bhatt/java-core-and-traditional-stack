package cookies;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/cookies")
public class CookieServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            Cookie cookie = new Cookie("username", "");
            cookie.setMaxAge(0);
            response.addCookie(cookie);
            response.sendRedirect("cookies");
            return;
        }

        if ("set".equals(action)) {
            Cookie cookie = new Cookie("username", "Dipak");
            cookie.setMaxAge(60 * 60 * 24);
            response.addCookie(cookie);
            response.sendRedirect("cookies");
            return;
        }

        String username = "not set";
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName())) {
                    username = cookie.getValue();
                }
            }
        }

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<h2>Cookie Example</h2>");
        out.println("<p>username cookie = <b>" + username + "</b></p>");
        out.println("<p><a href='cookies?action=set'>Set cookie</a></p>");
        out.println("<p><a href='cookies?action=delete'>Delete cookie</a></p>");
        out.println("<p><a href='cookies'>Read cookie</a></p>");
    }
}
