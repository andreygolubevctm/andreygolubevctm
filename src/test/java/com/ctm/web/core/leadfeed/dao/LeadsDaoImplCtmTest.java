package com.ctm.web.core.leadfeed.dao;

import com.ctm.web.car.leadfeed.services.CTM.CTMCarLeadFeedService;
import com.ctm.web.core.dao.VerticalsDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.leadfeed.config.LeadsConfig;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
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


// PowerMock for static class mocking
@RunWith(PowerMockRunner.class)
@PrepareForTest({ApplicationService.class, ServiceConfigurationService.class})
public class LeadsDaoImplCtmTest {

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
    ResultSet invalidLeadTooShort;
    @Mock
    ResultSet invalidLeadNoPhone;


    @Mock
    private ServiceConfiguration serviceConfiguration;

    private Date serverDate;

    private LeadFeedRootTransaction ctmTran;
    private LeadFeedRootTransaction ctmTranNoFeed;
    private Vertical carVertical;
    private Vertical homeVertical;
    private List<String> ctmPartners;
    private Brand budgetBrand;
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
    public void testGetLeads_budgetBrand() throws DaoException {
        ArrayList<LeadFeedData> result = leadsDao.getLeads(1, "CAR", 1, serverDate);
        assertEquals(1, result.size());
        LeadFeedData lead = result.get(0);
        assertEquals(1, lead.getBrandId().intValue());
        assertEquals("test", lead.getPerson().getFirstName());
        assertNotNull("test", lead.getMetadata());
        assertEquals("c", lead.getIdentifier());
        assertEquals("b", lead.getPhoneNumber());
        assertEquals("BUDD", lead.getPartnerBrand());
    }


    @Test
    public void testProcessTransactionDataCTMLeads() throws SQLException, DaoException, NamingException {
        ReflectionTestUtils.setField(leadsDao, "activeLeadProviders", "BUDD|TEST");
        LeadFeedData lead = leadsDao.processTransactionData("CAR", ctmTran, 1);
        assertNotNull(lead);
    }

    @Test
    public void testBuildCtmLead() throws SQLException, DaoException {
        Pair<LeadFeedData, Boolean> result = leadsDao.buildLead("CAR",
                Pair.of(null, true),
                validCtmLead,
                ctmTran,
                1);
        assertTrue(result.getRight());
        LeadFeedData lead = result.getLeft();
        assertNotNull(lead);
        assertEquals(1, lead.getBrandId().intValue());
        assertEquals("test", lead.getPerson().getFirstName());
        assertNotNull("test", lead.getMetadata());
        assertEquals("c", lead.getIdentifier());
        assertEquals("b", lead.getPhoneNumber());
        assertEquals("BUDD", lead.getPartnerBrand());

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
    public void buildUpdateToCTMLead_ctmLead() throws DaoException {
        LeadFeedData result = leadsDao.updateToCTMLead(new LeadFeedData(), ctmConcatString.split("\\|\\|", -1), 1L, "A", 1);
        assertNotNull(result.getRootId());
        assertEquals(1L, result.getRootId().longValue());
        assertNotNull(result.getPerson());
        assertEquals("test", result.getPerson().getFirstName());
        assertNotNull(result.getMetadata());
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

        ctmTran = new LeadFeedRootTransaction(1L, 1L);
        ctmTran.setStyleCode("BUDD");
        ctmTran.setHasLeadFeed(false);
        ctmTran.setType("R");

        ctmTranNoFeed = new LeadFeedRootTransaction(1L, 1L);
        ctmTranNoFeed.setStyleCode("BUDD");
        ctmTranNoFeed.setHasLeadFeed(true);
        ctmTranNoFeed.setType("R");


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

        when(validCtmTran.getLong("rootId")).thenReturn(1L);
        when(validCtmTran.getLong("transactionId")).thenReturn(1L);
        when(validCtmTran.getString("type")).thenReturn("R");
        when(validCtmTran.getString("styleCode")).thenReturn("BUDD");
        when(validCtmTran.next()).thenReturn(true, false);

        when(validCtmLead.getLong("transactionId")).thenReturn(1L);
        when(validCtmLead.getString("leadNo")).thenReturn("1");
        when(validCtmLead.getString("leadInfo")).thenReturn(ctmConcatString);
        when(validCtmLead.getString("productId")).thenReturn("X");
        when(validCtmLead.getString("moreInfoProductCode")).thenReturn("X");
        when(validCtmLead.getString("followupIntended")).thenReturn("X");
        when(validCtmLead.getString("brandCode")).thenReturn("BUDD");
        when(validCtmLead.next()).thenReturn(true, false);

        when(invalidLeadTooShort.getLong("rootId")).thenReturn(1L);
        when(invalidLeadTooShort.getLong("transactionId")).thenReturn(1L);
        when(invalidLeadTooShort.getString("leadInfo")).thenReturn(tooShortConcatString);
        when(invalidLeadTooShort.getString("person")).thenReturn("{\"firstname\":\"test\",\"address\":{\"state\":\"QLD\"}}");
        when(invalidLeadTooShort.getString("productId")).thenReturn("X");
        when(invalidLeadTooShort.getString("moreInfoProductCode")).thenReturn("X");
        when(invalidLeadTooShort.getString("followupIntended")).thenReturn("X");
        when(invalidLeadTooShort.getString("brandCode")).thenReturn("TEST");
        when(invalidLeadTooShort.getString("styleCode")).thenReturn("TEST");
        when(invalidLeadTooShort.getString("type")).thenReturn("R");
        when(invalidLeadTooShort.next()).thenReturn(true, false, true, false, true, false, true, false, true, false);

        when(invalidLeadNoPhone.getLong("rootId")).thenReturn(1L);
        when(invalidLeadNoPhone.getLong("transactionId")).thenReturn(1L);
        when(invalidLeadNoPhone.getString("leadInfo")).thenReturn(noPhoneConcatString);
        when(invalidLeadNoPhone.getString("person")).thenReturn("{\"firstname\":\"test\",\"address\":{\"state\":\"QLD\"}}");
        when(invalidLeadNoPhone.getString("productId")).thenReturn("X");
        when(invalidLeadNoPhone.getString("moreInfoProductCode")).thenReturn("X");
        when(invalidLeadNoPhone.getString("followupIntended")).thenReturn("X");
        when(invalidLeadNoPhone.getString("brandCode")).thenReturn("TEST");
        when(invalidLeadNoPhone.getString("type")).thenReturn("R");
        when(invalidLeadNoPhone.getString("styleCode")).thenReturn("TEST");

        when(invalidLeadNoPhone.next()).thenReturn(true, false, true, false, true, false, true, false, true, false);


        when(leadsRepository.getRawTransactions("CAR", 1)).thenReturn(validCtmTran);

        when(leadsRepository.getAggregateLeadData(eq(ctmTran), eq("BUDD|TEST"))).thenReturn(validCtmLead);

        when(serviceConfiguration.getPropertyValueByKey("enabled", 1, 0, ServiceConfigurationProperty.Scope.SERVICE)).thenReturn("true");

        mockStatic(ApplicationService.class);
        when(ApplicationService.getBrandByCode("BUDD")).thenReturn(budgetBrand);

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