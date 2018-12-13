package com.ctm.web.health.duplicateTransCheck.model.response;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.health.dao.HealthDetectMatchingTransactionsDao;
import com.ctm.web.health.model.HealthDuplicateTransaction;

import java.util.ArrayList;

public final class DuplicateTransactionsCheckDetails {

    private Boolean hasDuplicateTransactions;
	private String transactionId;
	private String rootId;
	private String fullName;
	private String date;
	private String time;
	private String operatorId;

    public DuplicateTransactionsCheckDetails(Boolean hasDuplicateTransactions, String transactionId, String rootId, String fullName, String date, String time, String operatorId) {
        this.hasDuplicateTransactions = hasDuplicateTransactions;
        this.transactionId = transactionId;
        this.rootId = rootId;
        this.fullName = fullName;
        this.date = date;
        this.time = time;
        this.operatorId = operatorId;
    }

    public static DuplicateTransactionsCheckDetails checkDuplicates(String rootId, String transactionId, String emailAddress, String fullAddress, String mobile, String homePhone) {
        HealthDetectMatchingTransactionsDao detectMatchingTransactionsDao;
        detectMatchingTransactionsDao = new HealthDetectMatchingTransactionsDao();
        ArrayList<HealthDuplicateTransaction> result = new ArrayList<>();
        try {
            result = detectMatchingTransactionsDao.checkMatchingTransactions(rootId, transactionId, emailAddress, fullAddress, mobile, homePhone, 1);
        } catch(DaoException e) {
            //Error already logged in DAO
        }

        if (result.size() > 0) {
            return new DuplicateTransactionsCheckDetails(true, result.get(0).getTransactionId(), result.get(0).getRootId(), result.get(0).getFullName(), result.get(0).getDate(), result.get(0).getTime(), result.get(0).getOperatorId());
        } else {
            return new DuplicateTransactionsCheckDetails(false, "", "", "", "", "", "");
        }
    }

    public Boolean getHasDuplicateTransactions() {
        return hasDuplicateTransactions;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public String getRootId() {
        return rootId;
    }

    public String getFullName() {
        return fullName;
    }

    public String getDate() {
        return date;
    }

    public String getTime() {
        return time;
    }

    public String getOperatorId() {
        return operatorId;
    }

}
