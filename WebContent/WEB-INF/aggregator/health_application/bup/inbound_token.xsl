<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:s="http://www.w3.org/2003/05/soap-envelope"
	xmlns:b="http://bupa.com.au/xsd/Facade/ctm/v1"
	xmlns:t="http://bupa.com.au/wsdl/WebFacadeCtmService-v1.0"
	exclude-result-prefixes="xsl soap b s t">

	<!-- PARAMETERS -->
	<xsl:param name="ssl" />

	<!-- RESULTS AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="//t:InitiateTokenisationSessionResponse">
		<result>
			<success>true</success>
			<sst><xsl:value-of select="//b:Sst" /></sst>
			<refId><xsl:value-of select="//b:TokenisationRefId" /></refId>
			<!-- Sometimes we need to play in a non ssl environment, using a recursive template for xslt 1 -->
			<url>
				<xsl:choose>
					<xsl:when test="$ssl = 'false' and contains(//b:TokenisationUrl, 'https:')">
						<xsl:text>http:</xsl:text><xsl:value-of select="substring-after(//b:TokenisationUrl,'https:')" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="//b:TokenisationUrl" />
					</xsl:otherwise>
				</xsl:choose>
			</url>
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