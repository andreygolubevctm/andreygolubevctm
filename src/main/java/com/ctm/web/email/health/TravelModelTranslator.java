package com.ctm.web.email.health;

import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.core.dao.RankingDetailsDao;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.email.exceptions.SendEmailException;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.RankingDetail;
import com.ctm.web.core.openinghours.services.OpeningHoursService;
import com.ctm.web.core.utils.RequestUtils;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.email.EmailRequest;
import com.ctm.web.email.EmailTranslator;
import com.ctm.web.email.EmailUtils;
import com.ctm.web.email.OptIn;
import com.ctm.web.email.travel.TravelEmailModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.security.GeneralSecurityException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

@Component
public class TravelModelTranslator implements EmailTranslator {

    @Autowired
    private EmailUtils emailUtils;
    private static final String vertical = VerticalType.TRAVEL.name().toLowerCase();
    private DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    @Override
    public void setUrls(HttpServletRequest request, EmailRequest emailRequest, Data data, String verticalCode) throws ConfigSettingException, DaoException, EmailDetailsException, SendEmailException, GeneralSecurityException {

    }

    @Override
    public void setVerticalSpecificFields(EmailRequest emailRequest, HttpServletRequest request, Data data) throws ConfigSettingException, DaoException {
        RankingDetailsDao rankingDetailsDao = new RankingDetailsDao();
        Long transactionId = RequestUtils.getTransactionIdFromRequest(request);
        List<RankingDetail> ranking = rankingDetailsDao.getLastestTopRankings(transactionId, EmailUtils.END);

        List<String> providerName = getRankingProperties(ranking,"providerName");
        List<String> premium = getRankingProperties(ranking,"price");
        List<String> luggage = getRankingProperties(ranking,"luggage");
        List<String> cancellation = getRankingProperties(ranking,"cxdfee");
        List<String> medical = getRankingProperties(ranking,"medical");
        String gaclientId = emailUtils.getParamFromXml(data.getXML(), "gaclientid", "/travel/");
        emailRequest.setVertical(vertical);
        emailRequest.setProviders(providerName);
        //replace span tab with empty string.
        emailRequest.setProviderCodes(providerName);
        emailRequest.setPremiums(premium);
        emailRequest.setPremiumFrequency(request.getParameter("rank_frequency0"));
        emailRequest.setGaClientID(gaclientId);
        String callCentreNumber = request.getParameter("callCentreNumber");

        HealthEmailModel healthEmailModel = new HealthEmailModel();
        OpeningHoursService openingHoursService = new OpeningHoursService();


        emailRequest.setHealthEmailModel(healthEmailModel);
        emailRequest.setCallCentreHours(openingHoursService.getCurrentOpeningHoursForEmail(request));
        List<String> providerPhones = new ArrayList<>();
        IntStream.range(EmailUtils.START,EmailUtils.END).forEach(value -> providerPhones.add(callCentreNumber));
        emailRequest.setProviderPhoneNumbers(providerPhones);
        List<String> quoteRefs = new ArrayList<>();

        IntStream.range(EmailUtils.START,EmailUtils.END).forEach(value -> quoteRefs.add(transactionId.toString()));
        emailRequest.setQuoteRefs(quoteRefs);
        TravelEmailModel travelEmailModel = new TravelEmailModel();
        travelEmailModel.setMedical(medical);
        travelEmailModel.setCancellation(cancellation);
        travelEmailModel.setLuggage(luggage);
        setDataFields(emailRequest, data, travelEmailModel);
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
        String firstName =  emailUtils.getParamSafely(data,vertical + "/firstName");
        String surname =  emailUtils.getParamSafely(data,vertical + "/surname");
        String adultsTravelling = emailUtils.getParamSafely(data,vertical + "/adults");
        String childrenTravelling = emailUtils.getParamSafely(data,vertical + "/children");
        String toDate = emailUtils.getParamSafely(data,vertical + "/dates/toDate");
        String fromDate = emailUtils.getParamSafely(data,vertical + "/dates/fromDate");
        String destination = emailUtils.getParamSafely(data,vertical + "/destination");
        String travellerAges = emailUtils.getParamSafely(data,vertical + "/travellers/travellersAge");

        List<Integer> ages = Arrays.stream(travellerAges.trim().split(",")).map(s -> Integer.parseInt(s)).collect(Collectors.toList());

        emailRequest.setOptIn(getOptIn(data));
        emailRequest.setFirstName(firstName);
        emailRequest.setLastName(surname);
        emailRequest.setEmailAddress(email);

        travelEmailModel.setAdultsTravelling(adultsTravelling);
        travelEmailModel.setChildrenTravelling(childrenTravelling);
        travelEmailModel.setDestination(destination);
        travelEmailModel.setTravellerAge(ages);

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
