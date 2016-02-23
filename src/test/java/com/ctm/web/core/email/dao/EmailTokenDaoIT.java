package com.ctm.web.core.email.dao;

import com.ctm.data.BaseDaoTest;
import com.ctm.data.common.TestMariaDbBean;
import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static junit.framework.TestCase.assertNotNull;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = {EmailTokenDao.class, TestMariaDbBean.class, SimpleDatabaseConnection.class})
@ActiveProfiles({"test"})
public class EmailTokenDaoIT extends BaseDaoTest {

    @Autowired
    private EmailTokenDao emailTokenDao;
    private Long transactionId = 1000L;
    private Long emailId = 1000L;
    private String emailTokenType = "brochures";
    private String action = "load";

    //@Test
    public void testAddEmailToken() throws Exception {
        emailTokenDao.addEmailToken( transactionId,  emailId,  emailTokenType,  action);
         assertNotNull(emailTokenDao.getEmailDetails( transactionId,  emailId,  emailTokenType,  action));

        // should not fall over on trying to add the same token
        emailTokenDao.addEmailToken( transactionId,  emailId,  emailTokenType,  action);
         assertNotNull(emailTokenDao.getEmailDetails( transactionId,  emailId,  emailTokenType,  action));
    }
}