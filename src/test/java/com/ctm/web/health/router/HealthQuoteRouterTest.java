package com.ctm.web.health.router;

import com.ctm.web.core.connectivity.SimpleConnection;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.ResultsWrapper;
import com.ctm.web.core.services.*;
import com.ctm.web.core.utils.SessionUtils;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.model.form.Benefits;
import com.ctm.web.health.model.form.HealthQuote;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.health.model.form.Simples;
import org.apache.cxf.jaxrs.ext.MessageContext;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

import static junit.framework.TestCase.assertEquals;
import static org.junit.Assert.assertNull;
import static org.mockito.Matchers.*;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

@RunWith(PowerMockRunner.class)
@PrepareForTest( { ApplicationService.class, SettingsService.class, SessionUtils.class,
        RequestService.class, ServiceConfigurationService.class, SimpleConnection.class, CommonRequestService.class})
public class HealthQuoteRouterTest {

    private HealthQuoteRouter healthQuoteRouter;
    @Mock
    private MessageContext context;
    @Mock
    private HttpServletRequest httpServletRequest;
    @Mock
    private SessionDataServiceBean sessionDataServiceBean;
    @Mock
    private com.ctm.web.core.model.settings.Brand brand;
    @Mock
    private javax.servlet.http.HttpSession session;
    @Mock
    private PageSettings pageSettings;
    @Mock
    private Vertical vertical;
    @Mock
    private ContentService contentService;
    @Mock
    private com.ctm.web.core.model.settings.ServiceConfiguration serviceConfig;
    @Mock
    private com.ctm.web.core.connectivity.SimpleConnection simpleConnection;

    private HealthRequest data;
    private Long transactionId = 100000L;
    private Data dataB;
    private String brandCode = "ctm";
    private java.lang.Integer brandId = 1;
    private String contactType = "contactType";

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        PowerMockito.mockStatic(ApplicationService.class);
        PowerMockito.mockStatic(SettingsService.class);
        PowerMockito.mockStatic(SessionUtils.class);
        PowerMockito.mockStatic(ServiceConfigurationService.class);
        PowerMockito.mockStatic(SimpleConnection.class);

        PowerMockito.whenNew(SimpleConnection.class).withNoArguments().thenReturn(simpleConnection);

        when(simpleConnection.get(anyString())).thenReturn("{" +
                "\"payload\" : {" +
                    "\"quotes\" : []" +
                    "}" +
                "}");

        PowerMockito.when(SettingsService.getPageSettingsByBrand(eq(brand), anyObject())).thenReturn(pageSettings);
        PowerMockito.when(SettingsService.getPageSettingsForPage(anyObject())).thenReturn(pageSettings);
        PowerMockito.when(ServiceConfigurationService.getServiceConfiguration(anyString(), anyInt(),anyInt())).thenReturn(serviceConfig);
        when(pageSettings.getVertical()).thenReturn(vertical);
        when(pageSettings.getBrandId()).thenReturn(brandId);
        when(brand.getCode()).thenReturn(brandCode);
        when(brand.getId()).thenReturn(brandId);
        when(brand.getVerticalByCode(anyString())).thenReturn(vertical);
        data = new HealthRequest();
        data.setTransactionId(transactionId);
        HealthQuote health = new HealthQuote();
        Simples simples = new Simples();
        simples.setContactType(contactType);
        health.setSimples(simples);
        health.setShowAll("Y");
        Benefits benefits = new Benefits();
        Map<String, String> benefitsExtras = new HashMap<>();
        benefits.setBenefitsExtras(benefitsExtras);
        health.setBenefits(benefits);
        health.setExcess("");
        data.setHealth(health);
        dataB = new Data();
        PowerMockito.when(ApplicationService.getBrandFromRequest(eq(httpServletRequest))).thenReturn(brand);
        when(context.getHttpServletRequest()).thenReturn(httpServletRequest);
        when(sessionDataServiceBean.getDataForTransactionId(httpServletRequest, transactionId.toString(), true)).thenReturn(dataB);
        when(httpServletRequest.getSession()).thenReturn(session);
        healthQuoteRouter = new HealthQuoteRouter(sessionDataServiceBean, contentService);

    }

    @Test
    public void testValidateRequestInvalid() throws Exception {
        data.getHealth().setSimples(null);
        when(SessionUtils.isCallCentre(anyObject())).thenReturn(true);
        ResultsWrapper result = healthQuoteRouter.getHealthQuote(context, data);
        assertEquals("validation", result.getError().getType());
    }

    @Test
    public void testValidateRequestValid() throws Exception {
        EnvironmentService.setEnvironment("localhost");
        when(SessionUtils.isCallCentre(anyObject())).thenReturn(false);
        ResultsWrapper result = healthQuoteRouter.getHealthQuote(context,  data);
        assertNull(result.getError());
    }

}