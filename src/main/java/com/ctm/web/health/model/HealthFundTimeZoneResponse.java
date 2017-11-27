package com.ctm.web.health.model;

import com.fasterxml.jackson.annotation.JsonAutoDetect;

/**
 * Created by msmerdon on 27/11/2017.
 */
@JsonAutoDetect(fieldVisibility= JsonAutoDetect.Visibility.ANY)
public class HealthFundTimeZoneResponse {

    private boolean application;
    private boolean submit;

    public HealthFundTimeZoneResponse(boolean application, boolean submit) {
        this.application = application;
        this.submit = submit;
    }
}
