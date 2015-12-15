package com.ctm.web.energy.apply.services;

import com.ctm.apply.model.response.ApplyResponse;
import com.ctm.interfaces.common.types.ConfirmationId;
import com.ctm.web.core.confirmation.services.ConfirmationService;
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

import static org.mockito.Matchers.anyObject;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@RunWith(MockitoJUnitRunner.class)
@SpringApplicationConfiguration(classes = {EnergyApplyConfirmation.class})
@ActiveProfiles("test")
@Component
public class EnergyApplyConfirmationTest {


    @Mock
    private ConfirmationService confirmationService;
    @Mock
    private EnergyApplyPostRequestPayload model;
    @Mock
    private EnergyApplyServiceRequestAdapter requestAdapter;
    @Mock
    private ApplyResponse applyResponse;

    @InjectMocks
    private EnergyApplyConfirmation energyApplyConfirmation;

    private ConfirmationId confirmationId = ConfirmationId.instanceOf("confirmationId");

    @Before
    public void setup(){
        when(applyResponse.getConfirmationId()).thenReturn(confirmationId);
    }

    @Test
    public void testCreateAndSaveConfirmation() throws Exception {
        String sessionId = "SESSION_ID";
        energyApplyConfirmation.createAndSaveConfirmation( sessionId,  model,
                 applyResponse,  requestAdapter);
        verify(confirmationService).addConfirmation(anyObject());
    }
}