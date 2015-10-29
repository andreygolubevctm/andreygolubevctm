package com.ctm.web;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.services.ContentService;
import com.disc_au.web.go.Data;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import javax.servlet.http.HttpServletRequest;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@RunWith(PowerMockRunner.class)
@PrepareForTest( { ContentService.class})
public class ReferralTrackingTest {

    private ReferralTracking referralTracking;
    private HttpServletRequest request;
    private Data data;
    private String invalidSource = "invalidSource";
    String validSource = "testSource";

    @Before
    public void setUp() throws Exception {
        PowerMockito.mockStatic(ContentService.class);
        referralTracking = new ReferralTracking();
        request = mock(HttpServletRequest.class);
        data = new Data();
    }

    @Test
    public void testGetAndSetUtmSource() throws Exception {
        String key = "utm_source";
        String xpath = "test/" + "sourceid";
        PowerMockito.when(ContentService.getContentIsValid(request, key, validSource)).thenReturn(true);
        when(request.getParameter(key)).thenReturn(validSource);
        // save from param
        String result = referralTracking.getAndSetUtmSource(request, data, "test");
        verifyValue(result, validSource, "sourceid");
        // prefer in data bucket
        String expectedResult = setupInDataBucket(xpath);
        result = referralTracking.getAndSetUtmSource(request, data, "test");
        verifyValue(result, expectedResult, "sourceid");
        // don't save if not in whitelist
        setupNoMatchInWhiteList(key);
        result = referralTracking.getAndSetUtmSource(request, data, "test");
        assertEquals("", result);
        assertNull(data.get(xpath));
    }

    private String setupInDataBucket(String xpath) {
        data = new Data();
        String expectedResult = "testSourceFromDataBucket";
        data.put(xpath , "testSourceFromDataBucket");
        return expectedResult;
    }

    @Test
    public void testGetAndSetUtmCampaign() throws Exception {
        String key = "utm_campaign";
        String xpath = "test/" + "cid";
        PowerMockito.when(ContentService.getContentIsValid(request, key, validSource)).thenReturn(true);
        when(request.getParameter(key)).thenReturn(validSource);
        // save from param
        String result = referralTracking.getAndSetUtmCampaign(request, data, "test");
        verifyValue(result, validSource , "cid");
        // prefer in data bucket
        String expectedResult = setupInDataBucket(xpath);
        result = referralTracking.getAndSetUtmCampaign(request, data, "test");
        verifyValue(result, expectedResult, "cid");
        // don't save if not in whitelist
        setupNoMatchInWhiteList(key);
        result = referralTracking.getAndSetUtmCampaign(request, data, "test");
        assertEquals("", result);
        assertNull(data.get(xpath));

    }

    private void verifyValue(String result, String expectedResult , String xpath) {
        assertEquals(expectedResult, result);
        assertEquals(expectedResult, data.get("test/" + xpath));
    }

    private void setupNoMatchInWhiteList(String key) throws DaoException, ConfigSettingException {
        data = new Data();
        when(request.getParameter(key)).thenReturn(invalidSource);
        PowerMockito.when(ContentService.getContentIsValid(request, key, invalidSource)).thenReturn(false);
    }
}