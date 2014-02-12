<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hsl="http://HSL.OMS.Public.API.Service"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">

	<xsl:include href="utils.xsl"/>

	<xsl:output indent="yes" />

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="hsl:xmlFile/text()">
		<xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
		<xsl:call-template name="passAccountNumber">
			<xsl:with-param name="xmlFile" select="."/>
		</xsl:call-template>
		<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text>
	</xsl:template>

	<xsl:template name="passAccountNumber">
		<xsl:param name="xmlFile" />
		<xsl:variable name="accountNumberClosing" select="'&lt;/AccountNumber&gt;'" />
		<xsl:variable name="accountNumber" select="substring-after(substring-before($xmlFile,$accountNumberClosing),'&lt;AccountNumber&gt;')"/>
		<xsl:variable name="accountNumberSpacesRemoved" select="translate($accountNumber, ' ', '')" />
		<xsl:variable name="length" select="string-length($accountNumberSpacesRemoved)" />
		<xsl:choose>
			<xsl:when test="$length = 16">
				<xsl:value-of select="substring-before($xmlFile,$accountNumber)"/>
				<xsl:call-template name="mask_creditcard">
					<xsl:with-param name="creditcard" select="$accountNumberSpacesRemoved"/>
				</xsl:call-template>
				<xsl:value-of select="$accountNumberClosing"/>
				<xsl:call-template name="passAccountNumber">
					<xsl:with-param name="xmlFile" select="substring-after($xmlFile, $accountNumberClosing)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$length > 0">
				<xsl:value-of select="substring-before($xmlFile,$accountNumber)"/>
				<xsl:call-template name="mask_banknumber">
					<xsl:with-param name="banknumber" select="$accountNumberSpacesRemoved"/>
				</xsl:call-template>
				<xsl:value-of select="$accountNumberClosing"/>
				<xsl:call-template name="passAccountNumber">
					<xsl:with-param name="xmlFile" select="substring-after($xmlFile,$accountNumberClosing)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$xmlFile"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>