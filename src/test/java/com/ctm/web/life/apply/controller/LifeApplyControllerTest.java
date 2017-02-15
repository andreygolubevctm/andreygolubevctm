package com.ctm.web.life.apply.controller;

import com.ctm.apply.model.response.ApplyResponse;
import com.ctm.web.core.apply.exceptions.FailedToRegisterException;
import com.ctm.web.core.exceptions.ServiceException;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.test.controller.BaseControllerTest;
import com.ctm.web.life.apply.services.LifeApplyService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.powermock.modules.junit4.PowerMockRunnerDelegate;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockServletContext;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import static org.mockito.Matchers.*;
import static org.mockito.MockitoAnnotations.initMocks;
import static org.powermock.api.mockito.PowerMockito.when;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@RunWith(PowerMockRunner.class)
@PowerMockRunnerDelegate(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = MockServletContext.class)
@WebAppConfiguration
@PrepareForTest({ApplicationService.class})
public class LifeApplyControllerTest extends BaseControllerTest {

    @Mock
    LifeApplyService service;

    @InjectMocks
    LifeApplyController controllerUnderTest;

    private Long transactionId = 100000L;

    @Mock
    private ApplyResponse applyResponse;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        setUp(controllerUnderTest);
    }

    @Test
    public void apply() throws Exception {
        mvc.perform(
                MockMvcRequestBuilders
                        .post("/rest/life/apply/apply.json")
                        .param("request_type", "REQUEST-CALL")
                        .param("client_product_id", "bc3f3836157efd5b2ecd80b2614ff04897d76c74")
                        .param("partner_product_id", "c5e560a26d8fafbe313acc1988eb4e139430045e")
                        .param("api_ref:", "c4aa7ccb59f5a461039f10")
                        .param("vertical", "life")
                        .param("partner_quote", "Y")
                        .param("transactionId", transactionId.toString())
                        .param("company", "AIA Australia")
                        .param("partnerBrand", "AIA Australia")
                        .accept(MediaType.ALL)
                        .contentType(MediaType.APPLICATION_FORM_URLENCODED_VALUE)
        )
                .andExpect(status().isOk());

    }

    @Test
    public void applyServiceRequestException() throws Exception {
        ServiceException e = new ServiceException("" , null);
        when(service.apply(anyObject() ,anyObject(), anyObject())).thenThrow(e);
        mvc.perform(
                MockMvcRequestBuilders
                        .post("/rest/life/apply/apply.json")
                        .param("request_type", "REQUEST-CALL")
                        .param("client_product_id", "bc3f3836157efd5b2ecd80b2614ff04897d76c74")
                        .param("partner_product_id", "c5e560a26d8fafbe313acc1988eb4e139430045e")
                        .param("api_ref:", "c4aa7ccb59f5a461039f10")
                        .param("vertical", "life")
                        .param("partner_quote", "Y")
                        .param("transactionId", transactionId.toString())
                        .param("company", "AIA Australia")
                        .param("partnerBrand", "AIA Australia")
                        .accept(MediaType.ALL)
                        .contentType(MediaType.APPLICATION_FORM_URLENCODED_VALUE)
        )
                .andExpect(status().is5xxServerError());

    }

    @Test
    public void applyFailedToRegisterException() throws Exception {
        FailedToRegisterException e = new FailedToRegisterException( applyResponse,  transactionId);
        when(service.apply(anyObject() ,anyObject(), anyObject())).thenThrow(e);
        mvc.perform(
                MockMvcRequestBuilders
                        .post("/rest/life/apply/apply.json")
                        .param("request_type", "REQUEST-CALL")
                        .param("client_product_id", "bc3f3836157efd5b2ecd80b2614ff04897d76c74")
                        .param("partner_product_id", "c5e560a26d8fafbe313acc1988eb4e139430045e")
                        .param("api_ref:", "c4aa7ccb59f5a461039f10")
                        .param("vertical", "life")
                        .param("partner_quote", "Y")
                        .param("transactionId", transactionId.toString())
                        .param("company", "AIA Australia")
                        .param("partnerBrand", "AIA Australia")
                        .accept(MediaType.ALL)
                        .contentType(MediaType.APPLICATION_FORM_URLENCODED_VALUE)
        )
                .andExpect(status().is5xxServerError());

    }
}