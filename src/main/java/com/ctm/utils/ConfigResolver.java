package com.ctm.utils;

import com.ctm.services.EnvironmentService;

public class ConfigResolver {

    private final EnvironmentService.Environment environment;

    public ConfigResolver() {
        environment = EnvironmentService.getEnvironment();
    }

    public ConfigResolver(EnvironmentService.Environment environment) {
        this.environment = environment;
    }

    public Object getConfigUrl(String base) {
        if(environment.equals( EnvironmentService.Environment.PRO)) {
            return base.replace(".xml", "_PRO.xml");
        } else {
            return base;
        }
    }
}
