<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:a1="http://ACE.Global.Travel.CRS.Schemas.ACORD.WS/"
	xmlns:a2="http://ACE.Global.Travel.CRS.Schemas.ACORD_QuoteArrayResp"
	xmlns:a3="http://ACE.Global.Travel.CRS.Schemas.ACORD_QuoteResp"
	exclude-result-prefixes="soap a1 a2 a3">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/unavailable.xsl"/>

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId">*NONE</xsl:param>
	<xsl:param name="defaultProductId"><xsl:value-of select="$productId" /></xsl:param>
	<xsl:param name="service">ACET</xsl:param>
	<xsl:param name="request" />
	<xsl:param name="rootURL" />


	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

	<!-- <xsl:variable name="request" select="document('test/ACET_req_in.xml')" /> -->
<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<xsl:template match="/">
		<xsl:choose>
			<!-- DO NOTHING -->
			<xsl:when test="$request/travel/oldest &lt; 18 or $request/travel/oldest &gt; 69">
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-1</xsl:with-param>
				</xsl:call-template>
			</xsl:when>

			<!-- ACCEPTABLE -->
			<xsl:when test="/soap:Envelope/soap:Body/a1:GetTravelQuoteArrayResponse/a2:ArrayOfACORD_QuoteResp/a3:ACORD/a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:MsgStatus/a3:MsgStatusCd ='Success'">
				<results>
					<xsl:apply-templates select="/soap:Envelope/soap:Body/a1:GetTravelQuoteArrayResponse/a2:ArrayOfACORD_QuoteResp/a3:ACORD" />
				</results>
			</xsl:when>
			<xsl:otherwise>
			<!-- UNACCEPTABLE -->
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-1</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<xsl:template match="/soap:Envelope/soap:Body/a1:GetTravelQuoteArrayResponse/a2:ArrayOfACORD_QuoteResp/a3:ACORD">
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

		<xsl:variable name="todayYYYY"><xsl:value-of select="substring($today,1,4)" /></xsl:variable>
		<xsl:variable name="todayMM"><xsl:value-of select="substring($today,6,2)" /></xsl:variable>
		<xsl:variable name="todayDD"><xsl:value-of select="substring($today,9,2)" /></xsl:variable>
		<xsl:variable name="oneYearYYYY"><xsl:value-of select="number($todayYYYY) + 1" /></xsl:variable>
		<xsl:variable name="todayMMM">
			<xsl:call-template name="getMMM">
				<xsl:with-param name="MM" select="$todayMM" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="fromDate"><xsl:value-of select="$request/travel/dates/fromDate" /></xsl:variable>
		<xsl:variable name="toDate"><xsl:value-of select="$request/travel/dates/toDate" /></xsl:variable>

		<xsl:variable name="startDateFormatted"><xsl:value-of select="substring($fromDate,7,4)" />-<xsl:value-of select="substring($fromDate,4,2)" />-<xsl:value-of select="substring($fromDate,1,2)" /></xsl:variable>
		<xsl:variable name="endDateFormatted"><xsl:value-of select="substring($toDate,7,4)" />-<xsl:value-of select="substring($toDate,4,2)" />-<xsl:value-of select="substring($toDate,1,2)" /></xsl:variable>

		<xsl:variable name="thePrice">
			<xsl:value-of select="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:QuoteInfo/a3:InsuredFullToBePaidAmt/a3:Amt" />
		</xsl:variable>
		<xsl:variable name="thePlan">
			<xsl:variable name="planDesc">
				<xsl:value-of select="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:PlanDesc" />
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="contains($planDesc,' One Trip')">
					<xsl:value-of select="substring-before($planDesc, ' One Trip')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$planDesc" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="thePlace">
			<xsl:value-of select="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Destination/a3:DestinationDesc" />
		</xsl:variable>
		<xsl:variable name="dest">
			<xsl:value-of select="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Destination/a3:RqUID" />
		</xsl:variable>
		<xsl:variable name="uniqueId">
			<xsl:choose>
				<xsl:when test="$thePlan = 'Essential' and $thePlace = 'Domestic'">4</xsl:when>
				<xsl:when test="$thePlan = 'Essential' and $thePlace != 'Domestic'">1</xsl:when>
				<xsl:when test="$thePlan = 'Premium' and $thePlace = 'Domestic'">5</xsl:when>
				<xsl:when test="$thePlan = 'Premium' and $thePlace != 'Domestic'">2</xsl:when>
				<xsl:when test="$thePlan = 'Elite' and $thePlace = 'Domestic'">6</xsl:when>
				<xsl:when test="$thePlan = 'Elite' and $thePlace != 'Domestic'">3</xsl:when>
				<xsl:when test="$thePlan = 'Annual Trip' and $thePlace = 'Domestic'">8</xsl:when>
				<xsl:when test="$thePlan = 'Annual Trip' and $thePlace != 'Domestic'">7</xsl:when>
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
		<xsl:variable name="urlToYear"><xsl:value-of select="concat($todayDD, $todayMMM, $oneYearYYYY)" /></xsl:variable>

		<xsl:variable name="quoteURL">
			<xsl:value-of select="$rootURL" />
			<xsl:choose>
				<xsl:when test="$thePlace = 'Domestic'"><xsl:text>Domestic</xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>International</xsl:text></xsl:otherwise>
			</xsl:choose>
			<xsl:text>/?autoSubmit=true%26</xsl:text>
			<xsl:choose>
				<xsl:when test="$thePlace = 'Domestic'"><xsl:text>destinationid=</xsl:text></xsl:when>
				<xsl:otherwise><xsl:text>_DTA_DESTINATION_=</xsl:text></xsl:otherwise>
			</xsl:choose>
			<xsl:value-of select="translate($dest,'abcdefghijklmnopqrstuvwxyz0123456789-','ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-')"/>
			<xsl:text>%26_DTA_ADULTS_TRAVELLING_=</xsl:text><xsl:value-of select="$request/travel/adults"/>
			<xsl:text>%26_DTA_DEPENDANTS_TRAVELLING_=</xsl:text><xsl:value-of select="$request/travel/children"/>
			<xsl:text>%26_DTA_MULTI_TRIP_=</xsl:text>
			<xsl:choose>
				<xsl:when test="$uniqueId = '8' or $uniqueId = '7'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
			<xsl:text>%26_DTA_EFF_FROM_=</xsl:text>
			<xsl:choose>
				<xsl:when test="$request/travel/policyType = 'S'">
					<xsl:value-of select="$urlFromDate" />
					<xsl:text>%26_DTA_EFF_TO_=</xsl:text>
					<xsl:value-of select="$urlToDate" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$urlFromToday" />
					<xsl:text>%26_DTA_EFF_TO_=</xsl:text>
					<xsl:value-of select="$urlToYear" />
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>%26brokerCode=citictm</xsl:text>
		</xsl:variable>

		<xsl:variable name="travelDuration"><xsl:value-of select="$request/travel/soapDuration"></xsl:value-of></xsl:variable>


		<xsl:if test="($thePlan = 'Annual Trip' and $request/travel/policyType = 'A')
						or
					($thePlan != 'Annual Trip' and $request/travel/policyType = 'S' and $travelDuration &lt; 180)">
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
				<provider>Ace Travel Insurance</provider>
				<trackCode>28</trackCode>
				<name><xsl:value-of select="$thePlan"/></name>
				<des>
					<xsl:choose>
						<xsl:when test="$thePlan = 'Annual Trip'">
							<xsl:text>Annual &amp;#8211; Frequent Traveller (90 days per trip)</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$thePlan"/>
						</xsl:otherwise>
					</xsl:choose>
				</des>
				<price><xsl:value-of select="format-number($thePrice,'#0.00')" /></price>
				<priceText><xsl:value-of select="format-number($thePrice,'$#,##0.00')" /></priceText>
				<duration><xsl:value-of select="$travelDuration" /></duration>
				<info>
					<xsl:variable name="prod">
						<xsl:value-of select="concat(cover_level_brief,'-',cover_type_brief)" />
					</xsl:variable>
					<excess>
						<desc>Excess</desc>
						<xsl:choose>
							<xsl:when test="$thePlace = 'Domestic'">
								<value>50</value>
								<text>$50</text>
							</xsl:when>
							<xsl:otherwise>
								<value>100</value>
								<text>$100</text>
							</xsl:otherwise>
						</xsl:choose>
					</excess>
					<medical>
						<desc>Overseas Emergency Medical / Hospital / Dental Expenses</desc>
						<xsl:choose>
							<xsl:when test="$thePlace = 'Domestic'"> <!-- if domestic -->
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
					<xsl:when test="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:RqUID='cd797de8-fd76-4126-8148-9ff60122690c'"> <!-- if essential one trip international (plan 1) -->
						<cxdfee>
							<desc>Cancellation Fees</desc>
							<value>25000</value>
							<text>$25,000</text>
						</cxdfee>
						<luggage>
							<desc>Luggage and Personal Effects</desc>
							<value>5000</value>
							<text>$5,000</text>
						</luggage>
						<expenses>
							<desc>Additional Expenses</desc>
							<value>999999999</value>
							<text>Unlimited</text>
						</expenses>
						<luggagedel>
							<desc>Delayed Luggage Allowance (more than 24 hours)</desc>
							<value>750</value>
							<text>$250 (more than 24 hours)&lt;br&gt;$750 (more than 72 hours)</text>
						</luggagedel>
						<delayExp>
							<desc>Travel Delay Accommodation</desc>
							<value>250</value>
							<text>$250</text>
						</delayExp>
						<hospitalcas>
						<desc>Cash in Hospital</desc>
							<value>5000</value>
							<text>$100 (daily amount)&lt;br&gt;$5,000 (maximum amount)</text>
						</hospitalcas>
						<liability>
							<desc>Personal Liability</desc>
							<value>2000000</value>
							<text>$2,000,000</text>
						</liability>
						<death>
							<desc>Accidental Death</desc>
							<value>20000</value>
							<text>$20,000</text>
						</death>
					</xsl:when>
					<xsl:when test="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:RqUID='889ccf0a-d96f-4166-876d-9ff601227b0e'"> <!-- if premium one trip international (plan 2) -->
						<cxdfee>
							<desc>Cancellation Fees</desc>
							<value>50000</value>
							<text>$50,000</text>
						</cxdfee>
						<luggage>
							<desc>Luggage and Personal Effects</desc>
							<value>10000</value>
							<text>$10,000</text>
						</luggage>
						<expenses>
							<desc>Additional Expenses</desc>
							<value>999999999</value>
							<text>Unlimited</text>
						</expenses>
						<luggagedel>
							<desc>Delayed Luggage Allowance (more than 24 hours)</desc>
							<value>1000</value>
							<text>$500 (more than 24 hours)&lt;br&gt;$1,000 (more than 72 hours)</text>
						</luggagedel>
						<replacementMoney>
							<desc>Replacement of Money</desc>
							<value>200</value>
							<text>$200</text>
						</replacementMoney>
						<rentalVeh>
							<desc>Rental Vehicle Excess</desc>
							<value>3000</value>
							<text>$3,000</text>
						</rentalVeh>
						<delayExp>
							<desc>Travel Delay Accommodation</desc>
							<value>500</value>
							<text>$500</text>
						</delayExp>
						<flightDelay>
							<desc>Flight Delay</desc>
							<value>200</value>
							<text>$100 more than 4 hours&lt;br&gt;$200 more than 12 hours</text>
						</flightDelay>
						<hospitalcas>
							<desc>Cash in Hospital</desc>
							<value>10000</value>
							<text>$100 (daily amount)&lt;br&gt;$10,000 (maximum amount)</text>
						</hospitalcas>
						<liability>
							<desc>Personal Liability</desc>
							<value>3000000</value>
							<text>$3,000,000</text>
						</liability>
						<death>
							<desc>Accidental Death</desc>
							<value>25000</value>
							<text>$25,000</text>
						</death>
						<cardBalance>
							<desc>Credit Card Balance</desc>
							<value></value>
							<text></text>
						</cardBalance>
						<legalExp>
							<desc>Legal Expenses</desc>
							<value></value>
							<text></text>
						</legalExp>
					</xsl:when>
					<xsl:when test="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:RqUID='d4066446-0598-4e67-a985-9ff6012283d6'"> <!-- if elite one trip international (plan 3) -->
						<cxdfee>
							<desc>Cancellation Fees</desc>
							<value>999999999</value>
							<text>Unlimited</text>
						</cxdfee>
						<luggage>
							<desc>Luggage and Personal Effects</desc>
							<value>30000</value>
							<text>$30,000</text>
						</luggage>
						<expenses>
							<desc>Additional Expenses</desc>
							<value>999999999</value>
							<text>Unlimited</text>
						</expenses>
						<luggagedel>
							<desc>Delayed Luggage Allowance (more than 24 hours)</desc>
							<value>1500</value>
							<text>$750 (more than 24 hours)&lt;br&gt;$1500 (more than 72 hours)</text>
						</luggagedel>
						<persMoney>
							<desc>Replacement of Money</desc>
							<value>200</value>
							<text>$200</text>
						</persMoney>
						<rentalVeh>
							<desc>Rental Vehicle Excess</desc>
							<value>5000</value>
							<text>$5,000</text>
						</rentalVeh>
						<delayExp>
							<desc>Travel Delay Accommodation</desc>
							<value>1500</value>
							<text>$1,500</text>
						</delayExp>
						<flightDelay>
							<desc>Flight Delay</desc>
							<value>300</value>
							<text>$150 more than 4 hours&lt;br&gt;$300 more than 12 hours</text>
						</flightDelay>
						<hospitalcas>
							<desc>Cash in Hospital</desc>
							<value>15000</value>
							<text>$150 (daily amount)&lt;br&gt;$15,000 (maximum amount)</text>
						</hospitalcas>
						<liability>
							<desc>Personal Liability</desc>
							<value>5000000</value>
							<text>$5,000,000</text>
						</liability>
						<death>
							<desc>Accidental Death</desc>
							<value>100000</value>
							<text>$100,000</text>
						</death>
						<cardBalance>
							<desc>Credit Card Balance</desc>
							<value>2500</value>
							<text>$2,500</text>
						</cardBalance>
						<legalExp>
							<desc>Legal Expenses</desc>
							<value>5000</value>
							<text>$5,000</text>
						</legalExp>
					</xsl:when>
					<xsl:when test="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:RqUID='12b6e6d8-222e-42c3-9540-9ff7006e08d3'"> <!-- if essential one trip domestic (plan 4) -->
						<cxdfee>
							<desc>Cancellation Fees</desc>
							<value>10000</value>
							<text>$10,000</text>
						</cxdfee>
						<luggage>
							<desc>Luggage and Personal Effects</desc>
							<value>2000</value>
							<text>$2,000</text>
						</luggage>
						<expenses>
							<desc>Additional Expenses</desc>
							<value>15000</value>
							<text>$15,000</text>
						</expenses>
						<luggagedel>
							<desc>Delayed Luggage Allowance (more than 24 hours)</desc>
							<value>1000</value>
							<text>$500 (more than 24 hours)&lt;br&gt;$1,000 (more than 72 hours)</text>
						</luggagedel>
						<death>
							<desc>Accidental Death</desc>
							<value>20000</value>
							<text>$20,000</text>
						</death>
					</xsl:when>
					<xsl:when test="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:RqUID='1b2da56c-c300-406c-b7da-9ff7006e14c0'"> <!-- if premium one trip domestic (plan 5) -->
						<cxdfee>
							<desc>Cancellation Fees</desc>
							<value>15000</value>
							<text>$15,000</text>
						</cxdfee>
						<luggage>
							<desc>Luggage and Personal Effects</desc>
							<value>5000</value>
							<text>$5,000</text>
						</luggage>
						<expenses>
							<desc>Additional Expenses</desc>
							<value>15000</value>
							<text>$15,000</text>
						</expenses>
						<luggagedel>
							<desc>Delayed Luggage Allowance (more than 24 hours)</desc>
							<value>1000</value>
							<text>$500 (more than 24 hours)&lt;br&gt;$1,000 (more than 72 hours)</text>
						</luggagedel>
						<delayExp>
							<desc>Travel Delay Accommodation</desc>
							<value>850</value>
							<text>$850</text>
						</delayExp>
						<liability>
							<desc>Personal Liability</desc>
							<value>200000</value>
							<text>$200,000</text>
						</liability>
						<death>
							<desc>Accidental Death</desc>
							<value>25000</value>
							<text>$25,000</text>
						</death>
					</xsl:when>
					<xsl:when test="$uniqueId = '6'"> <!-- if elite one trip domestic (plan 6) -->
						<cxdfee>
							<desc>Cancellation Fees</desc>
							<value>25000</value>
							<text>$25,000</text>
						</cxdfee>
						<luggage>
							<desc>Luggage and Personal Effects</desc>
							<value>10000</value>
							<text>$10,000</text>
						</luggage>
						<expenses>
							<desc>Additional Expenses</desc>
							<value>15000</value>
							<text>$15,000</text>
						</expenses>
						<luggagedel>
							<desc>Delayed Luggage Allowance (more than 24 hours)</desc>
							<value>1500</value>
							<text>$500 (more than 24 hours)&lt;br&gt;$1,500 (more than 72 hours)</text>
						</luggagedel>
						<rentalVeh>
							<desc>Rental Vehicle Excess</desc>
							<value>5000</value>
							<text>$5,000</text>
						</rentalVeh>
						<delayExp>
							<desc>Travel Delay Accommodation</desc>
							<value>850</value>
							<text>$850</text>
						</delayExp>
						<liability>
							<desc>Personal Liability</desc>
							<value>1000000</value>
							<text>$1,000,000</text>
						</liability>
						<death>
							<desc>Accidental Death</desc>
							<value>100000</value>
							<text>$100,000</text>
						</death>
					</xsl:when>
					<xsl:when test="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:RqUID='1cd185dd-b866-4d0a-9e89-9ff601229039' and $request/travel/policyType = 'A'"> <!-- if worldwide annual international (plan 7) -->
						<cxdfee>
							<desc>Cancellation Fees</desc>
							<value>50000</value>
							<text>$50,000</text>
						</cxdfee>
						<luggage>
							<desc>Luggage and Personal Effects</desc>
							<value>10000</value>
							<text>$10,000</text>
						</luggage>
						<expenses>
							<desc>Additional Expenses</desc>
							<value>999999999</value>
							<text>Unlimited</text>
						</expenses>
						<luggagedel>
							<desc>Delayed Luggage Allowance (more than 24 hours)</desc>
							<value>1000</value>
							<text>$500 (more than 24 hours)&lt;br&gt;$1,000 (more than 72 hours)</text>
						</luggagedel>
						<persMoney>
							<desc>Replacement of Money</desc>
							<value>300</value>
							<text>$300</text>
						</persMoney>
						<rentalVeh>
							<desc>Rental Vehicle Excess</desc>
							<value>3000</value>
							<text>$3,000</text>
						</rentalVeh>
						<delayExp>
							<desc>Travel Delay Accommodation</desc>
							<value>1200</value>
							<text>$1,200</text>
						</delayExp>
						<flightDelay>
							<desc>Flight Delay</desc>
							<value>200</value>
							<text>$100 more than 4 hours&lt;br&gt;$200 more than 12 hours</text>
						</flightDelay>
						<hospitalcas>
							<desc>Cash in Hospital</desc>
							<value>10000</value>
							<text>$100 (daily amount)&lt;br&gt;$10,000 (maximum amount)</text>
						</hospitalcas>
						<liability>
							<desc>Personal Liability</desc>
							<value>3000000</value>
							<text>$3,000,000</text>
						</liability>
						<death>
							<desc>Accidental Death</desc>
							<value>25000</value>
							<text>$25,000</text>
						</death>
					</xsl:when>
					<xsl:when test="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:RqUID='ae59e6ac-d3bd-4606-a958-9ff70023c82b'"> <!-- if worldwide annual domestic (plan 8) -->
						<cxdfee>
							<desc>Cancellation Fees</desc>
							<value>15000</value>
							<text>$15,000</text>
						</cxdfee>
						<luggage>
							<desc>Luggage and Personal Effects</desc>
							<value>5000</value>
							<text>$5,000</text>
						</luggage>
						<expenses>
							<desc>Additional Expenses</desc>
							<value>15000</value>
							<text>$15,000</text>
						</expenses>
						<luggagedel>
							<desc>Delayed Luggage Allowance (more than 24 hours)</desc>
							<value>1000</value>
							<text>$500 (more than 24 hours)&lt;br&gt;$1,000 (more than 72 hours)</text>
						</luggagedel>
						<rentalVeh>
							<desc>Rental Vehicle Excess</desc>
							<value>3000</value>
							<text>$3,000</text>
						</rentalVeh>
						<delayExp>
							<desc>Travel Delay Accommodation</desc>
							<value>850</value>
							<text>$850</text>
						</delayExp>
						<liability>
							<desc>Personal Liability</desc>
							<value>200000</value>
							<text>$200,000</text>
						</liability>
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

				<journeyResum>
					<desc>Resumption of Journey</desc>
					<value>3000</value>
					<text>$3,000</text>
				</journeyResum>
				<hijack>
					<desc>Public Hijacking and Kidnapping</desc>
					<value>15000</value>
					<text>$1000 (daily amount)&lt;br&gt;$15000 (maximum amount)</text>
				</hijack>

				<contractStartDate>
					<xsl:value-of select="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:ContractTerm/a3:EffectiveDt" />
				</contractStartDate>
				<contractEndDate>
					<xsl:value-of select="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:ContractTerm/a3:ExpirationDt" />
				</contractEndDate>
				<packageDesc></packageDesc>

				</info>
				<infoDes>Citibank Travel Insurance offers a wide range of cover options at competitive prices. Cover is available for both domestic and international travel. Citibank Travel Insurance is underwritten by ACE Insurance and offers 24 hour, 7 days a week worldwide emergency assistance through ACE Assistance.</infoDes>

				<xsl:choose>
					<xsl:when test="$request/travel/policyType = 'S'">
						<subTitle>https://citibank.aceinsurance.com.au/aceStatic/ACETravel/CitibankAU/files/CitibankTravelInsurance.pdf</subTitle>
					</xsl:when>
					<xsl:otherwise>
						<subTitle>https://citibank.aceinsurance.com.au/aceStatic/ACETravel/CitibankAU/files/CitibankFrequentTravellerInsurance.pdf</subTitle>
					</xsl:otherwise>
				</xsl:choose>
				<acn>23 001 642 020</acn>
				<afsLicenceNo>239687</afsLicenceNo>
				<quoteUrl><xsl:value-of select="normalize-space($quoteURL)" /></quoteUrl>
			</xsl:element>
		</xsl:if>
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

	<xsl:template name="aceDate">
	<xsl:param name="ourDate" />
		<xsl:variable name="MMM">
			<xsl:choose>
				<xsl:when test="substring($ourDate,4,2) = '01'">-Jan-</xsl:when>
				<xsl:when test="substring($ourDate,4,2) = '02'">-Feb-</xsl:when>
				<xsl:when test="substring($ourDate,4,2) = '03'">-Mar-</xsl:when>
				<xsl:when test="substring($ourDate,4,2) = '04'">-Apr-</xsl:when>
				<xsl:when test="substring($ourDate,4,2) = '05'">-May-</xsl:when>
				<xsl:when test="substring($ourDate,4,2) = '06'">-Jun-</xsl:when>
				<xsl:when test="substring($ourDate,4,2) = '07'">-Jul-</xsl:when>
				<xsl:when test="substring($ourDate,4,2) = '08'">-Aug-</xsl:when>
				<xsl:when test="substring($ourDate,4,2) = '09'">-Sep-</xsl:when>
				<xsl:when test="substring($ourDate,4,2) = '10'">-Oct-</xsl:when>
				<xsl:when test="substring($ourDate,4,2) = '11'">-Nov-</xsl:when>
				<xsl:otherwise>-Dec-</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat(substring($ourDate,1,2), $MMM, substring($ourDate,7,4))" />
	</xsl:template>

</xsl:stylesheet>