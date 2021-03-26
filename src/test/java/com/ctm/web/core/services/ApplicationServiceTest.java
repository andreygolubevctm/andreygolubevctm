package com.ctm.web.core.services;

import com.ctm.web.core.dao.BrandsDao;
import com.ctm.web.core.dao.ConfigSettingsDao;
import com.ctm.web.core.dao.VerticalsDao;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.ConfigSetting;
import com.ctm.web.core.model.settings.Vertical;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;

public class ApplicationServiceTest {

    @Mock
    private HttpServletRequest httpServletRequest;
    @Mock
    private BrandsDao brandsDao;
    @Mock
    private VerticalsDao verticalsDao;
    @Mock
    ConfigSettingsDao configSettingsDao;
    @Mock
    private Brand brand;
    @Mock
    private Vertical vertical;
    @Mock
    private HttpSession session;
    @Mock
    private ConfigSetting configSetting;

    private String brandCode = "brandCode";

    private ApplicationService service;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        service = new ApplicationService(brandsDao, verticalsDao, configSettingsDao);
        EnvironmentService.setEnvironment("localhost");
        ArrayList<Brand> brands = new ArrayList<>();
        when(brand.getCode()).thenReturn(brandCode);
        brands.add(brand);
        when(brandsDao.getBrands()).thenReturn(brands);
        ArrayList<Vertical> verticals = new ArrayList<>();
        when(vertical.clone()).thenReturn(vertical);
        verticals.add(vertical);
        when(verticalsDao.getVerticals()).thenReturn(verticals);
        ArrayList<ConfigSetting> configSettings = new ArrayList<>();
        configSettings.add(configSetting);
        when(configSettingsDao.getConfigSettings()).thenReturn(configSettings);
        when(httpServletRequest.getSession()).thenReturn(session);

    }

    @Test
    public void testGetBrand() throws Exception {
        when(httpServletRequest.getParameter("brandCode")).thenReturn(brandCode);
        Brand result = service.getBrand(httpServletRequest, Vertical.VerticalType.HEALTH);
        assertEquals(brand, result);
    }
}