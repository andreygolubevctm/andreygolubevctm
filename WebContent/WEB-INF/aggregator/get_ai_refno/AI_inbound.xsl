<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:ai="http://www.softsure.co.za/"
	exclude-result-prefixes="soap ai">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->	

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<refno>
			<xsl:value-of select="soap:Envelope/soap:Body/ai:UploadQuote70Response/ai:UploadQuote70Result/ai:ReferenceNo"/>
		</refno>		
	</xsl:template>
	
</xsl:stylesheet>