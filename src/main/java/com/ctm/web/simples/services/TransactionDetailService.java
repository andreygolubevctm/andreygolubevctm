package com.ctm.web.simples.services;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.formatter.JsonUtils;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.web.go.Data;
import org.json.JSONException;
import org.json.XML;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Optional;
import java.util.function.Function;

/**
 * The type Transaction detail service.
 * <p>
 * Created by xna on 22/08/17.
 */
@Service
public class TransactionDetailService {

    private static final Logger LOGGER = LoggerFactory.getLogger(TransactionDetailService.class);

    @Autowired
    private TransactionDetailsDao transactionDetailsDao;

    /**
     * Gets transaction details as an intance of {@link Data}.
     *
     * @param transactionId the transaction id
     * @return the transaction details in xml data
     * @throws DaoException the dao exception
     */
    public Data getTransactionDetailsInXmlData(Long transactionId) throws DaoException {
        final Data data = new Data();
        transactionDetailsDao.getTransactionDetails(transactionId, null)
                .forEach(txnDetail -> data.put(txnDetail.getXPath(), txnDetail.getTextValue()));
        return data;
    }

    /**
     * Gets transaction details as an intance of {@link Map}.
     *
     * @param transactionId the transaction id
     * @return the transaction details in map
     * @throws DaoException the dao exception
     */
    public Optional<Map<String, Object>> getTransactionDetailsInMap(Long transactionId) throws DaoException {

        // a function to convert xml string to json string
        final Function<String, Optional<String>> convertXmlToJson = (xml) -> {
            try {
                return Optional.of(XML.toJSONObject(xml).toString());
            } catch (JSONException e) {
                LOGGER.error("Failed to convert xml to json. Reason: {}", e.getMessage(), e);
                return Optional.empty();
            }
        };

        // load transaction details data and reformat it to an instance of Map.
        final Optional<Map<String, Object>> optMap = Optional.of(getTransactionDetailsInXmlData(transactionId))
                .map(data -> data.getXML(true))
                .flatMap(convertXmlToJson)
                .map(JsonUtils::convertToMap);

        // trim root node if exists
        final String rootNodeName = "this";
        return optMap.map(m -> m.get(rootNodeName))
                .filter(Map.class::isInstance)
                .map(Map.class::cast);
    }

}