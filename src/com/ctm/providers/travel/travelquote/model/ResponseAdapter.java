package com.ctm.providers.travel.travelquote.model;

import com.ctm.model.AvailableType;
import com.ctm.model.travel.results.ExemptedBenefit;
import com.ctm.model.travel.results.TravelResult;
import com.ctm.providers.QuoteResponse;
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

                String planDescription = "";

                if(travelQuote.getService().equals("1FOW")){
                    planDescription = travelQuote.getProduct().getLongTitle();
                    if(request.getPolicyType().equals("A")){
                        planDescription += " &lt;span class=\"daysPerTrip\"&gt;(30 Days)&lt;/span&gt;";
                    }
                }else if(travelQuote.getService().equals("VIRG")){
                    planDescription = "Virgin Money";
                    if(request.getPolicyType().equals("S")){
                        planDescription += " ";
                    }else{
                        planDescription += " AMT &lt;br&gt;Worldwide &lt;span class=\"daysPerTrip\"&gt;(<xsl:value-of select=\"product/maxTripDuration\"/> days)&lt;span&gt;";
                    }
                }else if(travelQuote.getService().equals("ZUJI")){
                    planDescription = travelQuote.getProduct().getLongTitle();
                }else{
                    planDescription = travelQuote.getProduct().getLongTitle();
                    if(travelQuote.getProduct().getMaxTripDuration() != null && travelQuote.getProduct().getMaxTripDuration() > 0){
                        planDescription += " &lt;span class=\"daysPerTrip\"&gt;("+travelQuote.getProduct().getMaxTripDuration()+" days)&lt;span&gt;";
                    }
                }
                result.setDes(planDescription);



                for(Benefit benefit : travelQuote.getBenefits()){
                    com.ctm.model.travel.results.Benefit benefitResult = new com.ctm.model.travel.results.Benefit();
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
                        benefitResult.setDesc(benefit.getDescription());
                        benefitResult.setLabel(benefit.getLabel());
                        benefitResult.setText(benefit.getText());
                        benefitResult.setOrder("");
                        result.addBenefit(benefitResult);
                    }

                    count++;


                }

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



/*
<info>
						<xsl:for-each select="benefit">

							<xsl:choose>
								<xsl:when test="@type='EXCESS'">
									<excess>
										<label>Excess</label>
										<desc>
											<xsl:choose>
												<xsl:when test="string-length(description) > 0"><xsl:value-of select="description" /></xsl:when>
												<xsl:otherwise>Excess</xsl:otherwise>
											</xsl:choose>
										</desc>
										<value><xsl:value-of select="value"/></value>
										<text><xsl:value-of select="text"/></text>
										<order/>
									</excess>
								</xsl:when>
								<xsl:when test="@type='CXDFEE'">
									<cxdfee>
										<label>Cancellation Fees</label>
										<desc>
											<xsl:choose>
												<xsl:when test="string-length(description) > 0"><xsl:value-of select="description" /></xsl:when>
												<xsl:otherwise>Cancellation Fees and Lost Deposits</xsl:otherwise>
											</xsl:choose>
										</desc>
										<value><xsl:value-of select="value"/></value>
										<text><xsl:value-of select="text"/></text>
										<order/>
									</cxdfee>
								</xsl:when>
								<xsl:when test="@type='MEDICAL'">
									<medical>
										<label>Overseas Medical</label>
										<desc>
											<xsl:choose>
												<xsl:when test="string-length(description) > 0"><xsl:value-of select="description" /></xsl:when>
												<xsl:otherwise>Overseas Emergency Medical</xsl:otherwise>
											</xsl:choose>
										</desc>
										<value><xsl:value-of select="value"/></value>
										<text><xsl:value-of select="text"/></text>
										<order/>
									</medical>
								</xsl:when>
								<xsl:when test="@type='LUGGAGE'">
									<luggage>
										<label>Luggage and PE</label>
										<desc>
											<xsl:choose>
												<xsl:when test="string-length(description) > 0"><xsl:value-of select="description" /></xsl:when>
												<xsl:otherwise>Luggage and Personal Effects</xsl:otherwise>
											</xsl:choose>
										</desc>
										<value><xsl:value-of select="value"/></value>
										<text><xsl:value-of select="text"/></text>
										<order/>
									</luggage>
								</xsl:when>
								<xsl:otherwise>
									<xsl:element name="benefit_{position()}">
										<label><xsl:value-of select="label" /></label>
										<desc><xsl:value-of select="description" /></desc>
										<value><xsl:value-of select="value" /></value>
										<text><xsl:value-of select="text" /></text>
										<order/>
									</xsl:element>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</info>
 */
                //



                // TODO Complete adapter

                results.add(result);
            }

        }

        return results;
    }
}
