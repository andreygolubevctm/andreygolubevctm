package com.ctm.listeners;

import ch.qos.logback.classic.LoggerContext;
import com.ctm.services.ApplicationService;
import com.ctm.services.EnvironmentService;
import com.ctm.services.elasticsearch.AddressSearchService;
import com.mysql.jdbc.AbandonedConnectionCleanupThread;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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

import static com.ctm.logging.LoggingArguments.kv;

/** adding this to debug threads **/

@WebListener()
public class ContextFinalizer implements ServletContextListener {

	Logger LOGGER = LoggerFactory.getLogger(ContextFinalizer.class);

	public void contextInitialized(ServletContextEvent sce) {
		Properties properties = new Properties();
		ServletContext servletContext = sce.getServletContext();
		EnvironmentService.setContextPath(servletContext.getContextPath());

		String propertyFileName = servletContext.getInitParameter("environmentConfigLocation");

		try {
			InputStream input = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (input == null) {
				LOGGER.error("Environment property file not found {}", kv("propertyFileName", propertyFileName));
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
			LOGGER.error("Unable initialize application", e);
		}

	}

	public void contextDestroyed(ServletContextEvent sce) {
		AddressSearchService.destroy();
		shutdownDB();
		shutdownLogback();
	}

	private void shutdownDB() {
		Enumeration<Driver> drivers = DriverManager.getDrivers();
		Driver d = null;
		while(drivers.hasMoreElements()) {
			try {
				d = drivers.nextElement();
				DriverManager.deregisterDriver(d);
			}
			catch (SQLException ex) {
				LOGGER.warn("Error deregistering sql driver {}", kv("sqlDriver", d), ex);
			}
		}

		try {
			AbandonedConnectionCleanupThread.shutdown();
		} catch (InterruptedException e) {
			LOGGER.error("Error shutting down mysql connection threads", e);
		}
	}

	private void shutdownLogback() {
		ILoggerFactory loggerContext = LoggerFactory.getILoggerFactory();
		if(loggerContext != null && loggerContext instanceof LoggerContext) {
			((LoggerContext) loggerContext).stop();
		}
	}

}