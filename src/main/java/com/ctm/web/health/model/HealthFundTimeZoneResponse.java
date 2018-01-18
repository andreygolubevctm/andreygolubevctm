package com.ctm.web.health.model;

import com.fasterxml.jackson.annotation.JsonAutoDetect;

/**
 * Created by msmerdon on 27/11/2017.
 */
@JsonAutoDetect(fieldVisibility= JsonAutoDetect.Visibility.ANY)
public class HealthFundTimeZoneResponse {

    private String timezone;
    private boolean application;
    private boolean submit;

    public HealthFundTimeZoneResponse(String timezone, boolean application, boolean submit) {
        this.timezone = timezone;
        this.application = application;
        this.submit = submit;
    }
}
