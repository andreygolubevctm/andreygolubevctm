package com.ctm.web.life.apply.services;

import com.ctm.interfaces.common.types.Status;
import com.ctm.life.apply.model.response.LifeApplyResponse;
import com.ctm.web.core.leadfeed.services.LeadFeedTouchService;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.services.AccessTouchService;
import com.ctm.web.life.apply.adapter.OzicareApplyServiceRequestAdapter;
import com.ctm.web.life.form.model.LifeQuote;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import javax.servlet.http.HttpServletRequest;

import static org.mockito.Mockito.verify;
import static org.mockito.MockitoAnnotations.initMocks;

public class LifeApplyCompleteServiceTest {

    @Mock
    private LeadFeedTouchService leadFeedTouchService;
    @Mock
    private AccessTouchService accessTouchService;
    @Mock
    private LifeSendEmailService lifeSendEmailService;

    @Mock
    private HttpServletRequest request;
    @Mock
    private LifeQuote lifeQuoteRequest;
    @Mock
    private OzicareApplyServiceRequestAdapter requestAdapter;

    private LifeApplyResponse applyResponse;
    private LifeApplyCompleteService service;
    private Long transactionId = 10000L;
    private String emailAddress = "emailAddress";
    private String productId = "productId";
    private boolean isOzicare = true;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        service = new LifeApplyCompleteService( accessTouchService,
                 leadFeedTouchService,
                 lifeSendEmailService);
        applyResponse = new LifeApplyResponse.Builder().responseStatus(Status.REGISTERED).build();

    }

    @Test
    public void testHandleSuccessOzicare() throws Exception {
        service.handleSuccess(  transactionId,
                 request,
                 emailAddress,
                 productId,
                applyResponse,
                isOzicare);
        verify( leadFeedTouchService).recordTouch(Touch.TouchType.SOLD, productId, transactionId);
    }
}