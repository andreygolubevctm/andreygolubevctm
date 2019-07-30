package com.ctm.web.core.messagequeue;

import com.ctm.web.core.transaction.dao.TransactionDao;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.mockito.MockitoAnnotations.initMocks;
import javax.naming.NamingException;
import java.sql.SQLException;
import java.util.Arrays;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {MessageController.class,ObjectMapper.class,TransactionDao.class})
public class MessageControllerTest {

    @Mock
    private TransactionDao transactionDao;
    @Bean
    private ObjectMapper objectMapper(){
        return new ObjectMapper();
    }
    @InjectMocks
    @Autowired
    private MessageController messageController;

    @Before
    public void setup() throws SQLException, NamingException {
        initMocks(this);
    }

    @Test
    public void TestValidHealthUpdate() throws Exception {
        JourneyUpdate journeyUpdate = new JourneyUpdate();
        journeyUpdate.setSessionId("test");
        journeyUpdate.setUserId("user");
        journeyUpdate.setSources(Arrays.asList("health", "car"));

        String result = messageController.JourneyUpdate(journeyUpdate);
        Assert.assertEquals("{\"sources\":[\"health\",\"car\"],\"sessionId\":\"test\",\"userId\":\"user\"}", result);
    }

    @Test
    public void TestValidTravelUpdate() throws Exception {
        JourneyUpdate journeyUpdate = new JourneyUpdate();
        journeyUpdate.setSessionId("test");
        journeyUpdate.setUserId("user");
        journeyUpdate.setSources(Arrays.asList("travel", "car"));

        String result = messageController.JourneyUpdate(journeyUpdate);
        Assert.assertEquals("{\"sources\":[\"travel\",\"car\"],\"sessionId\":\"test\",\"userId\":\"user\"}", result);
    }

    @Test
    public void TestInvalidResource() throws Exception {
        JourneyUpdate journeyUpdate = new JourneyUpdate();
        journeyUpdate.setSessionId("test");
        journeyUpdate.setUserId("user");
        journeyUpdate.setSources(Arrays.asList("car"));

        String result = messageController.JourneyUpdate(journeyUpdate);
        Assert.assertNull(result);
    }


    @Test
    public void TestInvalidSession() throws Exception {
        JourneyUpdate journeyUpdate = new JourneyUpdate();
        journeyUpdate.setSessionId("");
        journeyUpdate.setUserId("user");
        journeyUpdate.setSources(Arrays.asList("health"));

        String result = messageController.JourneyUpdate(journeyUpdate);
        Assert.assertNull(result);
    }

    @Test
    public void TestInvalidUser() throws Exception {
        JourneyUpdate journeyUpdate = new JourneyUpdate();
        journeyUpdate.setSessionId("test");
        journeyUpdate.setUserId("");
        journeyUpdate.setSources(Arrays.asList("health"));

        String result = messageController.JourneyUpdate(journeyUpdate);
        Assert.assertNull(result);
    }


    @Test
    public void TestNullSession() throws Exception {
        JourneyUpdate journeyUpdate = new JourneyUpdate();

        journeyUpdate.setUserId("user");
        journeyUpdate.setSources(Arrays.asList("health"));

        String result = messageController.JourneyUpdate(journeyUpdate);
        Assert.assertNull(result);
    }

    @Test
    public void TestNullUser() throws Exception {
        JourneyUpdate journeyUpdate = new JourneyUpdate();
        journeyUpdate.setSessionId("test");

        journeyUpdate.setSources(Arrays.asList("health"));

        String result = messageController.JourneyUpdate(journeyUpdate);
        Assert.assertNull(result);
    }
}
