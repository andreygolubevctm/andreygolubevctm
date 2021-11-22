package com.ctm.web.email.health;

import com.ctm.web.core.email.services.EmailDetailsService;
import com.ctm.web.core.email.services.EmailUrlService;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.email.EmailRequest;
import com.ctm.web.email.EmailUtils;
import com.ctm.web.factory.EmailServiceFactory;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import javax.servlet.http.HttpServletRequest;

import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyLong;
import static org.mockito.Matchers.anyObject;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@RunWith(PowerMockRunner.class)
@PrepareForTest({EmailServiceFactory.class, SettingsService.class})
public class HealthModelTranslatorSubTest {

    @Test
    public void testSetUrl() throws Exception {
        // Given
        EmailUtils emailUtils = mock(EmailUtils.class);
        IPAddressHandler ipAddressHandler = mock(IPAddressHandler.class);
        HealthModelTranslator testInstance = new HealthModelTranslator(emailUtils, null, null, ipAddressHandler);
        HttpServletRequest request = mock(HttpServletRequest.class);
        when(request.getAttribute("verticalCode")).thenReturn("CTM");
        PowerMockito.mockStatic(EmailServiceFactory.class);
        PageSettings pageSettings = mock(PageSettings.class);
        when(pageSettings.getVertical()).thenReturn(new Vertical());
        PowerMockito.mockStatic(SettingsService.class);
        when(SettingsService.getPageSettingsForPage(request)).thenReturn(pageSettings);
        EmailRequest emailRequest = new EmailRequest();
        emailRequest.setTransactionId("1234");
        Data data = new Data();
        String verticalCode = "CTM";
        EmailDetailsService emailDetailsService = mock(EmailDetailsService.class);
        EmailMaster emailMaster = mock(EmailMaster.class);
        when(emailDetailsService.handleReadAndWriteEmailDetails(anyLong(), anyObject(), anyString(), anyString())).thenReturn(emailMaster);
        when(EmailServiceFactory.createEmailDetailsService(any(), any(), any(), any())).thenReturn(emailDetailsService);
        EmailUrlService emailUrlService = mock(EmailUrlService.class);
        when(EmailServiceFactory.createEmailUrlService(any(), any())).thenReturn(emailUrlService);
        // When
        testInstance.setUrls(request, emailRequest, data, verticalCode);
        // Then
        // No Exception thrown..
    }
}
