package com.ctm.web.core.leadfeed.services;


import com.ctm.web.core.model.leadfeed.LeadFeedRootTransaction;
import lombok.Getter;
import lombok.Setter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
@Getter
@Setter
public class TransactionsService {

    ArrayList<LeadFeedRootTransaction> transactions = new ArrayList<>();
    Map<Long, Integer> indexedRoots = new HashMap<>();

    private final ArrayList<String> HAS_LEAD_FEED_TYPES = new ArrayList<String>(){{
        add("a");
        add("bp");
        add("cb");
    }};
    private static final Logger LOGGER = LoggerFactory.getLogger(TransactionsService.class);

    /**
     * convert a result set to a List of `LeadFeedRootTransaction`s
     *
     * @param set
     */
    public void addAllTransactions(ResultSet set){
        try {
            while (set.next()) {
                addTransaction(set);
            }
        } catch(SQLException error){
            error.printStackTrace();
            log("error", error);
        }
    }

    /**
     * Create or retrieve a single LeadFeedRootTransaction from a record in a result set and update it's transactions.
     *
     * @param set
     */
    public void addTransaction(ResultSet set){
        try {
            Long rootId = set.getLong("rootId");
            Long transactionId = set.getLong("transactionId");
            String type = set.getString("type");
            String styleCode = set.getString("styleCode");
            String ipAddress = set.getString("ipAddress");

            LeadFeedRootTransaction transaction = getRootTransaction(rootId, transactionId);

            transaction.setStyleCode(styleCode);
            transaction.setIpAddress(ipAddress);
            transaction.setType(type);

            if (hasLeadFeed(type)) {
                transaction.setHasLeadFeed(true);
                log("skipped", transactionId);
            }
        } catch( SQLException error ){

            error.printStackTrace();
            log("error", error );
        }
    }

    /**
     * Get the index of the root transaction.
     * If the root has not been added yet, create a new LeadFeedRootTransaction and return the new index.
     *
     * @param rootId
     * @param transactionId
     * @return
     */
    public LeadFeedRootTransaction getRootTransaction(Long rootId, Long transactionId){
        Integer rootIndex = indexedRoots.get(rootId);
        if( rootIndex == null){
            rootIndex = transactions.size();
            indexedRoots.put(rootId, rootIndex);
            transactions.add( new LeadFeedRootTransaction(rootId, transactionId) );
        }
        return transactions.get(rootIndex);
    }

    /**
     * Check if the transaction type should be skipped.
     * @param type
     * @return
     */
    private boolean hasLeadFeed(String type){
        return type != null && HAS_LEAD_FEED_TYPES.contains(type.toLowerCase());
    }

    /**
     * Make the logging code a smidgen prettier.
     *
     * @param logtype
     * @param additional
     */
    private void log(String logtype, Object additional){
        switch(logtype){
            case "skipped": LOGGER.info("[Lead info] Skipping existing lead feed transaction {}", kv("transactionId", additional)); break;
            case "error": LOGGER.error("[Lead info] Failed to add lead feed transaction {}", additional); break;
        }
    }
}