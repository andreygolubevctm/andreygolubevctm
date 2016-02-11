package com.ctm.web.life.email.services;

import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.services.EmailDetailsService;
import com.ctm.web.core.email.services.ExactTargetEmailSender;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.security.StringEncryption;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.web.go.Data;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import javax.servlet.http.HttpServletRequest;

import static org.mockito.Matchers.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;


@RunWith(PowerMockRunner.class)
@PrepareForTest( { StringEncryption.class, LifeEmailService.class, ExactTargetEmailSender.class})
public class LifeEmailServiceTest {

    LifeEmailService lifeEmailService;

    @Mock
    private PageSettings pageSettings;
    @Mock
    private EmailDetailsService emailDetailsService;
    @Mock
    private HttpServletRequest request;
    @Mock
    private TransactionDao transactionDao;
    @Mock
    ServiceConfigurationService serviceConfigurationService;
    @Mock
    ApplicationService applicationService;
    @Mock
    private com.ctm.web.core.model.settings.Brand brand;
    @Mock
    private com.ctm.web.core.model.settings.ServiceConfiguration serviceConfig;
    @Mock
    private LifeEmailDataService lifeEmailDataService;
    @Mock
    private com.ctm.web.core.email.services.ExactTargetEmailSender exactTargetEmailSender;

    private String emailAddress = "Meer@kat.com";
    private long transactionId = 1000L;
    private String serviceUrl = "serviceUrl";
    private String serviceUser = "serviceUser";
    private String servicePassword = "servicePassword";
    private String decryptedPassword  = "decryptedPassword";

    private EmailMaster emailDetails;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        PowerMockito.mockStatic(StringEncryption.class);
        PowerMockito.mockStatic(ExactTargetEmailSender.class);
        PowerMockito.whenNew(ExactTargetEmailSender.class).withAnyArguments().thenReturn(exactTargetEmailSender);
        emailDetails = new EmailMaster();
        PowerMockito.when(StringEncryption.decrypt(anyString(),anyString())).thenReturn(decryptedPassword);
        when(applicationService.getBrand( request, Vertical.VerticalType.LIFE)).thenReturn(brand);
        when(serviceConfigurationService.getServiceConfiguration(anyString(), anyObject())).thenReturn(serviceConfig);
        when(serviceConfig.getPropertyValueByKey(eq("serviceUrl"), anyInt(), anyInt(), anyObject())).thenReturn(serviceUrl);
        when(serviceConfig.getPropertyValueByKey(eq("serviceUser"), anyInt(), anyInt(), anyObject())).thenReturn(serviceUser);
        when(serviceConfig.getPropertyValueByKey(eq("servicePassword"), anyInt(), anyInt(),anyObject())).thenReturn(servicePassword);
        when(emailDetailsService.handleReadAndWriteEmailDetails(eq(transactionId), anyObject(), anyObject(), anyObject())).thenReturn(emailDetails);
        Data data = new Data();
        when(lifeEmailDataService.getDataObject(transactionId)).thenReturn(data);
        when(pageSettings.getSetting("sendClientId")).thenReturn("10000");
        lifeEmailService = new LifeEmailService( pageSettings,  EmailMode.BEST_PRICE,  emailDetailsService, transactionDao, lifeEmailDataService, serviceConfigurationService,  applicationService);
    }

    @Test
    public void testSendBestPriceEmail() throws Exception {
        lifeEmailService.sendBestPriceEmail( request,  emailAddress,  transactionId);
        verify(exactTargetEmailSender).sendToExactTarget(anyObject(), anyObject());
    }

    @Test
    public void testSend() throws Exception {
        lifeEmailService.send( request,  emailAddress,  transactionId);
        verify(exactTargetEmailSender).sendToExactTarget(anyObject(), anyObject());
    }
}