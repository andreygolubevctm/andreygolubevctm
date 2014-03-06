<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:s="http://www.w3.org/2003/05/soap-envelope"
	xmlns:b="http://bupa.com.au/xsd/Facade/ctm/v1"
	xmlns:t="http://bupa.com.au/wsdl/WebFacadeCtmService-v1.0"
	exclude-result-prefixes="xsl soap b s t">

	<!-- RESULTS AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="//t:InsertTokenisationLogResponse">
		<result>
			<success>true</success>
		</result>
	</xsl:template>

	<xsl:template match="s:Header"></xsl:template>

	<!-- Error returned by SOAP aggregator -->
	<xsl:template match="/error">
		<result>
			<success>false</success>
		</result>
	</xsl:template>

	<xsl:template match="s:Body/s:Fault">
		<result>
			<success>false</success>
		</result>
	</xsl:template>
</xsl:stylesheet>