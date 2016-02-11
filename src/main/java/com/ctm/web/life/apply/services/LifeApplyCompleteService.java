package com.ctm.web.life.apply.services;

import com.ctm.life.apply.model.response.LifeApplyResponse;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.leadfeed.services.LeadFeedTouchService;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.services.AccessTouchService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


@Component
public class LifeApplyCompleteService {

    private static final Logger LOGGER = LoggerFactory.getLogger(LifeApplyCompleteService.class);

    private AccessTouchService accessTouchService;
    private LeadFeedTouchService leadFeedTouchService;
    private LifeSendEmailService lifeSendEmailService;

    @Autowired
    public LifeApplyCompleteService(AccessTouchService accessTouchService,
                                    LeadFeedTouchService leadFeedTouchService,
                                    LifeSendEmailService lifeSendEmailService) {
        this.accessTouchService = accessTouchService;
        this.leadFeedTouchService = leadFeedTouchService;
        this.lifeSendEmailService = lifeSendEmailService;
    }

    public void handleSuccess(Long transactionId,
                              HttpServletRequest request,
                              String emailAddress,
                              String productId,
                              LifeApplyResponse applyResponse,
                              String company) {
        if("ozicare".equals(company) && com.ctm.interfaces.common.types.Status.REGISTERED.equals(applyResponse.getResponseStatus())){
            try {
                lifeSendEmailService.sendEmail(transactionId,emailAddress, request);
            } catch (SendEmailException e) {
                LOGGER.error("Failed to send ozicare emails {}" ,kv("emailAddress",emailAddress), e);
            }
            leadFeedTouchService.recordTouch(Touch.TouchType.SOLD, productId, transactionId);
        } else {
            accessTouchService.recordTouchWithComment(transactionId, Touch.TouchType.SOLD, "lifebroker");
        }
    }
}
