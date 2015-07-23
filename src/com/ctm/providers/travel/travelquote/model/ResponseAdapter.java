package com.ctm.providers.travel.travelquote.model;

import com.ctm.model.AvailableType;
import com.ctm.model.travel.results.TravelResult;
import com.ctm.providers.QuoteResponse;
import com.ctm.providers.travel.travelquote.model.response.TravelQuote;
import com.ctm.providers.travel.travelquote.model.response.TravelResponse;

import java.util.ArrayList;
import java.util.List;

public class ResponseAdapter {

    /**
     * Trave-quote to web_ctm adapter
     * Take response from travel-quote and convert it to a java model to be returned to the front end.
     *
     * @param response
     * @return
     */
    public static List<TravelResult> adapt(TravelResponse response) {

        List<TravelResult> results = new ArrayList<>();
        final QuoteResponse<TravelQuote> quoteResponse = response.getPayload();
        if (quoteResponse != null) {
            for (TravelQuote travelQuote : quoteResponse.getQuotes()) {

                TravelResult result = new TravelResult();
                result.setAvailable(travelQuote.isAvailable() ? AvailableType.Y : AvailableType.N);
                result.setServiceName(travelQuote.getService());
                result.setProductId(travelQuote.getProductId());

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
                    if(travelQuote.getProduct().getMaxTripDuration() > 0){
                        planDescription += " &lt;span class=\"daysPerTrip\"&gt;("+travelQuote.getProduct().getMaxTripDuration()+" days)&lt;span&gt;";
                    }
                }
                result.setDes(planDescription);


                result.setName(travelQuote.getProduct().getShortTitle());
                result.setPrice(travelQuote.getPrice());
                result.setPriceName(travelQuote.getPriceText());
                result.setInfoDes(travelQuote.getProduct().getDescription());
                result.setSubTitle(travelQuote.getProduct().getPdsUrl());

                /*
                <xsl:choose>
						<xsl:when test="methodType = 'GET'">
							<quoteUrl><xsl:value-of select="quoteUrl"/></quoteUrl>
						</xsl:when>
						<xsl:otherwise>
							<handoverType>post</handoverType>
							<handoverUrl><xsl:value-of select="quoteUrl"/></handoverUrl>
							<xsl:for-each select="quoteData/child::*" >
								<handoverVar><xsl:value-of select="name()"/></handoverVar>
								<handoverData><xsl:value-of select="."/></handoverData>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					<encodeUrl>
						<xsl:choose>
							<xsl:when test="encodeQuoteUrl='true'">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</encodeUrl>
                 */

                /*
                <xsl:if test="benefit/exempted = 'true'">
						<exemptedBenefits>
							<xsl:for-each select="benefit">
								<xsl:if test="exempted = 'true'">
									<xsl:choose>
										<xsl:when test="@type='EXCESS'">
											<benefit>excess</benefit>
										</xsl:when>
										<xsl:when test="@type='CXDFEE'">
											<benefit>cxdfee</benefit>
										</xsl:when>
										<xsl:when test="@type='MEDICAL'">
											<benefit>medical</benefit>
										</xsl:when>
										<xsl:when test="@type='LUGGAGE'">
											<benefit>luggage</benefit>
										</xsl:when>
										<xsl:otherwise>
											<benefit>benefit_<xsl:value-of select="position()"/></benefit>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:for-each>
						</exemptedBenefits>
					</xsl:if>
                 */

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
