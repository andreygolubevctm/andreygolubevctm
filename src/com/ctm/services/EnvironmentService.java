package com.ctm.services;

import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;
import java.util.jar.Attributes;
import java.util.jar.Manifest;

import org.apache.log4j.Logger;

import com.ctm.exceptions.EnvironmentException;

public class EnvironmentService {
	private static Logger logger = Logger.getLogger(EnvironmentService.class.getName());

	private static Environment currentEnvironment;
	private static String buildIdentifier = "";
	private static String buildRevision = "";

	public enum Environment {
		LOCALHOST {
			public String toString() {
				return "localhost";
			}
		},
		NXI{
			public String toString() {
				return "NXI";
			}
		},
		NXQ{
			public String toString() {
				return "NXQ";
			}
		},
		NXS{
			public String toString() {
				return "NXS";
			}
		},
		PRO{
			public String toString() {
				return "PRO";
			}
		};
	}

	public static void setEnvironment(String envCode) throws Exception{
		for (Environment env : Environment.values()) {
			if(env.toString().equalsIgnoreCase(envCode)){
				currentEnvironment = env;
			}
		}
		if(currentEnvironment == null) throw new Exception("Unknown environment code");
		logger.info("Environment set to "+currentEnvironment.toString());
	}

	public static Environment getEnvironment() throws EnvironmentException{
		if(currentEnvironment == null) throw new EnvironmentException("Environment variable not set, check the environment.properties file.");
		return currentEnvironment;
	}

	public static String getEnvironmentAsString() throws EnvironmentException{
		if(currentEnvironment == null) throw new EnvironmentException("Environment variable not set, check the environment.properties file.");
		return currentEnvironment.toString();
	}

	/**
	 * Whether the environment needs a brand code parameter. Typically this should be local and some test environments only.
	 * The F5 gateway should automatically add a brandCode param based on the domain name.
	 * Developers should NEVER specific a brand code param on an environment controlled by the F5 gateway!
	 *
	 * @return
	 * @throws Exception
	 */
	public static boolean needsManuallyAddedBrandCodeParam() throws EnvironmentException {
		return getEnvironment() == Environment.LOCALHOST || 
				getEnvironment() == Environment.NXI || 
				getEnvironment() == Environment.NXS || 
				getEnvironment() == Environment.NXQ;
		}

	/**
	 * Load the WAR's manifest.mf file, collect the Identifier property.
	 *
	 * @return buildIdentifier
	 * @throws IOException
	 */
	public String getBuildDetailsFromManifest(javax.servlet.ServletContext servletContext) throws IOException {
		InputStream inputStream = null;
		try {
			inputStream = servletContext.getResourceAsStream("/META-INF/MANIFEST.MF");
			Manifest manifest = new Manifest(inputStream);

			// Get the manifest attributes for our section as defined in Ant's build.xml
			Attributes attr = manifest.getAttributes("AGH-Build");

			if (attr != null) {
				for (Iterator<?> it = attr.keySet().iterator(); it.hasNext();) {
				Attributes.Name attrName = (Attributes.Name) it.next();
				String attrValue = attr.getValue(attrName);
				logger.debug("    " + attrName + ": " + attrValue);
			}

				if (attr.getValue("Identifier") != null) {
					buildIdentifier = attr.getValue("Identifier");
				}
				if (attr.getValue("Revision") != null) {
					buildRevision = attr.getValue("Revision");
				}
			}
		}
		catch (IOException e) {
			logger.error(e);
		}
		finally {
			if (inputStream != null) inputStream.close();
		}

		// Set to a default if property not found in manifest
		if (buildIdentifier.equals("")) {
			buildIdentifier = "dev";
		}

		logger.debug("buildIdentifier: " + buildIdentifier + ", revision: " + buildRevision);

		return buildIdentifier;
	}

	/**
	 * Get the JAR's build identifier.
	 * @return buildIdentifier
	 */
	public static String getBuildIdentifier() {
		return buildIdentifier;
	}

	/**
	 * Get the JAR's SCM revision.
	 * @return buildRevision
	 */
	public static String getBuildRevision() {
		return buildRevision;
	}

}
