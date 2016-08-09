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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


/**
 * NOTE: This class will only work for endpoints which are redirected via a <jsp:forward/> tag. Cases where the endpoint is called
 * directly and that are intercepted by this class will cause an exception since the request parameters are not able to be modified.
 */
public class SpringHealthFormParamMapInInterceptor extends HandlerInterceptorAdapter {

    private static final Logger LOGGER = LoggerFactory.getLogger(SpringHealthFormParamMapInInterceptor.class);

    private static final Pattern PARAMS_WITH_NUMBER_SUFFIX = Pattern.compile("^([a-z]+)([0-9]+)$");

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response, Object handler) throws Exception {

        Map<String, String[]> params = request.getParameterMap();

        Set<String> newSet = new TreeSet<>(params.keySet());

        for (String key : newSet) {
            if(key.contains("_")) {

                StringBuilder sb = new StringBuilder();
                String dot = "";
                boolean hasBenefitsExtras = false;
                for (String s : StringUtils.split(key, "_")) {
                    sb.append(dot).append(addBracketsOfNumberedSuffix(s));
                    if (key.startsWith("health_benefits_benefitsExtras")) {
                        if (s.equals("benefitsExtras")) {
                            hasBenefitsExtras = true;
                            dot = "[";
                        } else {
                            dot = ".";
                        }
                    } else {
                        dot = ".";
                    }
                }

                if (hasBenefitsExtras) {
                    sb.append("]");
                }

                String newKey = sb.toString();

                String[] value = params.get(key);
                params.remove(key);
                params.put(newKey, value);
                LOGGER.debug("Mapped {} -> {}",kv("key",key),kv("newKey",newKey));
            }
        }
        return true;
    }

    /**
     * Replaces any value that ends with numbers with brackets on the numbers
     * @param value
     * @return
     */
    protected String addBracketsOfNumberedSuffix(String value) {
        final Matcher matcher = PARAMS_WITH_NUMBER_SUFFIX.matcher(value);
        if (matcher.matches()) {
            return matcher.group(1) + "[" + matcher.group(2) + "]";
        }
        return value;
    }
}
