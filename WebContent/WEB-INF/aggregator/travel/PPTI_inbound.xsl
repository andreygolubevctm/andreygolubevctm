<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:a1="http://ACE.Global.Travel.CRS.Schemas.ACORD.WS/"
	xmlns:a2="http://ACE.Global.Travel.CRS.Schemas.ACORD_QuoteArrayResp"
	xmlns:a3="http://ACE.Global.Travel.CRS.Schemas.ACORD_QuoteResp"
	exclude-result-prefixes="soap a1 a2 a3">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/unavailable.xsl" />

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId">*NONE</xsl:param>
	<xsl:param name="defaultProductId"><xsl:value-of select="$productId" /></xsl:param>
	<xsl:param name="service">PPTI</xsl:param>
	<xsl:param name="request" />
	<xsl:param name="rootURL" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<xsl:template match="/">
		<xsl:choose>
			<!-- DO NOTHING -->
			<xsl:when test="$request/travel/oldest &lt; 18 or $request/travel/oldest &gt; 74">
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-1</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="soap:Envelope/soap:Body/a1:GetTravelQuoteArrayResponse/a2:ArrayOfACORD_QuoteResp/a3:ACORD/a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:MsgStatus/a3:MsgStatusCd[not(.='Rejected')])">
				<!-- UNACCEPTABLE. If all MsgStatusCd are all set to Rejected, show unavailable template  -->
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-1</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- ACCEPTABLE -->
				<results>
					<xsl:apply-templates select="soap:Envelope/soap:Body/a1:GetTravelQuoteArrayResponse/a2:ArrayOfACORD_QuoteResp/a3:ACORD" />
				</results>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<xsl:template match="a3:ACORD">
		<xsl:if  test="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:MsgStatus/a3:MsgStatusCd ='Success'">

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
			<xsl:variable name="toDate"><xsl:value-of select="$request/travel/dates/toDate" /></xsl:variable>

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
			<xsl:variable name="insuredPackage">
				<xsl:value-of select="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_InsuredPackage/a3:RqUID" />
			</xsl:variable>
			<xsl:variable name="uniqueId">
				<xsl:choose>
					<xsl:when test="$thePlan = 'Basic' and $thePlace != 'Australia'">1</xsl:when>
					<xsl:when test="$thePlan = 'Essential' and $thePlace = 'Australia'">4</xsl:when>
					<xsl:when test="$thePlan = 'Essential' and $thePlace != 'Australia'">2</xsl:when>
					<xsl:when test="$thePlan = 'Premium' and $thePlace = 'Australia'">5</xsl:when>
					<xsl:when test="$thePlan = 'Premium' and $thePlace != 'Australia'">3</xsl:when>
					<xsl:when test="$thePlan = 'Annual Trip' and $thePlace = 'Australia'">7</xsl:when>
					<xsl:when test="$thePlan = 'Annual Trip' and $thePlace != 'Australia'">6</xsl:when>
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
				<xsl:if test="$thePlace = 'Australia'"><xsl:text>/Domestic</xsl:text></xsl:if>
				<xsl:text>/?autoSubmit=true%26</xsl:text>
				<xsl:text>_DTA_COVER_FOR_=</xsl:text>
				<xsl:value-of select="translate($insuredPackage,'abcdefghijklmnopqrstuvwxyz0123456789-','ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-')"/>
				<xsl:text>%26_DTA_DESTINATION_=</xsl:text>
				<xsl:value-of select="translate($dest,'abcdefghijklmnopqrstuvwxyz0123456789-','ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-')"/>
				<xsl:text>%26_DTA_MULTI_TRIP_=</xsl:text>
				<xsl:choose>
					<xsl:when test="$uniqueId = '6' or $uniqueId = '7'">true</xsl:when>
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
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>%26_DTA_SPOOF_ADULTS_TRAVELLING_=</xsl:text>
				<xsl:choose>
					<xsl:when test="($request/travel/oldest &gt;= 18) and ($request/travel/oldest &lt;= 69)">
						<xsl:value-of select="$request/travel/adults"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
				<xsl:text>%26_DTA_DEPENDANTS_TRAVELLING_=</xsl:text>
				<xsl:value-of select="$request/travel/children"/>
				<xsl:text>%26_DTA_SENIORS_TRAVELLING_=</xsl:text>
				<xsl:choose>
					<xsl:when test="($request/travel/oldest &gt;= 70) and ($request/travel/oldest &lt;= 74)">
						<xsl:value-of select="$request/travel/adults"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
				<xsl:text>%26brokerCode=pricelinectm</xsl:text>
			</xsl:variable>

			<xsl:variable name="travelDuration"><xsl:value-of select="$request/travel/soapDuration"></xsl:value-of></xsl:variable>


			<xsl:if test="($thePlan = 'Annual Trip' and $request/travel/policyType = 'A')
							or
						($thePlan != 'Annual Trip' and $request/travel/policyType = 'S' and $travelDuration &lt; 181)">
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
					<provider>Priceline Protects Travel Insurance</provider>
					<trackCode>60</trackCode>
					<name><xsl:value-of select="$thePlan"/></name>
					<des>
						Priceline Protects <xsl:value-of select="$thePlan"/> Plan
					</des>
					<price><xsl:value-of select="format-number($thePrice,'#0.00')" /></price>
					<priceText><xsl:value-of select="format-number($thePrice,'$#,##0.00')" /></priceText>
					<duration><xsl:value-of select="$travelDuration" /></duration>
					<info>
						<xsl:variable name="prod">
							<xsl:value-of select="concat(cover_level_brief,'-',cover_type_brief)" />
						</xsl:variable>
						<excess>
							<desc>Excess on claims</desc>
							<xsl:choose>
								<xsl:when test="$thePlace = 'Australia'">
									<value>100</value>
									<text>$100</text>
								</xsl:when>
								<xsl:otherwise>
									<value>250</value>
									<text>$250</text>
								</xsl:otherwise>
							</xsl:choose>
						</excess>
						<medical>
							<desc>Overseas Emergency Medical / Hospital / Dental Expenses</desc>
							<xsl:choose>
								<xsl:when test="$thePlace = 'Australia'"> <!-- if domestic -->
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
						<xsl:when test="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:RqUID='8210a68c-bfec-4c40-b963-a1cf00388197'"> <!-- if basic one trip international (plan 1) -->
							<cxdfee>
								<desc>Cancellation Fees</desc>
								<value>0</value>
								<text>N/A</text>
							</cxdfee>
							<luggage>
								<desc>Luggage and Personal Effects</desc>
								<value>0</value>
								<text>N/A</text>
							</luggage>
							<emergencyAss>
								<desc>Emergency Assistance</desc>
								<value>999999999</value>
								<text>Included</text>
							</emergencyAss>
							<liability>
								<desc>Personal Liability</desc>
								<value>1000000</value>
								<text>$1,000,000</text>
							</liability>
						</xsl:when>
						<xsl:when test="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:RqUID='c9b94be1-99a7-4523-b682-a1cf00389c0c'"> <!-- if essential one trip international (plan 2) -->
							<cxdfee>
								<desc>Cancellation Fees</desc>
								<value>5000</value>
								<text>$5,000</text>
							</cxdfee>
							<luggage>
								<desc>Luggage and Personal Effects</desc>
								<value>1500</value>
								<text>$1,500</text>
							</luggage>
							<emergencyAss>
								<desc>Emergency Assistance</desc>
								<value>999999999</value>
								<text>Included</text>
							</emergencyAss>
							<homeHelp>
								<desc>Home Help</desc>
								<value>500</value>
								<text>$500</text>
							</homeHelp>
							<expenses>
								<desc>Additional Expenses</desc>
								<value>999999999</value>
								<text>Unlimited</text>
							</expenses>
							<liability>
								<desc>Personal Liability</desc>
								<value>2000000</value>
								<text>$2,000,000</text>
							</liability>
							<journeyResum>
								<desc>Resumption of Journey</desc>
								<value>3000</value>
								<text>$3,000</text>
							</journeyResum>
							<specialEvents>
								<desc>Special Events</desc>
								<value>2000</value>
								<text>$2,000</text>
							</specialEvents>
						</xsl:when>
						<xsl:when test="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:RqUID='0eb6cdfa-2e4e-4108-804a-a1cf0038b64f'"> <!-- if premium one trip international (plan 3) -->
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
							<emergencyAss>
								<desc>Emergency Assistance</desc>
								<value>999999999</value>
								<text>Included</text>
							</emergencyAss>
							<homeHelp>
								<desc>Home Help</desc>
								<value>500</value>
								<text>$500</text>
							</homeHelp>
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
								<value>200</value>
								<text>$200</text>
							</persMoney>
							<journeyResum>
								<desc>Resumption of Journey</desc>
								<value>3000</value>
								<text>$3,000</text>
							</journeyResum>
							<delayExp>
								<desc>Travel Delay Accommodation</desc>
								<value>500</value>
								<text>$500</text>
							</delayExp>
							<flightDelay>
								<desc>Flight Delay</desc>
								<value>200</value>
								<text>$100 (more than 4 hours)&lt;br&gt;$200 (more than 12 hours)</text>
							</flightDelay>
							<hospitalcas>
								<desc>Cash in Hospital</desc>
								<value>10000</value>
								<text>$100 (daily)&lt;br&gt;$10,000 (maximum)</text>
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
							<hijack>
								<desc>Public Hijacking and Kidnapping</desc>
								<value>15000</value>
								<text>$1,000 (daily)&lt;br&gt;$15,000 (maximum)</text>
							</hijack>
							<specialEvents>
								<desc>Special Events</desc>
								<value>2000</value>
								<text>$2,000</text>
							</specialEvents>
						</xsl:when>
						<xsl:when test="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:RqUID='071c54b8-47aa-488a-99ba-a1d50015f7e6'"> <!-- if essential one trip domestic (plan 4) -->
							<cxdfee>
								<desc>Cancellation Fees</desc>
								<value>2500</value>
								<text>$2,500</text>
							</cxdfee>
							<luggage>
								<desc>Luggage and Personal Effects</desc>
								<value>1000</value>
								<text>$1,000</text>
							</luggage>
							<expenses>
								<desc>Additional Expenses</desc>
								<value>15000</value>
								<text>$15,000</text>
							</expenses>
							<homeHelp>
								<desc>Home Help</desc>
								<value>500</value>
								<text>$500</text>
							</homeHelp>
							<liability>
								<desc>Personal Liability</desc>
								<value>2000</value>
								<text>$2,000</text>
							</liability>
							<journeyResum>
								<desc>Resumption of Journey</desc>
								<value>3000</value>
								<text>$3,000</text>
							</journeyResum>
						</xsl:when>
						<xsl:when test="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:RqUID='334bd224-ff11-485c-890d-a1d500160936'"> <!-- if premium one trip domestic (plan 5) -->
							<cxdfee>
								<desc>Cancellation Fees</desc>
								<value>5000</value>
								<text>$5,000</text>
							</cxdfee>
							<luggage>
								<desc>Luggage and Personal Effects</desc>
								<value>3500</value>
								<text>$3,500</text>
							</luggage>
							<homeHelp>
								<desc>Home Help</desc>
								<value>500</value>
								<text>$500</text>
							</homeHelp>
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
							<journeyResum>
								<desc>Resumption of Journey</desc>
								<value>3000</value>
								<text>$3,000</text>
							</journeyResum>
							<delayExp>
								<desc>Travel Delay Accommodation</desc>
								<value>500</value>
								<text>$500</text>
							</delayExp>
							<flightDelay>
								<desc>Flight Delay</desc>
								<value>200</value>
								<text>$100 (more than 4 hours)&lt;br&gt;$200 (more than 12 hours)</text>
							</flightDelay>
							<liability>
								<desc>Personal Liability</desc>
								<value>2000</value>
								<text>$2,000</text>
							</liability>
							<death>
								<desc>Accidental Death</desc>
								<value>25000</value>
								<text>$25,000</text>
							</death>
							<specialEvents>
								<desc>Special Events</desc>
								<value>2000</value>
								<text>$2,000</text>
							</specialEvents>
						</xsl:when>
						<xsl:when test="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:RqUID='4f466c05-2738-4829-8412-a1cf0038d032' and $request/travel/policyType = 'A'"> <!-- if worldwide annual international (plan 6) -->
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
							<emergencyAss>
								<desc>Emergency Assistance</desc>
								<value>999999999</value>
								<text>Included</text>
							</emergencyAss>
							<homeHelp>
								<desc>Home Help</desc>
								<value>500</value>
								<text>$500</text>
							</homeHelp>
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
								<value>200</value>
								<text>$200</text>
							</persMoney>
							<journeyResum>
								<desc>Resumption of Journey</desc>
								<value>3000</value>
								<text>$3,000</text>
							</journeyResum>
							<delayExp>
								<desc>Travel Delay Accommodation</desc>
								<value>500</value>
								<text>$500</text>
							</delayExp>
							<flightDelay>
								<desc>Flight Delay</desc>
								<value>200</value>
								<text>$100 (more than 4 hours)&lt;br&gt;$200 (more than 12 hours)</text>
							</flightDelay>
							<hospitalcas>
								<desc>Cash in Hospital</desc>
								<value>10000</value>
								<text>$100 (daily)&lt;br&gt;$10,000 (maximum)</text>
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
							<hijack>
								<desc>Public Hijacking and Kidnapping</desc>
								<value>15000</value>
								<text>$1,000 (daily)&lt;br&gt;$15,000 (maximum)</text>
							</hijack>
							<specialEvents>
								<desc>Special Events</desc>
								<value>2000</value>
								<text>$2,000</text>
							</specialEvents>
						</xsl:when>
						<xsl:when test="a3:InsuranceSvcRs/a3:PersPkgPolicyQuoteInqRs/a3:PersPolicy/a3:com.acegroup_Plan/a3:RqUID='289a1d33-85a1-463d-9a1d-a1d500161b78'"> <!-- if worldwide annual domestic (plan 7) -->
							<cxdfee>
								<desc>Cancellation Fees</desc>
								<value>5000</value>
								<text>$5,000</text>
							</cxdfee>
							<luggage>
								<desc>Luggage and Personal Effects</desc>
								<value>3500</value>
								<text>$3,500</text>
							</luggage>
							<homeHelp>
								<desc>Home Help</desc>
								<value>500</value>
								<text>$500</text>
							</homeHelp>
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
							<journeyResum>
								<desc>Resumption of Journey</desc>
								<value>3000</value>
								<text>$3,000</text>
							</journeyResum>
							<delayExp>
								<desc>Travel Delay Accommodation</desc>
								<value>500</value>
								<text>$500</text>
							</delayExp>
							<flightDelay>
								<desc>Flight Delay</desc>
								<value>200</value>
								<text>$100 (more than 4 hours)&lt;br&gt;$200 (more than 12 hours)</text>
							</flightDelay>
							<liability>
								<desc>Personal Liability</desc>
								<value>2000</value>
								<text>$2,000</text>
							</liability>
							<death>
								<desc>Accidental Death</desc>
								<value>25000</value>
								<text>$25,000</text>
							</death>
							<specialEvents>
								<desc>Special Events</desc>
								<value>2000</value>
								<text>$2,000</text>
							</specialEvents>
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
					<infoDes>Priceline Protects offers a wide range of cover options at competitive prices. Cover is available for both domestic and international travel. Priceline Protects is underwritten by ACE Insurance and offers 24 hour, 7 days a week worldwide emergency assistance through ACE Assistance.</infoDes>
					<subTitle>https://www.pricelineprotects.com.au/aceStatic/ACETravel/PricelineAU/files/PolicyWording.pdf</subTitle>
					<acn>23 001 642 020</acn>
					<afsLicenceNo>239687</afsLicenceNo>
					<quoteUrl><xsl:value-of select="normalize-space($quoteURL)" /></quoteUrl>
				</xsl:element>
			</xsl:if>
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