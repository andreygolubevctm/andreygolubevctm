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


@RunWith(PowerMockRunner.class)
@PrepareForTest({ApplicationService.class, ServiceConfigurationService.class})
public class LeadsDaoImplAngTest {

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

    private LeadFeedRootTransaction otherTran;
    private Vertical carVertical;
    private Vertical homeVertical;
    private List<String> ctmPartners;
    private Brand budgetBrand;
    private Brand testBrand;
    private String ctmConcatString;
    private String otherConcatString;

    @Before
    public void setUp() throws DaoException, SQLException, ServiceConfigurationException, NamingException {

        initMocks(this);
        setupMockData();
        setupMockBehaviour();


    }


    @Test
    public void testGetLeads_otherBrand() throws DaoException {
        ArrayList<LeadFeedData> result = leadsDao.getLeads(2, "CAR", 1, serverDate);
        assertEquals(1, result.size());
        LeadFeedData lead = result.get(0);
        assertNotNull(lead);
        assertEquals(2, lead.getBrandId().intValue());
        assertNull(lead.getPerson());
        assertNull(lead.getMetadata());
        assertEquals("c", lead.getIdentifier());
        assertEquals("b", lead.getPhoneNumber());
        assertEquals("TEST", lead.getPartnerBrand());
    }


    @Test
    public void testProcessTransactionDataOtherLeads() throws SQLException, DaoException, NamingException {
        ReflectionTestUtils.setField(leadsDao, "activeLeadProviders", "BUDD|TEST");
        LeadFeedData lead = leadsDao.processTransactionData("CAR", otherTran, 2);
        assertNotNull(lead);
    }


    @Test
    public void testBuildOtherLead() throws SQLException, DaoException {
        Pair<LeadFeedData, Boolean> result = leadsDao.buildLead("CAR",
                Pair.of(null, true),
                validOtherLead,
                otherTran,
                1);
        assertTrue(result.getRight());
        LeadFeedData lead = result.getLeft();
        assertNotNull(lead);
        assertEquals(2, lead.getBrandId().intValue());
        assertNull(lead.getPerson());
        assertNull(lead.getMetadata());
        assertEquals("c", lead.getIdentifier());
        assertEquals("b", lead.getPhoneNumber());
        assertEquals("TEST", lead.getPartnerBrand());

    }

    @Test
    public void testBuildOtherLead_ctmLengthAggregatedData() throws SQLException, DaoException {
        Pair<LeadFeedData, Boolean> result = leadsDao.buildLead("CAR",
                Pair.of(null, true),
                validOtherLeadWithCTMLength,
                otherTran,
                1);
        assertTrue(result.getRight());
        LeadFeedData lead = result.getLeft();
        assertNotNull(lead);
        assertEquals(2, lead.getBrandId().intValue());
        assertNull(lead.getPerson());
        assertNull(lead.getMetadata());
        assertEquals("c", lead.getIdentifier());
        assertEquals("b", lead.getPhoneNumber());
        assertEquals("TEST", lead.getPartnerBrand());

    }

    @Test
    public void testUpdateToCTMLead_otherLead() throws DaoException {
        LeadFeedData result = leadsDao.updateToCTMLead(new LeadFeedData(), otherConcatString.split("\\|\\|", -1), 1L, "A", 2);
        assertNull(result.getPerson());
        assertNull(result.getMetadata());
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

        otherTran = new LeadFeedRootTransaction(1L, 1L);
        otherTran.setStyleCode("TEST");
        otherTran.setHasLeadFeed(false);
        otherTran.setType("R");

        serverDate = new Date();
        ctmPartners = new ArrayList<String>() {{
            add("BUDD");
        }};

        ctmConcatString = "a||b||c||d||{\"firstName\":\"test\",\"address\":{\"state\":\"QLD\"}}||{\"type\":\"lead\",\"providerCode\":\"BUDD\",\"propensityScore\":\"a\"}";
        otherConcatString = "a||b||c||d";

    }

    private void setupMockBehaviour() throws DaoException, SQLException, ServiceConfigurationException, NamingException {

        when(config.getCtmPartners()).thenReturn(ctmPartners);

        when(verticalDao.getVerticalByCode("CAR")).thenReturn(carVertical);
        when(verticalDao.getVerticalByCode("HOME")).thenReturn(homeVertical);
        when(activeProvidersService.getActiveProvidersString(2, serverDate)).thenReturn(null);

        when(validOtherLead.getLong("rootId")).thenReturn(1L);
        when(validOtherLead.getLong("transactionId")).thenReturn(1L);
        when(validOtherLead.getString("leadInfo")).thenReturn(otherConcatString);
        when(validOtherLead.getString("person")).thenReturn("{\"firstname\":\"test\",\"address\":{\"state\":\"QLD\"}}");
        when(validOtherLead.getString("productId")).thenReturn("X");
        when(validOtherLead.getString("moreInfoProductCode")).thenReturn("X");
        when(validOtherLead.getString("followupIntended")).thenReturn("X");
        when(validOtherLead.getString("brandCode")).thenReturn("TEST");
        when(validOtherLead.getString("styleCode")).thenReturn("TEST");
        when(validOtherLead.getString("type")).thenReturn("R");

        when(validOtherLead.next()).thenReturn(true, false, true, false, true, false, true, false, true, false);

        when(validOtherLeadWithCTMLength.getLong("rootId")).thenReturn(1L);
        when(validOtherLeadWithCTMLength.getLong("transactionId")).thenReturn(1L);
        when(validOtherLeadWithCTMLength.getString("leadInfo")).thenReturn(ctmConcatString);
        when(validOtherLeadWithCTMLength.getString("person")).thenReturn("{\"firstname\":\"test\",\"address\":{\"state\":\"QLD\"}}");
        when(validOtherLeadWithCTMLength.getString("productId")).thenReturn("X");
        when(validOtherLeadWithCTMLength.getString("moreInfoProductCode")).thenReturn("X");
        when(validOtherLeadWithCTMLength.getString("followupIntended")).thenReturn("X");
        when(validOtherLeadWithCTMLength.getString("brandCode")).thenReturn("TEST");
        when(validOtherLeadWithCTMLength.getString("styleCode")).thenReturn("TEST");
        when(validOtherLeadWithCTMLength.getString("type")).thenReturn("R");

        when(validOtherLeadWithCTMLength.next()).thenReturn(true, false, true, false, true, false, true, false, true, false);

        when(leadsRepository.getRawTransactions("CAR", 2)).thenReturn(validOtherLead);
        when(leadsRepository.getAggregateLeadData(eq(otherTran), eq("BUDD|TEST"))).thenReturn(validOtherLead);

        when(serviceConfiguration.getPropertyValueByKey("enabled", 2, 0, ServiceConfigurationProperty.Scope.SERVICE)).thenReturn(null);
        when(activeProvidersService.getActiveProvidersString(1, serverDate)).thenReturn("BUDD|TEST");
        mockStatic(ApplicationService.class);
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