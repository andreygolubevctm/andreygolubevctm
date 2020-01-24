package com.ctm.web.core.confirmation.services;

import com.ctm.web.core.dao.JoinDao;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.sql.SQLException;

@Component
public class JoinService {

    private static final Logger LOGGER = LoggerFactory.getLogger(JoinService.class);
    private final JoinDao joinDao;

    public JoinService() {
        this.joinDao = new JoinDao();
    }

    /**
     * Write join details to `ctm`.`joins`
     *
     * @param transactionId
     * @param productId
     * @return joinDate
     * @throws SQLException
     **/
    public boolean writeJoin(long transactionId, String productId, String productCode, String providerId) {
        try {
            return joinDao.writeJoin(transactionId, productId, productCode, providerId);
        } catch (JoinDao.WriteJoinException e) {
            LOGGER.error(String.format("%1$s. productId '%2$s', transactionId '%3$d'", e.getMessage(), e.getProductId(), e.getTransactionId()), e);
            return false;
        }
    }

}
