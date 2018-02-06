package com.ctm.web.email.health;

import com.ctm.web.core.content.dao.ContentDao;
import com.ctm.web.core.dao.BrandsDao;
import com.ctm.web.core.dao.ConfigSettingsDao;
import com.ctm.web.core.dao.VerticalsDao;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.ConfigSetting;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.openinghours.services.OpeningHoursService;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.email.EmailRequest;
import com.ctm.web.email.EmailUtils;
import com.google.common.collect.ImmutableList;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.IntStream;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.junit.Assert.assertThat;
import static org.mockito.Matchers.*;
import static org.mockito.Mockito.when;


@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = {HealthModelTranslatorTest.TestConfiguration.class})
public class HealthModelTranslatorTest {

    @Autowired
    private HealthModelTranslator testInstance;
    @Autowired
    private BrandsDao brandsDaoMock;
    @Autowired
    private VerticalsDao verticalsDaoMock;
    @Autowired
    private ConfigSettingsDao configSettingsDaoMock;
    @Autowired
    private OpeningHoursService openingHoursServiceMock;
    @Autowired
    private Brand brandMock;
    @Autowired
    private ContentDao contentDaoMock;
    @Autowired
    private Vertical verticalMock;
    @Autowired
    private HttpSession sessionMock;
    @Autowired
    private ConfigSetting configSettingMock;
    @Autowired
    private ApplicationService service;

    @AfterClass
    public static void resetGlobalStaticVariablesToOriginalState() throws NoSuchFieldException, IllegalAccessException {
        fixGlobalStaticVariables(new BrandsDao(), new VerticalsDao(), new ConfigSettingsDao(), new ArrayList<>());
    }

    /**
     * There are a number of Global Static Variables set on the {@link ApplicationService} class.
     * This method sets them to values expected within this test.
     */
    private static void fixGlobalStaticVariables(BrandsDao brandsDao, VerticalsDao verticalsDao, ConfigSettingsDao configSettingsDao, List<Brand> brands) throws NoSuchFieldException, IllegalAccessException {
        Field brandsDaoField = ApplicationService.class.getDeclaredField("brandsDao");
        brandsDaoField.setAccessible(true);
        brandsDaoField.set(null, brandsDao);
        Field verticalsDaoField = ApplicationService.class.getDeclaredField("verticalsDao");
        verticalsDaoField.setAccessible(true);
        verticalsDaoField.set(null, verticalsDao);
        Field configSettingsDaoField = ApplicationService.class.getDeclaredField("configSettingsDao");
        configSettingsDaoField.setAccessible(true);
        configSettingsDaoField.set(null, configSettingsDao);
        Field brandsField = ApplicationService.class.getDeclaredField("brands");
        brandsField.setAccessible(true);
        brandsField.set(null, brands);
    }

    @Before
    public void setUp() throws Exception {
        Mockito.reset(brandsDaoMock, verticalsDaoMock, configSettingsDaoMock, openingHoursServiceMock, brandMock, contentDaoMock, verticalMock, sessionMock, configSettingMock);
        EnvironmentService.setEnvironment("localhost");
        ArrayList<Brand> brands = new ArrayList<>();
        when(brandMock.getCode()).thenReturn(HealthModelTranslator.VERTICAL_CODE);
        when(brandMock.getVerticalByCode(HealthModelTranslator.VERTICAL_CODE)).thenReturn(verticalMock);
        brands.add(brandMock);
        when(brandsDaoMock.getBrands()).thenReturn(brands);

        ArrayList<Vertical> verticals = new ArrayList<>();
        when(verticalMock.clone()).thenReturn(verticalMock);
        verticals.add(verticalMock);
        when(verticalsDaoMock.getVerticals()).thenReturn(verticals);

        ArrayList<ConfigSetting> configSettings = new ArrayList<>();
        configSettings.add(configSettingMock);

        when(configSettingsDaoMock.getConfigSettings()).thenReturn(configSettings);

        when(contentDaoMock.getByKey(eq("callCenterNumber"), anyInt(), anyInt(), any(Date.class), eq(false))).thenReturn(null);
        when(openingHoursServiceMock.getCurrentOpeningHoursForEmail(any(HttpServletRequest.class))).thenReturn("9 - 5");

        fixGlobalStaticVariables(brandsDaoMock, verticalsDaoMock, configSettingsDaoMock, brands);

    }

    @Test
    public void givenDiscountsInHttpRequest_thenDiscountSetInEmail() throws ConfigSettingException, DaoException {

        EmailRequest emailRequest = new EmailRequest();
        MockHttpServletRequest request = getMockHttpServletRequest();
        setParamWithValue(request, 10, "rank_premiumDiscountPercentage", "%1$d.%1$d");

        List<BigDecimal> expected = ImmutableList.of(
                BigDecimal.valueOf(0.0),
                BigDecimal.valueOf(1.1),
                BigDecimal.valueOf(2.2),
                BigDecimal.valueOf(3.3),
                BigDecimal.valueOf(4.4),
                BigDecimal.valueOf(5.5),
                BigDecimal.valueOf(6.6),
                BigDecimal.valueOf(7.7),
                BigDecimal.valueOf(8.8),
                BigDecimal.valueOf(9.9)
        );

        testInstance.setVerticalSpecificFields(emailRequest, request, new DataStub());

        assertThat(emailRequest.getPremiumDiscountPercentage(), equalTo(expected));
    }

    @Test
    public void givenInvalidBigDecimalDiscountsInHttpRequest_thenLeaveAsZero() throws ConfigSettingException, DaoException {

        EmailRequest emailRequest = new EmailRequest();
        MockHttpServletRequest request = getMockHttpServletRequest();
        setParamWithValue(request, 10, "rank_premiumDiscountPercentage", "NaN %1$d.%1$d");

        List<BigDecimal> expected = ImmutableList.of(
                BigDecimal.ZERO,
                BigDecimal.ZERO,
                BigDecimal.ZERO,
                BigDecimal.ZERO,
                BigDecimal.ZERO,
                BigDecimal.ZERO,
                BigDecimal.ZERO,
                BigDecimal.ZERO,
                BigDecimal.ZERO,
                BigDecimal.ZERO
        );

        testInstance.setVerticalSpecificFields(emailRequest, request, new DataStub());

        assertThat(emailRequest.getPremiumDiscountPercentage(), equalTo(expected));
    }

    @Test
    public void givenAltPremiumsInRequest_thenAlsoSetInEmailRequest() throws ConfigSettingException, DaoException {

        EmailRequest emailRequest = new EmailRequest();
        MockHttpServletRequest request = getMockHttpServletRequest();
        setParamWithValue(request, 10, "rank_altPremium", "rank_altPremium %1$d Value");

        List<String> expected = ImmutableList.of(
                "rank_altPremium 0 Value",
                "rank_altPremium 1 Value",
                "rank_altPremium 2 Value",
                "rank_altPremium 3 Value",
                "rank_altPremium 4 Value",
                "rank_altPremium 5 Value",
                "rank_altPremium 6 Value",
                "rank_altPremium 7 Value",
                "rank_altPremium 8 Value",
                "rank_altPremium 9 Value"
        );

        testInstance.setVerticalSpecificFields(emailRequest, request, new DataStub());

        assertThat(emailRequest.getHealthEmailModel().getAltPremiums(), equalTo(expected));
    }

    @Test
    public void givenAltPremiumsLabelsInRequest_thenAlsoSetInEmailRequest() throws ConfigSettingException, DaoException {

        EmailRequest emailRequest = new EmailRequest();
        MockHttpServletRequest request = getMockHttpServletRequest();
        setParamWithValue(request, 10, "rank_altPremiumText", "rank_altPremiumText %1$d Value");

        List<String> expected = ImmutableList.of(
                "rank_altPremiumText 0 Value",
                "rank_altPremiumText 1 Value",
                "rank_altPremiumText 2 Value",
                "rank_altPremiumText 3 Value",
                "rank_altPremiumText 4 Value",
                "rank_altPremiumText 5 Value",
                "rank_altPremiumText 6 Value",
                "rank_altPremiumText 7 Value",
                "rank_altPremiumText 8 Value",
                "rank_altPremiumText 9 Value"
        );

        testInstance.setVerticalSpecificFields(emailRequest, request, new DataStub());

        assertThat(emailRequest.getHealthEmailModel().getAltPremiumLabels(), equalTo(expected));
    }

    @Test
    public void givenSpecialOfferInRequest_thenAlsoSetInEmailRequest() throws ConfigSettingException, DaoException {

        EmailRequest emailRequest = new EmailRequest();
        MockHttpServletRequest request = getMockHttpServletRequest();
        setParamWithValue(request, 10, "rank_specialOffer", "rank_specialOffer %1$d Value");

        List<String> expected = ImmutableList.of(
                "rank_specialOffer 0 Value",
                "rank_specialOffer 1 Value",
                "rank_specialOffer 2 Value",
                "rank_specialOffer 3 Value",
                "rank_specialOffer 4 Value",
                "rank_specialOffer 5 Value",
                "rank_specialOffer 6 Value",
                "rank_specialOffer 7 Value",
                "rank_specialOffer 8 Value",
                "rank_specialOffer 9 Value"
        );

        testInstance.setVerticalSpecificFields(emailRequest, request, new DataStub());

        assertThat(emailRequest.getProviderSpecialOffers(), equalTo(expected));
    }

    @Test
    public void givenDataXml_thenSetGaClientIDInEmailRequest() throws ConfigSettingException, DaoException {

        EmailRequest emailRequest = new EmailRequest();
        MockHttpServletRequest request = getMockHttpServletRequest();

        testInstance.setVerticalSpecificFields(emailRequest, request, new DataStub());
        assertThat(emailRequest.getGaClientID(), equalTo(DataStub.STUB_GA_CLIENT_ID));

    }

    private MockHttpServletRequest getMockHttpServletRequest() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setAttribute("verticalCode", HealthModelTranslator.VERTICAL_CODE);
        request.setSession(sessionMock);
        request.setParameter("brandCode", HealthModelTranslator.VERTICAL_CODE);
        return request;
    }

    private void setParamWithValue(MockHttpServletRequest request, int num, String paramName, String patternFormat) {
        IntStream.rangeClosed(0, num).forEach(i -> {
            request.setParameter(String.format("%1$s%2$d", paramName, i), String.format(patternFormat, i));
        });
    }

    private static class DataStub extends Data {
        private static final String STUB_GA_CLIENT_ID = "1139575501.1515372592";
        private static final String STUB_DATA_XML = String.format("<this><gaclientid>%1$s</gaclientid></this>", STUB_GA_CLIENT_ID);

        @Override
        public String getXML() {
            return STUB_DATA_XML;
        }
    }
    @Configuration
    public static class TestConfiguration {

        @Bean
        public BrandsDao brandsdao() {
            return Mockito.mock(BrandsDao.class);
        }

        @Bean
        public VerticalsDao verticalsdao() {
            return Mockito.mock(VerticalsDao.class);
        }

        @Bean
        public ConfigSettingsDao configsettingsdao() {
            return Mockito.mock(ConfigSettingsDao.class);
        }

        @Bean
        public OpeningHoursService openinghoursservice() {
            return Mockito.mock(OpeningHoursService.class);
        }

        @Bean
        public Brand brand() {
            return Mockito.mock(Brand.class);
        }

        @Bean
        public ContentDao contentdao() {
            return Mockito.mock(ContentDao.class);
        }

        @Bean
        public Vertical vertical() {
            return Mockito.mock(Vertical.class);
        }

        @Bean
        @Primary
        public HttpSession httpsession() {
            return Mockito.mock(HttpSession.class);
        }

        @Bean
        public ConfigSetting configsetting() {
            return Mockito.mock(ConfigSetting.class);
        }

        @Bean
        public IPAddressHandler ipaddresshandler() {
            return Mockito.mock(IPAddressHandler.class);
        }

        @Bean
        public EmailUtils emailutils() {
            return new EmailUtils();
        }

        @Bean
        public ApplicationService applicationService(BrandsDao brandsDao,
                                                     VerticalsDao verticalsDao,
                                                     ConfigSettingsDao configSettingsDao) {
            return new ApplicationService(brandsDao, verticalsDao, configSettingsDao);
        }

        @Bean
        public HealthModelTranslator healthModelTranslator(EmailUtils emailUtils, ContentDao contentDao, OpeningHoursService openingHoursService, IPAddressHandler ipAddressHandler) {
            return new HealthModelTranslator(emailUtils, contentDao, openingHoursService, ipAddressHandler);
        }
    }
}