package com.ctm.web.core.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.transaction.dao.CallDetailDao;
import com.ctm.web.core.transaction.model.CallDetail;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by pgopisetty on 18/07/2017.
 */
@Service
public class InteractionService {

    private static final Logger LOGGER = LoggerFactory.getLogger(InteractionService.class);

    private CallDetailDao callDetailDao;

    @Autowired
    public InteractionService(CallDetailDao callDetailDao) {
        this.callDetailDao = callDetailDao;
    }

    public void persistInteractionId(final Integer transactionId, final String interactionId) {
        CallDetail callDetail = new CallDetail(interactionId, transactionId);
        try {
            callDetailDao.insert(callDetail);
            LOGGER.info("Persisted  interactionId={} against transactionId={}", interactionId, transactionId);
        } catch (DaoException e) {
            LOGGER.error("Failed to persist interactionId={} against transactionId={}", interactionId, transactionId);
        }
    }
}
