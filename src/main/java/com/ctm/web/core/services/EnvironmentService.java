package com.ctm.web.core.services;

import com.ctm.web.core.exceptions.EnvironmentException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.util.jar.Attributes;
import java.util.jar.Manifest;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class EnvironmentService {
	private static final Logger LOGGER = LoggerFactory.getLogger(EnvironmentService.class);

	private static Environment currentEnvironment;
	private static String buildIdentifier = "";
	private static String buildRevision = "";
	private static String contextPath = "";

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
		}
	}
	
	public enum BIGIPCookieId {
		LOCALHOST {
			public String toString() {
				return "JSESSIONID";
			}
		},
		NXI {
			public String toString() {
				return "BIGipServerPool_HTTP_AGGR_NXI_eCommerce_DISCOnline";
			}
		},
		NXQ {
			public String toString() {
				return "BIGipServerPool_HTTPS_AGGR_NXQ_eCommerce_DISCOnline";
			}
		},
		NXS {
			public String toString() {
				return "BIGipServerPool_HTTPS_AGGR_NXS_eCommerce_DISCOnline";
			}
		},
		PRO {
			public String toString() {
				return "BIGipServerPool_HTTPS_Ecommerce_DISCOnline_XS";
			}
		}
	}

	public static void setEnvironment(String envCode) throws Exception{
		for (Environment env : Environment.values()) {
			if(env.toString().equalsIgnoreCase(envCode)){
				currentEnvironment = env;
			}
		}
		if(currentEnvironment == null) throw new Exception("Unknown environment code");
		LOGGER.info("Environment set {}", kv("envCode", currentEnvironment));
	}

	public static Environment getEnvironment() throws EnvironmentException{
		if(currentEnvironment == null) throw new EnvironmentException("Environment variable not set, check the environment.properties file.");
		return currentEnvironment;
	}

	public static Environment getEnvironmentFromSpring() throws EnvironmentException{
		String envVariable = getEnvironmentProperty();
		Environment environment = null;
		for (Environment env : Environment.values()) {
			if(env.toString().equalsIgnoreCase(envVariable)){
				environment = env;
			}
		}
		if(environment == null) throw new EnvironmentException("Unknown environment code");
		LOGGER.info("Environment set {}", kv("envCode", currentEnvironment));
		return environment;
	}

	public static String getEnvironmentProperty() {
		return System.getProperty("spring.profiles.active", "localhost");
	}

	public static String getEnvironmentAsString() throws EnvironmentException{
		if(currentEnvironment == null) throw new EnvironmentException("Environment variable not set, check the environment.properties file.");
		return currentEnvironment.toString();
	}
	
	public static String getBIGIPCookieId() {
		String environment = getEnvironmentAsString().toUpperCase();
		return EnvironmentService.BIGIPCookieId.valueOf(environment).toString();
	}

	/**
	 * Whether the environment needs a brand code parameter. Typically this should be local and some test environments only.
	 * The F5 gateway should automatically add a brandCode param based on the domain name.
	 * Developers should NEVER specific a brand code param on an environment controlled by the F5 gateway!
	 */
	public static boolean needsManuallyAddedBrandCodeParam() throws EnvironmentException {
		return getEnvironment() == Environment.LOCALHOST ||
				getEnvironment() == Environment.NXI ||
				getEnvironment() == Environment.NXS ||
				getEnvironment() == Environment.NXQ;
	}

	public static boolean needsManuallyAddedBrandCodeParamWhiteLabel(String brandCode, String verticalCode) throws EnvironmentException {

		if ( brandCode != null && verticalCode != null &&  (brandCode.equalsIgnoreCase("wfdd") || brandCode.equalsIgnoreCase("bddd")) && ( verticalCode.equalsIgnoreCase("HEALTH") || verticalCode.equalsIgnoreCase("SIMPLES"))) {
			return true;
		}

		return needsManuallyAddedBrandCodeParam();
	}

	public static boolean needsManuallyAddedBrandCodeParamWhiteLabel(String brandCode) throws EnvironmentException {

		if (brandCode != null && (brandCode.equalsIgnoreCase("wfdd") || brandCode.equalsIgnoreCase("bddd"))) {
			return true;
		}

		return needsManuallyAddedBrandCodeParam();
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
			Attributes attr = manifest.getMainAttributes();

			if (attr != null) {
				StringBuffer sb = new StringBuffer();
				for (Object o : attr.keySet()) {
					Attributes.Name attrName = (Attributes.Name) o;
					String attrValue = attr.getValue(attrName);
					sb.append(attrName + "=" + attrValue + ",");
				}
				LOGGER.debug("manifest details {}", kv("properties", sb));

				if (attr.getValue("Implementation-Version") != null) {
					buildIdentifier = attr.getValue("Implementation-Version");
				}

				// Append the build timestamp to the implementation version
				if (attr.getValue("Bamboo-BuildTimestamp") != null) {
					buildIdentifier = buildIdentifier + "_" + attr.getValue("Bamboo-BuildTimestamp");
				}
				if (attr.getValue("Scm-Revision") != null) {
					buildRevision = attr.getValue("Scm-Revision");
					// Append buildRevision to build identifier
					buildIdentifier = buildIdentifier + "_" + buildRevision;
				}
			}
		}
		catch (IOException e) {
			LOGGER.error("Unable to get details from manifest", e);
		}
		finally {
			if (inputStream != null) inputStream.close();
		}

		// Set to a default if property not found in manifest
		if (buildIdentifier.equals("")) {
			buildIdentifier = "dev";
		}

		LOGGER.debug("build details {}, {}", kv("buildIdentifier", buildIdentifier), kv("revision", buildRevision));

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

	/**
	 * Get the servlet context path
	 */
	public static String getContextPath() {
		return contextPath;
	}
	public static void setContextPath(String contextPath) {
		// Move a prefix slash to the end to conform with legacy "contextFolder" configuration
		contextPath = contextPath.replaceAll("/(.+)", "$1/");

		LOGGER.debug("Context Path set {}", kv("contextPath", contextPath));
		EnvironmentService.contextPath = contextPath;
	}
}
