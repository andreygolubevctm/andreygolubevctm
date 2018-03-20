package com.ctm.web.core.services;

import com.ctm.web.core.email.model.EmailMode;
import com.ctm.web.core.email.model.IncomingEmail;
import com.ctm.web.core.email.services.EmailUrlService;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.model.settings.VerticalSettings;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.core.utils.common.utils.DateUtils;
import com.ctm.web.travel.services.TravelService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class RemoteLoadQuoteService {

    private final TransactionDetailsDao transactionDetailsDao;
    private final TransactionAccessService transactionAccessService;

    @Autowired
    private TravelService travelService;

    private static final Logger LOGGER = LoggerFactory.getLogger(RemoteLoadQuoteService.class);

    // do not remove as used by the jsp
    public RemoteLoadQuoteService() {
        transactionDetailsDao = new TransactionDetailsDao();
        transactionAccessService = new TransactionAccessService();
    }

    public RemoteLoadQuoteService(TransactionAccessService transactionAccessService, TransactionDetailsDao transactionDetailsDao) {
        this.transactionAccessService = transactionAccessService;
        this.transactionDetailsDao = transactionDetailsDao;
    }

    public List<TransactionDetail> getTransactionDetails(String hashedEmail, String vertical, String type, String emailAddress, long transactionId, int brandId) throws DaoException {
        List<TransactionDetail> transactionDetails = new ArrayList<>();
        emailAddress = EmailUrlService.decodeEmailAddress(emailAddress);
        LOGGER.debug("Checking details vertical {},{},{},{},{}", kv("vertical", vertical), kv("type", type), kv("emailAddress", emailAddress),
                kv("transactionId", transactionId), kv("brandId", brandId));
        EmailMode emailMode = EmailMode.findByCode(type);
        VerticalType verticalType = VerticalType.findByCode(vertical);
        IncomingEmail emailData = new IncomingEmail();
        emailData.setEmailAddress(emailAddress);
        emailData.setEmailHash(hashedEmail);
        emailData.setTransactionId(transactionId);
        emailData.setEmailType(emailMode);
        if (transactionAccessService.hasAccessToTransaction(emailData, brandId, verticalType)) {
            transactionDetails = transactionDetailsDao.getTransactionDetails(transactionId, vertical);
            // Get DOBs and generate ages for new xpath
            if (VerticalType.TRAVEL == verticalType) {

                TransactionDetail newTransactionDetail = transactionDetails.stream()
                        .filter(td -> Arrays.asList("travel/travellers/traveller1DOB", "travel/travellers/traveller2DOB").contains(td.getXPath()))
                        .filter(td -> StringUtils.isNotBlank(td.getTextValue()))
                        .map(td -> DateUtils.parseStringToLocalDate(td.getTextValue()))
                        .map(td -> DateUtils.getAgeFromDateOfBirth(td))
                        .map(String::valueOf)
                        //Build a new xpath for traveller ages for those transactions that previously stored DOB xpaths
                        .collect(Collectors.collectingAndThen(Collectors.joining(","),
                                //return new TransactionDetail object for transactions with previous DOB xpaths; null otherwise
                                ages -> (StringUtils.isNotEmpty(ages)) ? new TransactionDetail("travel/travellers/travellersAge", ages) : null
                        ));
                if (newTransactionDetail != null) {
                    transactionDetails.add(newTransactionDetail);
                }
            }
        }
        return transactionDetails;
    }


    public String getActionQuoteUrl(String vertical, String action, Long transactionId, String jParam, String trackingParams) {
        return VerticalSettings.getHomePageJsp(vertical) + "?action=" + action + "&amp;transactionId=" + transactionId + jParam + trackingParams;
    }

    public String getActionQuoteUrlForcedBrandCode(String vertical, String action, Long transactionId, String jParam, String trackingParams, String forcedBrandCode) {
        return VerticalSettings.getHomePageJsp(vertical) + "?action=" + action + "&amp;transactionId=" + transactionId + "&amp;brandCode=" + forcedBrandCode + jParam + trackingParams;
    }

    public String getStartAgainQuoteUrl(String vertical, Long transactionId, String jParam, String trackingParams) {
        return getActionQuoteUrl(vertical, "start-again", transactionId, jParam, trackingParams);
    }

    public String getLatestQuoteUrl(String vertical, Long transactionId, String jParam, String trackingParams) {
        return getActionQuoteUrl(vertical, "latest", transactionId, jParam, trackingParams);
    }


}
