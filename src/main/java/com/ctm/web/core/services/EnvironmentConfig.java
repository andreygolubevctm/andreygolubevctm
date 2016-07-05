package com.ctm.web.core.services;

import com.ctm.web.core.exceptions.EnvironmentException;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class EnvironmentConfig {

	@Bean
	public static EnvironmentService.Environment environmentBean() throws EnvironmentException {
		return EnvironmentService.getEnvironmentFromSpring();
	}

}
