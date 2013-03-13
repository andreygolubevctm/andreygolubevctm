<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv">
	
<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId">*NONE</xsl:param>
	<xsl:param name="defaultProductId"><xsl:value-of select="$productId" /></xsl:param>
	<xsl:param name="service"></xsl:param>
	<xsl:param name="request" />	
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>	
		
<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<xsl:choose>
		<!-- ACCEPTABLE -->
		<xsl:when test="/FpeQuoteResponse/OutputXml/policy_response/calculated_multi_values/bulk_premiums">
			<xsl:apply-templates select="/FpeQuoteResponse/OutputXml/policy_response/calculated_multi_values/bulk_premiums"/>
		</xsl:when>
		
		<!-- UNACCEPTABLE -->
		<xsl:otherwise>
			<results>
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-8</xsl:with-param>
				</xsl:call-template>
			</results>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/FpeQuoteResponse/OutputXml/policy_response/calculated_multi_values/bulk_premiums">
		<results>	
						
			<xsl:for-each select="bulk_premium">
			
				<xsl:if test="cover_level_brief != 'CANX'">

					<xsl:variable name="region">
						<xsl:choose>
							<xsl:when test="$request/travel/destinations/af/af">worldwide</xsl:when>
							<xsl:when test="$request/travel/destinations/me/me">worldwide</xsl:when>
							<xsl:when test="$request/travel/destinations/am/ca">worldwide</xsl:when>
							<xsl:when test="$request/travel/destinations/am/sa">worldwide</xsl:when>
							<xsl:when test="$request/travel/destinations/do/do">worldwide</xsl:when>
							<xsl:when test="$request/travel/destinations/am/us">worldwide</xsl:when>
							
							<xsl:when test="$request/travel/destinations/eu/eu">europe%2Fasia</xsl:when>
							<xsl:when test="$request/travel/destinations/eu/uk">europe%2Fasia</xsl:when>
							<xsl:when test="$request/travel/destinations/as/jp">europe%2Fasia</xsl:when>
							<xsl:when test="$request/travel/destinations/as/ch">europe%2Fasia</xsl:when>
							<xsl:when test="$request/travel/destinations/as/hk">europe%2Fasia</xsl:when>
							<xsl:when test="$request/travel/destinations/as/in">europe%2Fasia</xsl:when>
							<xsl:when test="$request/travel/destinations/as/th">europe%2Fasia</xsl:when>
							
							<xsl:when test="$request/travel/destinations/pa/in">pacific</xsl:when>
							<xsl:when test="$request/travel/destinations/pa/ba">pacific</xsl:when>
							<xsl:when test="$request/travel/destinations/pa/nz">pacific</xsl:when>
							<xsl:when test="$request/travel/destinations/pa/pi">pacific</xsl:when>
											
							<xsl:when test="$request/travel/destinations/au/au">australia</xsl:when>
							
							<xsl:otherwise>worldwide</xsl:otherwise>								
						</xsl:choose>
					</xsl:variable>
				
					<xsl:variable name="adults"><xsl:value-of select="$request/travel/adults" /></xsl:variable>
					<xsl:variable name="children"><xsl:value-of select="$request/travel/children" /></xsl:variable>			
	
					<xsl:variable name="fromDate"><xsl:value-of select="$request/travel/dates/fromDate" /></xsl:variable>
					<xsl:variable name="toDate"><xsl:value-of select="$request/travel/dates/toDate" /></xsl:variable>
	
	<!--  				<xsl:variable name="fromDate">2012-09-12</xsl:variable>
					<xsl:variable name="toDate">2012-09-12</xsl:variable>
			-->		
					<xsl:variable name="startDateFormatted"><xsl:value-of select="substring($fromDate,7,4)" /><xsl:value-of select="substring($fromDate,4,2)" /><xsl:value-of select="substring($fromDate,1,2)" /></xsl:variable>		
					<xsl:variable name="endDateFormatted"><xsl:value-of select="substring($toDate,7,4)" /><xsl:value-of select="substring($toDate,4,2)" /><xsl:value-of select="substring($toDate,1,2)" /></xsl:variable>		
						
				 
								
					<xsl:element name="price">
						<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
				
						<xsl:attribute name="productId">
							<xsl:choose>
								<xsl:when test="$productId != '*NONE'"><xsl:value-of select="$productId" /></xsl:when>
								<xsl:when test="cover_level_brief='DOMST'"><xsl:value-of select="$service" />-TRAVEL-32</xsl:when>
								<xsl:otherwise><xsl:value-of select="$service" />-TRAVEL-8</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						
						<available>Y</available>
						<transactionId><xsl:value-of select="$transactionId"/></transactionId>
						<provider>Online Travel Insurance</provider>
						<trackCode>2</trackCode>
						<xsl:variable name="plan_description">
							<xsl:call-template name="titleCase">
								<xsl:with-param name="text" select="translate(normalize-space(plan_name/text()),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')" />
							</xsl:call-template>
						</xsl:variable>
						<name>
							<xsl:value-of select="$plan_description"/>
						</name>
						<des>
							<xsl:value-of select="$plan_description"/>						
						</des>						
						 
						<price><xsl:value-of select="format-number(selling_gross,'#.00')"/></price>
						<priceText>$<xsl:value-of select="format-number(selling_gross,'#.00')"/></priceText>
				
 						<info>
							<xsl:variable name="prod">
								<xsl:value-of select="concat(cover_level_brief,'-',cover_type_brief)" />
							</xsl:variable>
							<excess>
								<desc>Excess</desc>
								<text>Nil</text>
								<value>0</value>
							</excess>
							<medical>
								<desc>Overseas Emergency Medical / Hospital / Dental Expenses</desc>
								<xsl:choose>
									<xsl:when test="cover_level_brief='COMP'">
										<value>99999999</value>
										<text>unlimited</text>
									</xsl:when>
									<xsl:otherwise>
										<value>0</value>
										<text>N/A</text>
									</xsl:otherwise>
								</xsl:choose>														
							</medical>
							<cxdfee>
								<desc>Cancellation Fees</desc>
								<value>999999999</value>
								<text>Unlimited</text>
							</cxdfee>
							<luggage>
								<desc>Luggage and Personal Effects</desc>
								<xsl:choose>
									<xsl:when test="cover_type_brief='SGL'">
										<value>5000</value>
										<text>$5,000</text>
									</xsl:when>
									<xsl:otherwise>
										<value>10000</value>
										<text>$10,000</text>
									</xsl:otherwise>
								</xsl:choose>																					
							</luggage>
							<expenses>
								<desc>Additional Expenses</desc>
								<xsl:choose>
									<xsl:when test="cover_type_brief='SGL'">
										<value>50000</value>
										<text>$50,000</text>
									</xsl:when>
									<xsl:otherwise>
										<value>100000</value>
										<text>$100,000</text>
									</xsl:otherwise>
								</xsl:choose>														
							</expenses>
							<hospitalcas>
								<desc>Hospital Cash Allowance</desc>
									<xsl:choose>
										<xsl:when test="cover_level_brief!='COMP'">
											<value>0</value>
											<text>N/A</text>									
										</xsl:when>
										<xsl:when test="cover_type_brief='SGL'">
											<value>5000</value>
											<text>$5,000</text>
										</xsl:when>
										<xsl:otherwise>
											<value>10000</value>
											<text>$10,000</text>
										</xsl:otherwise>
									</xsl:choose>
							</hospitalcas>
							<death>
								<desc>Accidental Death</desc>
								<xsl:choose>
									<xsl:when test="cover_type_brief='SGL'">
										<value>25000</value>
										<text>$25,000</text>
									</xsl:when>
									<xsl:otherwise>
										<value>50000</value>
										<text>$50,000</text>
									</xsl:otherwise>
								</xsl:choose>														
							</death>
							<disability>
								<desc>Permanent Disability</desc>
								<xsl:choose>
									<xsl:when test="cover_level_brief!='COMP'">
										<value>0</value>
										<text>N/A</text>									
									</xsl:when>							
									<xsl:when test="cover_type_brief='SGL'">
										<value>25000</value>
										<text>$25,000</text>
									</xsl:when>
									<xsl:otherwise>
										<value>50000</value>
										<text>$50,000</text>
									</xsl:otherwise>
								</xsl:choose>														
							</disability>
							<income>
								<desc>Loss of Income</desc>
								<xsl:choose>
									<xsl:when test="cover_level_brief!='COMP'">
										<value>0</value>
										<text>N/A</text>									
									</xsl:when>							
									<xsl:when test="cover_type_brief='SGL'">
										<value>10400</value>
										<text>$10,400</text>
									</xsl:when>
									<xsl:otherwise>
										<value>20800</value>
										<text>$20,800</text>
									</xsl:otherwise>
								</xsl:choose>														
							</income>
							<traveldocs>
								<desc>Travel Documents, Credit Cards and Travellers Cheques</desc>
								<xsl:choose>
									<xsl:when test="cover_level_brief!='COMP'">
										<value>0</value>
										<text>N/A</text>									
									</xsl:when>							
									<xsl:when test="cover_type_brief='SGL'">
										<value>5000</value>
										<text>$5,000</text>
									</xsl:when>
									<xsl:otherwise>
										<value>10000</value>
										<text>$10,000</text>
									</xsl:otherwise>
								</xsl:choose>														
							</traveldocs>
							<cashtheft>
								<desc>Theft of Cash</desc>
								<xsl:choose>
									<xsl:when test="cover_level_brief!='COMP'">
										<value>0</value>
										<text>N/A</text>									
									</xsl:when>							
									<xsl:otherwise>
										<value>250</value>
										<text>$250</text>
									</xsl:otherwise>
								</xsl:choose>
							</cashtheft>
							<luggagedel>
								<desc>Luggage and Personal Effects Delay Allowance</desc>
								<xsl:choose>
									<xsl:when test="cover_level_brief!='COMP'">
										<value>0</value>
										<text>N/A</text>									
									</xsl:when>							
									<xsl:when test="cover_type_brief='SGL'">
										<value>250</value>
										<text>$250</text>
									</xsl:when>
									<xsl:otherwise>
										<value>500</value>
										<text>$500</text>
									</xsl:otherwise>
								</xsl:choose>																					
							</luggagedel>
							<traveldelayAll>
								<desc>Travel Delay Allowance</desc>
								<xsl:choose>
									<xsl:when test="cover_type_brief='SGL'">
										<value>1000</value>
										<text>$1,000</text>
									</xsl:when>
									<xsl:otherwise>
										<value>2000</value>
										<text>$2,000</text>
									</xsl:otherwise>
								</xsl:choose>														
							</traveldelayAll>
							<transport>
								<desc>Alternative Transport Expenses</desc>
								<xsl:choose>
									<xsl:when test="cover_level_brief!='COMP'">
										<value>0</value>
										<text>N/A</text>									
									</xsl:when>							
									<xsl:when test="cover_type_brief='SGL'">
										<value>5000</value>
										<text>$5,000</text>
									</xsl:when>
									<xsl:otherwise>
										<value>10000</value>
										<text>$10,000</text>
									</xsl:otherwise>
								</xsl:choose>														
							</transport>
							<liability>
								<desc>Personal Liability</desc>
								<value>5000000</value>
								<text>$5,000,000</text>
							</liability>
							<rentalVeh>
								<desc>Rental Vehicle</desc>
								<value>3000</value>
								<text>$3,000</text>
							</rentalVeh>
						</info>
 	
						<infoDes>
							<xsl:if test="cover_type_brief='DUO'">
							Please note Duo policies provide cover on a per person basis and most of the Benefit Limits displayed here are the combined total limit for that benefit under each policy, meaning the per person Benefit Limit is half that displayed.  &lt;br&gt;For more details refer PDS on the Insurer's web-site. &lt;br&gt; &lt;br&gt;
							</xsl:if>
							Online Travel Insurance offers comprehensive benefits at competitive prices. &lt;br&gt;&lt;br&gt;Online Travel Insurance's claims and emergency medical assistance are managed by the world's largest assistance company, Allianz Global Assistance, with the policy underwritten by Allianz.
						</infoDes>
						<subTitle></subTitle>
						<acn></acn>
						<afsLicenceNo></afsLicenceNo>
						
						<!--
						<quoteUrl>http://www.onlinetravelinsurance.com.au?affiliate=CaptainCompare%26destination=<xsl:value-of select="$region" />%26startdate=<xsl:value-of select="$startDateFormatted" />%26enddate=<xsl:value-of select="$endDateFormatted" />%26adults=<xsl:value-of select="$adults" />%26children=<xsl:value-of select="$children" /></quoteUrl>
						-->
						<quoteUrl>http://www.onlinetravelinsurance.com.au</quoteUrl>						
												
					</xsl:element>
						 	
				</xsl:if>
					
			</xsl:for-each>
			
		</results>
	</xsl:template>


	<!-- UNAVAILABLE PRICE -->
	<xsl:template name="unavailable">
		<xsl:param name="productId" />

		<xsl:element name="price">
			<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
			<xsl:attribute name="productId"><xsl:value-of select="$service" />-<xsl:value-of select="$productId" /></xsl:attribute>
		
			<available>N</available>
			<transactionId><xsl:value-of select="$transactionId"/></transactionId>
			<xsl:choose>
				<xsl:when test="error">
					<xsl:copy-of select="error"></xsl:copy-of>
				</xsl:when>
				<xsl:otherwise>
					<error service="{$service}" type="unavailable">
						<code></code>
						<message>unavailable</message>
						<data></data>
					</error>
				</xsl:otherwise>
			</xsl:choose>
			<name></name>
			<des></des>
			<info></info>				
		</xsl:element>		
	</xsl:template>
	
	
	<xsl:template name="titleCase">
      <xsl:param name="text" />
      <xsl:param name="lastletter" select="' '"/>
      <xsl:if test="$text"> 
         <xsl:variable name="thisletter" select="substring($text,1,1)"/> 
         <xsl:choose>
            <xsl:when test="$lastletter=' '">
               <xsl:value-of select="translate($thisletter,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$thisletter"/>
            </xsl:otherwise>
         </xsl:choose> 
         <xsl:call-template name="titleCase">
            <xsl:with-param name="text" select="substring($text,2)"/>
            <xsl:with-param name="lastletter" select="$thisletter"/>
         </xsl:call-template> 
      </xsl:if> 
   </xsl:template> 
</xsl:stylesheet>