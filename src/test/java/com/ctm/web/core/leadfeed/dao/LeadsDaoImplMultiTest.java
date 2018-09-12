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
public class LeadsDaoImplMultiTest {

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
    ResultSet validMultiTran;
    @Mock
    ResultSet validMultiLead;


    @Mock
    private ServiceConfiguration serviceConfiguration;

    private Date serverDate;

    private LeadFeedRootTransaction multiTran1;
    private LeadFeedRootTransaction multiTran2;
    private LeadFeedRootTransaction multiTran3;
    private Vertical carVertical;
    private List<String> ctmPartners;
    private Brand budgetBrand;
    private String ctmConcatString;

    @Before
    public void setUp() throws DaoException, SQLException, ServiceConfigurationException, NamingException {

        initMocks(this);
        setupMockData();
        setupMockBehaviour();


    }


    @Test
    public void testGetLeads_multi() throws DaoException {
        ArrayList<LeadFeedData> result = leadsDao.getLeads(1, "CAR", 1, serverDate);

        // Mocked data will send through three trans in total; two valid and one skippable trans records.
        assertEquals(2, result.size());

        LeadFeedData lead1 = result.get(0);
        assertNotNull(lead1);
        assertEquals(1, lead1.getBrandId().intValue());
        assertEquals("c", lead1.getIdentifier());
        assertEquals("b", lead1.getPhoneNumber());
        assertEquals("BUDD", lead1.getPartnerBrand());

        LeadFeedData lead2 = result.get(1);
        assertNotNull(lead2);
        assertEquals(1, lead2.getBrandId().intValue());
        assertEquals("c", lead2.getIdentifier());
        assertEquals("b", lead2.getPhoneNumber());
        assertEquals("BUDD", lead2.getPartnerBrand());

    }

    private void setupMockData() {
        carVertical = new Vertical();
        carVertical.setId(1);
        carVertical.setType(Vertical.VerticalType.CAR);
        carVertical.setName("car");

        ArrayList<Vertical> verticalList = new ArrayList<Vertical>() {{
            add(carVertical);
        }};

        budgetBrand = new Brand();
        budgetBrand.setId(1);
        budgetBrand.setName("Budget");
        budgetBrand.setCode("BUDD");
        budgetBrand.setVerticals(verticalList);

        multiTran1 = new LeadFeedRootTransaction(2L, 2L);
        multiTran1.setStyleCode("BUDD");
        multiTran1.setHasLeadFeed(true);
        multiTran1.setType("R");

        multiTran2 = new LeadFeedRootTransaction(3L, 3L);
        multiTran2.setStyleCode("BUDD");
        multiTran2.setHasLeadFeed(true);
        multiTran2.setType("R");

        multiTran3 = new LeadFeedRootTransaction(4L, 4L);
        multiTran3.setStyleCode("BUDD");
        multiTran3.setHasLeadFeed(true);
        multiTran3.setType("BP");

        serverDate = new Date();
        ctmPartners = new ArrayList<String>() {{
            add("BUDD");
        }};

        ctmConcatString = "a||b||c||d||{\"firstName\":\"test\",\"address\":{\"state\":\"QLD\"}}||{\"type\":\"lead\",\"providerCode\":\"BUDD\",\"propensityScore\":\"a\"}";

    }

    private void setupMockBehaviour() throws DaoException, SQLException, ServiceConfigurationException, NamingException {

        when(config.getCtmPartners()).thenReturn(ctmPartners);

        when(verticalDao.getVerticalByCode("CAR")).thenReturn(carVertical);
        when(activeProvidersService.getActiveProvidersString(1, serverDate)).thenReturn("BUDD|TEST");
        when(activeProvidersService.getActiveProvidersString(2, serverDate)).thenReturn(null);

        when(validMultiTran.getLong("rootId")).thenReturn(2L, 3L, 4L);
        when(validMultiTran.getLong("transactionId")).thenReturn(2L, 3L, 4L);
        when(validMultiTran.getString("styleCode")).thenReturn("BUDD");
        when(validMultiTran.getString("type")).thenReturn("R", "R", "BP");
        when(validMultiTran.next()).thenReturn(true, true, false);

        when(validMultiLead.getLong("transactionId")).thenReturn(2L, 3L, 4L);
        when(validMultiLead.getString("leadNo")).thenReturn("1", "2", "3");
        when(validMultiLead.getString("leadInfo")).thenReturn(ctmConcatString);
        when(validMultiLead.getString("productId")).thenReturn("X");
        when(validMultiLead.getString("moreInfoProductCode")).thenReturn("X");
        when(validMultiLead.getString("followupIntended")).thenReturn("X");
        when(validMultiLead.getString("brandCode")).thenReturn("BUDD");
        when(validMultiLead.next()).thenReturn(true, false,true, false);

        when(leadsRepository.getRawTransactions("CAR", 1)).thenReturn(validMultiTran);

        when(leadsRepository.getAggregateLeadData(eq(multiTran1), eq("BUDD|TEST"))).thenReturn(validMultiLead);
        when(leadsRepository.getAggregateLeadData(eq(multiTran2), eq("BUDD|TEST"))).thenReturn(validMultiLead);
        when(leadsRepository.getAggregateLeadData(eq(multiTran3), eq("BUDD|TEST"))).thenReturn(validMultiLead);

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
