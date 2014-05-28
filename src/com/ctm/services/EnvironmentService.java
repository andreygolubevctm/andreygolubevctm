package com.ctm.services;

import org.apache.log4j.Logger;

import com.ctm.exceptions.EnvironmentException;

public class EnvironmentService {

	private static Logger logger = Logger.getLogger(EnvironmentService.class.getName());

	private static Environment currentEnvironment;

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
		if(getEnvironment() == Environment.LOCALHOST || getEnvironment() == Environment.NXI || getEnvironment() == Environment.NXS || getEnvironment() == Environment.NXQ){
			return true;
		}
		return false;
	}
}
