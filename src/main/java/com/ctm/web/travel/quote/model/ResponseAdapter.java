package com.ctm.web.travel.quote.model;

import com.ctm.web.core.providers.model.QuoteResponse;
import com.ctm.web.core.resultsData.model.AvailableType;
import com.ctm.web.travel.model.results.ExemptedBenefit;
import com.ctm.web.travel.model.results.Info;
import com.ctm.web.travel.model.results.TravelResult;
import com.ctm.web.travel.quote.model.request.PolicyType;
import com.ctm.web.travel.quote.model.request.TravelQuoteRequest;
import com.ctm.web.travel.quote.model.response.Benefit;
import com.ctm.web.travel.quote.model.response.TravelQuote;
import com.ctm.web.travel.quote.model.response.TravelResponse;

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

                result.setIsDomestic(travelQuote.getIsDomestic());


                // Override product names based on arbitrary rules.

                String planDescription = "";
                if(travelQuote.getService().equals("1FOW")){
                    planDescription = travelQuote.getProduct().getLongTitle();
                    if(request.getPolicyType().equals("A")){
                        planDescription += " <span class=\"daysPerTrip\">(30 Days)</span>";
                    }
                } else if(travelQuote.getService().equals("VIRG")){
                    planDescription = "Virgin Money";
                    if(request.getPolicyType() == PolicyType.SINGLE){
                        planDescription += " "+travelQuote.getProduct().getLongTitle();
                    }else{
                        planDescription += " AMT <br>"+travelQuote.getProduct().getLongTitle()+
                                " <span class=\"daysPerTrip\">("+travelQuote.getProduct().getMaxTripDuration()+" days)</span>";
                    }
                } else if(travelQuote.getService().equals("ZUJI")){
                    planDescription = travelQuote.getProduct().getLongTitle();
                } else if(travelQuote.getService().equals("WEBJ")) {
                    planDescription = "Webjet";
                    switch(request.getPolicyType()) {
                        case MULTI:
                            planDescription += " AMT <br>Worldwide <span class=\"daysPerTrip\">("+travelQuote.getProduct().getMaxTripDuration()+" days)</span>";
                            break;
                        case SINGLE:
                            planDescription += " "+travelQuote.getProduct().getLongTitle();
                            break;
                    }

                }
                else if(travelQuote.getService().equals("JANE")) {
                    planDescription += "Travel With Jane - "+travelQuote.getProduct().getLongTitle();
                }

                else{
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

                        com.ctm.web.travel.model.results.Benefit benefitResult = new com.ctm.web.travel.model.results.Benefit();

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
                info.setCxdfee(travelQuote.getBenefit("cxdfee"));
                info.setCxdfeeValue(travelQuote.getBenefitValue("cxdfee"));
                info.setExcess(travelQuote.getBenefit("excess"));
                info.setExcessValue(travelQuote.getBenefitValue("excess"));
                info.setLuggage(travelQuote.getBenefit("luggage"));
                info.setLuggageValue(travelQuote.getBenefitValue("luggage"));
                info.setMedical(travelQuote.getBenefit("medical"));
                info.setMedicalValue(travelQuote.getBenefitValue("medical"));

                String[] rentalVehicleExcessLabelsArray = {
                        "rental vehicle excess",
                        "rental vehicle excess#*",
                        "<sup>*</sup> rental vehicle excess",
                        "rental vehicle excess waiver",
                        "rental car excess waiver",
                        "rental vehicle insurance excess",
                        "Return of Rental Vehicle",
                        "Rental Vehicle Insurance Excess#*",
                        "Rental Vehicle Excess#^^",
                        "Rental Vehicle Excess *",
                        "Rental Vehicle",
                        "Car Hire Excess"
                };

                info.setRentalVehicle(travelQuote.getBenefitByLabelArray(rentalVehicleExcessLabelsArray));
                info.setRentalVehicleValue(travelQuote.getBenefitValueByLabelArray(rentalVehicleExcessLabelsArray));

                result.setInfo(info);


                // Handle handover url quirks

                if(travelQuote.getMethodType().equals("GET")){
                    result.setQuoteUrl(travelQuote.getQuoteUrl());
                }else{
                    result.setHandoverType("post");
                    result.setHandoverUrl(travelQuote.getQuoteUrl());

                    String handoverVarString = "";
                    String handoverDataString = "";
                    Iterator it = travelQuote.getQuoteData().entrySet().iterator();
                    while (it.hasNext()) {
                        Map.Entry pair = (Map.Entry)it.next();
                        handoverVarString += (String)pair.getKey();
                        handoverDataString += (String)pair.getValue();
                        it.remove();
                    }

                    result.setHandoverVar(handoverVarString);
                    result.setHandoverData(handoverDataString);

                }

                result.setEncodeUrl(travelQuote.isEncodeQuoteUrl() ? "Y" : "N");

                results.add(result);
            }

        }

        return results;
    }
}
