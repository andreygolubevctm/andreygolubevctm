<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:z="http://tempuri.org/"
	xmlns:encoder="xalan://java.net.URLEncoder"
	xmlns:a="http://schemas.datacontract.org/2004/07/Real.Aggregator.Service.DataContracts"
	exclude-result-prefixes="soap z a encoder">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="../../includes/utils.xsl"/>
	<xsl:import href="../includes/get_price_availability.xsl"/>
	<xsl:import href="../includes/product_details.xsl"/>



<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="service"/>
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">

		<xsl:variable name="productId">
			<xsl:choose>
				<xsl:when test="/soap:Envelope/soap:Body/z:GetContentForTokenResponse/z:GetContentForTokenResult/a:ProductContent/a:Content/a:Code = 'ESS'"><xsl:value-of select="$service" />-02-01</xsl:when>
				<xsl:otherwise><xsl:value-of select="$service" />-02-02</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<!-- ACCEPTABLE -->
			<!-- /soap:Envelope/soap:Body/z:GetQuoteResponse/z:GetQuoteResult/a:QuoteResult/a:Quote/a:AnnualPremium != '' -->
			<xsl:when test="/soap:Envelope/soap:Body/z:GetContentForTokenResponse/z:GetContentForTokenResult/a:ContentReturned = 'true'">
				<xsl:apply-templates />
			</xsl:when>

			<!-- UNACCEPTABLE -->
			<xsl:otherwise>
				<results>
				</results>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!--
For Production the following quote URL will be available:
https://quote.realinsurance.com.au/quotelines/car/referral/comparethemarket?t=<Encrypted Token>&n=<Quote Number>&p=<Product Code>
-->
	<xsl:template match="/soap:Envelope/soap:Body/z:GetContentForTokenResponse">
		<results>
			<xsl:for-each select="/soap:Envelope/soap:Body/z:GetContentForTokenResponse/z:GetContentForTokenResult/a:ProductContent/a:Content">

				<xsl:variable name="productId">
					<xsl:choose>
						<xsl:when test="a:Code = 'ESS'"><xsl:value-of select="$service" />-02-01</xsl:when>
						<xsl:otherwise><xsl:value-of select="$service" />-02-02</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:element name="result">
					<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
					<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
					<xsl:attribute name="type">content</xsl:attribute>

					<transactionId><xsl:value-of select="$transactionId"/></transactionId>

					<underwriter><xsl:value-of select="a:UnderwriterName" /> ACN <xsl:value-of select="a:UnderwriterAcn" /></underwriter> <!-- This ACN temporary until AGIS sort theirs out -->
					<brandCode><xsl:value-of select="$service" /></brandCode>
					<acn><xsl:value-of select="a:UnderwriterAcn" /></acn>
					<afsLicenceNo><xsl:value-of select="a:UnderwriterAfs" /></afsLicenceNo>

					<telNo><xsl:value-of select="a:ContactDetails" /></telNo>

					<openingHours><xsl:value-of select="a:OpenHours" /></openingHours>

					<quoteUrl><xsl:value-of select="a:ReturnUrl" /></quoteUrl>
					<pdsaDesLong>Product Disclosure Statement</pdsaDesLong>
					<pdsaDesShort>PDS</pdsaDesShort>
					<pdsaUrl><xsl:value-of select="a:PdsLink" /></pdsaUrl>
					<pdsbUrl />
					<pdsbDesLong />
					<pdsbDesShort />
					<fsgUrl />

					<specialConditions><xsl:value-of select="a:SpecialConditions" /></specialConditions>
					<disclaimer><xsl:value-of select="a:Disclaimer" /></disclaimer>

					<productDes><xsl:value-of select="a:Brand" /></productDes>

				</xsl:element>
			</xsl:for-each>
		</results>
	</xsl:template>

</xsl:stylesheet>