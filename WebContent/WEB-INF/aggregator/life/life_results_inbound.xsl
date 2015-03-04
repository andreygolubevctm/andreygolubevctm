<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv"
	xmlns:lb="urn:Lifebroker.EnterpriseAPI">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/error">
		<xsl:element name="results">
			<xsl:element name="success">false</xsl:element>
			<xsl:element name="error">
				<xsl:element name="code"><xsl:value-of select="code" /></xsl:element>
				<xsl:element name="message"><xsl:value-of select="message" /></xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="/lb:results">
		<xsl:element name="results">
			<xsl:element name="success">true</xsl:element>
			<xsl:element name="api">
				<xsl:element name="reference">
					<xsl:if test="lb:api_reference">
						<xsl:value-of select="lb:api_reference" />
					</xsl:if>
				</xsl:element>
			</xsl:element>
			<xsl:element name="client">
				<xsl:call-template name="getProducts">
					<xsl:with-param name="products" select="lb:client/lb:products/lb:premium"/>
				</xsl:call-template>
			</xsl:element>
			<xsl:element name="partner">
				<xsl:call-template name="getProducts">
					<xsl:with-param name="products" select="lb:partner/lb:products/lb:premium"/>
				</xsl:call-template>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template name="getProducts">
		<xsl:param name="products" />

		<xsl:for-each select="$products">
			<xsl:element name="premium">
				<xsl:element name="company"><xsl:value-of select="lb:company"/></xsl:element>
				<xsl:element name="name"><xsl:value-of select="lb:name"/></xsl:element>
				<xsl:element name="description"><xsl:value-of select="lb:description"/></xsl:element>
				<xsl:element name="stars"><xsl:value-of select="lb:stars"/></xsl:element>
				<xsl:element name="pds"><xsl:value-of select="lb:pds"/></xsl:element>
				<xsl:element name="info"><xsl:value-of select="lb:info"/></xsl:element>
				<xsl:element name="product_id"><xsl:value-of select="lb:product_id"/></xsl:element>
				<xsl:element name="value"><xsl:value-of select="lb:value"/></xsl:element>
				<xsl:element name="below_min"><xsl:value-of select="lb:below_min"/></xsl:element>
				<xsl:element name="insurer_contact">1800 204 124</xsl:element>
				<xsl:element name="service_provider">Lifebroker</xsl:element>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>