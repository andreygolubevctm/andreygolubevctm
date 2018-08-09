package com.ctm.web.core.rememberme.services;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.SessionException;
import com.ctm.web.core.model.session.SessionData;

import com.ctm.web.core.security.StringEncryption;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.services.SettingsService;
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
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Component
public class RememberMeService {
    private static final Logger LOGGER = LoggerFactory.getLogger(RememberMeService.class);
    private static final String COOKIE_SUFFIX = "RememberMe";
    private static final String SECRET_KEY = "ruCSj2WR3a1O1zLMr92rDA==";
    private static final int MAX_AGE = 2592000; // 30 days
    private SessionDataServiceBean sessionDataServiceBean;
    private TransactionDetailsDao transactionDetailsDao;
    private TransactionDao transactionDao;
    private final String HEALTH_XPATH = "health/healthCover/primary/dob";
    private static final Integer maxAttempts = 3;


    /**
     * Used by health_quote_v4.jsp
     */
    @SuppressWarnings("unused")
    public RememberMeService() {
        this.sessionDataServiceBean = new SessionDataServiceBean();
        this.transactionDetailsDao = new TransactionDetailsDao();
        this.transactionDao = new TransactionDao();
    }

    @Autowired
    public RememberMeService(final SessionDataServiceBean sessionDataServiceBean,
                             final TransactionDetailsDao transactionDetailsDao,
                             final TransactionDao transactionDao) {
        this.sessionDataServiceBean = sessionDataServiceBean;
        this.transactionDetailsDao = transactionDetailsDao;
        this.transactionDao = transactionDao;
    }

    public static void setCookie(final String vertical,
                                 final Long transactionId,
                                 final HttpServletResponse response) throws GeneralSecurityException, DaoException, ConfigSettingException {
        if (vertical != null && transactionId != null) {
            final String cookieName = getCookieName(vertical.toLowerCase() + COOKIE_SUFFIX);
            addCookie(response, transactionId, cookieName);
        }
    }

    private static String getCookieName(final String content) throws GeneralSecurityException {
        return StringEncryption.encrypt(SECRET_KEY, content);
    }

    private static void addCookie(HttpServletResponse response, final Long transactionId, final String cookieName) throws GeneralSecurityException {
        final Cookie cookie = new Cookie(cookieName, StringEncryption.encrypt(SECRET_KEY, transactionId.toString()+":"+LocalDateTime.now().toString()));
        cookie.setMaxAge(MAX_AGE); // 30 days
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        setCookieDomain(cookie);
        setCookieSecure(cookie);
        response.addCookie(cookie);
    }

    private static void setCookieDomain(final Cookie cookie) {
		LOGGER.info("RememberMeService - setCookieDomain - Environment: " + EnvironmentService.getEnvironment().name());
        if (EnvironmentService.getEnvironment() ==  EnvironmentService.Environment.PRO) {
			cookie.setDomain("secure.comparethemarket.com.au");
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
    	LOGGER.info("RememberMeService - setCookieSecure - Environment: " + EnvironmentService.getEnvironment().name());
        if (EnvironmentService.getEnvironment() != EnvironmentService.Environment.LOCALHOST) {
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
            if (isRememberMeEnabled(request, vertical)) {
                Cookie cookie = getRememberMeCookie(request, vertical);
                if (cookie != null && !cookie.getValue().isEmpty())
                    return true;
            }
        } catch (GeneralSecurityException e) {
            LOGGER.error("Error retrieving cookie for remember me {}", kv("vertical", vertical), e);
        }
        return false;
    }


    /**
     * Used in health_quote_v2.jsp
     */
    @SuppressWarnings("unused")
    public Boolean hasUserVisitedInLast30Minutes(final HttpServletRequest request,
                                                final String vertical) throws DaoException, ConfigSettingException, GeneralSecurityException {
        try {
            if (isRememberMeEnabled(request, vertical)) {
                Cookie cookie = getRememberMeCookie(request, vertical);
                LOGGER.info("getRememberMeCookie(): {}", kv("cookie", cookie));
                if (cookie != null && !cookie.getValue().isEmpty()) {
                    String cookieValue = StringEncryption.decrypt(SECRET_KEY, cookie.getValue());
                    String transactionId = getTransactionIdFromCookie(vertical, request).orElse(null);
                    if(cookieValue.indexOf(":") > 0){

                        String createdTime = cookieValue.substring(cookieValue.indexOf(":")+1,cookieValue.length());
                        LocalDateTime dateTime = LocalDateTime.parse(createdTime);

                        Long createdEpochTime = dateTime.atZone(ZoneId.systemDefault()).toEpochSecond();
                        Long currentEpochTime =  LocalDateTime.now().atZone(ZoneId.systemDefault()).toEpochSecond();
                        if(currentEpochTime - createdEpochTime < 1800) {

                            loadSessionData(request,vertical,transactionId,getTransactionDetails(transactionId));
                            LOGGER.info("session is within 30minutes");
                            return true;
                        }
                        else {
                            return false;
                        }
                    }

                }

            }
        } catch (GeneralSecurityException e) {
            LOGGER.error("Error retrieving cookie for remember me {}", kv("vertical", vertical), e);
        }
        LOGGER.info("isRememberMeEnabled(): {}", isRememberMeEnabled(request, vertical));
        return false;
    }


    /**
     * Used in health_quote_v2.jsp
     */
    @SuppressWarnings("unused")
    public String retrieveTransactionId(final HttpServletRequest request,
                                                 final String vertical) throws DaoException, ConfigSettingException, GeneralSecurityException {
        try {
            if (isRememberMeEnabled(request, vertical)) {
                Cookie cookie = getRememberMeCookie(request, vertical);
                if (cookie != null && !cookie.getValue().isEmpty()) {
                    String cookieValue = StringEncryption.decrypt(SECRET_KEY, cookie.getValue());
                    String transactionId = getTransactionIdFromCookie(vertical, request).orElse(null);
                    return getTransactionIdFromCookie(vertical, request).orElse(null);
                }

            }
        } catch (GeneralSecurityException e) {
            LOGGER.error("Error retrieving cookie for remember me {}", kv("vertical", vertical), e);
        }

        return "";
    }

    private Cookie getRememberMeCookie(final HttpServletRequest request,
                                       final String vertical) throws GeneralSecurityException {
        final String cookieName = getCookieName(vertical.toLowerCase() + COOKIE_SUFFIX);
        if(request.getCookies() != null ){
            return Arrays.stream(request.getCookies())
                    .filter(Objects::nonNull)
                    .filter(cookie -> cookie.getName().equals(cookieName))
                    .findFirst()
                    .orElse(null);
        }else
            return null;
    }

    public Optional<String> getTransactionIdFromCookie(final String vertical, final HttpServletRequest request) throws GeneralSecurityException {
        final Cookie cookie = getRememberMeCookie(request, vertical);
        if (cookie !=null && !cookie.getValue().isEmpty()) {
            String value = StringEncryption.decrypt(SECRET_KEY, cookie.getValue());
            if(value.indexOf(":") > 0) {
                return Optional.ofNullable(value.substring(0, value.indexOf(":")));
            } else
                return Optional.ofNullable(value);
        }
        return Optional.empty();
    }

    /**
     * Used in health_quote-v4.jsp
     */
    @SuppressWarnings("unused")
    public boolean hasPersonalInfoAndLoadData(HttpServletRequest request,
                                              final HttpServletResponse response,
                                              final String vertical) throws GeneralSecurityException {
        return Optional.ofNullable(getTransactionIdFromCookie(vertical.toLowerCase(), request))
                .map(rememberMeCookieValue -> Optional.ofNullable(getTransactionDetails(rememberMeCookieValue.get()))
                        .map(presentTransactionDetails -> {
                            boolean hasPersonalInfo = presentTransactionDetails.stream().anyMatch(details ->
                                    details.getXPath().equals(getXpathToVerifyForVertical(vertical)));
                            if (!hasPersonalInfo) {
                                loadSessionData(request, vertical, rememberMeCookieValue.orElse(null), presentTransactionDetails);
                                try {
                                    deleteCookie(vertical, response);
                                } catch (GeneralSecurityException e) {
                                    throw new RuntimeException(e);
                                }
                            }
                            if (vertical.equals("health")) {
                                if (isCoverAndLocationMatch(presentTransactionDetails, request)) {
                                    return hasPersonalInfo;
                                } else
                                    return false;
                            } else
                                return hasPersonalInfo;

                        })
                        .orElse(false))
                .orElse(false);
    }


    /**
     * match the cover and location values from broucher with the remembered transaction details
     * @param transactionDetails
     * @param request
     * @return
     */
    private boolean isCoverAndLocationMatch(final List<TransactionDetail> transactionDetails, final HttpServletRequest request){
        TransactionDetail healthCvr = transactionDetails.stream().
                filter(transactionDetail -> transactionDetail.getXPath().equals("health/situation/healthCvr")).findFirst().orElse(null);

        TransactionDetail postcode = transactionDetails.stream().
                filter(transactionDetail -> transactionDetail.getXPath().equals("health/situation/postcode")).findFirst().orElse(null);

        if(request.getParameter("cover") == null  && request.getParameter("health_location") == null )
            return true;
        else if ((healthCvr != null && (request.getParameter("cover").isEmpty() || request.getParameter("cover").startsWith("Choose")
                || healthCvr.getTextValue().equals(request.getParameter("cover"))))
                && (postcode != null && (request.getParameter("health_location").isEmpty() || request.getParameter("health_location").contains(postcode.getTextValue())))) {
            return true;
        } else
            return false;

    }

    /**
     * Used in remember_me.jsp
     */
    @SuppressWarnings("unused")
    public String getNameOfUser(HttpServletRequest request,
                                final HttpServletResponse response,
                                final String vertical) throws GeneralSecurityException {
        return Optional.ofNullable(getTransactionIdFromCookie(vertical.toLowerCase(), request))
                .map(rememberMeCookieValue -> Optional.ofNullable(getTransactionDetails(rememberMeCookieValue.get()))
                        .map(presentTransactionDetails -> {
                            TransactionDetail detail = presentTransactionDetails.stream().
                                    filter(transactionDetail -> transactionDetail.getXPath().equals(getXpathForName(vertical))).findFirst().orElse(null);
                            if (detail != null)
                                return detail.getTextValue();
                            else
                                return "";
                        })
                        .orElse(""))
                .orElse("");
    }

    public Boolean validateAnswerAndLoadData(final String vertical, final String answer,
                                             HttpServletRequest request) throws GeneralSecurityException {
        return Optional.ofNullable(getTransactionIdFromCookie(vertical.toLowerCase(), request))
                .map(rememberMeCookieValue -> Optional.ofNullable(getTransactionDetails(rememberMeCookieValue.get()))
                        .map(presentTransactionDetails -> {
                            boolean match = presentTransactionDetails.stream().anyMatch(details ->
                                    details.getXPath().equals(getXpathToVerifyForVertical(vertical)) && details.getTextValue().equals(answer));
                            if (match) {
                                loadSessionData(request, vertical, rememberMeCookieValue.orElse(null), presentTransactionDetails);
                            }
                            return match;
                        }).orElse(false))
                .orElse(false);
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
                removeAttemptsSessionAttribute(request, vertical);
                deleteCookie(vertical, response);
            }
        }
    }

    public Boolean removeAttemptsSessionAttribute(final HttpServletRequest request, final String vertical) {
        HttpSession session = request.getSession();
        LOGGER.info("RememberMe Service removeAttemptsSessionAttribute(): {}", kv("session", session));
        if (session != null) {
            String attemptsSessionAttributeName = getAttemptsSessionAttributeName(vertical);
            Object expectedRemoveAttemptsSessionVar = session.getAttribute(attemptsSessionAttributeName);
            if (expectedRemoveAttemptsSessionVar == null) {
                LOGGER.info("Expected session var {} is null", attemptsSessionAttributeName);
            }
            session.removeAttribute(attemptsSessionAttributeName);
            return true;
        }
        return false;
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

    private void loadSessionData(HttpServletRequest request, final String vertical, final String transactionId, final List<TransactionDetail> transactionDetails) {
        Data data = getDataBucket(request, transactionId);
        Optional.ofNullable(data)
                .map(sessionData -> {
                    transactionDetails.stream()
                            .forEach(transactionDetail -> data.put(transactionDetail.getXPath(), transactionDetail.getTextValue()));
                    return null;
                });

        //if session data is cleared, reload it
        if (data != null && data.getString("current/transactionId") == null) {
            SessionData sessionData = (SessionData) request.getSession().getAttribute("sessionData");
            data.put("current/verticalCode", vertical.toUpperCase());
            data.put("current/brandCode", "ctm");
            data.put("current/transactionId", transactionId);
            data.put("rootId", transactionId);
            sessionData.addTransactionData(data);
            SessionData.markSessionForCommit(request);
        }
    }

    public static Boolean isRememberMeEnabled(final HttpServletRequest request, final String vertical) throws DaoException, ConfigSettingException {
        return SettingsService.getPageSettingsForPage(request, vertical)
                .getSettingAsBoolean("rememberMeEnabled");
    }

    private List<TransactionDetail> getTransactionDetails(final String transactionId) {
        try {
            return transactionDetailsDao.getTransactionDetails(Long.valueOf(transactionId));
        } catch (DaoException e) {
            LOGGER.error("populateDataBucket: Error getting transaction details for transactionId {}", kv("transactionId", transactionId), e);
            throw new RuntimeException(e);
        }
    }

    private Data getDataBucket(final HttpServletRequest request,final String transactionId) {
        try {
            return sessionDataServiceBean.getDataForTransactionId(request, transactionId, true);
        } catch (DaoException | SessionException e) {
            LOGGER.error("Error getting data for transactionId {}", kv("transactionId", transactionId), e);
            throw new RuntimeException(e);
        } finally {
            SessionData.markSessionForCommit(request);
        }
    }

    public Boolean deleteCookie(final String vertical, final HttpServletResponse response) throws GeneralSecurityException {
        final String cookieName = getCookieName(vertical.toLowerCase() + COOKIE_SUFFIX);
        LOGGER.info("RememberMe Service deleteCookie: {}", kv("cookieName", cookieName));
        if (cookieName != null) {
            final Cookie cookie = new Cookie(cookieName, "");
            cookie.setMaxAge(0);
            cookie.setPath("/");
			setCookieDomain(cookie);
            response.addCookie(cookie);
            return true;
        }
        return false;
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

    private String getXpathForName(final String vertical) {
        String xpath = null;
        switch (vertical) {
            case "health":
                xpath = "health/contactDetails/name";
                break;
        }
        return xpath;
    }
}