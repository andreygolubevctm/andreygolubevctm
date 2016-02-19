package com.ctm.web.core.email.dao;

import com.ctm.data.BaseDaoTest;
import com.ctm.data.common.TestMariaDbBean;
import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.assertEquals;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = {EmailTokenDao.class, TestMariaDbBean.class, SimpleDatabaseConnection.class})
@ActiveProfiles({"test"})
public class EmailTokenDaoTest extends BaseDaoTest {

    @Autowired
    private EmailTokenDao emailTokenDao;
    private Long transactionId = 1000L;
    private Long emailId = 1000L;
    private String emailTokenType = "brochures";
    private String action = "load";

    @Test
    public void testAddEmailToken() throws Exception {
        int count = emailTokenDao.getEmailTokenCount(transactionId,  emailId,  emailTokenType,  action);
        emailTokenDao.addEmailToken( transactionId,  emailId,  emailTokenType,  action);
        assertEquals(count + 1 , emailTokenDao.getEmailTokenCount(transactionId,  emailId,  emailTokenType,  action));

        emailTokenDao.addEmailToken( transactionId,  emailId,  emailTokenType,  action);
        assertEquals(count + 1 , emailTokenDao.getEmailTokenCount(transactionId,  emailId,  emailTokenType,  action));
    }
}