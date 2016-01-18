package com.ctm.web.core.validation;

import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.request.TokenRequest;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.services.SettingsService;

import java.util.ArrayList;
import java.util.List;

public class ResultsTokenValidation<T extends TokenRequest> extends TokenValidation<T> {

    public ResultsTokenValidation(SettingsService settingsService, SessionDataService sessionDataService, Vertical vertical) {
        super(settingsService, sessionDataService , vertical);
    }


    @Override
    protected List<Touch.TouchType> getValidTouchTypes() {
        List<Touch.TouchType> validTouches = new ArrayList<>();
        validTouches.add(Touch.TouchType.NEW);
        validTouches.add(getCurrentTouch());
        return validTouches;
    }

    @Override
    protected Touch.TouchType getCurrentTouch(){
        return Touch.TouchType.PRICE_PRESENTATION;
    }

}
