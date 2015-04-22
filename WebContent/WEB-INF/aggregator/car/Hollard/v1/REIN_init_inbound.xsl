<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:z="http://tempuri.org/"
	xmlns:a="http://schemas.datacontract.org/2004/07/Real.Aggregator.Service.DataContracts"
	xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
	exclude-result-prefixes="s a i z">

	<xsl:template match="/error">

		<xsl:choose>
			<xsl:when test="/error[1]">
				<xsl:copy-of select="/error[1]"></xsl:copy-of>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/s:Envelope/s:Body/z:InitializeResponse/z:InitializeResult">
		<result>
			<hasError>
				<xsl:value-of select="a:HasErrored" />
			</hasError>
			<token>
				<xsl:value-of select="a:TokenValue" />
			</token>
		</result>
	</xsl:template>

</xsl:stylesheet>