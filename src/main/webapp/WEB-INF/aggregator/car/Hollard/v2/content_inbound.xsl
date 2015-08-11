<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:z="http://tempuri.org/"
	xmlns:encoder="xalan://java.net.URLEncoder"
	xmlns:a="http://schemas.datacontract.org/2004/07/Real.Aggregator.Service.DataContracts"
	exclude-result-prefixes="soap z a encoder">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="../../../includes/utils.xsl"/>
	<xsl:import href="../../../includes/get_price_availability.xsl"/>

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="service"/>
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">

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


<!-- CONTENT DATA ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/soap:Envelope/soap:Body/z:GetContentForTokenResponse/z:GetContentForTokenResult/a:ContentReturned">

	</xsl:template>

	<xsl:template match="/soap:Envelope/soap:Body/z:GetContentForTokenResponse/z:GetContentForTokenResult/a:ProductContent">
		<results>
			<xsl:for-each select="a:Content">
				<xsl:variable name="productId">
					<xsl:choose>
						<xsl:when test="a:Code = 'COMP'"><xsl:value-of select="$service"/>-01-02</xsl:when>
						<xsl:otherwise><xsl:value-of select="$service"/>-01-01</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:element name="price">
					<xsl:attribute name="service"><xsl:value-of select="$service"/></xsl:attribute>
					<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
					<xsl:attribute name="type">content</xsl:attribute>

					<telNo><xsl:value-of select="a:ContactDetails" /></telNo>
					<disclaimer><xsl:value-of select="a:Disclaimer" /></disclaimer>
					<openingHours><xsl:value-of select="a:OpenHours" /></openingHours>
					<pdsaDesLong>Product Disclosure Statement</pdsaDesLong>
					<pdsaDesShort>PDS</pdsaDesShort>
					<pdsaUrl><xsl:value-of select="a:PdsLink" /></pdsaUrl>
					<pdsbUrl />
					<pdsbDesLong />
					<pdsbDesShort />
					<fsgUrl />
					<quoteUrl><xsl:value-of select="a:ReturnUrl" /></quoteUrl>
					<xsl:element name="underwriter">
						<xsl:value-of select="a:UnderwriterName" />
						<xsl:text> ABN </xsl:text>
						<xsl:value-of select="a:UnderwriterAcn" />
					</xsl:element>
					<afsLicenceNo><xsl:value-of select="a:UnderwriterAfs" /></afsLicenceNo>
					<conditions>
						<condition><xsl:value-of select="a:SpecialConditions" /></condition>
					</conditions>
					<feature><xsl:value-of select="a:SpecialConditions" /></feature>
				</xsl:element>
			</xsl:for-each>
		</results>
	</xsl:template>

</xsl:stylesheet>