package com.ctm.web.core.services;

import com.ctm.web.core.dao.HandoverConfirmationDao;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.HandoverConfirmation;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.core.model.Touch.TouchType.SOLD;
import static java.lang.Integer.parseInt;
import static java.lang.Long.parseLong;

public class HandoverConfirmationService {
	private static final Logger LOGGER = LoggerFactory.getLogger(HandoverConfirmationService.class);
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
            LOGGER.warn("Existing sold touch already recorded {}", kv("handoverConfirmation", handoverConfirmation));
        }

        if (!handoverConfirmationDao.hasExistingConfirmationWithPolicy(handoverConfirmation)) {
            handoverConfirmationDao.recordConfirmation(handoverConfirmation);
        } else {
            LOGGER.info("Handover confirmation already recorded {}", kv("handoverConfirmation", handoverConfirmation));
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
