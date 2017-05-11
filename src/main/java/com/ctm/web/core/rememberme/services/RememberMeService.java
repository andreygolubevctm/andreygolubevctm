package com.ctm.web.core.rememberme.services;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.security.StringEncryption;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.transaction.dao.TransactionDao;
import com.ctm.web.core.transaction.dao.TransactionDetailsDao;
import com.ctm.web.core.transaction.model.TransactionDetail;
import com.ctm.web.core.web.go.Data;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.security.GeneralSecurityException;
import java.util.*;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class RememberMeService {
    private static final Logger LOGGER = LoggerFactory.getLogger(RememberMeService.class);
    private static final String HEALTH_BENEFITS_BENEFITS_EXTRAS_PREFIX = "health/benefits/benefitsextras";
    private Set<String> WHITE_LIST;
    private static final String COOKIE_SUFFIX = "RememberMe";
    private static final String SECRET_KEY = "ruCSj2WR3a1O1zLMr92rDA==";
    private static final int MAX_AGE = 2592000; // 30 days
    private SessionDataServiceBean sessionDataServiceBean;
    private TransactionDetailsDao transactionDetailsDao;
    private TransactionDao transactionDao;
    private final String HEALTH_XPATH = "health/healthCover/primary/dob";
    private static final Integer maxAttempts = 3;


    @SuppressWarnings("unused")
    public RememberMeService() {
        this.sessionDataServiceBean = new SessionDataServiceBean();
        this.transactionDetailsDao = new TransactionDetailsDao();
        this.transactionDao = new TransactionDao();
        this.WHITE_LIST = new HashSet<>(Arrays.asList(getWhiteList().toLowerCase().split(",")));
    }

    @Autowired
    public RememberMeService(final SessionDataServiceBean sessionDataServiceBean,
                             final TransactionDetailsDao transactionDetailsDao,
                             final TransactionDao transactionDao) {
        this.sessionDataServiceBean = sessionDataServiceBean;
        this.transactionDetailsDao = transactionDetailsDao;
        this.transactionDao = transactionDao;
        this.WHITE_LIST = new HashSet<>(Arrays.asList(getWhiteList().toLowerCase().split(",")));
    }

    public static void setCookie(final String vertical,
                                 final Long transactionId,
                                 final HttpServletResponse response) throws GeneralSecurityException, DaoException, ConfigSettingException {
        final Optional<String> verticalOptional = Optional.ofNullable(vertical);
        final Optional<Long> transactionIdOptional = Optional.ofNullable(transactionId);
        if (verticalOptional.isPresent() && transactionIdOptional.isPresent()) {
            final String cookieName = getCookieName(verticalOptional.get().toLowerCase() + COOKIE_SUFFIX);
            addCookie(response, transactionIdOptional.get(), cookieName);
        }
    }

    private static String getCookieName(String content) throws GeneralSecurityException {
        return StringEncryption.encrypt(SECRET_KEY, content);
    }

    private static void addCookie(HttpServletResponse response, Long transactionId, String cookieName) throws GeneralSecurityException {
        final Cookie cookie = new Cookie(cookieName, StringEncryption.encrypt(SECRET_KEY, transactionId.toString()));
        cookie.setMaxAge(MAX_AGE); // 30 days
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        setCookieDomain(cookie);
        setCookieSecure(cookie);
        response.addCookie(cookie);
    }

    private static void setCookieDomain(final Cookie cookie) {
        switch (EnvironmentService.getEnvironment()) {
            case PRO:
                cookie.setDomain("secure.comparethemarket.com.au");
                break;
        }
    }

    public static String getSecretKey() {
        return SECRET_KEY;
    }

    /**
     * Sends the cookie from the browser to the server only when using a secure protocol, such as HTTPS or SSL,
     * except LOCALHOST and NXI
     */
    private static void setCookieSecure(final Cookie cookie) {
        switch (EnvironmentService.getEnvironment()) {
            case LOCALHOST:
            case NXI:
                break;
            default:
                cookie.setSecure(true);
        }
    }

    /**
     * Used in health_quote_v2.jsp
     */
    @SuppressWarnings("unused")
    public boolean hasRememberMe(final HttpServletRequest request,
                                 final String vertical) throws DaoException, ConfigSettingException {
        try {
            return getRememberMeCookie(request, vertical).isPresent();
        } catch (GeneralSecurityException e) {
            LOGGER.error("Error retrieving cookie for remember me {}", kv("vertical", vertical), e);
        }
        return false;
    }

    private Optional<Cookie> getRememberMeCookie(final HttpServletRequest request,
                                                 final String vertical) throws GeneralSecurityException {
        final String cookieName = getCookieName(vertical.toLowerCase() + COOKIE_SUFFIX);

        if (null != request.getCookies()) {
            return Arrays.stream(request.getCookies())
                    .filter(Objects::nonNull)

                    .filter(cookie -> cookie.getName().equals(cookieName))
                    .findFirst();
        }
        return Optional.empty();
    }

    private Long getCookieTransactionId(final String vertical, final HttpServletRequest request) throws GeneralSecurityException {
        final Optional<Cookie> cookie = getRememberMeCookie(request, vertical);
        if (cookie.isPresent()) {
            return Long.valueOf(StringEncryption.decrypt(SECRET_KEY, cookie.get().getValue()));
        }
        return null;
    }


    @SuppressWarnings("unused")
    public boolean hasPersonalInfoAndLoadData(final HttpServletRequest request,
                                              final HttpServletResponse response,
                                              final String vertical) throws GeneralSecurityException {
        final Optional<Long> rememberMeValue = Optional.ofNullable(getCookieTransactionId(vertical.toLowerCase(), request));
        boolean hasPersonalInfo = false;

        if (rememberMeValue.isPresent()) {
            final List<TransactionDetail> transactionDetails = getTransactionDetails(rememberMeValue.get());
            String xpathToVerify = getXpathToVerifyForVertical(vertical);

            if (transactionDetails != null) {
                hasPersonalInfo = transactionDetails.stream()
                        .anyMatch(details -> details.getXPath().equals(xpathToVerify));
            }

            if (!hasPersonalInfo) {
                loadData(request, rememberMeValue.orElse(null), transactionDetails);
                deleteCookie(vertical, response);
            }
        }

        return hasPersonalInfo;
    }

    public boolean validateAnswerAndLoadData(final String vertical, final String answer,
                                             final HttpServletRequest request) throws GeneralSecurityException {
        final Optional<Long> rememberMeValue = Optional.ofNullable(getCookieTransactionId(vertical.toLowerCase(), request));
        final List<TransactionDetail> transactionDetails;
        boolean isMatch = false;

        if (rememberMeValue.isPresent()) {
            transactionDetails = getTransactionDetails(rememberMeValue.orElse(null));
            String xpathToVerify = getXpathToVerifyForVertical(vertical);
            if (transactionDetails != null) {
                isMatch = transactionDetails.stream()
                        .anyMatch(details -> details.getXPath().equals(xpathToVerify) && details.getTextValue().equals(answer));

            }
            if (isMatch) {
                loadData(request, rememberMeValue.orElse(null), transactionDetails);
            }
        }
        return isMatch;
    }

    public void updateAttemptsCounter(final HttpServletRequest request, final HttpServletResponse response,
                                      final String vertical) throws GeneralSecurityException {
        Integer attemptsCounter = 1;
        HttpSession session = request.getSession();
        String attemptsSessionAttributeName = getAttemptsSessionAttributeName(vertical);
        if (attemptsSessionAttributeName != null) {
            Optional<Integer> attemptsSessionValue = getAttemptsCounterFromSession(session, attemptsSessionAttributeName);
            if (attemptsSessionValue.isPresent()) {
                attemptsCounter = attemptsSessionValue.get() + 1;
                session.setAttribute(attemptsSessionAttributeName, attemptsCounter);
            } else {
                session.setAttribute(attemptsSessionAttributeName, attemptsCounter);
            }
            if (attemptsCounter >= maxAttempts && session != null) {
                removeAttemptsSessionAttribute(vertical, request);
                deleteCookie(vertical, response);
            }
        }
    }

    public void removeAttemptsSessionAttribute(final String vertical, final HttpServletRequest request) {
        HttpSession session = request.getSession();
        if (session != null) {
            session.removeAttribute(getAttemptsSessionAttributeName(vertical));
        }
    }

    private String getAttemptsSessionAttributeName(final String vertical) {
        if (vertical.equals("health")) {
            return "healthAttemptsCount";
        }
        return null;
    }

    private Optional<Integer> getAttemptsCounterFromSession(final HttpSession session, final String attributeName) {
        if (session.getAttribute(attributeName) != null) {
            return Optional.of(Integer.parseInt(session.getAttribute(attributeName).toString()));
        }
        return Optional.empty();
    }

    private void loadData(final HttpServletRequest request, final Long transactionId, final List<TransactionDetail> transactionDetails) {
        Optional.ofNullable(getDataBucket(request, transactionId))
                .map(data -> {
                    transactionDetails.stream()
                            .filter(transactionDetail ->
                                    WHITE_LIST.contains(transactionDetail.getXPath().toLowerCase()) ||
                                            transactionDetail.getXPath().toLowerCase().startsWith(HEALTH_BENEFITS_BENEFITS_EXTRAS_PREFIX))
                            .forEach(transactionDetail -> data.put(transactionDetail.getXPath(), transactionDetail.getTextValue()));
                    return null;
                })
                .orElseGet(() -> {
                    LOGGER.info("populateDataBucket: TranId not found in databucket currentTransactionId={}", transactionId);
                    return null;
                });
    }

    public static Boolean isRememberMeEnabled(PageSettings settings) throws DaoException, ConfigSettingException {
        return settings.getSettingAsBoolean("rememberMeEnabled");
    }

    private List<TransactionDetail> getTransactionDetails(final Long transactionId) {
        try {

            final Long rootId = transactionDao.getRootIdOfTransactionId(transactionId);
            final Long latestTransactionId = transactionDao.getLatestTransactionIdByRootId(rootId);

            return transactionDetailsDao.getTransactionDetails(latestTransactionId);


        } catch (DaoException e) {
            LOGGER.error("populateDataBucket: Error getting transaction details for transactionId {}", kv("transactionId", transactionId), e);
            throw new RuntimeException(e);
        }
    }

    private Data getDataBucket(HttpServletRequest request, Long transactionId) {
        try {
            return sessionDataServiceBean.getDataForTransactionId(request, transactionId.toString(), true);
        } catch (DaoException | SessionException e) {
            LOGGER.error("Error getting data for transactionId {}", kv("transactionId", transactionId), e);
            throw new RuntimeException(e);
        }
    }

    public void deleteCookie(final String vertical, final HttpServletResponse response) throws GeneralSecurityException {
        final String cookieName = getCookieName(vertical.toLowerCase() + COOKIE_SUFFIX);
        final Cookie cookie = new Cookie(cookieName, "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);
    }

    private String getXpathToVerifyForVertical(final String vertical) {
        String xpath = null;
        switch (vertical) {
            case "health":
                xpath = HEALTH_XPATH;
                break;
        }
        return xpath;
    }

    public String getWhiteList() {
        return "health/situation/healthCvr," +
                "health/situation/location," +
                " health/situation/healthSitu," +
                "health/healthCover/primary/dob," +
                "health/healthCover/primary/cover," +
                "health/healthCover/primary/healthCoverLoading," +
                "health/healthCover/partner/dob," +
                "health/healthCover/partner/cover," +
                "health/healthCover/partner/healthCoverLoading," +
                "health/healthCover/rebate," +
                "health/healthCover/dependants," +
                "health/healthCover/income," +
                "health/situation/coverType," +
                "health/benefits/benefitsExtras," +
                "health/journey/stage," +
                "health/benefits/covertype";
    }
}