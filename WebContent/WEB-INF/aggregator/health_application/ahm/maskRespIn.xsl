<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:s="http://www.w3.org/2003/05/soap-envelope"
	xmlns:b="http://schemas.datacontract.org/2004/07/Civica.WHICSServices"
	xmlns:t="http://tempuri.org/"
	exclude-result-prefixes="xsl soap s b t">

	<xsl:include href="../utils.xsl"/>

	<xsl:output indent="yes" />

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="/s:Envelope/s:Body/t:EnrolMemberResponse/t:EnrolMemberResult/b:DirectCRAccount/text()">
		<xsl:call-template name="mask_creditcard">
			<xsl:with-param name="creditcard" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="/s:Envelope/s:Body/t:EnrolMemberResponse/t:EnrolMemberResult/b:DirectDRAccount/text()">
		<xsl:call-template name="mask_banknumber">
			<xsl:with-param name="banknumber" select="."/>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>