package jruby.ext;
 
import java.util.Arrays;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import org.jruby.Ruby;
import org.jruby.javasupport.JavaEmbedUtils;
 
/**
 * Launch a Ruby script at web application startup. To wire up this
 * listener, add
 * <listener-class>jruby.ext.StartupScriptLauncher</listener-class> to your
 * application's web.xml file.
 *
 * @author nicksieger
 */
public class StartupScriptLauncher implements ServletContextListener {
    public void contextInitialized(ServletContextEvent event) {
        ServletContext servletContext = event.getServletContext();
        Ruby runtime = null;
        try {
            runtime = JavaEmbedUtils.initialize(Arrays.asList(new String[] {
                // set up any $LOAD_PATH items here
                servletContext.getRealPath("/WEB-INF"),
                servletContext.getRealPath("/WEB-INF/lib")
            }));
            // setup any global variables
            runtime.getGlobalVariables().set("$servlet_context",
                JavaEmbedUtils.javaToRuby(runtime, servletContext));
            // require e.g., WEB-INF/config/startup.rb
            runtime.getLoadService().require("config/startup");
        } catch (Exception ex) {
            ex.printStackTrace();
            servletContext.log(ex.getMessage());
        } finally {
            if (runtime != null) {
                runtime.tearDown();
            }
        }
    }
 
    public void contextDestroyed(ServletContextEvent event) {
    }
}