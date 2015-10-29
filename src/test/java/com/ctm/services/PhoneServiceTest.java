package com.ctm.services;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.model.settings.PageSettings;
import com.ctm.web.simples.services.PhoneService;
import org.json.JSONException;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.junit.Assert.assertEquals;
import static org.powermock.api.mockito.PowerMockito.mock;
import static org.powermock.api.mockito.PowerMockito.when;

@RunWith(PowerMockRunner.class)
@PrepareForTest(PhoneService.class)
public class PhoneServiceTest {
    public static final String OK_RESPONSE = "<service><response><accessToken/><status>OK</status></response></service>";
    public static final String BOGUS_RESPONSE = "{ \"imjson\": \"notxml\" }";

    @Test
    public void callUrl() throws ConfigSettingException {
        verifyCallUrl("http://test", "http://test/dataservices/makeCall?accessToken=&extension=666&numberToCall=0491570156", "666", "0491570156");
        verifyCallUrl("https://blah", "https://blah/dataservices/makeCall?accessToken=&extension=010&numberToCall=+1340589897", "010", "+1340589897");
    }

    private void verifyCallUrl(final String baseUrl, final String expected, final String extension, final String phone) throws ConfigSettingException {
        final PageSettings pageSettings = mock(PageSettings.class);
        when(pageSettings.getSetting("ctiMakeCallUrl")).thenReturn(baseUrl);
        assertEquals(expected, PhoneService.callUrl(pageSettings, extension, phone));
    }

    @Test
    public void callReturnStatus() throws JSONException {
        assertEquals(true, PhoneService.callReturnStatus(OK_RESPONSE));
        assertEquals(false, PhoneService.callReturnStatus(BOGUS_RESPONSE));
    }

}