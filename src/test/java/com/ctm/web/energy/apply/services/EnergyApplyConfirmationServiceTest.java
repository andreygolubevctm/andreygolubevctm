package com.ctm.web.energy.apply.services;

import com.ctm.apply.model.response.ApplyResponse;
import com.ctm.interfaces.common.types.ConfirmationId;
import com.ctm.web.core.confirmation.services.ConfirmationService;
import com.ctm.web.core.services.TouchService;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.energy.apply.adapter.EnergyApplyServiceRequestAdapter;
import com.ctm.web.energy.apply.model.request.EnergyApplyPostRequestPayload;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.stereotype.Component;
import org.springframework.test.context.ActiveProfiles;

import java.util.Optional;

import static org.mockito.Matchers.anyLong;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@RunWith(MockitoJUnitRunner.class)
@SpringApplicationConfiguration(classes = {EnergyApplyConfirmationService.class})
@ActiveProfiles("test")
@Component
public class EnergyApplyConfirmationServiceTest {


    @Mock
    TouchService touchService;

    @Mock
    private TransactionDao transactionDao;
    @Mock
    private ConfirmationService confirmationService;
    @Mock
    private EnergyApplyPostRequestPayload model;
    @Mock
    private EnergyApplyServiceRequestAdapter requestAdapter;
    @Mock
    private ApplyResponse applyResponse;

    @InjectMocks
    private EnergyApplyConfirmationService energyApplyConfirmation;

    private ConfirmationId confirmationId = ConfirmationId.instanceOf("confirmationId");

    @Before
    public void setup() throws Exception {
        when(applyResponse.getConfirmationId()).thenReturn(confirmationId);
        when(confirmationService.getConfirmationByKeyAndTransactionId(anyObject() , anyLong())).thenReturn(Optional.empty());
        when(transactionDao.getRootIdOfTransactionId(anyLong())).thenReturn(1000L);

    }

    @Test
    public void testCreateAndSaveConfirmation() throws Exception {
        String sessionId = "SESSION_ID";
        energyApplyConfirmation.createAndSaveConfirmation( sessionId,  model,
                 applyResponse,  requestAdapter);
        verify(confirmationService).addConfirmation(anyObject());
    }
}