package com.ctm.web.validation;

import com.ctm.model.Touch;
import com.ctm.model.request.TokenRequest;
import com.ctm.services.SessionDataService;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

public class ResultsTokenValidation<T extends TokenRequest> extends TokenValidation<T> {

    public ResultsTokenValidation(SessionDataService sessionDataService) {
        super(sessionDataService );
    }


    @Override
    protected List<Touch.TouchType> getValidTouchTypes() {
        List<Touch.TouchType> validTouches = new ArrayList<>();
        validTouches.add(Touch.TouchType.NEW);
        validTouches.add(getCurrentTouch());
        return validTouches;
    }

    @Override
    protected int getMinimumSeconds(HttpServletRequest request) {
        return 2;
    }

    @Override
    protected Touch.TouchType getCurrentTouch(){
        return Touch.TouchType.PRICE_PRESENTATION;
    }
}
