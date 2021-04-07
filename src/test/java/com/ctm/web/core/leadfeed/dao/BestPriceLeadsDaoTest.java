package com.ctm.web.core.leadfeed.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.content.model.ContentSupplement;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.dao.VerticalsDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.leadfeed.model.LeadFeedData;
import com.ctm.web.core.model.leadfeed.LeadFeedRootTransaction;
import com.ctm.web.core.model.settings.Vertical;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.runners.MockitoJUnitRunner;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import static org.mockito.Matchers.*;
import static org.mockito.Mockito.*;

@RunWith(MockitoJUnitRunner.class)
public class BestPriceLeadsDaoTest {

    @Mock
    private SimpleDatabaseConnection simpleDatabaseConnection;

    @Mock
    private VerticalsDao verticalsDao;

    @Mock
    private ContentService contentService;

    @Mock
    private Content content;

    @Mock
    private LeadFeedRootTransaction leadFeedRootTransaction;

    @Mock
    private ResultSet resultSet;

    @Mock
    private Connection connection;

    private ArrayList<ContentSupplement> providersContent = new ArrayList<>();

    private BestPriceLeadsDao bestPriceLeadsDao;

    @Before
    public void setup() throws Exception {
        MockitoAnnotations.initMocks(this);
        when(simpleDatabaseConnection.getConnection()).thenReturn(connection);

        PreparedStatement preparedStatement = mock(PreparedStatement.class);
        when(connection.prepareStatement(anyString())).thenReturn(preparedStatement);

        when(preparedStatement.executeQuery()).thenReturn(resultSet);
        when(resultSet.next()).thenReturn(true).thenReturn(false).thenReturn(true).thenReturn(false);
        when(resultSet.getString("type")).thenReturn("BP");
        when(leadFeedRootTransaction.getHasLeadFeed()).thenReturn(false);

        when(contentService.getContent(anyString(), anyInt(), anyInt(), anyObject(), anyBoolean())).thenReturn(content);
        when(content.getSupplementary()).thenReturn(providersContent);
        when(verticalsDao.getVerticalByCode(anyString())).thenReturn(new Vertical());

        bestPriceLeadsDao = Mockito.spy(new BestPriceLeadsDao());
        doReturn(simpleDatabaseConnection).when(bestPriceLeadsDao).getSimpleDatabaseConnection();
        doReturn(verticalsDao).when(bestPriceLeadsDao).getVerticalsDao();
        doReturn(contentService).when(bestPriceLeadsDao).getContentService();

    }


    @Test
    public void testGetLeadsShouldReturnNoLeadsWhenPhoneNumberIsNull() throws Exception {
        when(resultSet.getString("leadInfo")).thenReturn("test||||info||again||tester||");
        ContentSupplement contentSupplement1 = mock(ContentSupplement.class);
        when(contentSupplement1.getSupplementaryValue()).thenReturn("Y");
        when(contentSupplement1.getSupplementaryKey()).thenReturn("test-key-1");
        providersContent.add(contentSupplement1);

        ContentSupplement contentSupplement2 = mock(ContentSupplement.class);
        when(contentSupplement2.getSupplementaryValue()).thenReturn("Y");
        when(contentSupplement2.getSupplementaryKey()).thenReturn("test-key-2");
        providersContent.add(contentSupplement2);
        ArrayList<LeadFeedData> leads = bestPriceLeadsDao.getLeads(1, "HEALTH", 10, new Date());
        Assert.assertEquals(0, leads.size());
    }

    @Test
    public void testGetLeadsShouldReturnNoLeadsWhenOldLeadIsSent() throws Exception {
        when(resultSet.getString("leadInfo")).thenReturn("test||||info");
        ContentSupplement contentSupplement1 = mock(ContentSupplement.class);
        when(contentSupplement1.getSupplementaryValue()).thenReturn("Y");
        when(contentSupplement1.getSupplementaryKey()).thenReturn("test-key-1");
        providersContent.add(contentSupplement1);

        ContentSupplement contentSupplement2 = mock(ContentSupplement.class);
        when(contentSupplement2.getSupplementaryValue()).thenReturn("Y");
        when(contentSupplement2.getSupplementaryKey()).thenReturn("test-key-2");
        providersContent.add(contentSupplement2);

        ArrayList<LeadFeedData> leads = bestPriceLeadsDao.getLeads(1, "HEALTH", 10, new Date());
        Assert.assertEquals(0, leads.size());
    }

    @Test(expected = DaoException.class)
    public void testGetLeadsShouldReachLoggerWhenActiveProvidersIsEmpty() throws Exception {
        bestPriceLeadsDao.getLeads(1, "HEALTH", 10, new Date());
    }

    @Test(expected = DaoException.class)
    public void testGetLeadsShouldReachLoggerWhenVerticalIsNull() throws Exception {
        bestPriceLeadsDao.getLeads(1, null, 10, new Date());
    }

    @Test
    public void testNewLeadQuotesWithEmptyPhoneNumber() throws SQLException, DaoException {
        when(resultSet.getString("type")).thenReturn("LALA");
        when(resultSet.getString("leadInfo")).thenReturn("test||||some||old||quote||");
        ContentSupplement contentSupplement1 = mock(ContentSupplement.class);
        when(contentSupplement1.getSupplementaryValue()).thenReturn("Y");
        when(contentSupplement1.getSupplementaryKey()).thenReturn("test-key-1");
        providersContent.add(contentSupplement1);

        ContentSupplement contentSupplement2 = mock(ContentSupplement.class);
        when(contentSupplement2.getSupplementaryValue()).thenReturn("Y");
        when(contentSupplement2.getSupplementaryKey()).thenReturn("test-key-2");
        providersContent.add(contentSupplement2);
        ArrayList<LeadFeedData> leads = bestPriceLeadsDao.getLeads(1, "HEALTH", 10, new Date());
        Assert.assertEquals(0, leads.size());

    }

    @Test
    public void testOldLeadQuotes() throws SQLException, DaoException {
        when(resultSet.getString("type")).thenReturn("LALA");
        when(resultSet.getString("leadInfo")).thenReturn("test||345435435||some");
        ContentSupplement contentSupplement1 = mock(ContentSupplement.class);
        when(contentSupplement1.getSupplementaryValue()).thenReturn("Y");
        when(contentSupplement1.getSupplementaryKey()).thenReturn("test-key-1");
        providersContent.add(contentSupplement1);

        ContentSupplement contentSupplement2 = mock(ContentSupplement.class);
        when(contentSupplement2.getSupplementaryValue()).thenReturn("Y");
        when(contentSupplement2.getSupplementaryKey()).thenReturn("test-key-2");
        providersContent.add(contentSupplement2);
        ArrayList<LeadFeedData> leads = bestPriceLeadsDao.getLeads(1, "HEALTH", 10, new Date());
        Assert.assertEquals(0, leads.size());
    }

    @Test(expected = DaoException.class)
    public void testLeadFeedException() throws DaoException {
        when(verticalsDao.getVerticalByCode(anyString())).thenAnswer(invocationOnMock -> {
            throw new NamingException("test-naming-exception message");
        });

        ArrayList<LeadFeedData> leads = bestPriceLeadsDao.getLeads(1, "HEALTH", 10, new Date());
    }

    @Test(expected = DaoException.class)
    public void testWhenNoActiveProviders() throws DaoException {
        ContentSupplement contentSupplement1 = mock(ContentSupplement.class);
        when(contentSupplement1.getSupplementaryValue()).thenReturn("N");
        providersContent.add(contentSupplement1);
        ArrayList<LeadFeedData> leads = bestPriceLeadsDao.getLeads(1, "HEALTH", 10, new Date());
        Assert.assertEquals(0, leads.size());
    }
}
