package com.ctm.spring;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.legacy.context.web.SpringBootContextLoaderListener;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.ServletContextEvent;

/**
 * Created by dkocovski on 25/09/2015.
 */
public class CtmContextListener extends SpringBootContextLoaderListener {
    private static final Logger LOGGER = LoggerFactory.getLogger(CtmContextListener.class);


    @Override
    public void contextInitialized(ServletContextEvent event) {
        super.contextInitialized(event);
        LOGGER.error("ServletContextListener started");
        WebApplicationContext springWebApplicationContext =
                WebApplicationContextUtils.getWebApplicationContext(event.getServletContext());

        // Get the webctm datasourcefactory bean and place it in the servletcontext for easy access
        WebCtmDataAccessConfiguration dataAccessConfiguration =
                springWebApplicationContext.getBean(WebCtmDataAccessConfiguration.class);
        event.getServletContext().setAttribute("database", dataAccessConfiguration);
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        super.contextDestroyed(event);
        LOGGER.error("ServletContextListener destroyed");
    }


}
