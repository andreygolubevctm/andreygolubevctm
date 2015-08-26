package com.ctm.services;

import com.ctm.dao.TouchDao;
import com.ctm.dao.transaction.TransactionLockDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.AccessTouch;
import com.ctm.model.Touch;
import com.ctm.model.transaction.TransactionLock;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class AccessCheckService {

	private static final Logger logger = LoggerFactory.getLogger(AccessCheckService.class.getName());

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
        if(transactionLock != null) {
            if (!transactionLock.operatorId.equals(operatorId)) {
                isLocked = true;
            }
            latestTouch.setLockDateTime(transactionLock.lockDateTime);
            latestTouch.setOperator(transactionLock.operatorId);
        }
        return isLocked;
    }

    public boolean handleAccessCheck(long transactionId, String operatorId, String vertical) {
        boolean isLocked = false;
        if(vertical == null || vertical.isEmpty()){
            logger.warn("vertical must have a value default to locked");
        } else if (vertical.equalsIgnoreCase("health")) {
            try {
                isLocked = getIsLockedByTransactionId(transactionId, operatorId);
                if(!isLocked) {
                    createOrUpdateTransactionLock(transactionId, operatorId);
                }
            } catch (DaoException e) {
                logger.error("{}",e);
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


    public boolean isLocked(long transactionId , String operatorId, String vertical) {
        return handleAccessCheck(transactionId, operatorId, vertical);
    }

    private boolean isOperator(String operatorId) {
        return operatorId != null && !operatorId.isEmpty() && !operatorId.equals(Touch.ONLINE_USER);
    }

}
