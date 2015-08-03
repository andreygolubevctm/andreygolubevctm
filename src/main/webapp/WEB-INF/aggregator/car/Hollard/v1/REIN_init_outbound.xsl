<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:param name="keyname" />
<xsl:param name="keypass" />
<xsl:param name="siteKey" />
<xsl:template match="/">
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/">
		<soapenv:Header/>
		<soapenv:Body>
			<tem:Initialize>
				<tem:username><xsl:value-of select="$keyname" /></tem:username>
				<tem:password><xsl:value-of select="$keypass" /></tem:password>
				<tem:siteKey><xsl:value-of select="$siteKey" /></tem:siteKey>
			</tem:Initialize>
		</soapenv:Body>
	</soapenv:Envelope>
</xsl:template>
</xsl:stylesheet>