package com.ctm.web.core.filter;

import com.ctm.web.core.servlet.WrapperRequest;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


@WebFilter(
        urlPatterns = { "/ajax/json/travel_quote_results.jsp",
                        "/ajax/json/health_quote_results_ws.jsp",
                        "/ajax/json/health_application_ws.jsp",
                        "/ajax/json/home_results_ws.jsp"},
        asyncSupported = true
)
public class SpringFormParamMapFilter implements Filter {

    private static final Logger LOGGER = LoggerFactory.getLogger(SpringFormParamMapFilter.class);

    private static final Pattern PARAMS_WITH_NUMBER_SUFFIX = Pattern.compile("^([a-z]+)([0-9]+)$");



    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        LOGGER.info("Initialising SpringFormParamMapFilter");
    }

    @Override
    public void doFilter(final ServletRequest servletRequest,
                         final ServletResponse servletResponse,
                         final FilterChain filterChain) throws IOException, ServletException {
        if (servletRequest instanceof HttpServletRequest) {
            Map<String, String[]> params = new HashMap<>();

            for (Map.Entry<String,String[]> entry : servletRequest.getParameterMap().entrySet()) {
                // Strings are immutable objects, so deep copies are created by default.
                params.put(entry.getKey(),entry.getValue());
            }

            Set<String> newSet = new TreeSet<>(params.keySet());

            for (String key : newSet) {
                if (key.contains("_")) {

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
                    LOGGER.debug("Mapped {} -> {}", kv("key", key), kv("newKey", newKey));
                }
            }

            WrapperRequest newReq = new WrapperRequest(servletRequest,params);

            filterChain.doFilter(newReq, servletResponse);
        } else {
            filterChain.doFilter(servletRequest,servletResponse);
        }
    }

    @Override
    public void destroy() {
        LOGGER.info("SpringFormParamMapFilter  destroyed");
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
