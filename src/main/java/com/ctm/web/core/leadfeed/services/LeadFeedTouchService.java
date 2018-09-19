package com.ctm.web.core.leadfeed.services;

import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.services.AccessTouchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class LeadFeedTouchService {

    private AccessTouchService touchService;

    @Autowired
    public LeadFeedTouchService(AccessTouchService touchService){
        this.touchService = touchService;
    }

    public Boolean recordTouch(Touch.TouchType touchType, LeadFeedData leadData) {
        return recordTouch( touchType, leadData.getProductId(), leadData.getTransactionId());
    }

    public Boolean recordTouch(Touch.TouchType touchType, String productId, Long transactionId) {

        if(!productId.isEmpty())
            return touchService.recordTouchWithProductCode(transactionId, touchType.getCode(), Touch.ONLINE_USER, productId);
        else
            return touchService.recordTouch(transactionId, touchType.getCode(), Touch.ONLINE_USER);
    }

    public Boolean updateTouch(Touch.TouchType touchType, Long transactionId) {
        try {
            touchService.updateTouch(transactionId, touchType);
        } catch(Exception e){
            return false;
        }
        return true;

    }
}
