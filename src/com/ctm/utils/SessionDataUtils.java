package com.ctm.utils;

import com.disc_au.web.go.Data;

public class SessionDataUtils {

    public static long getTransactionIdFromTransactionSessionData(Data data) {
        return data.getLong("current/transactionId");
    }
}
