package com.ctm.services.simples;

import org.apache.commons.lang3.StringUtils;
import org.apache.taglibs.standard.tag.common.sql.ResultImpl;

import java.util.ArrayList;
import java.util.List;
import java.util.SortedMap;

/**
 * Created by lbuchanan on 25/02/2015.
 */
public class SimplesSearchService {

    private String hotTransactionIdsCsv;
    private String coldTransactionIdsCsv;

    public void mapResults(ResultImpl transactions , boolean hasHotAndCold){
        SortedMap[] rows = transactions.getRows();
        hotTransactionIdsCsv = "";
        coldTransactionIdsCsv = "";
        List<Long> coldTransactionIds = new ArrayList<>();
        List<Long> hotTransactionIds = new ArrayList<>();
        for(int i = 0 ; i < rows.length ; i++) {
            SortedMap row = rows[i];
            Object id = row.get("id");
            Long transactionId = 0L;
            if(id instanceof Long){
                 transactionId = (Long) id;
            } else if(id instanceof String){
                transactionId = Long.parseLong((String) id);
            }else {
                transactionId = Long.parseLong(id.toString());
            }
            if (hasHotAndCold) {
                if(row.get("tableType").equals("COLD")) {
                    coldTransactionIds.add(transactionId);
                } else {
                    hotTransactionIds.add(transactionId);
                }
            } else {
                hotTransactionIds.add(transactionId);
            }
        }
        hotTransactionIdsCsv = StringUtils.join(hotTransactionIds, ",");
        coldTransactionIdsCsv = StringUtils.join(coldTransactionIds, ",");
    }

    public boolean hasColdTransactions(){
        return !coldTransactionIdsCsv.isEmpty();
    }

    public boolean hasHotTransactions(){
        return !hotTransactionIdsCsv.isEmpty();
    }


    public String getHotTransactionIdsCsv() {
        return hotTransactionIdsCsv;
    }

    public String getColdTransactionIdsCsv() {
        return coldTransactionIdsCsv;
    }
}
