package javaxservlet;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;

@WebFilter("/generic")
public class LogFilter implements Filter {

    @Override
    public void init(FilterConfig config) throws ServletException {
        String value = config.getInitParameter("message");
        if (value == null) {
            value = "no init-param set (using annotation)";
        }
        System.out.println("[Filter] init, message = " + value);
    }

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        System.out.println("[Filter] before servlet");
        chain.doFilter(request, response);
        System.out.println("[Filter] after servlet");
    }
}
