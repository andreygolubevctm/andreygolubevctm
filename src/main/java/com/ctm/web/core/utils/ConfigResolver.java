package com.ctm.web.core.utils;

import com.ctm.web.core.services.EnvironmentService;
import org.apache.commons.io.IOUtils;

import javax.servlet.ServletContext;
import java.io.IOException;
import java.io.InputStream;

public class ConfigResolver {

    private final EnvironmentService.Environment environment;

    public ConfigResolver() {
        environment = EnvironmentService.getEnvironment();
    }

    public ConfigResolver(EnvironmentService.Environment environment) {
        this.environment = environment;
    }

    public String getConfig(ServletContext sc, String base) throws IOException {
        InputStream resource = null;
        try {
            String configUrl = base.replace(".xml", "_" + environment.toString() + ".xml");
            resource = sc.getResourceAsStream(configUrl);
            if (resource == null) {
                resource = sc.getResourceAsStream(base);
            }
            String config = IOUtils.toString(
                    resource,
                    "UTF-8"
            );
            return config;
        }  finally {
            if (resource != null){
                resource.close();
            }
        }
    }
}
