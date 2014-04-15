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

import org.apache.log4j.Logger;

import com.ctm.services.ApplicationService;
import com.ctm.services.EnvironmentService;
import com.mysql.jdbc.AbandonedConnectionCleanupThread;

/** adding this to debug threads **/

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
			String envVariable = (String) properties.get("environment");
			EnvironmentService.setEnvironment(envVariable);
			ApplicationService.getBrands();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public void contextDestroyed(ServletContextEvent sce) {
		Enumeration<Driver> drivers = DriverManager.getDrivers();
		Driver d = null;
		while(drivers.hasMoreElements()) {
			try {
				d = drivers.nextElement();
				DriverManager.deregisterDriver(d);
			} catch (SQLException ex) {
				logger.warn(String.format("Error deregistering driver %s", d), ex);
			}
		}
		try {
			AbandonedConnectionCleanupThread.shutdown();
		} catch (InterruptedException e) {
			logger.error(e);
		}


	}

}