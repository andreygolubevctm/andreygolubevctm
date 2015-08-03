<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:auf="http://ws.australianunity.com.au/B2B/Broker">

	<xsl:include href="../utils.xsl"/>

	<xsl:output indent="yes" />

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@accountNumber">
		<xsl:attribute name="accountNumber">
			<xsl:call-template name="mask_banknumber">
				<xsl:with-param name="banknumber" select="."/>
			</xsl:call-template>
		</xsl:attribute>
	</xsl:template>

</xsl:stylesheet>