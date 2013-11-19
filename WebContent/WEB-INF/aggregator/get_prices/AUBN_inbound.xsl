<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"

	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:a="http://services.fastr.com.au/Quotation/Data"
	xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:b="http://schemas.microsoft.com/2003/10/Serialization/Arrays"
	xmlns:aubn="http://services.fastr.com.au/Quotation"
	exclude-result-prefixes="s a i b aubn">

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

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/s:Envelope/s:Body/RequestInitialQuotationResponse">
		<xsl:choose>
		<!-- ACCEPTABLE -->
		<xsl:when test="(contains(aubn:RequestInitialQuotationResult/a:QuotationGenerated,'true') = true)">
			<xsl:apply-templates />
		</xsl:when>

		<!-- UNACCEPTABLE -->
		<xsl:otherwise>
			<results>
				<xsl:element name="price">
					<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
					<xsl:attribute name="service">AUBN</xsl:attribute>
					<available>N</available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>
					<xsl:choose>
						<xsl:when test="error">
							<xsl:copy-of select="error"></xsl:copy-of>
						</xsl:when>
						<xsl:otherwise>
							<error service="AUBN" type="unavailable">
								<code></code>
								<message>We're sorry but this provider chose not to quote</message>
								<data></data>
							</error>
						</xsl:otherwise>
					</xsl:choose>

					<headlineOffer>ONLINE</headlineOffer>
					<onlinePrice>
						<lumpSumTotal>9999999999</lumpSumTotal>
					</onlinePrice>
					<xsl:call-template name="ranking">
						<xsl:with-param name="productId">*NONE</xsl:with-param>
					</xsl:call-template>

				</xsl:element>
			</results>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ERROR -->
	<xsl:template match="/error">
		<results>
			<xsl:element name="price">
				<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
				<xsl:attribute name="service">AUBN</xsl:attribute>
				<available>N</available>
				<transactionId><xsl:value-of select="$transactionId"/></transactionId>
				<xsl:choose>
					<xsl:when test="error">
						<xsl:copy-of select="error"></xsl:copy-of>
					</xsl:when>
					<xsl:otherwise>
						<error service="AUBN" type="unavailable">
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
	</xsl:template>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="aubn:RequestInitialQuotationResult">

		<!-- Extract the basic excess amount -->
		<xsl:variable name="aubnBasicExcess" select="a:MotorPremium/a:BasicExcess" />
		<xsl:variable name="aubnImposedExcess" select="a:MotorPremium/a:ImposedExcess" />
		<xsl:variable name="aubnSystemImposedExcess" select="a:MotorPremium/a:SystemImposedExcess" />
		<xsl:variable name="aubnTotalExcess" select="$aubnBasicExcess + $aubnImposedExcess + $aubnSystemImposedExcess" />

		<!-- Extract the quote number -->
		<xsl:variable name="aubnLeadNumber" select="a:QuotationNumber" />

		<!-- Extract the quote url -->
		<xsl:variable name="aubnQuoteUrl" select="a:InsurerQuotationUrl" />

		<results>
			<xsl:element name="price">
				<xsl:attribute name="service">AUBN</xsl:attribute>
				<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>

				<available>Y</available>
				<transactionId><xsl:value-of select="$transactionId"/></transactionId>
				<trackCode>15</trackCode>
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

				<onlinePrice>
					<xsl:call-template name="price">
						<xsl:with-param name="annualPremium" select="a:MotorPremium/a:Premium" />
						<xsl:with-param name="monthlyPremium" select="a:MotorPremium/a:AvailablePaymentMethods/a:PaymentMethod[4]/a:InstalmentAmount" />
						<xsl:with-param name="kms" select="''" />
					</xsl:call-template>
				</onlinePrice>

				<productDes>AutObarn</productDes>
				<prodId>AUBN-01-01</prodId>
				<underwriter>AVEA Insurance Limited ABN: 18 009 129 793</underwriter>
				<brandCode>AUBN</brandCode>
				<acn>18 009 129 793</acn>
				<afsLicenceNo>238279</afsLicenceNo>
				<excess>
					<total>
						<xsl:value-of select="$aubnTotalExcess"/>
					</total>
					<excess>
						<description>Any driver licensed less than 2 years</description>
						<amount>$900 OR</amount>
					</excess>
					<excess>
						<description>Drivers under 21 years of age</description>
						<amount>$900</amount>
					</excess>
					<excess>
						<description>Drivers 21-24 years of age</description>
						<amount>$600</amount>
					</excess>
					<excess>
						<description>Drivers 25-29 years of age</description>
						<amount>$350</amount>
					</excess>
				</excess>
				<leadNo><xsl:value-of select="$aubnLeadNumber"/></leadNo>
				<quoteUrl>avea.jsp?prdId=aubn</quoteUrl>
				<telNo>1800 999 977</telNo>
				<openingHours>Monday to Friday (9am-5pm AEST)</openingHours>

				<refnoUrl></refnoUrl>
				<pdsaUrl>http://www.avea.com.au/PDS/MOT.pdf</pdsaUrl>
				<pdsaDesLong>Product Disclosure Statement</pdsaDesLong>
				<pdsaDesShort>PDS</pdsaDesShort>
				<pdsbUrl></pdsbUrl>
				<pdsbDesLong></pdsbDesLong>
				<pdsbDesShort></pdsbDesShort>
				<fsgUrl></fsgUrl>

				<disclaimer>
					<![CDATA[
					This indicative quote is subject to meeting the insurers underwriting criteria and may change the excess due to factors such as:<br>
					- Driver's history or offences or claims<br>
					]]>
				</disclaimer>

				<transferring>Continue your application with...</transferring>

				<xsl:call-template name="ranking">
					<xsl:with-param name="productId" select="$productId" />
				</xsl:call-template>

			</xsl:element>

		</results>
	</xsl:template>

	<xsl:template name="price">
		<xsl:param name="annualPremium" />
		<xsl:param name="monthlyPremium" />
		<xsl:param name="kms" />
		<lumpSumTotal>
			<xsl:value-of select="format-number($annualPremium,'######.00')"/>
		</lumpSumTotal>
		<instalmentFirst>
			<xsl:value-of select="format-number($monthlyPremium,'######.00')"/>
		</instalmentFirst>
		<instalmentCount>11</instalmentCount>
		<instalmentPayment>
			<xsl:value-of select="format-number($monthlyPremium,'######.00')"/>
		</instalmentPayment>
		<instalmentTotal>
			<xsl:value-of select="format-number(($monthlyPremium * 12),'######.00')"/>
		</instalmentTotal>

		<xsl:call-template name="productInfo">
			<xsl:with-param name="productId" select="$productId" />
			<xsl:with-param name="priceType"> </xsl:with-param>
			<xsl:with-param name="kms" select="$kms" />
		</xsl:call-template>

	</xsl:template>

</xsl:stylesheet>