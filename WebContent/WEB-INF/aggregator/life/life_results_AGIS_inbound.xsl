<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="../includes/utils.xsl" />

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="company" />
	<xsl:param name="companyCode" />

	<xsl:variable name="companyName">
		<xsl:choose>
			<xsl:when test="$company = 'budget_direct'">Budget Direct</xsl:when>
			<xsl:when test="$company = 'ozicare'">Ozicare</xsl:when>
		</xsl:choose>
	</xsl:variable>

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<xsl:element name="results">
			<xsl:if test="/error or /soapenv:Envelope/soapenv:Body/soapenv:Fault">
				<xsl:element name="failedProviders"><xsl:value-of select="$company" /></xsl:element>
			</xsl:if>
			<xsl:if test="not(/soapenv:Envelope/soapenv:Body/response/client/quoteslist/quote) and not(/error) and not(/soapenv:Envelope/soapenv:Body/soapenv:Fault)">
				<xsl:element name="unquotedClientResults"><xsl:value-of select="$company" /></xsl:element>
			</xsl:if>
			<xsl:if test="not(/soapenv:Envelope/soapenv:Body/response/partner/quoteslist/quote) and not(/error) and not(/soapenv:Envelope/soapenv:Body/soapenv:Fault)">
				<xsl:element name="unquotedPartnerResults"><xsl:value-of select="$company" /></xsl:element>
			</xsl:if>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>

	<xsl:template match="/soapenv:Envelope/soapenv:Body/response/header">
		<xsl:element name="transactionId"><xsl:value-of select="/soapenv:Envelope/soapenv:Body/response/header/partnerReference" /></xsl:element>
	</xsl:template>

	<xsl:template match="/soapenv:Envelope/soapenv:Body/response/client">
		<xsl:element name="client">
			<xsl:call-template name="getProducts">
				<xsl:with-param name="products" select="/soapenv:Envelope/soapenv:Body/response/client/quoteslist/quote" />
			</xsl:call-template>
		</xsl:element>
	</xsl:template>

	<xsl:template match="/soapenv:Envelope/soapenv:Body/response/partner">
		<xsl:element name="partner">
			<xsl:call-template name="getProducts">
				<xsl:with-param name="products" select="/soapenv:Envelope/soapenv:Body/response/partner/quoteslist/quote" />
			</xsl:call-template>
		</xsl:element>
	</xsl:template>

	<xsl:template name="getProducts">
		<xsl:param name="products" />

		<xsl:for-each select="$products">
			<xsl:variable name="productName"><xsl:value-of select="onlinePrice/productName" /></xsl:variable>
			<xsl:variable name="uniqueId">
				<xsl:choose>
					<xsl:when test="contains($productName, 'Life, TPD, and Trauma Cover')">1</xsl:when>
					<xsl:when test="contains($productName, 'Life, TPD, and Trauma Plus Cover')">2</xsl:when>
					<xsl:when test="contains($productName, 'Life and TPD Cover')">3</xsl:when>
					<xsl:when test="contains($productName, 'Life and Trauma Plus Cover')">4</xsl:when>
					<xsl:when test="contains($productName, 'Life and Trauma Cover')">5</xsl:when>
					<xsl:when test="contains($productName, 'Life Cover')">6</xsl:when>
					<xsl:when test="contains($productName, 'Trauma Plus')">7</xsl:when>
					<xsl:when test="contains($productName, 'Trauma')">8</xsl:when>
					<xsl:when test="contains($productName, 'TPD')">9</xsl:when>
					<xsl:when test="contains($productName, 'Life')">10</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<xsl:element name="premium">
				<xsl:element name="company"><xsl:value-of select="$company" /></xsl:element>
				<xsl:element name="companyName"><xsl:value-of select="$companyName" /></xsl:element>
				<xsl:element name="name"><xsl:value-of select="onlinePrice/productName"/></xsl:element>
				<xsl:element name="description"><xsl:value-of select="onlinePrice/productDescription"/></xsl:element>
				<xsl:element name="stars"></xsl:element>
				<xsl:element name="pds"><xsl:value-of select="pdsaUrl"/></xsl:element>
				<xsl:element name="info"></xsl:element>
				<xsl:element name="special_offer"><xsl:value-of select="onlinePrice/featureTerms"/></xsl:element>
				<xsl:element name="product_id"><xsl:value-of select="$companyCode" />_LIFE_<xsl:value-of select="$uniqueId" /></xsl:element>
				<xsl:element name="lead_number"><xsl:value-of select="leadNumber" /></xsl:element>
				<xsl:element name="value"><xsl:value-of select="onlinePrice/paymentAmount"/></xsl:element>
				<xsl:element name="below_min">N</xsl:element>
				<xsl:element name="insurer_contact"><xsl:value-of select="insurerContact" /></xsl:element>
				<xsl:element name="fsg"><xsl:value-of select="fsgUrl"/></xsl:element>
				<xsl:element name="service_provider"><xsl:value-of select="$companyName" /></xsl:element>
				<xsl:element name="call_centre_hours"><xsl:value-of select="tradingHours" /></xsl:element>
				<xsl:element name="features">
					<xsl:call-template name="getFeatures">
						<xsl:with-param name="featureGroups" select="groupInformation/group" />
					</xsl:call-template>
				</xsl:element>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="getFeatures">
		<xsl:param name="featureGroups" />

		<xsl:for-each select="$featureGroups">
			<xsl:variable name="apostropheRemoved">
				<xsl:call-template name="util_replace">
					<xsl:with-param name="text" select="@name" />
					<xsl:with-param name="replace"><![CDATA[&rsquo;]]></xsl:with-param>
					<xsl:with-param name="with" select="''" />
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="name" select="translate($apostropheRemoved, ' ABCDEFGHIJKLMNOPQRSTUVWXYZ', '_abcdefghijklmnopqrstuvwxyz')" />
			<xsl:element name="{$name}">
				<xsl:for-each select="type">
					<xsl:element name="feature">
						<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
						<xsl:element name="name"><xsl:value-of select="description"/></xsl:element>
						<xsl:element name="available"><xsl:value-of select="value" /></xsl:element>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>