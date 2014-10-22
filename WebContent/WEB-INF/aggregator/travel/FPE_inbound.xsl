<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:pr="http://pricingapi.agaassistance.com.au/PricingResponse.xsd"
	exclude-result-prefixes="soapenv pr">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/string_formatting.xsl" />
	<xsl:import href="utilities/unavailable.xsl"/>

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
			<xsl:when test="/pr:PricingResponse/pr:Plans">
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
				<xsl:element name="price">

					<xsl:variable name="fromDate"><xsl:value-of select="$request/travel/dates/fromDate" /></xsl:variable>
					<xsl:variable name="toDate"><xsl:value-of select="$request/travel/dates/toDate" /></xsl:variable>

					<xsl:variable name="startDateFormatted"><xsl:value-of select="substring($fromDate,7,4)" /><xsl:value-of select="substring($fromDate,4,2)" /><xsl:value-of select="substring($fromDate,1,2)" /></xsl:variable>
					<xsl:variable name="endDateFormatted"><xsl:value-of select="substring($toDate,7,4)" /><xsl:value-of select="substring($toDate,4,2)" /><xsl:value-of select="substring($toDate,1,2)" /></xsl:variable>

						<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
						<xsl:attribute name="productId">
							<xsl:value-of select="$service" />-TRAVEL-<xsl:value-of select="pr:PlanId" />
							<xsl:choose>
								<xsl:when test="pr:PlanLevel = 'MULTI'"><xsl:value-of select="pr:MaxTripDuration" /></xsl:when>
							</xsl:choose>
						</xsl:attribute>
						<available>Y</available>
						<transactionId><xsl:value-of select="$transactionId"/></transactionId>
						<provider>Online Travel Insurance</provider>
						<trackCode>34</trackCode>
						<name>
							<xsl:value-of select="pr:PlanName"/><xsl:choose><xsl:when test="pr:PlanLevel = 'MULTI'"> (30 days)</xsl:when></xsl:choose>
						</name>
						<des>
							<xsl:value-of select="pr:PlanName"/><xsl:choose><xsl:when test="pr:PlanLevel = 'MULTI'"> &lt;span class=&quot;daysPerTrip&quot;&gt;(30 days)&lt;/span&gt;</xsl:when></xsl:choose>
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

							<!-- Check if we have any overseas medical fees -->
							<xsl:choose>
								<xsl:when test="pr:PlanDetails/pr:PlanDetail/pr:Id/text() = $code_overseas_medical"></xsl:when>
								<xsl:otherwise><medical>
									<label>Overseas Medical</label>
									<desc>Overseas Medical and Hospital Expenses</desc>
									<value>0</value>
									<text>N/A</text>
									<order/>
									</medical></xsl:otherwise>
							</xsl:choose>

							<!-- Check if we have any cancellation fees -->
							<xsl:choose>
								<xsl:when test="pr:PlanDetails/pr:PlanDetail/pr:Id/text() = $code_cancellation"></xsl:when>
								<xsl:otherwise><cxdfee>
									<label>Cancellation Fees</label>
									<desc>Cancellation and Amendment Fees</desc>
									<value>0</value>
									<text>N/A</text>
									<order/>
									</cxdfee></xsl:otherwise>
							</xsl:choose>

							<!-- Check if we have any luggage and personal effects fees -->
							<xsl:choose>
								<xsl:when test="pr:PlanDetails/pr:PlanDetail/pr:Id/text() = $code_baggage"></xsl:when>
								<xsl:otherwise><luggage>
									<label>Luggage and PE Delay</label>
									<desc>Delayed Luggage Allowance</desc>
									<value>0</value>
									<text>N/A</text>
									<order/>
									</luggage></xsl:otherwise>
							</xsl:choose>

							<xsl:for-each select="pr:PlanDetails/pr:PlanDetail">
								<xsl:variable name="prName">
									<xsl:value-of select="pr:Name"/>
								</xsl:variable>
								<xsl:variable name="prValue">
									<xsl:choose>
										<xsl:when test="pr:Value = 'Unlimited'">999999999</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="removeDollarFormatting">
												<xsl:with-param name="oldDollarValue" select="pr:Value" />
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="prText">
									<xsl:choose>
										<xsl:when test="$prValue = 999999999">Unlimited</xsl:when>
										<xsl:otherwise><xsl:value-of select="pr:Value"/></xsl:otherwise>
									</xsl:choose>
								</xsl:variable>


								<xsl:choose>
									<xsl:when test="pr:Id/text() = $code_overseas_medical">
										<medical>
											<desc><xsl:value-of select="$prName"/></desc>
											<text><xsl:value-of select="$prText"/></text>
											<value><xsl:value-of select="$prValue"/></value>
											<order/>
										</medical>
									</xsl:when>
									<xsl:when test="pr:Id/text() = $code_cancellation">
										<cxdfee>
											<desc><xsl:value-of select="$prName"/></desc>
											<text><xsl:value-of select="$prText"/></text>
											<value><xsl:value-of select="$prValue"/></value>
											<order/>
										</cxdfee>
									</xsl:when>
									<xsl:when test="pr:Id/text() = $code_baggage">
										<luggage>
											<desc><xsl:value-of select="$prName"/></desc>
											<text><xsl:value-of select="$prText"/></text>
											<value><xsl:value-of select="$prValue"/></value>
											<order/>
										</luggage>
									</xsl:when>
									<xsl:otherwise>
										<xsl:element name="benefit{pr:Id/text()}">
											<desc><xsl:value-of select="$prName"/></desc>
											<text><xsl:value-of select="$prText"/></text>
											<value><xsl:value-of select="$prValue"/></value>
											<order/>
										</xsl:element>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</info>
						<infoDes>
							<xsl:if test="/pr:PricingResponse/pr:Plans/pr:Plan/pr:PlanType='DUO'">
								Please note Duo policies provide cover on a per person basis. For more details refer to the PDS on the Insurer's web-site.&lt;br&gt; &lt;br&gt;
							</xsl:if>
							Online Travel Insurance (OTI) has been helping Australians in trouble overseas for over 10 years. As a brand of the worlds largest assistance company - Allianz Global Assistance, OTI understands travel insurance can be complicated, so they try to keep it simple &amp; cost-effective. OTI is underwritten by Allianz.
						</infoDes>
						<subTitle>https://www.onlinetravelinsurance.com.au/pdf/Product_Disclosure_Statement.pdf</subTitle>
						<acn></acn>
						<afsLicenceNo></afsLicenceNo>

						<quoteUrl><xsl:value-of select="$quoteUrl"/>/quote/choose-a-plan?id=<xsl:value-of select="/pr:PricingResponse/pr:Id" />%26accesscode=<xsl:value-of select="/pr:PricingResponse/pr:AccessCode" />%26affid=ctm</quoteUrl>
					</xsl:element>
			</xsl:for-each>
		</results>
	</xsl:template>
</xsl:stylesheet>