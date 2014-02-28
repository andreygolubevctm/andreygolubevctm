<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:ai="http://www.softsure.co.za/"
	exclude-result-prefixes="soap ai">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="../includes/utils.xsl"/>
	<xsl:import href="../includes/ranking.xsl"/>
	<xsl:import href="../includes/product_info.xsl"/>
	<xsl:import href="../includes/get_price_availability.xsl"/>

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>
	<xsl:param name="quoteURL" />


<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<xsl:choose>
		<!-- ACCEPTABLE -->
		<xsl:when test="/soap:Envelope/soap:Body/ai:GetVehiclePremiumResponse/ai:GetVehiclePremiumResult/ai:Results/ai:StatusCode = 'Status_Success'">
			<xsl:apply-templates />
		</xsl:when>

		<!-- UNACCEPTABLE -->
		<xsl:otherwise>
			<results>
				<xsl:element name="price">
					<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
					<xsl:attribute name="service">AI</xsl:attribute>
					<available>N</available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>
					<xsl:choose>
						<xsl:when test="error">
							<xsl:copy-of select="error"></xsl:copy-of>
						</xsl:when>
						<xsl:otherwise>
							<error service="AI" type="unavailable">
								<code></code>
								<message>We're sorry but this provider chose not to quote</message>
								<data></data>
							</error>
						</xsl:otherwise>

					</xsl:choose>

					<headlineOffer>ONLINE</headlineOffer>
					<onlinePrice>

						<lumpSumTotal>9999999999</lumpSumTotal>
				<xsl:call-template name="productInfo">
					<xsl:with-param name="productId" select="$productId" />
					<xsl:with-param name="priceType" select="headline" />
					<xsl:with-param name="kms" select="''" />
				</xsl:call-template>
					</onlinePrice>

					<xsl:call-template name="ranking">
						<xsl:with-param name="productId">*NONE</xsl:with-param>
					</xsl:call-template>

				</xsl:element>
			</results>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="soap:Envelope/soap:Body/ai:GetVehiclePremiumResponse">

		<!-- AI don't pass the excess in the response, so get it from the request -->
		<xsl:variable name="excess">
			<xsl:choose>
				<xsl:when test="$request/excess &gt;= 800">1200</xsl:when>
				<xsl:otherwise>600</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<results>
			<xsl:element name="price">
				<xsl:attribute name="service">AI</xsl:attribute>
				<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>

				<available>Y</available>
				<transactionId><xsl:value-of select="$transactionId"/></transactionId>

				<headlineOffer>ONLINE</headlineOffer>

				<onlineAvailable>
					<xsl:call-template name="getPriceAvailability">
						<xsl:with-param name="productId" select="$productId" />
						<xsl:with-param name="priceType">ONLINE</xsl:with-param>
						<xsl:with-param name="hasModifications">N</xsl:with-param>
					</xsl:call-template>
				</onlineAvailable>
				<onlineAvailableWithModifications>
					<xsl:call-template name="getPriceAvailability">
						<xsl:with-param name="productId" select="$productId" />
						<xsl:with-param name="priceType">ONLINE</xsl:with-param>
						<xsl:with-param name="hasModifications">Y</xsl:with-param>
					</xsl:call-template>
				</onlineAvailableWithModifications>

				<offlineAvailable>
					<xsl:call-template name="getPriceAvailability">
						<xsl:with-param name="productId" select="$productId" />
						<xsl:with-param name="priceType">OFFLINE</xsl:with-param>
						<xsl:with-param name="hasModifications">N</xsl:with-param>
					</xsl:call-template>
				</offlineAvailable>
				<offlineAvailableWithModifications>
					<xsl:call-template name="getPriceAvailability">
						<xsl:with-param name="productId" select="$productId" />
						<xsl:with-param name="priceType">OFFLINE</xsl:with-param>
						<xsl:with-param name="hasModifications">Y</xsl:with-param>
					</xsl:call-template>
				</offlineAvailableWithModifications>

				<callbackAvailable>
					<xsl:call-template name="getPriceAvailability">
						<xsl:with-param name="productId" select="$productId" />
						<xsl:with-param name="priceType">CALLBACK</xsl:with-param>
						<xsl:with-param name="hasModifications">N</xsl:with-param>
					</xsl:call-template>
				</callbackAvailable>
				<callbackAvailableWithModifications>
					<xsl:call-template name="getPriceAvailability">
						<xsl:with-param name="productId" select="$productId" />
						<xsl:with-param name="priceType">CALLBACK</xsl:with-param>
						<xsl:with-param name="hasModifications">Y</xsl:with-param>
					</xsl:call-template>
				</callbackAvailableWithModifications>

				<xsl:call-template name="priceInfo">
					<xsl:with-param name="tagName">onlinePrice</xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="priceInfo">
					<xsl:with-param name="tagName">offlinePrice</xsl:with-param>
				</xsl:call-template>

				<productDes>AI Car Insurance</productDes>
				<underwriter>The Hollard Insurance Company (PTY) LTD</underwriter>
				<brandCode>AI</brandCode>
				<acn>78 090 584 473</acn>
				<afsLicenceNo>241436</afsLicenceNo>
				<excess>
					<total><xsl:value-of select="$excess" /></total>
					<excess>
						<description>Male driver under the age of 30 or less than 2 years driving experience</description>
						<amount>$1500</amount>
					</excess>
					<excess>
						<description>Female driver under the age of 30 or less than 2 years driving experience</description>
						<amount>$900</amount>
					</excess>
					<excess>
						<description>Unlisted drivers</description>
						<amount>$1000</amount>
					</excess>
					<excess>
						<description>Single car accident excess</description>
						<amount>$300</amount>
					</excess>
					<excess>
						<description>Theft / Malicious Damage excess</description>
						<amount>$1000</amount>
					</excess>
					<excess>
						<description>Claim within first 6 months of policy inception</description>
						<amount>$600</amount>
					</excess>

				</excess>
				<conditions>
					<condition> </condition>
				</conditions>

				<leadNo><xsl:value-of select="/soap:Envelope/soap:Body/ai:GetVehiclePremiumResponse/ai:GetVehiclePremiumResult/ai:Results/ai:ReferenceNo"/></leadNo>

				<telNo>1300 284 875</telNo>
				<openingHours>Monday to Friday (9am-7pm EST)</openingHours>

				<quoteUrl><xsl:value-of select="$quoteURL" /><xsl:value-of select="/soap:Envelope/soap:Body/ai:GetVehiclePremiumResponse/ai:GetVehiclePremiumResult/ai:Results/ai:ReferenceNo"/></quoteUrl>

				<refnoUrl/>
							<pdsaUrl>/ctm/legal/AI-PDS-Comprehensive-Cover-single-web.pdf</pdsaUrl>
							<pdsaDesLong>Product Disclosure Statement</pdsaDesLong>
							<pdsaDesShort>PDS</pdsaDesShort>
							<pdsbUrl></pdsbUrl>
							<pdsbDesLong></pdsbDesLong>
							<pdsbDesShort></pdsbDesShort>
				<fsgUrl />

				<disclaimer>
					<![CDATA[
					The indicative quote includes any applicable online discount and is subject to meeting the insurer's underwriting criteria and may change due to factors such as:<br>
					- Driver's history or offences or claims<br>
					- Age or licence type of additional drivers<br>
					- Vehicle condition, accessories and modifications<br>
					]]>
				</disclaimer>

				<transferring />

				<xsl:call-template name="ranking">
					<xsl:with-param name="productId" select="$productId" />
				</xsl:call-template>					
							<discount>
								<online></online>
								<offline></offline>
							</discount>

			</xsl:element>						
		</results>
	</xsl:template>

	<!-- Create the onlinePrice & offlinePrice elements -->
	<xsl:template name="priceInfo">
		<xsl:param name="tagName" />

		<xsl:variable name="init" select="/soap:Envelope/soap:Body/ai:GetVehiclePremiumResponse/ai:GetVehiclePremiumResult/ai:MonthlyPremium/ai:InitFee"/>
		<xsl:variable name="premium" select="/soap:Envelope/soap:Body/ai:GetVehiclePremiumResponse/ai:GetVehiclePremiumResult/ai:MonthlyPremium/ai:TotalPremium"/>

		<xsl:element name="{$tagName}">

					<lumpSumTotal>
						<xsl:call-template name="util_mathCeil">
							<xsl:with-param name="num" select="/soap:Envelope/soap:Body/ai:GetVehiclePremiumResponse/ai:GetVehiclePremiumResult/ai:AnnualPremium/ai:TotalPremium"/>
						</xsl:call-template>
					</lumpSumTotal>
					<instalmentFirst>
						<xsl:value-of select="format-number($premium + $init, '0.##')"/>
					</instalmentFirst>
					<instalmentCount>11</instalmentCount>
					<instalmentPayment>
						<xsl:value-of select="$premium"/>
					</instalmentPayment>
					<instalmentTotal>
						<xsl:call-template name="util_mathCeil">
							<xsl:with-param name="num" select="(/soap:Envelope/soap:Body/ai:GetVehiclePremiumResponse/ai:GetVehiclePremiumResult/ai:MonthlyPremium/ai:TotalPremium * 12) + 110" />
						</xsl:call-template>
					</instalmentTotal>

			<xsl:call-template name="productInfo">
				<xsl:with-param name="productId" select="$productId" />
				<xsl:with-param name="priceType" select="$tagName" />
				<xsl:with-param name="kms" select="''" />

			</xsl:call-template>

		</xsl:element>
	</xsl:template>

</xsl:stylesheet>