package com.ctm.web.email;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.results.model.ResultProperty;
import com.ctm.web.core.services.ResultsService;
import com.ctm.web.core.web.go.Data;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.parser.Parser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

/**
 * Created by akhurana on 22/09/17.
 */
@Component
public class EmailUtils {

    private static final Logger LOGGER = LoggerFactory.getLogger(EmailUtils.class);

    public static final String ANNUAL_PREMIUM = "Annual  Premium";
    public static final String ANNUAL_ONLINE_PREMIUM = "Annual Online Premium";

    public List<ResultProperty> getResultPropertiesForTransaction(String tranId) throws DaoException {
        try {
            return ResultsService.getResultsPropertiesForTransactionId(Long.parseLong(tranId));
        } catch (DaoException e) {
            e.printStackTrace();
            throw e;
        }
    }

    public List<String> buildParameterList(HttpServletRequest httpServletRequest, String paramName){
        List params = new ArrayList();
        IntStream.range(0,10).forEach(idx -> {
            String parameter = httpServletRequest.getParameter(paramName + idx);
            if(parameter != null)params.add(parameter);
        });
        return params;
    }

    public String getParamSafely(Data data, String param) {
        try {
            return (String) data.get(param);
        }
        catch(Exception e){
            LOGGER.warn("Field " + param + " not found before sending email");
        }
        return null;
    }

    public String getParamFromXml(String xml, String param, String baseUri){
        try {
            Document document = Jsoup.parse(xml, baseUri, Parser.xmlParser());
            return document.select(param).text();
        }
        catch(Exception e){
            LOGGER.warn("Field " + param + "not found in xml ");
        }
        return null;
    }

    public List<String> getPremiumLabels(List<String> premiumLabels){
        if(premiumLabels.isEmpty())return createEmptyListWithAnnualOnlinePremium();

        return premiumLabels.stream().map(s -> {
            if(s!=null && s.equals("OFFLINE")) return ANNUAL_PREMIUM;
            return ANNUAL_ONLINE_PREMIUM;
        }).collect(Collectors.toList());
    }

    private List<String> createEmptyListWithAnnualOnlinePremium(){
        List<String> premiumList = new ArrayList<>();
        IntStream.range(0,10).forEach(value -> {
            premiumList.add(ANNUAL_ONLINE_PREMIUM);
        });
        return premiumList;
    }
}
