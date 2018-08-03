package com.ctm.web.core.leadfeed.dao;

import com.ctm.energy.apply.model.request.application.address.State;
import com.ctm.web.car.leadfeed.services.CTM.CTMCarLeadFeedService;
import com.ctm.web.core.dao.VerticalsDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.leadfeed.config.LeadsConfig;
import com.ctm.web.core.leadfeed.model.CTMCarLeadFeedRequestMetadata;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.leadfeed.model.Person;
import com.ctm.web.core.leadfeed.services.ActiveProvidersService;
import com.ctm.web.core.leadfeed.services.TransactionsService;
import com.ctm.web.core.model.leadfeed.LeadFeedRootTransaction;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.ServiceConfiguration;
import com.ctm.web.core.model.settings.ServiceConfigurationProperty;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.ServiceConfigurationService;
import org.apache.commons.lang3.tuple.Pair;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.springframework.test.util.ReflectionTestUtils;

import javax.naming.NamingException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static org.junit.Assert.*;
import static org.mockito.Matchers.eq;
import static org.mockito.MockitoAnnotations.initMocks;
import static org.powermock.api.mockito.PowerMockito.mockStatic;
import static org.powermock.api.mockito.PowerMockito.when;

@RunWith(PowerMockRunner.class)
@PrepareForTest({ApplicationService.class, ServiceConfigurationService.class})
public class LeadsDaoImplTest {

    @InjectMocks
    LeadsDaoImpl leadsDao;

    @Mock
    ActiveProvidersService activeProvidersService;
    @Mock
    LeadsRepository leadsRepository;
    @Mock
    VerticalsDao verticalDao;
    @Mock
    LeadsConfig config;

    @Mock
    ResultSet validCtmLead;
    @Mock
    ResultSet validCtmTran;
    @Mock
    ResultSet validOtherLead;
    @Mock
    ResultSet validMultiTran;
    @Mock
    ResultSet validMultiLead;
    @Mock
    ResultSet validOtherLeadWithCTMLength;
    @Mock
    ResultSet invalidLeadTooShort;
    @Mock
    ResultSet invalidLeadNoPhone;


    @Mock
    private ServiceConfiguration serviceConfiguration;

    private Date serverDate;

    private LeadFeedRootTransaction ctmTran;
    private LeadFeedRootTransaction ctmTranNoFeed;
    private LeadFeedRootTransaction otherTran;
    private LeadFeedRootTransaction multiTran1;
    private LeadFeedRootTransaction multiTran2;
    private Vertical carVertical;
    private Vertical homeVertical;
    private List<String> ctmPartners;
    private Brand budgetBrand;
    private Brand testBrand;
    private Brand multiBrand;
    private String ctmConcatString;
    private String tooShortConcatString;
    private String noPhoneConcatString;
    private String otherConcatString;

    @Before
    public void setUp() throws DaoException, SQLException, ServiceConfigurationException, NamingException {

        initMocks(this);
        setupMockData();
        setupMockBehaviour();


    }

    @Test
    public void testGetLeadsNoVertical() throws DaoException {
        assertEquals(0, leadsDao.getLeads(1, null, 1, serverDate).size());
    }

    @Test
    public void testGetLeadsNoProvider() throws DaoException {
        assertEquals(0, leadsDao.getLeads(1, null, 1, serverDate).size());
    }


    @Test
    public void testGetActiveLeadProvidersExist() throws DaoException {
        leadsDao.setActiveLeadProviders("CAR", serverDate);
        assertEquals("BUDD|TEST", leadsDao.getActiveLeadProviders());
    }

    @Test
    public void getActiveLeadProvidersDoNotExist() throws DaoException {
        leadsDao.setActiveLeadProviders("HOME", serverDate);
        assertNull(leadsDao.getActiveLeadProviders());
    }

    @Test
    public void testProcessTransactionDataNoLeadFeed() throws SQLException, DaoException, NamingException {

        LeadFeedData lead = leadsDao.processTransactionData("HOME", ctmTranNoFeed, 1);
        assertNull(lead);
    }


    @Test
    public void testBuildLead_invalidTooShort() throws SQLException, DaoException {
        Pair<LeadFeedData, Boolean> result = leadsDao.buildLead("CAR",
                Pair.of(null, true),
                invalidLeadTooShort,
                otherTran,
                1);
        assertNull(result.getLeft());
    }

    @Test
    public void testBuildLead_invalidNoPhone() throws SQLException, DaoException {
        Pair<LeadFeedData, Boolean> result = leadsDao.buildLead("CAR",
                Pair.of(null, true),
                invalidLeadNoPhone,
                otherTran,
                1);
        assertNull(result.getLeft());
    }

    @Test
    public void testIsCTMLead_true() {
        LeadFeedData leadData = new LeadFeedData();
        leadData.setVerticalCode("CAR");
        leadData.setPartnerBrand("BUDD");
    }

    @Test
    public void testIsCTMLead_wrongPartner() {
        LeadFeedData leadData = new LeadFeedData();
        leadData.setVerticalCode("CAR");
        leadData.setPartnerBrand("TEST");
    }

    @Test
    public void testIsCTMLead_wrongVertical() {
        LeadFeedData leadData = new LeadFeedData();
        leadData.setVerticalCode("HOME");
        leadData.setPartnerBrand("BUDD");
    }

    @Test
    public void testIsCTMLead_wrongVerticalAndPartner() {
        LeadFeedData leadData = new LeadFeedData();
        leadData.setVerticalCode("HOME");
        leadData.setPartnerBrand("TEST");
    }

    @Test
    public void testUpdateToCTMLead_shortLead() throws DaoException {
        assertNull(leadsDao.updateToCTMLead(new LeadFeedData(), otherConcatString.split("\\|\\|", -1), 1L, "A", 1));
    }

    @Test
    public void testUpdateToCTMLead_otherLead() throws DaoException {
        LeadFeedData result = leadsDao.updateToCTMLead(new LeadFeedData(), otherConcatString.split("\\|\\|", -1), 1L, "A", 2);
        assertNull(result.getPerson());
        assertNull(result.getMetadata());
    }

    @Test
    public void testGetPersonDataBlank() {
        assertNull(leadsDao.getPersonData(""));
    }

    @Test
    public void testGetPersonDataInvalid() {
        assertNull(leadsDao.getPersonData("firstName=1"));
    }

    @Test
    public void testGetPersonData() {
        Person result = leadsDao.getPersonData("{\"firstName\":\"test\",\"address\":{\"state\":\"QLD\"}}");
        assertEquals("test", result.getFirstName());
        assertNotNull(result.getAddress());
        assertEquals(State.QLD, result.getAddress().getState());
    }


    @Test
    public void testGetMetadataBlank() {
        assertNull(leadsDao.getMetadata(new LeadFeedData(), "", "X"));
    }

    @Test
    public void testGetMetadataInvalid() {
        LeadFeedData leadData = new LeadFeedData();
        leadData.setPartnerReference("REF");
        leadData.setPartnerBrand("TEST");
        CTMCarLeadFeedRequestMetadata result = leadsDao.getMetadata(leadData, "bad=data", "X");
        assertEquals("TEST", result.getProviderCode());
        assertEquals("REF", result.getProviderQuoteRef());
        assertEquals("X", result.getPropensityScore());
    }

    @Test
    public void testGetMetadata() {
        LeadFeedData leadData = new LeadFeedData();
        leadData.setPartnerReference("REF");
        leadData.setPartnerBrand("TEST");

        CTMCarLeadFeedRequestMetadata result = leadsDao.getMetadata(leadData, "{}", "X");
        assertEquals("TEST", result.getProviderCode());
        assertEquals("REF", result.getProviderQuoteRef());
        assertEquals("X", result.getPropensityScore());
    }

    @Test
    public void testCTMLeadsEnabled_true() throws DaoException {
        assertTrue(leadsDao.CTMLeadsEnabled(1));
    }

    @Test
    public void testCTMLeadsEnabled_false() throws DaoException {
        assertFalse(leadsDao.CTMLeadsEnabled(2));
    }


    private void setupMockData() {
        carVertical = new Vertical();
        carVertical.setId(1);
        carVertical.setType(Vertical.VerticalType.CAR);
        carVertical.setName("car");

        homeVertical = new Vertical();
        homeVertical.setId(2);
        homeVertical.setType(Vertical.VerticalType.HOME);
        homeVertical.setName("home");


        ArrayList<Vertical> verticalList = new ArrayList<Vertical>() {{
            add(homeVertical);
            add(carVertical);
        }};

        budgetBrand = new Brand();
        budgetBrand.setId(1);
        budgetBrand.setName("Budget");
        budgetBrand.setCode("BUDD");
        budgetBrand.setVerticals(verticalList);

        testBrand = new Brand();
        testBrand.setId(2);
        testBrand.setName("Testing");
        testBrand.setCode("TEST");
        testBrand.setVerticals(verticalList);

        multiBrand = new Brand();
        multiBrand .setId(3);
        multiBrand .setName("MultiLead");
        multiBrand .setCode("MULTI");
        multiBrand .setVerticals(verticalList);

        ctmTran = new LeadFeedRootTransaction(1L, 1L);
        ctmTran.setStyleCode("BUDD");
        ctmTran.setHasLeadFeed(false);

        ctmTranNoFeed = new LeadFeedRootTransaction(1L, 1L);
        ctmTranNoFeed.setStyleCode("BUDD");
        ctmTranNoFeed.setHasLeadFeed(true);

        multiTran1 = new LeadFeedRootTransaction(2L, 2L);
        multiTran1.setStyleCode("BUDD");
        multiTran1.setHasLeadFeed(true);

        multiTran2 = new LeadFeedRootTransaction(3L, 3L);
        multiTran2.setStyleCode("BUDD");
        multiTran2.setHasLeadFeed(true);

        otherTran = new LeadFeedRootTransaction(1L, 1L);
        otherTran.setStyleCode("TEST");
        otherTran.setHasLeadFeed(false);

        serverDate = new Date();
        ctmPartners = new ArrayList<String>() {{
            add("BUDD");
        }};

        ctmConcatString = "a||b||c||d||{\"firstName\":\"test\",\"address\":{\"state\":\"QLD\"}}||{\"type\":\"lead\",\"providerCode\":\"BUDD\",\"propensityScore\":\"a\"}";
        tooShortConcatString = "\"a||b||c";
        noPhoneConcatString = "a||||c||d||{\"firstName\":\"test\",\"address\":{\"state\":\"QLD\"}}||{\"type\":\"lead\",\"providerCode\":\"BUDD\",\"propensityScore\":\"a\"}";
        otherConcatString = "a||b||c||d";

    }

    private void setupMockBehaviour() throws DaoException, SQLException, ServiceConfigurationException, NamingException {

        when(config.getCtmPartners()).thenReturn(ctmPartners);

        when(verticalDao.getVerticalByCode("CAR")).thenReturn(carVertical);
        when(verticalDao.getVerticalByCode("HOME")).thenReturn(homeVertical);
        when(activeProvidersService.getActiveProvidersString(1, serverDate)).thenReturn("BUDD|TEST");
        when(activeProvidersService.getActiveProvidersString(2, serverDate)).thenReturn(null);

        when(invalidLeadTooShort.getLong("rootId")).thenReturn(1L);
        when(invalidLeadTooShort.getLong("transactionId")).thenReturn(1L);
        when(invalidLeadTooShort.getString("leadInfo")).thenReturn(tooShortConcatString);
        when(invalidLeadTooShort.getString("person")).thenReturn("{\"firstname\":\"test\",\"address\":{\"state\":\"QLD\"}}");
        when(invalidLeadTooShort.getString("productId")).thenReturn("X");
        when(invalidLeadTooShort.getString("moreInfoProductCode")).thenReturn("X");
        when(invalidLeadTooShort.getString("followupIntended")).thenReturn("X");
        when(invalidLeadTooShort.getString("brandCode")).thenReturn("TEST");
        when(invalidLeadTooShort.getString("styleCode")).thenReturn("TEST");
        when(invalidLeadTooShort.getString("type")).thenReturn("X");
        when(invalidLeadTooShort.next()).thenReturn(true, false, true, false, true, false, true, false, true, false);

        when(invalidLeadNoPhone.getLong("rootId")).thenReturn(1L);
        when(invalidLeadNoPhone.getLong("transactionId")).thenReturn(1L);
        when(invalidLeadNoPhone.getString("leadInfo")).thenReturn(noPhoneConcatString);
        when(invalidLeadNoPhone.getString("person")).thenReturn("{\"firstname\":\"test\",\"address\":{\"state\":\"QLD\"}}");
        when(invalidLeadNoPhone.getString("productId")).thenReturn("X");
        when(invalidLeadNoPhone.getString("moreInfoProductCode")).thenReturn("X");
        when(invalidLeadNoPhone.getString("followupIntended")).thenReturn("X");
        when(invalidLeadNoPhone.getString("brandCode")).thenReturn("TEST");
        when(invalidLeadNoPhone.getString("type")).thenReturn("X");
        when(invalidLeadNoPhone.getString("styleCode")).thenReturn("TEST");

        when(invalidLeadNoPhone.next()).thenReturn(true, false, true, false, true, false, true, false, true, false);

        when(serviceConfiguration.getPropertyValueByKey("enabled", 1, 0, ServiceConfigurationProperty.Scope.SERVICE)).thenReturn("true");
        when(serviceConfiguration.getPropertyValueByKey("enabled", 2, 0, ServiceConfigurationProperty.Scope.SERVICE)).thenReturn(null);

        mockStatic(ApplicationService.class);
        when(ApplicationService.getBrandByCode("BUDD")).thenReturn(budgetBrand);
        when(ApplicationService.getBrandByCode("TEST")).thenReturn(testBrand);


        mockStatic(ServiceConfigurationService.class);
        when(ServiceConfigurationService.getServiceConfiguration("leadService", CTMCarLeadFeedService.CAR_VERTICAL_ID))
                .thenReturn(serviceConfiguration);

        ReflectionTestUtils.setField(leadsDao, "leadsRepository", leadsRepository);
        ReflectionTestUtils.setField(leadsDao, "activeProvidersService", activeProvidersService);
        ReflectionTestUtils.setField(leadsDao, "verticalDao", verticalDao);
        ReflectionTestUtils.setField(leadsDao, "config", config);
        ReflectionTestUtils.setField(leadsDao, "transactionsService", new TransactionsService());

    }
}