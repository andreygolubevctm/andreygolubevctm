package com.ctm.listeners;

import ch.qos.logback.classic.LoggerContext;
import com.ctm.services.ApplicationService;
import com.ctm.services.EnvironmentService;
import com.ctm.services.elasticsearch.AddressSearchService;
import com.mysql.jdbc.AbandonedConnectionCleanupThread;
import org.slf4j.Logger; import org.slf4j.LoggerFactory;
import org.slf4j.ILoggerFactory;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Properties;

/** adding this to debug threads **/

@WebListener()
public class ContextFinalizer implements ServletContextListener {

	Logger logger = LoggerFactory.getLogger(ContextFinalizer.class.getName());

	public void contextInitialized(ServletContextEvent sce) {

		Properties properties = new Properties();
		ServletContext servletContext = sce.getServletContext();
		EnvironmentService.setContextPath(servletContext.getContextPath());

		String propertyFileName = servletContext.getInitParameter("environmentConfigLocation");

		try {
			InputStream input = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (input == null) {
				logger.error("Sorry, unable to find " + propertyFileName);
				return;
			}
			properties.load(input);

			// Initialise the CTM environment and application objects
			String envVariable = (String) properties.get("environment");
			if(envVariable == null || envVariable.isEmpty()){
				 envVariable =  System.getProperty("spring.profiles.active", "localhost");
			}
			EnvironmentService.setEnvironment(envVariable);
			ApplicationService.getBrands();

			EnvironmentService environmentService = new EnvironmentService();
			environmentService.getBuildDetailsFromManifest(servletContext);

			AddressSearchService.init();
		}
		catch (Exception e) {
			logger.error("{}",e);
		}

	}

	public void contextDestroyed(ServletContextEvent sce) {
		ILoggerFactory loggerContext = LoggerFactory.getILoggerFactory();
		if(loggerContext != null && loggerContext instanceof LoggerContext) {
			((LoggerContext) loggerContext).stop();
		}
		Enumeration<Driver> drivers = DriverManager.getDrivers();
		Driver d = null;
		while(drivers.hasMoreElements()) {
			try {
				d = drivers.nextElement();
				DriverManager.deregisterDriver(d);
			}
			catch (SQLException ex) {
				logger.warn(String.format("Error deregistering driver %s", d), ex);
			}
		}

		AddressSearchService.destroy();
		try {
			AbandonedConnectionCleanupThread.shutdown();
		} catch (InterruptedException e) {
			logger.error("{}",e);
		}


	}

}