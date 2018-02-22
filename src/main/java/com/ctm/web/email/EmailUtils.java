package com.ctm.web.email;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.results.model.ResultProperty;
import com.ctm.web.core.services.ResultsService;
import com.ctm.web.core.web.go.Data;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.parser.Parser;
import org.jsoup.safety.Whitelist;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

/**
 * Created by akhurana on 22/09/17.
 */
@Component
public class EmailUtils {

    /**
     * Function to strip HTML from a given string, maintaining white space. If a string is null, an empty String will be returned.
     */
    public static final Function<String, String> stripHtml = s -> Optional.ofNullable(s)
            .map(htmlString -> Jsoup.clean(htmlString, "", Whitelist.none(), new Document.OutputSettings().prettyPrint(false)))
            .orElse("");
    /**
     * Function to strip HTML elements from each string in the provided List.
     */
    public static final Function<List<String>, List<String>> stripHtmlFromStrings = l -> l.stream().map(EmailUtils.stripHtml).collect(Collectors.toList());
    /**
     * Function to return a String as a BigDecimal, or if the String cannot be parsed, return {@link BigDecimal#ZERO}
     */
    public static final Function<String, BigDecimal> bigDecimalOrZero = s -> {
        try {
            return new BigDecimal(s);
        } catch (NumberFormatException nfe) {
            return BigDecimal.ZERO;
        }
    };
    public static final String ANNUAL_PREMIUM = "Annual  Premium";
    public static final String ANNUAL_ONLINE_PREMIUM = "Annual Online Premium";
    public final static int START = 0;
    public final static int END = 10;
    private static final Logger LOGGER = LoggerFactory.getLogger(EmailUtils.class);

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
        IntStream.range(START,END).forEach(idx -> {
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

    public static String getStringData(Data data, String xPath) throws ClassCastException{
        return (String) data.get(xPath);
    }

    public static List getListData(Data data, String xPath) throws ClassCastException{
        return (ArrayList) data.get(xPath);
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
        IntStream.range(START,END).forEach(value -> {
            premiumList.add(ANNUAL_ONLINE_PREMIUM);
        });
        return premiumList;
    }
}
