package com.ctm.web.life.email.services;

import com.ctm.web.core.dao.RankingDetailsDao;
import com.ctm.web.core.model.RankingDetail;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.life.dao.OccupationsDao;
import com.ctm.web.life.model.Occupation;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

import java.util.ArrayList;
import java.util.List;

import static org.hibernate.validator.internal.util.Contracts.assertNotNull;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;


public class LifeEmailDataServiceTest {

    private LifeEmailDataService lifeEmailDataService;

    @Mock
    private RankingDetailsDao rdDao;
    @Mock
    private TransactionDetailsDao tdDao;
    @Mock
    private OccupationsDao oDao;


    private long transactionId = 10000L;
    private List<RankingDetail> rankings;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        lifeEmailDataService = new LifeEmailDataService( rdDao,  tdDao, oDao);
        rankings = new ArrayList<>();
        RankingDetail ranking = new RankingDetail();
        rankings.add(ranking);
        when(rdDao.getDetailsByPropertyValue(transactionId, "company", "ozicare")).thenReturn(rankings);
        Occupation occupation = new Occupation();
        when(oDao.getOccupation(anyString())).thenReturn(occupation);

    }

    @Test
    public void testGetDataObject() throws Exception {
        Data result = lifeEmailDataService.getDataObject(transactionId);
        assertNotNull(result);
    }
}