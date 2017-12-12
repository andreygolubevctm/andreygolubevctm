package com.ctm.web.car.model.request.propensityscore;

import org.junit.Test;

import static org.junit.Assert.*;

public class DeviceTypeTest {

    @Test
    public void GivenValieUserAgent_WhenGetDeviceType_ThenReturnLowerCaseDeviceType() throws Exception {
        //Given
        //When
        String deviceType = DeviceType.getDeviceType("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36");
        //Then
        assertEquals(deviceType, "desktop");
    }

    @Test
    public void GivenNull_WhenGetDeviceType_ThenReturnNull() throws Exception {
        //Given
        //When
        String deviceType = DeviceType.getDeviceType("Test");
        //Then
        assertEquals(deviceType, null);
    }

}
