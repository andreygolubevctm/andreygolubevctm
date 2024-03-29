package com.ctm.web.health.validation;

import com.ctm.web.core.model.Touch;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.SessionDataService;
import com.ctm.web.core.services.SettingsService;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


public class HealthApplicationTokenValidation extends HealthTokenValidationService {

    private static final Logger logger = LoggerFactory.getLogger(HealthApplicationTokenValidation.class.getName());

    private static final Touch.TouchType CURRENT_TOUCH = Touch.TouchType.APPLY;

    public HealthApplicationTokenValidation(SettingsService settingsService, SessionDataService sessionDataService, Vertical vertical) {
        super(settingsService, sessionDataService, vertical);
    }


    @Override
    protected List<Touch.TouchType> getValidTouchTypes() {
        List<Touch.TouchType> validTouches = new ArrayList<>();
        validTouches.add(Touch.TouchType.PRICE_PRESENTATION);
        validTouches.add(getCurrentTouch());
        return validTouches;
    }

    @Override
    protected Touch.TouchType getCurrentTouch(){
        return CURRENT_TOUCH;
    }

    public String createErrorResponse(Long transactionId, String errorMessage, HttpServletRequest request , String type) {
        String responseString = "";
        try {
            JSONObject response = new JSONObject();
            JSONObject error = new JSONObject();
            error.put("type", type);
            error.put("message", errorMessage);
            response.put("error", error);
            if(isValidToken()){
               setNewToken(response, transactionId, request);
            }
            responseString = response.toString();
        } catch (JSONException e) {
            logger.warn("Failed to create response. {}", kv("errorMessage", errorMessage) , e);
        }
        return responseString;
    }
}
