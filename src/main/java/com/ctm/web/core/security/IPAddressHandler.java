package com.ctm.web.core.security;

import com.ctm.web.core.content.services.ConfigService;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.PageSettings;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

@Component
public class IPAddressHandler {

    protected static final String GET_X_FORWARD_CONFIG_CODE = "getIPFromXForward";
    public static final String FORWARD_FOR_HEADER = "X-FORWARDED-FOR";

    private static final Logger LOGGER = LoggerFactory.getLogger(IPAddressHandler.class);

    private final static IPAddressHandler instance = new IPAddressHandler(new ConfigService());
    private final ConfigService configService;

    @Autowired
    public IPAddressHandler(ConfigService configService) {
        this.configService = configService;
    }

    @SuppressWarnings("unused")
    @Deprecated
    public IPAddressHandler() {
        this.configService = new ConfigService();
    }

    public static IPAddressHandler getInstance() {
        return instance;
    }

    public String getIPAddress(HttpServletRequest request) {
        boolean returnFromXForward = returnFromXForward(request);
        return getIPAddress(request, returnFromXForward);
    }

    public String getIPAddress(HttpServletRequest request, PageSettings pageSettings) {
        boolean returnFromXForward = returnFromXForward(pageSettings);
        return getIPAddress(request, returnFromXForward);
    }

    public String getIPAddress(final HttpServletRequest request, final boolean returnFromXForward) {
        if (returnFromXForward) {
            String headerForwardFor = request.getHeader(FORWARD_FOR_HEADER);
            if (StringUtils.isNotBlank(headerForwardFor)) {
                // X-Forwarded-For can contain a list of IPs, with the first one being the one we want
                final String[] ips = StringUtils.split(headerForwardFor, ",", 2);
                return StringUtils.trim(ips[0]);
            } else {
                LOGGER.warn("Config " + GET_X_FORWARD_CONFIG_CODE + " is enabled but " + FORWARD_FOR_HEADER + " is empty");
                return request.getRemoteAddr();
            }
        } else {
            return request.getRemoteAddr();
        }
    }

    private boolean returnFromXForward(HttpServletRequest request) {
        try {
            return configService.getConfigValueBoolean(request, GET_X_FORWARD_CONFIG_CODE);
        } catch(DaoException | ConfigSettingException e) {
            handleFailure(e);
            return false;
        }
    }

    private boolean returnFromXForward(PageSettings pageSettings) {
        try {
            return pageSettings.getSettingAsBoolean(GET_X_FORWARD_CONFIG_CODE);
        } catch(ConfigSettingException e) {
            handleFailure(e);
            return false;
        }
    }

    private void handleFailure(Exception e) {
        LOGGER.warn("Could not get config getIPFromXForward so defaulting to false", e);
    }

}
