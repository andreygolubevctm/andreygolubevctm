<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:pr="http://pricingapi.agaassistance.com.au/PricingResponse.xsd"
	exclude-result-prefixes="soapenv pr">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/string_formatting.xsl" />
	<xsl:import href="utilities/unavailable.xsl"/>
	<xsl:import href="includes/webjet_benefits.xsl"/>

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
				<xsl:if test="$planId &lt; 51026">
					<xsl:element name="price">
						<xsl:variable name="campaign">
					<xsl:choose>
							<xsl:when test="$planId = 51016 or $planId = 51017 or $planId = 51018">comprehensive</xsl:when>
							<xsl:when test="$planId = 51019 or $planId = 51020 or $planId = 51021">essentials</xsl:when>
							<xsl:when test="$planId = 51022 or $planId = 51023 or $planId = 51024">medical</xsl:when>
							<xsl:when test="$planId = 51025">multi</xsl:when>
							<xsl:otherwise>cancellation</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

					<xsl:variable name="regionCode">
					<xsl:choose>
							<xsl:when test="policyType = 'A'">WORLD</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
										<!-- Africa, Worldwide, Canada, Middle East, Japan -->
									<xsl:when test="$request/travel/destinations/af/af !=''">WORLD</xsl:when>
									<xsl:when test="$request/travel/destinations/do/do !=''">WORLD</xsl:when>
									<xsl:when test="$request/travel/destinations/am/ca !=''">WORLD</xsl:when>
									<xsl:when test="$request/travel/destinations/me/me !=''">WORLD</xsl:when>
									<xsl:when test="$request/travel/destinations/as/jp !=''">WORLD</xsl:when>

										<!-- US, South America -->
									<xsl:when test="$request/travel/destinations/am/us !=''">USASC</xsl:when>
									<xsl:when test="$request/travel/destinations/am/sa !=''">USASC</xsl:when>
									
									<!-- Europe, UK -->
									<xsl:when test="$request/travel/destinations/eu/eu !=''">EURUK</xsl:when>
									<xsl:when test="$request/travel/destinations/eu/uk !=''">EURUK</xsl:when>
										<!-- China, HK, India, Thailand, Indonesia, India -->
									<xsl:when test="$request/travel/destinations/as/ch !=''">ASNJP</xsl:when>
									<xsl:when test="$request/travel/destinations/as/hk !=''">ASNJP</xsl:when>
									
									<xsl:when test="$request/travel/destinations/as/in !=''">ASNJP</xsl:when>
									<xsl:when test="$request/travel/destinations/as/th !=''">ASNJP</xsl:when>
									<xsl:when test="$request/travel/destinations/pa/in !=''">ASNJP</xsl:when>
									<!-- Bali, New Zealand, Pacific Islands -->
									<xsl:when test="$request/travel/destinations/pa/ba !=''">PACBL</xsl:when>
									<xsl:when test="$request/travel/destinations/pa/nz !=''">PACBL</xsl:when>
									<xsl:when test="$request/travel/destinations/pa/pi !=''">PACBL</xsl:when>
						<!-- Australia -->
									<xsl:when test="$request/travel/destinations/au/au !=''">AUS</xsl:when>
					</xsl:choose>
							</xsl:otherwise>
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
					<provider>WebJet</provider>
					<trackCode>52</trackCode>
					<name>
						<xsl:value-of select="pr:PlanName"/>
					</name>
					<des>
						<xsl:value-of select="pr:PlanName"/>
					</des>
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
						As Australia and New Zealand's leading online travel agency, Webjet leads the way in online travel tools and technology. Offering unparalleled choice in online travel bookings, Webjet offers a broad range of Travel Insurance products, with the opportunity to tailor your excess and control your premium to suit your needs. Backed by Allianz Global Assistance, we've got you covered. Get a quote today and pack some peace of mind.
					</infoDes>
					<subTitle>https://api.agaassistance.com.au/content/webjet/attachments/ProductDisclosureStatement.pdf</subTitle>
					<acn></acn>
					<afsLicenceNo></afsLicenceNo>

					<quoteUrl><xsl:value-of select="$quoteUrl"/>?regioncode=<xsl:value-of select="$regionCode" />%26startDate=<xsl:value-of select="$request/travel/dates/fromDate" />%26endDate=<xsl:value-of select="$request/travel/dates/toDate" />%26numAdults=<xsl:value-of select="$request/travel/adults" />%26numchildren=<xsl:value-of select="$request/travel/children" />%26transaction_Id=<xsl:value-of select="$transactionId"/>%26utm_source=comparethemarket%26utm_medium=cpc%26utm_campaign=<xsl:value-of select="$campaign"/></quoteUrl>
				</xsl:element>
				</xsl:if>
			</xsl:for-each>
		</results>
	</xsl:template>
</xsl:stylesheet>