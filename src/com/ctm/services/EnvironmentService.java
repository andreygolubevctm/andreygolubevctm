package com.ctm.services;

import org.apache.log4j.Logger;

import com.ctm.data.exceptions.EnvironmentException;

public class EnvironmentService {

	private static Logger logger = Logger.getLogger(SessionDataService.class.getName());

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

	public static Environment getEnvironment() throws Exception{
		if(currentEnvironment == null) throw new EnvironmentException("Environment variable not set, check the environment.properties file.");
		return currentEnvironment;
	}

	public static String getEnvironmentAsString() throws Exception{
		if(currentEnvironment == null) throw new EnvironmentException("Environment variable not set, check the environment.properties file.");
		return currentEnvironment.toString();
	}
}
