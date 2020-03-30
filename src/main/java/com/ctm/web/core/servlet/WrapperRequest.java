package com.ctm.web.core.servlet;

import org.apache.commons.collections.iterators.IteratorEnumeration;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * This wrapper has been created to cater for functionality whereby, previously, an interceptor used to modify certain
 * param names in the request parameter map (it removed the old names and added the new names).
 *
 * The functions responsible for returning the request parameter map, as well as individual params and their values
 * appear to provide additional functionality as well - it is not simply dumb getters that return member variables.
 *
 * In order to cater for the aforementioned extra functionality, I call the super class' methods where applicable.
 * Refer to each method below for an explanation.
 */
public class WrapperRequest extends HttpServletRequestWrapper {
    private Map<String, String[]> modifiedParams = new HashMap<>();

    public WrapperRequest(final ServletRequest request, Map<String,String[]> changedParams) {
        super((HttpServletRequest) request);
        modifiedParams.putAll(changedParams);
    }

    @Override
    public void setRequest(ServletRequest request) {
        super.setRequest(request);
    }

    @Override
    public String getParameter(String paramName) {
        String[] values = getParameterValues(paramName);
        return values != null && values.length != 0 ? values[0] : null;
    }

    @Override
    public String[] getParameterValues(String paramName) {
        String[] values = modifiedParams.get(paramName);
        // if the local modified param map doesn't contain the parameter, check the super class.
        return values !=null && values.length != 0 ? values : super.getParameterValues(paramName);
    }

    @Override
    public Map<String,String[]> getParameterMap() {
        // create a map containing all params (modified and original super class' params)
        // order is important. Modified params should take precedence where applicable
        HashMap<String, String[]> allParams = new HashMap<>();
        allParams.putAll(super.getParameterMap());
        allParams.putAll(modifiedParams);

        return allParams;
    }

    @Override
    public Enumeration<String> getParameterNames() {
        // create a map containing all params (modified and original super class' params)
        // order is important. Modified params should take precedence where applicable
        HashMap<String, String[]> allParams = new HashMap<>();
        allParams.putAll(super.getParameterMap());
        allParams.putAll(modifiedParams);
        return new IteratorEnumeration(allParams.keySet().iterator());
    }
}