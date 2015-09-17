package com.ctm.router;

import com.ctm.providers.health.healthapply.model.response.HealthApplyResponse;
import org.apache.cxf.jaxrs.provider.RequestDispatcherProvider;

import java.util.HashMap;
import java.util.Map;

public class ApplicationDispatchProvider extends RequestDispatcherProvider {

    public ApplicationDispatchProvider() {
        super();
        final Map<String, String> resources = new HashMap<>();
        resources.put(HealthApplyResponse.class.getName(), "/ajax/json/health_application_result_ws.jsp");
        setClassResources(resources);
        final Map<String, String> beanNames = new HashMap<>();
        beanNames.put(HealthApplyResponse.class.getName(), "applyServiceResponse");
        setBeanNames(beanNames);
        setUseClassNames(false);
    }

}

