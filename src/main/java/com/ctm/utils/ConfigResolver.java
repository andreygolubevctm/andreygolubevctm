package com.ctm.utils;

import com.ctm.services.EnvironmentService;
import com.disc_au.web.go.FileUtils;

public class ConfigResolver {

    private final EnvironmentService.Environment environment;

    public ConfigResolver() {
        environment = EnvironmentService.getEnvironment();
    }

    public ConfigResolver(EnvironmentService.Environment environment) {
        this.environment = environment;
    }

    public Object getConfigUrl(String base) {
        String configUrl = base.replace(".xml", "_"+ environment.toString() + ".xml");
        if(environment.equals( EnvironmentService.Environment.PRO)) {
            return configUrl;
        } else {
            if(FileUtils.exists(configUrl)) {
                return configUrl;
            } else {
                return base;
            }
        }
    }
}
