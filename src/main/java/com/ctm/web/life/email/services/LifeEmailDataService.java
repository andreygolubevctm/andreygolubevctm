package com.ctm.web.life.email.services;

import com.ctm.web.core.dao.RankingDetailsDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.RankingDetail;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.life.dao.OccupationsDao;
import com.ctm.web.life.model.Occupation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class LifeEmailDataService {

    private static final Logger LOGGER = LoggerFactory.getLogger(LifeEmailDataService.class);

    private final RankingDetailsDao rdDao;
    private final OccupationsDao oDao;
    private final TransactionDetailsDao tdDao;

    @Autowired
    public LifeEmailDataService(RankingDetailsDao rdDao, TransactionDetailsDao tdDao, OccupationsDao oDao) {
        this.rdDao = rdDao;
        this.tdDao = tdDao;
        this.oDao = oDao;
    }

    /**
     * Because Life sends out the best price email as part of a CRON job (instead of on a user's activity)
     * we need to manually grab the data for the requested transaction as there is no active session
     * @param transactionId
     * @return
     */
    public Data getDataObject(long transactionId) {
        Data data = new Data();
        List<TransactionDetail> transactionDetails = null;
        try {
            transactionDetails = tdDao.getTransactionDetails(transactionId, null);
        } catch (DaoException e1) {
            LOGGER.error("Could not populate life email data object with transaction details {}", kv("transactionId", transactionId), e1);
        }

        for(TransactionDetail detail : transactionDetails) {
            data.put(detail.getXPath(), detail.getTextValue());
        }

        try {
            List<RankingDetail> rankingDetails = rdDao.getDetailsByPropertyValue(transactionId, "company", "ozicare");
            RankingDetail rankingDetail = rankingDetails.get(0);
            Map<String, String> rankingDetailProperties = rankingDetail.getProperties();
            for (Map.Entry<String, String> property : rankingDetailProperties.entrySet()) {
                String key = property.getKey();
                Object value = property.getValue();
                data.put("life/rankingDetails/" + key, value);
            }
        } catch (DaoException e1) {
            LOGGER.error("Could not populate life email data object with ranking details {}", kv("transactionId", transactionId), e1);
        }
        Occupation occupation = oDao.getOccupation((String) data.get("life/primary/occupation"));
        data.put("life/primary/occupationName", occupation.getTitle());

        return data;
    }
}
