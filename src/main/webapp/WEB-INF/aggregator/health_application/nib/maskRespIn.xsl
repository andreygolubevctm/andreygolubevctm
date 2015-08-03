<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.nib.com.au/Broker/Gateway"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:nib="http://www.nib.com.au/Broker/Gateway"
	exclude-result-prefixes="xsl soap nib">

	<xsl:include href="../utils.xsl"/>

	<xsl:output indent="yes" />

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="nib:DirectDebitCreditCard/nib:CardNo/text()">
		<xsl:call-template name="mask_creditcard">
			<xsl:with-param name="creditcard" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="nib:AccountNo/text()">
		<xsl:call-template name="mask_banknumber">
			<xsl:with-param name="banknumber" select="."/>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>