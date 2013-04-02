/**  =========================================== */
/**  ===  AIH Compare The Market Aggregator  === */
/**  ISeriesConfig class: Determine iSeries connection details
 *   $Id$
 * (c)2012 Australian Insurance Holdings Pty Ltd */

package com.disc_au.web;

import java.util.Hashtable;

import javax.servlet.ServletContext;


/**
 * Determine iSeries connection details for various DISC call uses.
 * @author xplooy
 * @version 1.0
 *
 */
public class ISeriesConfig {

	private static final String ENV_PREFIX = "AIH_ISERIES_";
	private static final String ENV_DEFAULT_FEATURE= "_DEFAULT";

	/**
	 * Retrieve an iSeries connection string environment variable in the form of: (prefix)[(appCode)_][(brandingCode)_](feature)
	 *   or if a branding code is provided but no matching environment variable is found,
	 *   the process will then match the form of: (prefix)[(appCode)_](feature) as a fallback.
	 * If (feature) is not provided, "_DEFAULT" is used.
	 * @param appCode       The application code to be used in the environment variable name
	 * @param brandingCode  The branding code to be used in the environment variable name
	 * @param feature       The feature suffix to be used in the environment variable name
	 * @return              Hashtable of the iSeries server name and port from the matching environment variable (if found, otherwise null)
	 */
	public static Hashtable<String, String> getEnvironmentConfig(String appCode, String brandingCode, String feature) {
		boolean hasBranding = false;

		// Build environment variable string in the form of: (prefix)[(appCode)_][(brandingCode)_](feature)
		StringBuffer envVar = new StringBuffer(ENV_PREFIX);

		if ( appCode != null && appCode.length() > 0 ) {
			envVar.append(appCode.toUpperCase()).append("_");
		}

		if ( brandingCode != null && brandingCode.length() > 0 ) {
			hasBranding = true;
			envVar.append(brandingCode.toUpperCase()).append("_");
		}

		// Use default feature string if none provided
		if ( feature == null || feature.length() == 0 ) {
			feature = ENV_DEFAULT_FEATURE;
		}

		// Finalise environment variable string and check for its presence in the server environment
		String envVarFinal = envVar.append(feature.toUpperCase()).toString();
		String envValue = System.getenv(envVarFinal);
System.out.println("Testing for environment variable: " + envVarFinal + " / " + envValue);

		if ( envValue != null && envValue.matches("[a-zA-Z0-9]+:[1-9][0-9]*") ) {
			// Variable matched from server environment and in valid format "server:port"; build output hashtable
			String[] connectionArray = envValue.split(":");
			Hashtable<String, String> connectionInfo = new Hashtable<String, String>();
			connectionInfo.put("serverName", connectionArray[0]);
			connectionInfo.put("serverPort", connectionArray[1]);
			System.out.println("ISeriesConfig: Using connection info from environment variable " + envVar + ": server " + connectionInfo.get("serverName") + ", port " + connectionInfo.get("serverPort"));

			// Happy Happy Happy! Joy Joy Joy!
			return connectionInfo;
		} else {
			if ( hasBranding ) {
				// Fallback: try again, but without the branding code
				return getEnvironmentConfig(appCode, "", feature);
			}
		}

		// What a senseless waste of human life. (no match, return null)
		System.out.println("ISeriesConfig: No match for environment variable " + envVar);
		return null;
	}

	/**
	 * Retrieve an iSeries connection string environment variable in the form of: (prefix)[(appCode)_][(brandingCode)_](feature)
	 *   or if a branding code is provided but no matching environment variable is found,
	 *   the process will then match the form of: (prefix)[(appCode)_](feature) as a fallback.
	 * If (feature) is not provided, "_DEFAULT" is used.
	 * @param context       The ServletContext object as defined by the calling class
	 * @param brandingCode  The branding code to be used in the environment variable name
	 * @param feature       The feature suffix to be used in the environment variable name
	 * @return              Hashtable of the iSeries server name and port from the matching environment variable (if found, otherwise null)
	 */
	public static Hashtable<String, String> getEnvironmentConfig(ServletContext context, String brandingCode, String feature) {
		return getEnvironmentConfig(context.getInitParameter("iSeriesEnvAppPrefix"), brandingCode, feature);
	}

	/**
	 * Retrieve an iSeries connection string environment variable in the form of: (prefix)[(appCode)_](feature).
	 * If (feature) is not provided, "_DEFAULT" is used.
	 * @param context   The ServletContext object as defined by the calling class
	 * @param feature   The feature suffix to be used in the environment variable name
	 * @return          Hashtable of the iSeries server name and port from the matching environment variable (if found, otherwise null)
	 */
	public static Hashtable<String, String> getEnvironmentConfig(ServletContext context, String feature) {
		return getEnvironmentConfig(context, "", feature);
	}

	/**
	 * Retrieve an iSeries connection string environment variable in the form of: (prefix)[(appCode)_](defaultFeature).
	 * @param context   The ServletContext object as defined by the calling class
	 * @return          Hashtable of the iSeries server name and port from the matching environment variable (if found, otherwise null)
	 */
	public static Hashtable<String, String> getEnvironmentConfig(ServletContext context) {
		return getEnvironmentConfig(context, "", "");
	}

	/**
	 * Retrieve an iSeries connection string environment variable in the form of: (prefix)[(appCode)_](feature).
	 * If (feature) is not provided, "_DEFAULT" is used.
	 * @param appCode   The application code to be used in the environment variable name
	 * @param feature   The feature suffix to be used in the environment variable name
	 * @return          Hashtable of the iSeries server name and port from the matching environment variable (if found, otherwise null)
	 */
	public static Hashtable<String, String> getEnvironmentConfig(String appCode, String feature) {
		return getEnvironmentConfig(appCode, "", feature);
	}

	/**
	 * Retrieve an iSeries connection string environment variable in the form of: (prefix)[(appCode)_](defaultFeature).
	 * @param appCode   The application code to be used in the environment variable name
	 * @return          Hashtable of the iSeries server name and port from the matching environment variable (if found, otherwise null)
	 */
	public static Hashtable<String, String> getEnvironmentConfig(String appCode) {
		return getEnvironmentConfig(appCode, "", "");
	}

	/**
	 * Retrieve an iSeries connection string environment variable in the form of: (prefix)(defaultFeature).
	 * @return  Hashtable of the iSeries server name and port from the matching environment variable (if found, otherwise null)
	 */
	public static Hashtable<String, String> getEnvironmentConfig() {
		return getEnvironmentConfig("", "", "");
	}
}
