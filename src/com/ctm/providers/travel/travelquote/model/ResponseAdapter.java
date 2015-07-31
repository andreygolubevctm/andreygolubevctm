package com.ctm.providers.travel.travelquote.model;

import com.ctm.model.resultsData.AvailableType;
import com.ctm.model.travel.results.ExemptedBenefit;
import com.ctm.model.travel.results.Info;
import com.ctm.model.travel.results.TravelResult;
import com.ctm.providers.QuoteResponse;
import com.ctm.providers.travel.travelquote.model.request.PolicyType;
import com.ctm.providers.travel.travelquote.model.request.TravelQuoteRequest;
import com.ctm.providers.travel.travelquote.model.response.Benefit;
import com.ctm.providers.travel.travelquote.model.response.TravelQuote;
import com.ctm.providers.travel.travelquote.model.response.TravelResponse;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class ResponseAdapter {

    /**
     * Trave-quote to web_ctm adapter
     * Take response from travel-quote and convert it to a java model to be returned to the front end.
     *
     * @param response
     * @return
     */
    public static List<TravelResult> adapt(TravelQuoteRequest request, TravelResponse response) {

        List<TravelResult> results = new ArrayList<>();
        final QuoteResponse<TravelQuote> quoteResponse = response.getPayload();

        if (quoteResponse != null) {

            for (TravelQuote travelQuote : quoteResponse.getQuotes()) {

                TravelResult result = new TravelResult();
                result.setAvailable(travelQuote.isAvailable() ? AvailableType.Y : AvailableType.N);
                result.setServiceName(travelQuote.getService());
                result.setService(travelQuote.getService());
                result.setProductId(travelQuote.getProductId());
                result.setTrackCode(String.valueOf(travelQuote.getTrackCode()));

                result.setName(travelQuote.getProduct().getShortTitle());
                result.setPrice(travelQuote.getPrice());
                result.setPriceText(travelQuote.getPriceText());
                result.setInfoDes(travelQuote.getProduct().getDescription());
                result.setSubTitle(travelQuote.getProduct().getPdsUrl());


                // Override product names based on arbitrary rules.

                String planDescription = "";
                if(travelQuote.getService().equals("1FOW")){
                    planDescription = travelQuote.getProduct().getLongTitle();
                    if(request.getPolicyType().equals("A")){
                        planDescription += " <span class=\"daysPerTrip\">(30 Days)</span>";
                    }
                }else if(travelQuote.getService().equals("VIRG")){
                    planDescription = "Virgin Money";
                    if(request.getPolicyType() == PolicyType.SINGLE){
                        planDescription += " "+travelQuote.getProduct().getLongTitle();
                    }else{
                        planDescription += " AMT <br>Worldwide <span class=\"daysPerTrip\">("+travelQuote.getProduct().getMaxTripDuration()+" days)</span>";
                    }
                }else if(travelQuote.getService().equals("ZUJI")){
                    planDescription = travelQuote.getProduct().getLongTitle();
                }else{
                    planDescription = travelQuote.getProduct().getLongTitle();
                    if(travelQuote.getProduct().getMaxTripDuration() != null && travelQuote.getProduct().getMaxTripDuration() > 0){
                        planDescription += " <span class=\"daysPerTrip\">("+travelQuote.getProduct().getMaxTripDuration()+" days)</span>";
                    }
                }
                result.setDes(planDescription);


                // Import benefits - separate the exempt benefits.

                for(Benefit benefit : travelQuote.getBenefits()){

                    int count = 0;
                    if(benefit.isExempted()){

                        ExemptedBenefit exemptedBenefit = new ExemptedBenefit();

                        if(benefit.getType().equals("EXCESS")){
                            exemptedBenefit.setBenefit("excess");
                        }else if(benefit.getType().equals("CXDFEE")){
                            exemptedBenefit.setBenefit("cxdfee");
                        }else if(benefit.getType().equals("MEDICAL")){
                            exemptedBenefit.setBenefit("medical");
                        }else if(benefit.getType().equals("LUGGAGE")){
                            exemptedBenefit.setBenefit("luggage");
                        }else {
                            exemptedBenefit.setBenefit("benefit_"+count);//<benefit>benefit_<xsl:value-of select="position()"/></benefit>
                        }

                        result.addExemptedBenefit(exemptedBenefit);

                    }else{

                        com.ctm.model.travel.results.Benefit benefitResult = new com.ctm.model.travel.results.Benefit();

                        if(benefit.getType().equals("EXCESS")){

                            if(benefit.getDescription() == null || benefit.getDescription().equals("")) {
                                benefitResult.setDesc("Excess");
                            }else{
                                benefitResult.setDesc(benefit.getDescription());
                            }
                            benefitResult.setLabel("Excess");

                        }else if(benefit.getType().equals("CXDFEE")){

                            if(benefit.getDescription() == null || benefit.getDescription().equals("")){
                                benefitResult.setDesc("Cancellation Fees and Lost Deposits");
                            }else{
                                benefitResult.setDesc(benefit.getDescription());
                            }
                            benefitResult.setLabel("Cancellation Fees");

                        }else if(benefit.getType().equals("MEDICAL")){

                            if(benefit.getDescription() == null || benefit.getDescription().equals("")){
                                benefitResult.setDesc("Overseas Emergency Medicals");
                            }else{
                                benefitResult.setDesc(benefit.getDescription());
                            }
                            benefitResult.setLabel("Overseas Medical");

                        }else if(benefit.getType().equals("LUGGAGE")){

                            if(benefit.getDescription() == null || benefit.getDescription().equals("")){
                                benefitResult.setDesc("Luggage and Personal Effects");
                            }else{
                                benefitResult.setDesc(benefit.getDescription());
                            }
                            benefitResult.setLabel("Luggage and PE");

                        }else {
                            benefitResult.setDesc(benefit.getDescription());
                            benefitResult.setLabel(benefit.getLabel());
                        }
                        benefitResult.setText(benefit.getText());
                        benefitResult.setType(benefit.getType());
                        benefitResult.setValue(benefit.getValue());
                        benefitResult.setOrder("");
                        result.addBenefit(benefitResult);
                    }

                    count++;


                }

                //Create info object for results grid

                Info info = new Info();
                info.setCxdfee(result.getBenefit("cxdfee"));
                info.setCxdfeeValue(result.getBenefitValue("cxdfee"));
                info.setExcess(result.getBenefit("excess"));
                info.setExcessValue(result.getBenefitValue("excess"));
                info.setLuggage(result.getBenefit("luggage"));
                info.setLuggageValue(result.getBenefitValue("luggage"));
                info.setMedical(result.getBenefit("medical"));
                info.setMedicalValue(result.getBenefitValue("medical"));

                result.setInfo(info);


                // Handle handover url quirks

                if(travelQuote.getMethodType().equals("GET")){
                    result.setQuoteUrl(travelQuote.getQuoteUrl());
                }else{
                    result.setHandoverType("post");
                    result.setHandoverUrl(travelQuote.getQuoteUrl());

                    String handoverDataString = "";
                    Iterator it = travelQuote.getQuoteData().entrySet().iterator();
                    while (it.hasNext()) {
                        Map.Entry pair = (Map.Entry)it.next();
                        handoverDataString += "<handoverVar>"+pair.getKey()+"</handoverVar>";
                        handoverDataString += "<handoverData>"+pair.getValue()+"</handoverData>";
                        it.remove();
                    }

                    result.setHandoverData(handoverDataString);

                }

                result.setEncodeUrl(travelQuote.isEncodeQuoteUrl() ? "Y" : "N");

                results.add(result);
            }

        }

        return results;
    }
}
