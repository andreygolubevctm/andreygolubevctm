<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS -->
	<xsl:param name="transactionId">*NONE</xsl:param>
	<xsl:param name="schemaVersion" />


<!-- MAIN TEMPLATE -->
	<xsl:template match="/quote">


<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<soapenv:Envelope
		xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
		xmlns:tem="http://tempuri.org/"
		xmlns:real="http://schemas.datacontract.org/2004/07/Real.Aggregator.Service.DataContracts"
		xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays"
		xmlns:i="http://www.w3.org/2001/XMLSchema-instance">

		<soapenv:Body>
			<tem:GetContentForToken>
				<tem:token><xsl:value-of select="token" /></tem:token>
			</tem:GetContentForToken>
		</soapenv:Body>
	</soapenv:Envelope>
	</xsl:template>

</xsl:stylesheet>