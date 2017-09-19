package com.ctm.web.core.services;

import com.ctm.web.core.dao.TouchDao;
import com.ctm.web.core.transaction.dao.TransactionLockDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.AccessTouch;
import com.ctm.web.core.model.Touch;
import com.ctm.web.core.transaction.model.TransactionLock;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static com.ctm.commonlogging.common.LoggingArguments.kv;


public class AccessCheckService {

	private static final Logger LOGGER = LoggerFactory.getLogger(AccessCheckService.class);

    private final TransactionLockDao transactionLockDao;

    private final TouchDao dao;
    private AccessTouch latestTouch;

    public AccessCheckService(TouchDao dao , TransactionLockDao transactionLockDao) {
        this.dao = dao;
        this.transactionLockDao = transactionLockDao;
    }

    public AccessCheckService() {
        dao = new TouchDao();
        this.transactionLockDao = new TransactionLockDao();
    }

    @SuppressWarnings("unused")
    // This is used in the jsp
    public AccessTouch getLatestTouch() {
        return latestTouch;
    }

    public boolean getIsLockedByTransactionId(long transactionId, String operatorId) throws DaoException {
        Touch touch = dao.getLatestTouchByTransactionId(transactionId);
        latestTouch = new AccessTouch(touch);
        TransactionLock transactionLock = transactionLockDao.getLatest(transactionId);
        boolean isLocked = false;
        // Transactions accessed by non-operator cannot be locked
        if(transactionLock != null && operatorId != null && !operatorId.isEmpty()) {
            if (!transactionLock.operatorId.equals(operatorId)) {
                isLocked = true;
            } else {
                latestTouch.setLockDateTime(transactionLock.lockDateTime);
                latestTouch.setOperator(transactionLock.operatorId);
            }
        }
        return isLocked;
    }

    public boolean handleAccessCheck(long transactionId, String operatorId, String vertical) {
        boolean isLocked = false;
        if(vertical == null || vertical.isEmpty()){
            LOGGER.warn("invalid vertical value, defaulted to locked {}, {}, {}", kv("transactionId", transactionId),
                kv("operatorId", operatorId), kv("vertical", vertical));
        } else if (vertical.equalsIgnoreCase("health")) {
            try {
                isLocked = getIsLockedByTransactionId(transactionId, operatorId);
                if (!isLocked) {
                    createOrUpdateTransactionLock(transactionId, operatorId);
                }
            } catch (DaoException e) {
                LOGGER.error("failed to handle access check {}, {}, {}", kv("transactionId", transactionId),
                    kv("operatorId", operatorId), kv("vertical", vertical), e);
            }
        }
        return isLocked;
    }

    public int getAccessCheckCode(long transactionId, String operatorId, String vertical) {
        return handleAccessCheck( transactionId,  operatorId,  vertical) ? 0 : 1;
    }

    /**
     * Set a lock for this operator and transaction id to prevent other
     * operators from editing the quote for one minute
     * @param transactionId transaction id to lock to this operator uid
     * @param operatorUid ldap username to set the lock to
     * @throws DaoException if unable to a update database
     */
    public void createOrUpdateTransactionLock(Long transactionId, String operatorUid) throws DaoException {
        if(isOperator(operatorUid) && transactionId != null && transactionId > 0){
            transactionLockDao.insert(transactionId,  operatorUid);
        }
    }

    /**
     * Release the lock from the operator and transaction Id to other operators can amend the quote
     * @param transactionId transaction id to unlock to this operator uid
     * @param operatorUid ldap username to release the lock from
     * @throws DaoException if unable to a update database
     */
    public void deleteTransactionLock(Long transactionId, String operatorUid) throws DaoException {
        if(isOperator(operatorUid) && transactionId != null && transactionId > 0){
            transactionLockDao.unlock(transactionId);
        }
    }


    public boolean isLocked(long transactionId , String operatorId, String vertical) {
        return handleAccessCheck(transactionId, operatorId, vertical);
    }

    private boolean isOperator(String operatorId) {
        return operatorId != null && !operatorId.isEmpty() && !operatorId.equals(Touch.ONLINE_USER);
    }

}
