package com.ctm.web.core.transaction.utils;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TransactionDetailsUtil {

    private static final Logger LOGGER = LoggerFactory.getLogger(TransactionDetailsUtil.class);

    public static final int TEXT_VALUE_LENGTH = 1000;

    /**
     * Checks if the length of the textValue is greater than the TEXT_VALUE_LENGTH then
     * truncates it to the TEXT_VALUE_LENGTH.
     * @param textValue
     * @return
     */
    public static String checkLengthTextValue(String textValue) {
        if (StringUtils.length(textValue) > TEXT_VALUE_LENGTH) {
            LOGGER.warn("TextValue is longer than {}, truncating [{}]", TEXT_VALUE_LENGTH, textValue);
            return StringUtils.left(textValue, TEXT_VALUE_LENGTH);
        }
        return textValue;
    }

}
