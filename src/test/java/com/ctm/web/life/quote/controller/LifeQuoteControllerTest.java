package com.ctm.web.life.quote.controller;

import com.ctm.apply.model.response.ApplyResponse;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.web.go.Data;
import com.ctm.test.controller.BaseControllerTest;
import com.ctm.web.life.services.LifeQuoteService;
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

import static org.mockito.MockitoAnnotations.initMocks;
import static org.powermock.api.mockito.PowerMockito.when;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@RunWith(PowerMockRunner.class)
@PowerMockRunnerDelegate(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = MockServletContext.class)
@WebAppConfiguration
@PrepareForTest({ApplicationService.class})
public class LifeQuoteControllerTest extends BaseControllerTest {
    @Mock
    LifeQuoteService service;
    @Mock
    IPAddressHandler ipAddressHandler;

    @Mock
    ApplicationService applicationService;

    @InjectMocks
    LifeQuoteController controllerUnderTest;

    @Mock
    private Data value;
    private Long transactionId = 100000L;
    @Mock
    private ApplyResponse applyResponse;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        setUp( controllerUnderTest);
    }

    @Test
    public void shouldSendQuote() throws Exception {
        mvc.perform(
                MockMvcRequestBuilders
                        .post("/rest/life/quote/get.json")
                        .param("life_currentJourney" , "40")
                        .param("life_primary_insurance_partner" , "Y")
                        .param("life_primary_insurance_samecover" , "Y")
                        .param("life_primary_insurance_term" , "500000")
                        .param("life_primary_insurance_termentry" , "500,000")
                        .param("life_primary_insurance_tpd" , "250000")
                        .param("life_primary_insurance_tpdentry" , "250,000")
                        .param("life_primary_insurance_trauma" , "150000")
                        .param("life_primary_insurance_traumaentry" , "150,000")
                        .param("life_primary_insurance_tpdanyown" , "A")
                        .param("life_partner_insurance_term" , "200000")
                        .param("life_partner_insurance_termentry" , "200,000")
                        .param("life_partner_insurance_tpd" , "125000")
                        .param("life_partner_insurance_tpdentry" , "125,000")
                        .param("life_partner_insurance_trauma" , "75000")
                        .param("life_partner_insurance_traumaentry" , "75,000")
                        .param("life_partner_insurance_tpdanyown" , "A")
                        .param("life_primary_insurance_frequency" , "M")
                        .param("life_primary_insurance_type" , "S")
                        .param("life_primary_firstName" , "Joe")
                        .param("life_primary_lastname" , "Blogs")
                        .param("life_primary_gender" , "M")
                        .param("life_primary_dob" , "25/01/1967")
                        .param("life_primary_age" , "50")
                        .param("life_primary_smoker" , "N")
                        .param("life_primary_occupation" , "3a8e54084f5c98147c7eb565a48ce9245fd4fb71")
                        .param("life_primary_hannover" , "1")
                        .param("life_primary_occupationTitle" , "Accountant - Qualified (professionally or degree)")
                        .param("life_partner_firstName" , "Josephine")
                        .param("life_partner_lastname" , "Bloggs")
                        .param("life_partner_gender" , "F")
                        .param("life_partner_dob" , "11/07/1971")
                        .param("life_partner_age" , "45")
                        .param("life_partner_smoker" , "N")
                        .param("life_partner_occupation" , "3a8e54084f5c98147c7eb565a48ce9245fd4fb71")
                        .param("life_partner_hannover" , "1")
                        .param("life_partner_occupationTitle" , "Accountant - Qualified (professionally or degree)")
                        .param("life_contactDetails_email" , "preload.testing@comparethemarket.com.au")
                        .param("life_contactDetails_contactNumber" , "0400123123")
                        .param("life_contactDetails_contactNumberinput" , "(0400) 123 123")
                        .param("life_primary_state" , "QLD")
                        .param("life_primary_postCode" , "4007")
                        .param("life_privacyoptin" , "Y")
                        .param("life_contactDetails_call" , "Y")
                        .param("life_splitTestingJourney" , "0")
                        .param("life_refine_insurance_type" , "primary")
                        .param("transcheck" , "1")
                        .param("transactionId" , transactionId.toString())
                        .param("vertical" , "life")
                        .accept(MediaType.ALL)
                        .contentType(MediaType.APPLICATION_FORM_URLENCODED_VALUE)
        )
                .andExpect(status().isOk());

    }
}