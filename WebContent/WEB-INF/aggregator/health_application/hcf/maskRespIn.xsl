<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="xsl">

	<xsl:include href="../utils.xsl"/>

	<xsl:output indent="yes" />

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="/GetHCFSaleInfo/GetOneOffPaymentDetails/CCNumber/text()">
		<xsl:call-template name="mask_creditcard">
			<xsl:with-param name="creditcard" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/GetHCFSaleInfo/GetDebitCCDetails/DDCCNumber/text()">
		<xsl:call-template name="mask_creditcard">
			<xsl:with-param name="creditcard" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/GetHCFSaleInfo/GetDebitEzipayDetails/EPAccountNum/text()">
		<xsl:call-template name="mask_banknumber">
			<xsl:with-param name="banknumber" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/GetHCFSaleInfo/GetDirectCreditDetails/CRAccountNum/text()">
		<xsl:call-template name="mask_creditcard">
			<xsl:with-param name="creditcard" select="."/>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>