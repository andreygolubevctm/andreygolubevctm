package com.ctm.model;

import com.ctm.exceptions.ConfigSettingException;
import com.ctm.model.settings.PageSettings;

public class IpAddress {

    public enum IpCheckRole {
        TEMPORARY_USER("T", 999999), // default to no restriction, set only to a value in PROD using "blockUserAfterXRequestsFromIP" configuration option.
        ADMIN_USER("A", 999999),
        BANNED_USER("P", 0), //perma ban
        EDITOR_USER ("E", 100);

        private final String code;
        private final int limit;

        IpCheckRole(String code, int limit) {
            this.code = code;
            this.limit = limit;
        }

        public String getCode() {
            return code;
        }

        /**
         *
         * @param pageSettings
         * @return
         */
        public int getLimit(PageSettings pageSettings) {
            if(code.equals(IpCheckRole.TEMPORARY_USER.getCode()) &&
                    pageSettings.hasSetting("blockUserAfterXRequestsFromIP")) {
                try {
                    return pageSettings.getSettingAsInt("blockUserAfterXRequestsFromIP");
                } catch (ConfigSettingException e) {
                    // fall through to default limit
                }
            }
            return limit;
        }

        public static IpCheckRole findByCode(String code) {
            for (IpCheckRole ipCheckRole : IpCheckRole.values()) {
                if (code.equals(ipCheckRole.getCode())) {
                    return ipCheckRole;
                }
            }
            return null;
        }

    }

    private long ipStart;
    private long ipEnd;
    private String service;
    private IpCheckRole role = IpCheckRole.TEMPORARY_USER;
    private int numberOfHits = 0;
    private int styleCodeId;

    public IpAddress(long ipStart, long ipEnd, String service, IpCheckRole role, int numberOfHits, int styleCodeId) {
        this.ipStart = ipStart;
        this.ipEnd = ipEnd;
        this.service = service;
        this.role = role;
        this.numberOfHits = numberOfHits;
        this.styleCodeId = styleCodeId;
    }

    public long getIpStart() {
        return ipStart;
    }

    public void setIpStart(int ipStart) {
        this.ipStart = ipStart;
    }

    public long getIpEnd() {
        return ipEnd;
    }

    public void setIpEnd(int ipEnd) {
        this.ipEnd = ipEnd;
    }

    public String getService() {
        return service;
    }

    public void setService(String service) {
        this.service = service;
    }

    public IpCheckRole getRole() {
        return role;
    }

    public void setRole(IpCheckRole role) {
        this.role = role;
    }

    public int getNumberOfHits() {
        return numberOfHits;
    }

    public void setNumberOfHits(int numberOfHits) {
        this.numberOfHits = numberOfHits;
    }

    public int getStyleCodeId() {
        return styleCodeId;
    }

    public void setStyleCodeId(int styleCodeId) {
        this.styleCodeId = styleCodeId;
    }

    public String toString(){
        return "IpAddress:{" +
                "service:'"+service+"'" +
                ",role:'"+role+"'" +
                ",numberOfHits:'"+numberOfHits+"'" +
                ",ipStart:'"+ipStart+"'" +
                ",ipEnd:'"+ipEnd+"'" +
                "}";
    }


}
