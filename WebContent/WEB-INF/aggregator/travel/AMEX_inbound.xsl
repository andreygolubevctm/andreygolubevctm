<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:a1="http://ACE.Global.Travel.CRS.Schemas.ACORD.WS/"
	xmlns:a2="http://ACE.Global.Travel.CRS.Schemas.ACORD_QuoteArrayResp"
	xmlns:a3="http://ACE.Global.Travel.CRS.Schemas.ACORD_QuoteResp"
	xmlns:cal="java.util.GregorianCalendar" xmlns:sdf="java.text.SimpleDateFormat" xmlns:java="http://xml.apache.org/xslt/java"
	exclude-result-prefixes="soap a1 a2 a3 cal sdf java">
	
<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/unavailable.xsl" />

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId">*NONE</xsl:param>
	<xsl:param name="defaultProductId"><xsl:value-of select="$productId" /></xsl:param>
	<xsl:param name="service">AMEX</xsl:param>
	<xsl:param name="request" />	
	<xsl:param name="rootURL" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>	
	

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="not(/soap:Envelope/soap:Body/a1:GetTravelQuoteArrayResponse/a2:ArrayOfACORD_QuoteResp/a3:ACORD/a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:MsgStatus/a3:MsgStatusCd[not(.='Rejected')])">
				<!-- UNACCEPTABLE. If all MsgStatusCd are all set to Rejected, show unavailable template  -->
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-22</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
		<!-- ACCEPTABLE -->
				<results>
					<xsl:apply-templates select="/soap:Envelope/soap:Body/a1:GetTravelQuoteArrayResponse/a2:ArrayOfACORD_QuoteResp/a3:ACORD" />
				</results>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
						
	<xsl:template match="/soap:Envelope/soap:Body/a1:GetTravelQuoteArrayResponse/a2:ArrayOfACORD_QuoteResp/a3:ACORD">
		<xsl:if test="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:MsgStatus/a3:MsgStatusCd ='Success'">
		<xsl:variable name="adults"><xsl:value-of select="$request/travel/adults" /></xsl:variable>
		<xsl:variable name="children"><xsl:value-of select="$request/travel/children" /></xsl:variable>

		<xsl:variable name="todayYYYY"><xsl:value-of select="substring($today,1,4)" /></xsl:variable>
		<xsl:variable name="todayMM"><xsl:value-of select="substring($today,6,2)" /></xsl:variable>
		<xsl:variable name="todayDD"><xsl:value-of select="substring($today,9,2)" /></xsl:variable>
		<xsl:variable name="todayMMM">
			<xsl:call-template name="getMMM">
				<xsl:with-param name="MM" select="$todayMM" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="fromDate"><xsl:value-of select="$request/travel/dates/fromDate" /></xsl:variable>
		<xsl:variable name="toDate">
			<xsl:choose>
				<xsl:when test="$request/travel/policyType = 'S'">
					<xsl:value-of select="$request/travel/dates/toDate" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="yearPlus" select="cal:add(1, 1)"/> <!-- Year -->
					<xsl:value-of select="sdf:format(sdf:new('dd/MM/yyyy'),cal:getTime())" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="thePrice">
			<xsl:value-of select="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:QuoteInfo/a3:InsuredFullToBePaidAmt/a3:Amt" />
		</xsl:variable>

		<xsl:variable name="destinationId">
			<xsl:value-of select="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Destination/a3:RqUID" />
		</xsl:variable>
		<xsl:variable name="insuredPackage">
			<xsl:value-of select="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_InsuredPackage/a3:RqUID" />
		</xsl:variable>
		<xsl:variable name="planID">
			<xsl:value-of select="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:RqUID" />
		</xsl:variable>

		<xsl:variable name="uniqueId">
			<xsl:choose>
				<xsl:when test="$planID = 'd1c2a44c-cf88-41c5-84d4-a2e4003ed8f0'">22</xsl:when> <!-- Basic -->
				<xsl:when test="$planID = 'a8f7ad2c-87ec-4d96-9204-a2e4003ecd11'">23</xsl:when> <!-- Essential -->
				<xsl:when test="$planID = 'db27dd0f-5fbe-4f84-9483-a2e4003eb613'">24</xsl:when> <!-- Comprehensive -->
				<xsl:when test="$planID = '363cba19-28af-4f38-b987-a2e4003f3463'">25</xsl:when> <!-- AMT -->
				<xsl:when test="$planID = '98bd095e-7ef6-4890-984b-78546d8127ef'">26</xsl:when> <!-- Domestic -->
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="thePlan">
			Amex
			<xsl:variable name="planDesc">
				<xsl:value-of select="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:PlanDesc" />
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="$planID = '363cba19-28af-4f38-b987-a2e4003f3463'">
				AMT <xsl:value-of select="substring-before($planDesc, ' Annual')" /> Excl. Cuba (45 days per trip)
				</xsl:when><!-- Comprehensive -->
				<xsl:otherwise>
					<xsl:value-of select="$planDesc" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fromYYYY"><xsl:value-of select="substring($fromDate,7,4)" /></xsl:variable>
		<xsl:variable name="fromMM"><xsl:value-of select="substring($fromDate,4,2)" /></xsl:variable>
		<xsl:variable name="fromDD"><xsl:value-of select="substring($fromDate,1,2)" /></xsl:variable>
		<xsl:variable name="fromMMM">
			<xsl:choose>
				<xsl:when test="$fromMM='01'">-Jan-</xsl:when>
				<xsl:when test="$fromMM='02'">-Feb-</xsl:when>
				<xsl:when test="$fromMM='03'">-Mar-</xsl:when>
				<xsl:when test="$fromMM='04'">-Apr-</xsl:when>
				<xsl:when test="$fromMM='05'">-May-</xsl:when>
				<xsl:when test="$fromMM='06'">-Jun-</xsl:when>
				<xsl:when test="$fromMM='07'">-Jul-</xsl:when>
				<xsl:when test="$fromMM='08'">-Aug-</xsl:when>
				<xsl:when test="$fromMM='09'">-Sep-</xsl:when>
				<xsl:when test="$fromMM='10'">-Oct-</xsl:when>
				<xsl:when test="$fromMM='11'">-Nov-</xsl:when>
				<xsl:otherwise>-Dec-</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="urlFromDate"><xsl:value-of select="concat($fromDD, $fromMMM, $fromYYYY)" /></xsl:variable>
		<xsl:variable name="urlFromToday"><xsl:value-of select="concat($todayDD, $todayMMM, $todayYYYY)" /></xsl:variable>

		<xsl:variable name="toYYYY"><xsl:value-of select="substring($toDate,7,4)" /></xsl:variable>
		<xsl:variable name="toMM"><xsl:value-of select="substring($toDate,4,2)" /></xsl:variable>
		<xsl:variable name="toDD"><xsl:value-of select="substring($toDate,1,2)" /></xsl:variable>
		<xsl:variable name="toMMM">
			<xsl:choose>
				<xsl:when test="$toMM='01'">-Jan-</xsl:when>
				<xsl:when test="$toMM='02'">-Feb-</xsl:when>
				<xsl:when test="$toMM='03'">-Mar-</xsl:when>
				<xsl:when test="$toMM='04'">-Apr-</xsl:when>
				<xsl:when test="$toMM='05'">-May-</xsl:when>
				<xsl:when test="$toMM='06'">-Jun-</xsl:when>
				<xsl:when test="$toMM='07'">-Jul-</xsl:when>
				<xsl:when test="$toMM='08'">-Aug-</xsl:when>
				<xsl:when test="$toMM='09'">-Sep-</xsl:when>
				<xsl:when test="$toMM='10'">-Oct-</xsl:when>
				<xsl:when test="$toMM='11'">-Nov-</xsl:when>
				<xsl:otherwise>-Dec-</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="urlToDate"><xsl:value-of select="concat($toDD, $toMMM, $toYYYY)" /></xsl:variable>

		<xsl:variable name="quoteURL">
			<xsl:value-of select="$rootURL" />
			<xsl:text>?brokerCode=axauctm%26utm_source=ctm%26utm_medium=referral%26utm_campaign=affiliate%26extlink=agg-auiis-tr-comparethemarket%26_DTA_TRIP_TYPECOMBO_TRIP_=</xsl:text>
			<xsl:choose>
				<xsl:when test="$request/travel/policyType = 'S'">one_trip</xsl:when>
				<xsl:otherwise>annual_trip</xsl:otherwise>
			</xsl:choose>
			<xsl:text>%26_DTA_DESTINATION_=</xsl:text>
				<xsl:value-of select="$destinationId" />
			<xsl:text>%26_DTA_EFF_FROM_=</xsl:text>
			<xsl:choose>
				<xsl:when test="$request/travel/policyType = 'S'">
					<xsl:value-of select="$urlFromDate" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$urlFromToday" />
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>%26_DTA_EFF_TO_=</xsl:text>
				<xsl:value-of select="$urlToDate" />
			<xsl:text>%26_DTA_ADULTS_TRAVELLING_=</xsl:text>
					<xsl:value-of select="$request/travel/adults"/>
			<xsl:text>%26_DTA_ADULT_AGE1_=</xsl:text>
					<xsl:value-of select="$request/travel/oldest"/>
			<xsl:choose>
				<xsl:when test="$request/travel/adults = 2 and ($request/travel/oldest &gt;= 18) and ($request/travel/oldest &lt;= 89)">
					<xsl:text>%26_DTA_ADULT_AGE2_=</xsl:text>
					<xsl:value-of select="$request/travel/oldest"/>
				</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
			<xsl:text>%26_DTA_DEPENDANTS_TRAVELLING_=</xsl:text>
			<xsl:value-of select="$request/travel/children"/>
			<xsl:text>%26_DTA_COVER_FOR_=</xsl:text>
				<xsl:value-of select="$insuredPackage" />
			<xsl:text>%26_DTA_MULTI_TRIP_=</xsl:text>
			<xsl:choose>
				<xsl:when test="$request/travel/policyType = 'S'">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
			<xsl:text>%26autoSubmit=true</xsl:text>
		</xsl:variable>

				<xsl:element name="price">
					<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>

					<xsl:attribute name="productId">
						<xsl:choose>
							<xsl:when test="$productId != '*NONE'"><xsl:value-of select="$productId" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="$service" />-TRAVEL-<xsl:value-of select="$uniqueId" /></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					<available>Y</available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>
				<provider>Amex Travel Insurance</provider>
				<trackCode>39</trackCode>
				<name><xsl:value-of select="$thePlan"/></name>
				<des>
					<xsl:value-of select="$thePlan"/>
				</des>
				<price><xsl:value-of select="format-number($thePrice,'#0.00')" /></price>
				<priceText><xsl:value-of select="format-number($thePrice,'$#,##0.00')" /></priceText>
					<info>
					<excess>
						<desc>Excess on claims</desc>
						<value>100</value>
						<text>$100</text>
					</excess>
					<medical>
						<desc>Overseas Medical and Dental Expenses</desc>
							<xsl:choose>
							<xsl:when test="$planID = '98bd095e-7ef6-4890-984b-78546d8127ef'"><!-- Domestic -->
								<value>0</value>
								<text>N/A</text>
							</xsl:when>
							<xsl:otherwise>
								<value>99999999</value>
								<text>Unlimited</text>
							</xsl:otherwise>
							</xsl:choose>
					</medical>
				<xsl:choose>
					<xsl:when test="$planID = '98bd095e-7ef6-4890-984b-78546d8127ef'"><!-- Domestic -->
						<cxdfee>
							<desc>Cancellation Fees</desc>
							<value>10000</value>
							<text>$10,000</text>
						</cxdfee>
						<luggage>
							<desc>Luggage and Personal Effects</desc>
							<value>5000</value>
							<text>$5,000</text>
						</luggage>
						<luggagedel>
							<desc>Delayed Luggage Allowance (more than 12 hours)</desc>
							<value>250</value>
							<text>$250</text>
						</luggagedel>
						<rentalveh>
							<desc>Personal Liability</desc>
							<value>3000</value>
							<text>$3,000</text>
						</rentalveh>
						<liability>
							<desc>Personal Liability</desc>
							<value>5000000</value>
							<text>$5,000,000</text>
						</liability>
					</xsl:when>
					<xsl:when test="$planID = 'd1c2a44c-cf88-41c5-84d4-a2e4003ed8f0'"><!-- Basic -->
						<cxdfee>
							<desc>Cancellation Fees</desc>
							<value>0</value>
							<text>N/A</text>
						</cxdfee>
						<luggage>
							<desc>Luggage and Personal Effects</desc>
							<value>0</value>
							<text>Optional Extra</text>
						</luggage>
						<medicalAssi>
							<desc>Overseas Emergency Medical Assistance</desc>
							<value>999999999</value>
							<text>Unlimited</text>
						</medicalAssi>
						<rentalveh>
							<desc>Rental Vehicle Excess</desc>
							<value>0</value>
							<text>Optional Extra</text>
						</rentalveh>
						<liability>
							<desc>Personal Liability</desc>
							<value>1000000</value>
							<text>$1,000,000</text>
						</liability>
					</xsl:when>
					<xsl:when test="$planID = 'a8f7ad2c-87ec-4d96-9204-a2e4003ecd11'"><!-- Essential -->
						<cxdfee>
							<desc>Cancellation Fees</desc>
							<value>10000</value>
							<text>$10,000</text>
						</cxdfee>
						<luggage>
							<desc>Luggage and Personal Effects</desc>
							<value>5000</value>
							<text>$5,000</text>
						</luggage>
						<medicalAssi>
							<desc>Overseas Emergency Medical Assistance</desc>
							<value>999999999</value>
							<text>Included</text>
						</medicalAssi>
						<expenses>
							<desc>Additional Expenses</desc>
							<value>750</value>
							<text>$750</text>
						</expenses>
						<journeyResum>
							<desc>Resumption of Journey</desc>
							<value>3000</value>
							<text>$3,000 (over 21 days)</text>
						</journeyResum>
						<luggagedel>
							<desc>Delayed Luggage Allowance (more than 24 hours)</desc>
							<value>250</value>
							<text>$250 (more than 12 hours)</text>
						</luggagedel>
						<rentalveh>
							<desc>Rental Vehicle Excess</desc>
							<value>0</value>
							<text>Optional Extra</text>
						</rentalveh>
						<delayExp>
							<desc>Travel Delay Accommodation</desc>
							<value>500</value>
							<text>$500</text>
						</delayExp>
						<liability>
							<desc>Personal Liability</desc>
							<value>1250000</value>
							<text>$1,250,000</text>
						</liability>
					</xsl:when>
					<xsl:when test="$planID = 'db27dd0f-5fbe-4f84-9483-a2e4003eb613'"><!-- Comprehensive -->
						<cxdfee>
							<desc>Cancellation Fees</desc>
							<value>999999999</value>
							<text>Unlimited</text>
						</cxdfee>
						<medicalAssi>
							<desc>Overseas Emergency Medical Assistance</desc>
							<value>999999999</value>
							<text>Included</text>
						</medicalAssi>
						<luggage>
							<desc>Luggage and Personal Effects</desc>
							<value>15000</value>
							<text>$15,000</text>
						</luggage>
						<emergencyAss>
							<desc>Emergency Assistance</desc>
							<value>999999999</value>
							<text>Unlimited</text>
						</emergencyAss>
						<expenses>
							<desc>Additional Expenses</desc>
							<value>1500</value>
							<text>$1,500</text>
						</expenses>
						<luggagedel>
							<desc>Delayed Luggage Allowance (more than 24 hours)</desc>
							<value>500</value>
							<text>$500 (more than 12 hours)</text>
						</luggagedel>
						<persMoney>
							<desc>Replacement of Money</desc>
							<value>250</value>
							<text>$250</text>
						</persMoney>
						<journeyResum>
							<desc>Resumption of Journey</desc>
							<value>3000</value>
							<text>$3,000 (over 21 days)</text>
						</journeyResum>
						<delayExp>
							<desc>Travel Delay Accommodation</desc>
							<value>2000</value>
							<text>$2,000</text>
						</delayExp>
						<hospitalcas>
							<desc>Cash in Hospital</desc>
							<value>6000</value>
							<text>$100 (Daily Amount)&lt;br&gt;$6,000 (Maximum Amount)</text>
						</hospitalcas>
						<liability>
							<desc>Personal Liability</desc>
							<value>5000000</value>
							<text>$5,000,000</text>
						</liability>
						<death>
							<desc>Accidental Death</desc>
							<value>25000</value>
							<text>$25,000</text>
						</death>
						<rentalveh>
							<desc>Rental Vehicle Excess</desc>
							<value>3000</value>
							<text>$3,000</text>
						</rentalveh>
					</xsl:when>
					<xsl:when test="$planID = '363cba19-28af-4f38-b987-a2e4003f3463'"><!-- AMT -->
						<cxdfee>
							<desc>Cancellation Fees</desc>
							<value>999999999</value>
							<text>Unlimited</text>
						</cxdfee>
						<luggage>
							<desc>Luggage and Personal Effects</desc>
							<value>15000</value>
							<text>$15,000</text>
						</luggage>
						<expenses>
							<desc>Additional Expenses</desc>
							<value>1500</value>
							<text>$1,500</text>
						</expenses>
						<liability>
							<desc>Personal Liability</desc>
							<value>5000000</value>
							<text>$5,000,000</text>
						</liability>
						<journeyResum>
							<desc>Resumption of Journey</desc>
							<value>3000</value>
							<text>$3,000 (over 21 days)</text>
						</journeyResum>
						<medicalAssi>
							<desc>Overseas Emergency Medical Assistance</desc>
							<value>999999999</value>
							<text>Included</text>
						</medicalAssi>
						<luggagedel>
							<desc>Delayed Luggage Allowance (more than 24 hours)</desc>
							<value>500</value>
							<text>$500 (more than 12 hours)</text>
						</luggagedel>
						<persMoney>
							<desc>Replacement of Money</desc>
							<value>250</value>
							<text>$250</text>
						</persMoney>
						<delayExp>
							<desc>Travel Delay Accommodation</desc>
							<value>2000</value>
							<text>$2,000</text>
						</delayExp>
						<hospitalcas>
							<desc>Cash in Hospital</desc>
							<value>6000</value>
							<text>$100 (Daily Amount)&lt;br&gt;$6,000 (Maximum Amount)</text>
						</hospitalcas>
						<death>
							<desc>Accidental Death</desc>
							<value>25000</value>
							<text>$25,000</text>
						</death>
					</xsl:when>
					<xsl:otherwise>
						<cxdfee>
							<desc>Cancellation Fees</desc>
							<value>999999999</value>
							<text>Not specified</text>
						</cxdfee>
						<luggage>
							<desc>Luggage and Personal Effects</desc>
							<value>999999999</value>
							<text>Not specified</text>
						</luggage>
					</xsl:otherwise>
				</xsl:choose>

				<contractStartDate>
					<xsl:value-of select="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:ContractTerm/a3:EffectiveDt" />
				</contractStartDate>
				<contractEndDate>
					<xsl:value-of select="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:ContractTerm/a3:ExpirationDt" />
				</contractEndDate>
				<packageDesc></packageDesc>
					
				</info>
				<infoDes>With over 150 years travel experience, American Express offers a range of plans depending on your travel needs. Plans include Annual multi trip policy (includes International &amp; Domestic cover) as well as a variety of Single trip plans offering different cover levels. You can even tailor make your policies to include optional extras such as golf, winter sports, rental vehicle excess and additional luggage.&lt;br&gt;&lt;br&gt;American Express Travel Insurance is underwritten by ACE Insurance Limited.</infoDes>
				<subTitle>https://insurance.americanexpress.com.au/files/2014/06/travel-insurance-PDS.pdf</subTitle>
				<acn></acn>
				<afsLicenceNo></afsLicenceNo>
				<quoteUrl><xsl:value-of select="normalize-space($quoteURL)" /></quoteUrl>
				</xsl:element>		
		</xsl:if>
	</xsl:template>

<!-- UTILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="getMMM">
		<xsl:param name="MM" />
			<xsl:variable name="MMM">
				<xsl:choose>
					<xsl:when test="$MM='01'">-Jan-</xsl:when>
					<xsl:when test="$MM='02'">-Feb-</xsl:when>
					<xsl:when test="$MM='03'">-Mar-</xsl:when>
					<xsl:when test="$MM='04'">-Apr-</xsl:when>
					<xsl:when test="$MM='05'">-May-</xsl:when>
					<xsl:when test="$MM='06'">-Jun-</xsl:when>
					<xsl:when test="$MM='07'">-Jul-</xsl:when>
					<xsl:when test="$MM='08'">-Aug-</xsl:when>
					<xsl:when test="$MM='09'">-Sep-</xsl:when>
					<xsl:when test="$MM='10'">-Oct-</xsl:when>
					<xsl:when test="$MM='11'">-Nov-</xsl:when>
					<xsl:otherwise>-Dec-</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		<xsl:value-of select="$MMM" />
	</xsl:template>

</xsl:stylesheet>