package com.ctm.web.email.health;

import com.ctm.interfaces.common.config.types.ProviderCode;
import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.dao.ProviderDao;
import com.ctm.web.core.dao.RankingDetailsDao;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.email.services.EmailDetailsService;
import com.ctm.web.core.email.services.EmailUrlService;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.EmailMaster;
import com.ctm.web.core.model.RankingDetail;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.provider.model.Provider;
import com.ctm.web.core.security.IPAddressHandler;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.email.EmailRequest;
import com.ctm.web.email.EmailTranslator;
import com.ctm.web.email.EmailUtils;
import com.ctm.web.email.OptIn;
import com.ctm.web.email.travel.TravelEmailModel;
import com.ctm.web.factory.EmailServiceFactory;
import com.ctm.web.travel.services.email.TravelEmailDetailMappings;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.security.GeneralSecurityException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Component
public class TravelModelTranslator implements EmailTranslator {

    public static final int NUM_RESULTS = 10;
    @Autowired
    private EmailUtils emailUtils;
    private static final String vertical = VerticalType.TRAVEL.name().toLowerCase();
    private DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private static final Logger LOGGER = LoggerFactory.getLogger(TravelModelTranslator.class);

    @Autowired
    protected IPAddressHandler ipAddressHandler;
    @Autowired
    private ProviderDao providerDao;

    @Override
    public void setUrls(HttpServletRequest request, EmailRequest emailRequest, Data data, String verticalCode) throws ConfigSettingException, DaoException, EmailDetailsException, SendEmailException, GeneralSecurityException {
        PageSettings pageSettings = SettingsService.getPageSettingsForPage(request);
        String emailAddress = getEmail(data);
        LOGGER.info("emailAddress retrieved from SessionData is: {}", emailAddress);
        EmailMaster emailDetails = new EmailMaster();
        emailDetails.setEmailAddress(emailAddress);
        emailDetails.setSource("QUOTE");
        EmailDetailsService emailDetailsService = EmailServiceFactory.createEmailDetailsService(
                pageSettings, data, Vertical.VerticalType.TRAVEL, new TravelEmailDetailMappings());
        Long transactionId = RequestUtils.getTransactionIdFromRequest(request);
        emailDetails = emailDetailsService.handleReadAndWriteEmailDetails(transactionId, emailDetails, "ONLINE",  ipAddressHandler.getIPAddress(request));

        EmailUrlService emailUrlService = EmailServiceFactory.createEmailUrlService(pageSettings, Vertical.VerticalType.TRAVEL);
        Map<String, String> emailParameters = new HashMap<>();
        emailParameters.put(EmailUrlService.TRANSACTION_ID, Long.toString(transactionId));
        emailParameters.put(EmailUrlService.HASHED_EMAIL, emailDetails.getHashedEmail());
        emailParameters.put(EmailUrlService.STYLE_CODE_ID, Integer.toString(pageSettings.getBrandId()));
        emailParameters.put(EmailUrlService.EMAIL_TOKEN_TYPE, EMAIL_TYPE);
        emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, "load");
        emailParameters.put(EmailUrlService.VERTICAL, "travel");
        emailParameters.put(EmailUrlService.TRAVEL_POLICY_TYPE, (String) data.get("travel/policyType"));
        String applyUrl = emailUrlService.getApplyUrl(emailDetails,emailParameters,null);

        emailParameters.put(EmailUrlService.EMAIL_TOKEN_ACTION, "unsubscribe");
        String unsubscribeUrl = emailUrlService.getUnsubscribeUrl(emailParameters);
        List<String> applyUrls = new ArrayList<>();
        IntStream.range(EmailUtils.START, NUM_RESULTS).forEach(index -> applyUrls.add(applyUrl));
        emailRequest.setApplyUrls(applyUrls);
        emailRequest.setUnsubscribeURL(unsubscribeUrl);
    }

    @Override
    public void setVerticalSpecificFields(EmailRequest emailRequest, HttpServletRequest request, Data data) throws ConfigSettingException, DaoException {
        RankingDetailsDao rankingDetailsDao = new RankingDetailsDao();
        Long transactionId = RequestUtils.getTransactionIdFromRequest(request);
        List<RankingDetail> ranking = rankingDetailsDao.getLastestTopRankings(transactionId, NUM_RESULTS);

        List<String> providerCodes = getRankingProperties(ranking,"providerName");
        List<String> premium = getRankingProperties(ranking,"price");
        List<String> luggage = getRankingProperties(ranking,"luggage");
        List<String> cancellation = getRankingProperties(ranking,"cxdfee");
        List<String> medical = getRankingProperties(ranking,"medical");
        List<String> excesses = getRankingProperties(ranking,"excess");
        String gaclientId = emailUtils.getParamFromXml(data.getXML(), "gaclientid", "/travel/");
        List<String> providerNames = providerCodes.stream()
                .map(providerCode -> {
                    try {
                        return providerDao.getByCode(providerCode, ApplicationService.getServerDate()).getName();
                    } catch (Exception e) {
                        LOGGER.debug(e.getMessage());
                    }
                    return "";
                } )
                .collect(Collectors.toList());
        emailRequest.setVertical(vertical);
        emailRequest.setProviders(providerNames);
        emailRequest.setProviderCodes(providerCodes);
        emailRequest.setPremiums(premium);
        emailRequest.setPremiumFrequency(request.getParameter("rank_frequency0"));
        emailRequest.setGaClientID(gaclientId);

        TravelEmailModel travelEmailModel = new TravelEmailModel();
        travelEmailModel.setMedical(medical);
        travelEmailModel.setCancellation(cancellation);
        travelEmailModel.setLuggage(luggage);
        emailRequest.setExcesses(excesses);
        setDataFields(emailRequest, data, travelEmailModel);
        emailRequest.setTravelEmailModel(travelEmailModel);
    }

    private List<String> getRankingProperties(List<RankingDetail> rankingDetails, String property){
        return rankingDetails.stream().map(rankingDetail -> {
            String value = rankingDetail.getProperty(property);
            if(value == null) value = "";
            return value;
        }).collect(Collectors.toList());
    }

    private void setDataFields(EmailRequest emailRequest, Data data, TravelEmailModel travelEmailModel){
        String email = getEmail(data);
        LOGGER.info("email retrieved from SessionData is: {}", email);
        String firstName =  emailUtils.getParamSafely(data,vertical + "/firstName");
        String surname =  emailUtils.getParamSafely(data,vertical + "/surname");
        String adultsTravelling = emailUtils.getParamSafely(data,vertical + "/adults");
        String childrenTravelling = emailUtils.getParamSafely(data,vertical + "/children");
        String toDate = emailUtils.getParamSafely(data,vertical + "/dates/toDate");
        String fromDate = emailUtils.getParamSafely(data,vertical + "/dates/fromDate");
        String destination = emailUtils.getParamSafely(data,vertical + "/destination");
        String travellerAges = emailUtils.getParamSafely(data,vertical + "/travellers/travellersAge");

        List<Integer> ages = Arrays.stream(travellerAges.trim().split(",")).map(s -> Integer.parseInt(s)).collect(Collectors.toList());
        Integer oldestTravellerAge = ages.stream().max(Comparator.naturalOrder()).orElse(null);

        emailRequest.setOptIn(getOptIn(data));
        emailRequest.setFirstName(firstName);
        emailRequest.setLastName(surname);
        emailRequest.setEmailAddress(email);

        travelEmailModel.setAdultsTravelling(adultsTravelling);
        travelEmailModel.setChildrenTravelling(childrenTravelling);
        travelEmailModel.setDestination(destination);
        travelEmailModel.setTravellerAge(ages);
        travelEmailModel.setOldestTravellerAge(oldestTravellerAge);

        if(fromDate !=null){
            travelEmailModel.setTravelStartDate(LocalDate.parse(fromDate,dateTimeFormatter));
        }
        if(toDate !=null){
            travelEmailModel.setTravelEndDate(LocalDate.parse(toDate, dateTimeFormatter));
        }
    }


    public String getEmail(Data data){
        return emailUtils.getParamSafely(data,vertical + "/email");
    }

    public OptIn getOptIn(Data data){
        String optIn = emailUtils.getParamSafely(data,vertical + "/marketing");
        if(optIn!=null){
            return OptIn.valueOf(optIn);
        }
        return OptIn.N;
    }
}
