<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:pr="http://pricingapi.agaassistance.com.au/PricingResponse.xsd"
	exclude-result-prefixes="soapenv pr">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/countryMapping.xsl" />
	<xsl:import href="utilities/string_formatting.xsl" />
	<xsl:import href="utilities/unavailable.xsl"/>
	<xsl:import href="includes/zuji_benefits.xsl"/>

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId">*NONE</xsl:param>
	<xsl:param name="defaultProductId"><xsl:value-of select="$productId" /></xsl:param>
	<xsl:param name="service"></xsl:param>
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="quoteUrl" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">

		<xsl:choose>
			<!-- ACCEPTABLE -->
			<xsl:when test="/pr:PricingResponse/pr:Plans/pr:Plan/pr:PlanId">
				<xsl:apply-templates select="/pr:PricingResponse/pr:Plans"/>
			</xsl:when>
			<!-- UNACCEPTABLE -->
			<xsl:otherwise>
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-8</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!-- VARS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="code_cancellation">8</xsl:variable>
	<xsl:variable name="code_overseas_medical">2</xsl:variable>
	<xsl:variable name="code_baggage">12</xsl:variable>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/pr:PricingResponse/pr:Plans">
		<results>
			<xsl:for-each select="pr:Plan">
				<xsl:variable name="planId"><xsl:value-of select="pr:PlanId" /></xsl:variable>
				<xsl:choose>
					<xsl:when test="$planId &lt; 53438">
						<xsl:element name="price">
							<xsl:variable name="campaign">
								<xsl:choose>
									<xsl:when test="$planId = 53429 or $planId = 53430 or $planId = 53431">comprehensive</xsl:when>
									<xsl:when test="$planId = 53432 or $planId = 53433 or $planId = 53434">essentials</xsl:when>
									<xsl:when test="$planId = 53435 or $planId = 53436 or $planId = 53437">medical</xsl:when>
									<xsl:when test="$planId = 53438">multi</xsl:when>
									<xsl:otherwise>cancellation</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<xsl:variable name="regionCode">
								<xsl:choose>
									<xsl:when test="$request/travel/policyType = 'S'">
										<xsl:call-template name="getRegionMapping">
											<xsl:with-param name="selectedRegions" select="$request/travel/mappedCountries/ZUJI/regions" />
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>WORLD</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>


							<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
							<xsl:attribute name="productId">
								<xsl:value-of select="$service" />-TRAVEL-<xsl:value-of select="$planId" />
								<xsl:choose>
									<xsl:when test="pr:PlanLevel = 'MULTI'"><xsl:value-of select="pr:MaxTripDuration" /></xsl:when>
								</xsl:choose>
							</xsl:attribute>
							<available>Y</available>
							<transactionId><xsl:value-of select="$transactionId"/></transactionId>
							<provider>Zuji Travel Insurance</provider>
							<trackCode>35</trackCode>
							<name><xsl:value-of select="pr:PlanName"/></name>
							<des><xsl:value-of select="pr:PlanName"/></des>
							<price><xsl:value-of select="format-number(pr:Premium,'#.00')"/></price>
							<priceText>$<xsl:value-of select="format-number(pr:Premium,'#.00')"/></priceText>
							<xsl:variable name="otherNodes" />


							<info>
								<!-- MUST HAVE EXCESS, MEDICAL, CANCELLATION AND LUGGAGE AS THEY ARE REQUIRED FIELDS FOR THE PRICE PRESENTATION PAGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
								<excess>
									<desc>Excess</desc>
									<text>$<xsl:call-template name="formatAmount">
													<xsl:with-param name="amount" select="pr:Excess" />
												</xsl:call-template></text>
									<value><xsl:call-template name="formatAmount">
													<xsl:with-param name="amount" select="pr:Excess" />
												</xsl:call-template></value>
								</excess>
								<xsl:call-template name="getBenefits">
									<xsl:with-param name="planId" select="$planId" />
								</xsl:call-template>
								
							</info>
							<infoDes>
								Zuji is one of Asia Pacific's leading online travel agencies, a  position the company has held for more than 10 years. ZUJI empowers customers to travel in their own unique way by providing easy-to-use technology and choice.
							</infoDes>
							<subTitle>https://api.agaassistance.com.au/Content/zuji/attachments/ProductDisclosureStatement.pdf</subTitle>
							<acn></acn>
							<afsLicenceNo></afsLicenceNo>
							<quoteUrl><xsl:value-of select="$quoteUrl"/>?regioncode=<xsl:value-of select="$regionCode" />%26startDate=<xsl:value-of select="$request/travel/dates/fromDate" />%26endDate=<xsl:value-of select="$request/travel/dates/toDate" />%26numAdults=<xsl:value-of select="$request/travel/adults" />%26numchildren=<xsl:value-of select="$request/travel/children" />%26transaction_Id=<xsl:value-of select="$transactionId"/>%26utm_source=comparethemarket%26utm_medium=cpc%26utm_campaign=<xsl:value-of select="$campaign"/></quoteUrl>
						</xsl:element>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$request/travel/policyType = 'A'">
							<price service="ZUJI" productId="ZUJI-TRAVEL-8">
								<available>N</available>
								<transactionId><xsl:value-of select="$transactionId"/></transactionId>
								<error type="unavailable" service="ZUJI">
									<code/>
									<message>unavailable</message>
									<data/>
								</error>
								<name/>
								<des/>
								<info/>
							</price>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</results>
	</xsl:template>
</xsl:stylesheet>