package com.ctm.web.core.messagequeue;

import com.ctm.web.core.transaction.dao.TransactionDao;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import javax.validation.Valid;

/**
 * In the absence of capability to communicate directly with NATS, this receiver is intended to take messages forwarded
 * from the webctm-passthrough service.
 */
@Api(basePath = "/rest/messagequeue", value = "Message Queue Receiver")
@RestController
@RequestMapping("/rest/messagequeue")
public class MessageController {

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private TransactionDao transactionDao;

    private final String OWN_HEALTH = "health";
    private final String OWN_TRAVEL = "travel";
    @RequestMapping(value = "/",
            method = RequestMethod.POST,
            consumes = {MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/json"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public String JourneyUpdate(@Valid @RequestBody final JourneyUpdate journeyUpdate) throws Exception {
        if ((journeyUpdate.getSources().contains(OWN_HEALTH) || journeyUpdate.getSources().contains(OWN_TRAVEL))
        && journeyUpdate.getSessionId() != null && journeyUpdate.getUserId() != null
        && !journeyUpdate.getSessionId().equals("") && !journeyUpdate.getUserId().equals("")) {
            transactionDao.updateAuthIDs(journeyUpdate.sessionId, journeyUpdate.userId);
            return objectMapper.writeValueAsString(journeyUpdate);
        }
        return null;
    }
}
