package com.ctm.web.energy.apply.controller;

import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.energy.apply.services.EnergyApplyService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.powermock.modules.junit4.PowerMockRunnerDelegate;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockServletContext;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.mockito.Matchers.*;
import static org.mockito.MockitoAnnotations.initMocks;
import static org.powermock.api.mockito.PowerMockito.when;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;



@RunWith(PowerMockRunner.class)
@PowerMockRunnerDelegate(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = MockServletContext.class)
@WebAppConfiguration
@PrepareForTest({ApplicationService.class})
public class EnergyApplyControllerTest {

    @Mock
    EnergyApplyService energyService;
    @Mock
    SessionDataServiceBean sessionDataServiceBean;

    @Mock
    ApplicationService applicationService;

    @InjectMocks
    EnergyApplyController controllerUnderTest;
    private MockMvc mvc;

    @Mock
    private com.ctm.web.core.web.go.Data value;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        when(sessionDataServiceBean.getDataForTransactionId(anyObject(), anyString(), anyBoolean())).thenReturn(value);
        PowerMockito.mockStatic(ApplicationService.class);
        mvc = MockMvcBuilders.standaloneSetup(controllerUnderTest).build();
    }

    @Test
    public void apply() throws Exception {
        mvc.perform(
                MockMvcRequestBuilders
                        .post("/rest/energy/apply/apply.json")
                        .param("utilities.householdDetails.location", "Pascoe Vale 3044 VIC")
                        .param("utilities.householdDetails.postcode", "3044")
                        .param("utilities.householdDetails.suburb", "Pascoe Vale")
                        .param("utilities.householdDetails.state", "VIC")
                        .param("utilities.application.details.title", "Mr")
                        .param("utilities.householdDetails.whatToCompare", "EG")
                        .param("utilities.householdDetails.movingIn", "N")
                        .param("utilities.householdDetails.recentElectricityBill", "Y")
                        .param("utilities.householdDetails.recentGasBill", "N")
                        .param("utilities.householdDetails.tariff", "A100")
                        .param("utilities.householdDetails.solarPanels", "N")
                        .param("utilities.estimateDetails.usage.electricity.currentSupplier", "8")
                        .param("utilities.estimateDetails.spend.electricity.amount", "300")
                        .param("utilities.estimateDetails.spend.electricity.days", "90")
                        .param("utilities.estimateDetails.electricity.meter", "T")
                        .param("utilities.estimateDetails.usage.electricity.peak.amount", "4000")
                        .param("utilities.estimateDetails.usage.electricity.offpeak.amount", "2500")
                        .param("utilities.estimateDetails.usage.gas.currentSupplier", "6")
                        .param("utilities.estimateDetails.gas.usage", "Medium")
                        .param("utilities.resultsDisplayed.firstName", "Test")
                        .param("utilities.resultsDisplayed.phone", "0711223344")
                        .param("utilities.resultsDisplayed.phoneinput", "(07) 1122 3344")
                        .param("utilities.resultsDisplayed.email", "preload.testing@comparethemarket.com.au")
                        .param("utilities.privacyoptin", "Y")
                        .param("utilities.resultsDisplayed.optinMarketing", "Y")
                        .param("utilities.resultsDisplayed.optinPhone", "Y")
                        .param("utilities.application.details.firstName", "Test")
                        .param("utilities.application.details.lastName", "User")
                        .param("utilities.application.details.dobInputD", "31")
                        .param("utilities.application.details.dobInputM", "12")
                        .param("utilities.application.details.dobInputY", "1979")
                        .param("utilities.application.details.dob", "31/12/1979")
                        .param("utilities.application.details.otherPhoneNumberinput", "(07) 1122 3344")
                        .param("utilities.application.details.email", "preload.testing@comparethemarket.com.au")
                        .param("utilities.application.details.address.autofilllessSearch", "1/536 Pascoe Vale Road, Pascoe Vale, VIC, 3044")
                        .param("utilities.application.details.address.streetNum", "9")
                        .param("utilities.application.details.address.type", "R")
                        .param("utilities.application.details.address.elasticSearch", "Y")
                        .param("utilities.application.details.address.lastSearch", "1/536 Pascoe Vale Road, Pascoe Vale, VIC, 3044")
                        .param("utilities.application.details.address.fullAddressLineOne", "1/536 Pascoe Vale Road")
                        .param("utilities.application.details.address.fullAddress", "1/536 Pascoe Vale Road, Pascoe Vale,VIC, 3044")
                        .param("utilities.application.details.address.dpId", "86177996")
                        .param("utilities.application.details.address.unitType", "UN")
                        .param("utilities.application.details.address.unitSel", "1")
                        .param("utilities.application.details.address.houseNoSel", "536")
                        .param("utilities.application.details.address.streetName", "Pascoe Vale Road")
                        .param("utilities.application.details.address.streetId", "134743")
                        .param("utilities.application.details.address.suburbName", "Pascoe Vale")
                        .param("utilities.application.details.address.postCode", "3044")
                        .param("utilities.application.details.address.state", "VIC")
                        .param("utilities.application.details.postalMatch", "Y")
                        .param("utilities.application.thingsToKnow.termsAndConditions", "Y")
                        .param("utilities.application.thingsToKnow.hidden.productId", "2213")
                        .param("utilities.application.thingsToKnow.hidden.retailerName", "Simply Energy")
                        .param("utilities.application.thingsToKnow.hidden.planName", "Simply Summer Sale Plan (Dual Fuel)")
                        .param("utilities.application.thingsToKnow.receiveInfo", "N")
                        .param("transcheck", "1")
                        .param("utilities.partner.uniqueCustomerId", "T009448")
                        .param("utilities.journey.stage", "enquiry")
                        .param("utilities.renderingMode", "md")
                        .param("utilities.lastFieldTouch", "utilities.application.details.address.autofilllessSearch")
                        .param("transactionId", "2692282")
                        .accept(MediaType.ALL)
                        .contentType(MediaType.APPLICATION_FORM_URLENCODED_VALUE)
        )
                .andExpect(status().isOk());

    }
}