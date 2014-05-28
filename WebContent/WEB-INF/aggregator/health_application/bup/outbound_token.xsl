<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan">

	<xsl:template match="*">
		<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:web="http://bupa.com.au/wsdl/WebFacadeCtmService-v1.0">
			<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
				<wsa:Action>http://bupa.com.au/wsdl/WebFacadeCtmService-v1.0/IWebFacadeCtmService/InitiateTokenisationSession</wsa:Action>
			</soap:Header>
			<soap:Body>
				<web:InitiateTokenisationSession>
					<!-- This is piped with a dynamic url for the iFrame host, so that we can whitelabel -->
					<web:clientType>BupaCTM|<xsl:value-of select="dynamicUrl" /></web:clientType>
				</web:InitiateTokenisationSession>
			</soap:Body>
		</soap:Envelope>
	</xsl:template>

</xsl:stylesheet>