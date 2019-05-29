package com.ctm.web.travel.quote.model;

import com.ctm.web.core.providers.model.IncomingQuotesResponse;
import com.ctm.web.core.resultsData.model.AvailableType;
import com.ctm.web.travel.model.results.ExemptedBenefit;
import com.ctm.web.travel.model.results.Info;
import com.ctm.web.travel.model.results.Offer;
import com.ctm.web.travel.model.results.TravelResult;
import com.ctm.web.travel.quote.model.request.PolicyType;
import com.ctm.web.travel.quote.model.request.TravelQuoteRequest;
import com.ctm.web.travel.quote.model.response.Benefit;
import com.ctm.web.travel.quote.model.response.Product;
import com.ctm.web.travel.quote.model.response.TravelQuote;
import com.ctm.web.travel.quote.model.response.TravelResponseV2;
import org.springframework.util.StringUtils;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ResponseAdapterV2 {

    /**
     * Trave-quote to web_ctm adapter
     * Take response from travel-quote and convert it to a java model to be returned to the front end.
     *
     * @param response
     * @return
     */
    public static List<TravelResult> adapt(TravelQuoteRequest request, TravelResponseV2 response) {

        List<TravelResult> results = new ArrayList<>();
        final IncomingQuotesResponse.Payload<TravelQuote> quoteResponse = response.getPayload();

        if (quoteResponse != null) {

            for (TravelQuote travelQuote : quoteResponse.getQuotes()) {

                TravelResult result = new TravelResult();
                result.setAvailable(travelQuote.isAvailable() ? AvailableType.Y : AvailableType.N);
                result.setServiceName(travelQuote.getService());
                result.setService(travelQuote.getService());
                result.setProductId(travelQuote.getProductId());
                result.setTrackCode(String.valueOf(travelQuote.getTrackCode()));

                results.add(result);

                if (!travelQuote.isAvailable()) {
                    continue;
                }


                result.setName(travelQuote.getProduct().getShortTitle());
                result.setInfoDes(travelQuote.getProduct().getDescription());
                result.setSubTitle(travelQuote.getProduct().getPdsUrl());

                result.setPrice(travelQuote.getPrice());
                result.setPriceText(travelQuote.getPriceText());
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
                info.setRentalVehicle(travelQuote.getBenefit("rentalvehicle"));
                info.setRentalVehicleValue(travelQuote.getBenefitValue("rentalvehicle"));

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
                        "Rental Vehicle"
                };

                info.setRentalVehicle(travelQuote.getBenefitByLabelArray(rentalVehicleExcessLabelsArray));
                info.setRentalVehicleValue(travelQuote.getBenefitValueByLabelArray(rentalVehicleExcessLabelsArray));

                result.setInfo(info);

                // Create offer object for results grid
                com.ctm.web.travel.quote.model.response.Offer travelQuoteOffer = travelQuote.getOffer();
                if (travelQuoteOffer != null) {
                    result.setOffer(new Offer(travelQuoteOffer.getDescription(), travelQuoteOffer.getTerms()));
                }

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

                /*
                 * Filter out AMT fields by Duration / region
                 * Duration checks if the product has a getMaxTripDuration value, if it doesn't it checks the getLongTitle value, if both fail duration is not filtered
                 * Region checks user inputs against ISO codes and groups them into regions. In the product side the getLongTitle value is checked for regions
                 * Worldwide is always returned along with the single region the user selects (if the America(s) are not selected, then Worldwide excluding Americas are also
                 * always returned
                 * */
                // compare the duration retrieved from the returned products with the user request
                if (request.getPolicyType() == PolicyType.MULTI && (request.getAmtDuration() > 1 && parseDuration(travelQuote.getProduct()) < request.getAmtDuration())) {
                    result.setAvailable(AvailableType.N);
                    continue;
                }
                // check if the region retrieved from the returned products is equal to the parsed user request
                if ( request.getPolicyType() == PolicyType.MULTI && (request.getDestinations().size()) > 0) {
                    String userRegion = parseRegion(request.getDestinations());
                    String productRegion = parseLongtitle(travelQuote.getProduct());

                    System.out.println("userRegion ---> " + userRegion + "productRegion: ---> " + productRegion + " TITLE: " + result.getDes());

                    if (productRegion == "worldwide" && !userRegion.contains("wwExAmericas")) {
                        System.out.println("region is WORLDWIDE, continue");
                        continue;
                    } else if (productRegion == "wwExAmericas" && userRegion.contains("wwExAmericas")) {
                        System.out.println("region is wwExAmericas, continue");
                        continue;
                    } else if (productRegion == "apac" && userRegion.contains("asia") || userRegion.contains("pacific")) {
                        System.out.println("region is apac, continue");
                        continue;
                    }
                    if (!userRegion.contains(productRegion)) {
                        System.out.println("userRegion ---> " + userRegion + "productRegion: ---> " + productRegion + " no match, removing result");
                        result.setAvailable(AvailableType.N);
                        continue;
                    }
                }
            }
        }
        return results;
    }

    private static String getDurationFromTitle(Product product) {
        Pattern p = Pattern.compile("\\d+");
        Matcher m = p.matcher(product.getLongTitle());
        while(m.find()) {
            return m.group();
        }
        return "NaN";
    }

    // maxTripDuration is NOT always populated - check the long title otherwise return null
    private static Integer parseDuration(Product product) {
        try {
            if (StringUtils.isEmpty(product.getMaxTripDuration())) {
                String durationResult = getDurationFromTitle(product);
                return Integer.valueOf(durationResult);
            } else {
                Integer durationResult = Integer.valueOf(product.getMaxTripDuration());
                return durationResult;
            }
        } catch (NumberFormatException nfe ) {
            return null;
        }
    }

    private static String parseLongtitle(Product product) {
        String s = product.getLongTitle().toLowerCase();

        // some partners don't say worldwide but infer it, so check for america in the longTitle
        if (s.contains("worldwide") || s.contains("america")){
            if (s.contains("excl ") || s.contains("exc ") || s.contains("excluding ")) {
                return "wwExAmericas";
            } else {
                return "worldwide";
            }
        } else if (s.contains("pacific") || s.contains("new zealand")) {
            // double check for partners that bundle pacific/asia
            if (s.contains("asia")) {
                return "apac";
            } else {
                return "pacific";
            }
        } else if (s.contains("europe")) {
            return "europe";
        } else if (s.contains("asia")) {
            return "asia";
        } else if (s.contains("bali")) {
            return "bali";
        }
        return "NO MATCH FOUND - original string was: " + product.getLongTitle();
    }

    // pass in the users destination(s)
    // check if the region includes Worldwide, Worldwide excluding Americas, Europe, Asia, Pacific/New Zealand, Bali ISO codes
    private static String parseRegion(List<String> regions) {

        Pattern americas = Pattern.compile("USA|AQ|ARG|BOL|BRA|CHL|COL|ECU|GUY|PRY|PER|SUR|URY|VEN|ATG|BHS|BRB|BLZ|CAN|CRI|CUB|DMA|DOM|SLV|GRD|GTM|HTI|HND|JAM|MEX|NIC|PAN|KNA|LCA|VCT|TTO");
        Pattern europe = Pattern.compile("EU|ALB|AND|ARM|AUT|AZE|BLR|BEL|BIH|BGR|HRV|CYP|CZE|DNK|EST|FIN|FRA|GEO|DEU|GRC|HUN|ISL|IRL|ITA|KAZ|LVA|LIE|LTU|LUX|MLT|MDA|MCO|MNE|NLD|MKD|NOR|POL|PRT|ROU|RUS|SMR|SRB|SVK|SVN|ESP|SWE|CHE|TUR|UKR|GBR");
        Pattern asia = Pattern.compile("AS|AFG|ARM|AZE|BHR|BGD|BTN|BRN|KHM|CHN|CYP|GEO|IND|IDN|IRN|IRQ|ISR|JPN|JOR|KAZ|KWT|KGZ|LAO|LBN|MYS|MDV|MNG|MMR|NPL|PRK|OMN|PAK|PSE|PHL|QAT|SAU|SGP|KOR|LKA|SYR|TWN|TJK|THA|TLS|TUR|TKM|ARE|UZB|VNM|YEM");
        Pattern pacific = Pattern.compile("PC|AUS|NZL|FJI|VUT|COK|NCL|MHL|NRU|SLB|TON|WLF|TUV|TKL|WSM|ASM|NIU|PYF|PCN");
        Pattern bali = Pattern.compile("BAL");

        String flatRegions = String.join(" ", regions);
        String resultString = "";
        Integer regionCount = 0;
        System.out.println("------------------------------------------------------------- raw region passed into parseRegion is: " + regions);
        System.out.println("------------------------------------------------------------- flatRegions: " + flatRegions);
        System.out.println("------------------------------------------------------------- regionlength: " + regions.size());
        // build the user region string & track count of regions
        if (bali.matcher(flatRegions).find()) {
            resultString+= "bali ";
            regionCount++;
        }
        if (pacific.matcher(flatRegions).find() && asia.matcher(flatRegions).find()) {
            resultString+= "apac ";
            regionCount++;
        } else {
            if (pacific.matcher(flatRegions).find()) {
                resultString+= "pacific ";
                regionCount++;
            }
            if (asia.matcher(flatRegions).find()) {
                resultString+= "asia ";
                regionCount++;
            }
        }
        if (europe.matcher(flatRegions).find()) {
            resultString+= "europe ";
            regionCount++;
        }
        // if more than one region selected, switch to worldwide products
        if ( regionCount > 1) {
            // check for americas
            if (!americas.matcher(flatRegions).find()) {
                resultString = "wwExAmericas worldwide ";
            } else {
                resultString = "worldwide ";
            }
        // otherwise add to string
        } else if (!americas.matcher(flatRegions).find()) {
            resultString+= "wwExAmericas worldwide ";
        } else {
            resultString+= "worldwide ";
        }

        System.out.println("------------------------------------------------------------- resultString: " + resultString + " regionCount: " + regionCount);

        return resultString;
    }
}
