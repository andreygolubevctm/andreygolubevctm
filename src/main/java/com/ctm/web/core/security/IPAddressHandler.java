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
import java.util.List;
import java.util.Arrays;

@Component
public class IPAddressHandler {

    protected static final String GET_X_FORWARD_CONFIG_CODE = "getIPFromXForward";
    public static final String FORWARD_FOR_HEADER = "X-FORWARDED-FOR";

    private static final Logger LOGGER = LoggerFactory.getLogger(IPAddressHandler.class);

    private final static IPAddressHandler instance = new IPAddressHandler(new ConfigService());
    private final static String CIDR = "202.56.60.0/23";
    private static int MIN_IP_ADDR = 0;
    private static int MAX_IP_ADDR = 0;
	List<String> localIps = Arrays.asList("127.0.0.1", "0.0.0.0", "0:0:0:0:0:0:0:1");
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

    public boolean isLocalRequest(HttpServletRequest request) {
        String ip = getIPAddress(request);
        return ipIsValid(ip) && (isLocalIP(ip) || isIPInRange(ip));
    }

	public boolean isIPInRange(String ipStr) {
		setMinMaxIPs();
		int ip = getIPAsInt(ipStr);
		return ip > 0 && (isLocalIP(ipStr) || (ip >= MIN_IP_ADDR && ip <= MAX_IP_ADDR));
	}

    public boolean isLocalIP(String ip) {
    	return ip.startsWith("192.168.") || localIps.stream().anyMatch(ips -> ips.equals(ip));
	}

    public int getIPAsInt(String ipStr) {
    	if(ipIsValid(ipStr)) {
			int[] ip = new int[4];
			String[] parts = ipStr.split("\\.");
			for (int i = 0; i < 4; i++) {
				ip[i] = Integer.parseInt(parts[i]);
			}
			return ((ip[0] << 24) & 0xFF000000)
					| ((ip[1] << 16) & 0xFF0000)
					| ((ip[2] << 8) & 0xFF00)
					| (ip[3] & 0xFF);
		} else {
    		return 01;
		}
	}

	private boolean ipIsValid(String ip) {
    	return ip.matches("^(\\d{1,3}\\.){3}(\\d{1,3})$");
	}

	private void setMinMaxIPs() {
		if(MIN_IP_ADDR == 0 || MAX_IP_ADDR == 0) {
			String ip = CIDR.split("/")[0];
			int range = Integer.valueOf(CIDR.split("/")[1]);
			int addr = getIPAsInt(ip);
			int mask = (-1) << (32 - range);
			MIN_IP_ADDR = addr & mask;
			MAX_IP_ADDR = MIN_IP_ADDR + (~mask);
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
