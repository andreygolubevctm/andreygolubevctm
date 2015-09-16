package com.ctm.router;

import com.ctm.model.resultsData.ApplicationResultsWrapper;
import org.apache.cxf.jaxrs.provider.RequestDispatcherProvider;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class ApplicationDispatchProvider extends RequestDispatcherProvider {

    public ApplicationDispatchProvider() {
        super();
        final Map<String, String> resources = new HashMap<>();
        resources.put(ApplicationResultsWrapper.class.getName(), "/ajax/json/health_application_result_ws.jsp");
        setClassResources(resources);
        final Map<String, String> beanNames = new HashMap<>();
        beanNames.put(ApplicationResultsWrapper.class.getName(), "resultsWrapper");
        setProduceMediaTypes(Collections.singletonList("application/json"));
        setBeanNames(beanNames);
        setUseClassNames(false);
    }

}

