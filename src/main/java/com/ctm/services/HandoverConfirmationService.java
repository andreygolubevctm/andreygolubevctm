package com.ctm.services;

import com.ctm.dao.HandoverConfirmationDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.HandoverConfirmation;
import com.ctm.model.settings.Vertical.VerticalType;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;

import static com.ctm.model.Touch.TouchType.SOLD;
import static java.lang.Integer.parseInt;
import static java.lang.Long.parseLong;

public class HandoverConfirmationService {
    private final Logger logger = Logger.getLogger(HandoverConfirmationService.class.getName());
    private final AccessTouchService accessTouchService;
    private final HandoverConfirmationDao handoverConfirmationDao;

    public HandoverConfirmationService() {
        this.accessTouchService = new AccessTouchService();
        this.handoverConfirmationDao = new HandoverConfirmationDao();
    }

    public HandoverConfirmationService(final AccessTouchService accessTouchService, final HandoverConfirmationDao handoverConfirmationDao) {
        this.accessTouchService = accessTouchService;
        this.handoverConfirmationDao = handoverConfirmationDao;
    }

    public void confirm(final HandoverConfirmation handoverConfirmation) throws DaoException {
        if (!accessTouchService.hasTouch(handoverConfirmation.transactionId, SOLD)) {
            accessTouchService.recordTouch(handoverConfirmation.transactionId, SOLD.getCode());
        } else {
            logger.info("existing sold touch already recorded transactionId:" + handoverConfirmation.transactionId);
        }

        if (!handoverConfirmationDao.hasExistingConfirmationWithPolicy(handoverConfirmation)) {
            handoverConfirmationDao.recordConfirmation(handoverConfirmation);
        } else {
            logger.info("handover confirmation already recorded transactionId:" + handoverConfirmation.transactionId);
        }
    }

    public HandoverConfirmation createConfirmation(final Map<String, String[]> values, final String ip) {
        final VerticalType vertical = VerticalType.findByCode(stringValue(values, "v"));
        final int providerId = parseInt(stringValue(values, "pid"));
        final String policyNo = truncateStringValue(values, "policyno");
        final BigDecimal premium = new BigDecimal(stringValue(values, "premium"));
        final String policyType = truncateStringValue(values, "type");
        final String policyName = truncateStringValue(values, "name");
        final Date createTime = base36DateValue(values, "c");
        final Date updateTime = base36DateValue(values, "u");
        final String productCode = truncateStringValue(values, "pd");
        final long tid = parseLong(stringValue(values, "tid"));
        final String sent = stringValue(values, "sent");
        final boolean test = parseTestValue(values, "test");
        return new HandoverConfirmation(createTime, updateTime, policyNo, policyType, policyName, premium, productCode,
                providerId, vertical, tid, ip, sent, test);
    }

    private boolean parseTestValue(final Map<String, String[]> values, final String key) {
        final String value = stringValue(values, key);
        return value != null && value.equalsIgnoreCase("1");
    }

    private Date base36DateValue(final Map<String, String[]> parameterMap, final String key) {
        final String value = stringValue(parameterMap, key);
        return value == null ? null : new Date(parseLong(value, 36)*1000);
    }

    private String stringValue(final Map<String, String[]> parameterMap, final String key) {
        final String[] values = parameterMap.get(key);
        return values == null ? null : values[0];
    }

    // deliberately truncate values so that we don't fail if string is too long for some key values
    private String truncateStringValue(final Map<String, String[]> parameterMap, final String key) {
        return StringUtils.left(stringValue(parameterMap, key), 128);
    }

}
