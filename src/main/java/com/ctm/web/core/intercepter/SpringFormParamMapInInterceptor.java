package com.ctm.web.core.intercepter;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


public class SpringFormParamMapInInterceptor extends HandlerInterceptorAdapter {

    private static final Logger LOGGER = LoggerFactory.getLogger(SpringFormParamMapInInterceptor.class);


    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response, Object handler) throws Exception {

        Map<String, String[]> params = request.getParameterMap();

        Set<String> newSet = new TreeSet<>(params.keySet());

        for (String key : newSet) {
            LOGGER.debug("Mapping {}",kv("key",key));
            if(key.contains("_")) {
                String newKey = StringUtils.replace(key, "_", ".");
                String[] value = params.get(key);
                params.remove(key);
                params.put(newKey, value);
            }
        }
        return true;
    }
}
