package com.ctm.listeners;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Properties;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.apache.log4j.Logger;
import org.slf4j.ILoggerFactory;
import org.slf4j.LoggerFactory;

import ch.qos.logback.classic.LoggerContext;

import com.ctm.services.ApplicationService;
import com.ctm.services.EnvironmentService;
import com.ctm.services.elasticsearch.AddressSearchService;
import com.mysql.jdbc.AbandonedConnectionCleanupThread;

/** adding this to debug threads **/

@WebListener()
public class ContextFinalizer implements ServletContextListener {

	Logger logger = Logger.getLogger(ContextFinalizer.class.getName());

	public void contextInitialized(ServletContextEvent sce) {

		Properties properties = new Properties();
		String propertyFileName = sce.getServletContext().getInitParameter("environmentConfigLocation");

		try {
			InputStream input = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (input == null) {
				logger.error("Sorry, unable to find " + propertyFileName);
				return;
			}
			properties.load(input);

			// Initialise the CTM environment and application objects
			String envVariable = (String) properties.get("environment");
			EnvironmentService.setEnvironment(envVariable);
			ApplicationService.getBrands();

			EnvironmentService environmentService = new EnvironmentService();
			environmentService.getBuildDetailsFromManifest(sce.getServletContext());

			AddressSearchService.init();
		}
		catch (IOException e) {
			logger.error(e);
		}
		catch (Exception e) {
			logger.error(e);
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
			logger.error(e);
		}


	}

}