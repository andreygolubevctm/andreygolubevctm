package com.ctm.web.core.leadService.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.leadService.model.LeadMetadata;
import com.ctm.web.core.leadService.model.LeadRequest;
import com.ctm.web.core.leadService.model.LeadStatus;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ServiceConfigurationService;
import com.ctm.web.core.utils.SessionUtils;
import com.ctm.web.core.web.go.Data;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import static com.ctm.web.core.model.settings.ServiceConfigurationProperty.Scope.SERVICE;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.eq;
import static org.mockito.Mockito.times;
import static org.mockito.MockitoAnnotations.initMocks;
import static org.powermock.api.mockito.PowerMockito.*;

@RunWith(PowerMockRunner.class)
@PrepareForTest({SessionUtils.class, ServiceConfigurationService.class, LeadServiceUtil.class})
public class LeadServiceTest {

    @Mock
    ServiceConfiguration mockServiceConfig;
    @Mock
    HttpServletRequest mockRequest;
    @Mock
    Data mockData;
    @Mock
    IPAddressHandler ipAddressHandler;

    LeadService leadService;

    @Before
    public void setup() throws ServiceConfigurationException, DaoException {
        initMocks(this);

        leadService = new LeadService(ipAddressHandler) {
            @Override
            protected LeadRequest updatePayloadData(Data data) {
                LeadRequest lr = new LeadRequest();
                lr.setVerticalType("health");
                lr.getPerson().setFirstName("Firstname");
                lr.getPerson().setEmail("Email");
                lr.getPerson().setMobile("Mobile");
                lr.setMetadata(mock(LeadMetadata.class));
                return lr;
            }
        };

        mockStatic(SessionUtils.class);
        when(SessionUtils.isCallCentre(any())).thenReturn(false);

        when(mockRequest.getSession()).thenReturn(mock(HttpSession.class));
        when(ipAddressHandler.getIPAddress(mockRequest)).thenReturn("1.1.1.1");

        when(mockData.getLong("current/rootId")).thenReturn(1111L);
        when(mockData.getLong("current/transactionId")).thenReturn(1111L);
        when(mockData.getString("current/brandCode")).thenReturn("ctm");
        when(mockData.getString("current/brandCode")).thenReturn("ctm");

        mockStatic(ServiceConfigurationService.class);
        when(ServiceConfigurationService.getServiceConfiguration("leadService", 4)).thenReturn(mockServiceConfig);

        when(mockServiceConfig.getPropertyValueByKey("enabled", 0, 0, SERVICE)).thenReturn("true");
        when(mockServiceConfig.getPropertyValueByKey("url", 0, 0, SERVICE)).thenReturn("url");

        mockStatic(LeadServiceUtil.class);
    }

    @Test
    public void sendNormalLead() throws Exception {
        leadService.sendLead(4, mockData, mockRequest, LeadStatus.OPEN.name());
        verifyStatic(times(1));
        LeadServiceUtil.sendRequest(any(), eq("url"));
    }

    @Test
    public void callcentreShouldNotSendLeads() throws Exception {
        when(SessionUtils.isCallCentre(any())).thenReturn(true);

        leadService.sendLead(4, mockData, mockRequest, LeadStatus.OPEN.name());
        verifyStatic(times(0));
        LeadServiceUtil.sendRequest(any(), any());

        leadService.sendLead(4, mockData, mockRequest, LeadStatus.SOLD.name());
        verifyStatic(times(0));
        LeadServiceUtil.sendRequest(any(), any());

        leadService.sendLead(4, mockData, mockRequest, LeadStatus.PENDING.name());
        verifyStatic(times(0));
        LeadServiceUtil.sendRequest(any(), any());
    }

    @Test
    public void callcentreShouldSendInboundLead() throws Exception {
        when(SessionUtils.isCallCentre(any())).thenReturn(true);

        leadService.sendLead(4, mockData, mockRequest, LeadStatus.INBOUND_CALL.name());
        verifyStatic(times(1));
        LeadServiceUtil.sendRequest(any(), any());
    }
}