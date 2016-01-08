package com.ctm.web.core.services;

import com.ctm.web.core.dao.TouchRepository;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Touch;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class TouchServiceBean {

    private static final Logger LOGGER = LoggerFactory.getLogger(TouchServiceBean.class);

    @Autowired
    private TouchRepository touchRepository;

    public boolean recordTouch(final Touch touch){
        try {
            touchRepository.store(touch);
            return true;
        } catch(Exception e) {
            // Failing to write the touch shouldn't be fatal - let's just log an error
            LOGGER.warn("Failed to record {} {}", kv("touch",touch.getType()), kv("transactionId", touch.getTransactionId()));
            return false;
        }
    }

}
