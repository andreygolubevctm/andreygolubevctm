package com.ctm.web.simples.services;


import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.simples.model.ConfirmationOperator;
import com.ctm.web.simples.dao.SimplesTransactionDao;

import java.util.List;

public class SimplesTransactionService {

    /**
     * Find if any transaction chained from the provided Root ID is confirmed (sold).
     * @param rootIds
     * @return Not null if confirmed
     */
    public ConfirmationOperator findConfirmationByRootId(List<Long> rootIds) throws DaoException {
        SimplesTransactionDao simplesTransactionDao = new SimplesTransactionDao();
        return simplesTransactionDao.getConfirmationFromTransactionChain(rootIds);
    }
}
