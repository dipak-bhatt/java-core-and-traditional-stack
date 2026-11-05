package javaxservlet;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent event) {
        ServletContext context = event.getServletContext();
        context.setAttribute("globalMessage",
                "This value is shared by every servlet in the application.");
        System.out.println("[Listener] Application started");
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        System.out.println("[Listener] Application stopped");
    }
}
