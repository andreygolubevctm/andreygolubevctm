package com.ctm.web.validation;

import com.ctm.model.Touch;
import com.ctm.model.request.TokenRequest;
import com.ctm.model.settings.Vertical;
import com.ctm.services.SessionDataService;

import java.util.ArrayList;
import java.util.List;

public class ResultsTokenValidation<T extends TokenRequest> extends TokenValidation<T> {

    public ResultsTokenValidation(SessionDataService sessionDataService, Vertical vertical) {
        super(sessionDataService , vertical);
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
