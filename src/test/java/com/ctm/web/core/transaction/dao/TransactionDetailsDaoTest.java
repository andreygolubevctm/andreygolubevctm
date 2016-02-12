package com.ctm.web.core.transaction.dao;

import com.ctm.data.BaseDaoTest;
import com.ctm.data.common.TestMariaDbBean;
import com.ctm.web.core.dao.SqlDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.Optional;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = {TransactionDetailsDao.class, TestMariaDbBean.class, SqlDao.class})
@ActiveProfiles({"test"})
public class TransactionDetailsDaoTest extends BaseDaoTest {

    @Autowired
    private TransactionDetailsDao transactionDetailsDao;
    private long transactionId = 1000L;
    private String xpath = "%/detail/where/xpath/like";

    @Test
    public void testTransactionDetailWhereXpathLike() throws Exception {
        Optional<TransactionDetail> transactionDetails = transactionDetailsDao.getTransactionDetailWhereXpathLike(transactionId, xpath);
        assertTrue(transactionDetails.isPresent());
    }

    public void testTransactionDetailWhereXpathLikeNoMatch() throws Exception {
        Optional<TransactionDetail> transactionDetails = transactionDetailsDao.getTransactionDetailWhereXpathLike(transactionId, "no match");
        assertFalse(transactionDetails.isPresent());
    }
}