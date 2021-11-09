package com.ctm.web.health.services;

import com.ctm.web.core.dao.ProviderDao;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.provider.model.Provider;
import com.ctm.web.health.dao.ProviderContentDao;
import com.ctm.web.health.dao.ProviderInfoDao;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.util.Date;

import static org.junit.Assert.*;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.when;

@RunWith(MockitoJUnitRunner.class)
public class ProviderContentServiceTest {

    @Autowired
    @InjectMocks
    ProviderContentService providerContentService;

    @Mock
    ProviderContentDao providerContentDao;
    @Mock
    ProviderDao providerDao;
    @Mock
    ProviderInfoDao providerInfoDao;
    @Mock
    ObjectMapper mapper;
    @Mock
    HttpServletRequest request;
    @Mock
    HttpSession session;

    @Test
    public void emptyProviderContentInformation() throws DaoException, ConfigSettingException {
        // Given
        String providerName = null;
        String product = null;
        String styleCode = null;
        String providerContentTypeCode = null;
        // When
        String nextStep = providerContentService.getProviderContentText(request, providerName, product, styleCode, providerContentTypeCode);
        // Then
        assertNull(nextStep);
    }

    @Test
    public void happyPathNextStepInformation()  throws DaoException, ConfigSettingException {
        // Given
        String returnedNextSteps = "NextSteps";
        String providerName = "Australian Unity";
        String product = null;
        String styleCode = "CTM";
        String providerContentTypeCode = "IDK";
        Provider provider = new Provider();
        provider.setId(99);
        when(providerDao.getByName(anyString(), any())).thenReturn(provider);
        when(request.getSession()).thenReturn(session);
        Date currDate = new Date();
        when(session.getAttribute("applicationDate")).thenReturn(currDate);
        when(providerContentDao.getProviderContentText(99, providerContentTypeCode, "HEALTH", currDate, styleCode)).thenReturn(returnedNextSteps);
        // When
        String nextStep = providerContentService.getProviderContentText(request, providerName, product, styleCode, providerContentTypeCode);
        // Then
        assertEquals(nextStep, returnedNextSteps);
    }

    @Test
    public void missingProviderNameNextStepInformation()  throws DaoException, ConfigSettingException {
        // Given
        ProviderContentService providerContentService = new ProviderContentService(providerInfoDao, providerDao, providerContentDao, new ObjectMapper());
        String returnedNextSteps = "NextSteps";
        String providerName = null;
        String product = "{ \"providerName\": \"AHM\" }";
        String styleCode = "CTM";
        String providerContentTypeCode = "IDK";
        Provider provider = new Provider();
        provider.setId(99);
        when(providerDao.getByName(anyString(), any())).thenReturn(provider);
        when(request.getSession()).thenReturn(session);
        Date currDate = new Date();
        when(session.getAttribute("applicationDate")).thenReturn(currDate);
        when(providerContentDao.getProviderContentText(99, providerContentTypeCode, "HEALTH", currDate, styleCode)).thenReturn(returnedNextSteps);
        // When
        String nextStep = providerContentService.getProviderContentText(request, providerName, product, styleCode, providerContentTypeCode);
        // Then
        assertEquals(nextStep, returnedNextSteps);
    }
}