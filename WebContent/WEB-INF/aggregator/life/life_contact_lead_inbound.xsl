<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:lb="urn:Lifebroker.EnterpriseAPI"
	exclude-result-prefixes="soapenv">

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

	<xsl:template match="/lb:results/lb:client">
		<xsl:element name="results">
			<xsl:element name="success">true</xsl:element>
			<xsl:element name="client">
				<xsl:element name="reference"><xsl:value-of select="lb:reference"/></xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>