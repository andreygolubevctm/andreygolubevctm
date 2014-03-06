<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan">

	<xsl:template match="*">
		<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:web="http://bupa.com.au/wsdl/WebFacadeCtmService-v1.0" xmlns:v1="http://bupa.com.au/xsd/Facade/ctm/v1">
		<soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
			<wsa:Action>http://bupa.com.au/wsdl/WebFacadeCtmService-v1.0/IWebFacadeCtmService/InsertTokenisationLog</wsa:Action>
		</soap:Header>
		<soap:Body>
			<web:InsertTokenisationLog>
				<!--Optional:-->
				<web:tokenisationLogRequest>
					<v1:Sst><xsl:value-of select="sst" /></v1:Sst>
					<v1:TokeinsationRefId><xsl:value-of select="sessionId" /></v1:TokeinsationRefId>
					<v1:TokenisationDate><xsl:value-of select="date" />T00:00:00.000</v1:TokenisationDate>
					<v1:ClientType>BupaCTM</v1:ClientType>
					<v1:ClientRefId><xsl:value-of select="transactionId" /></v1:ClientRefId>
					<v1:ResponseMaskedCardNo><xsl:value-of select="maskedNumber" /></v1:ResponseMaskedCardNo>
					<v1:ResponseCardType><xsl:value-of select="cardType" /></v1:ResponseCardType>
					<v1:ResponseToken><xsl:value-of select="token" /></v1:ResponseToken>
					<v1:ResponseCode><xsl:value-of select="responseCode" /></v1:ResponseCode>
					<v1:ResponseResult><xsl:value-of select="responseResult" /></v1:ResponseResult>
				</web:tokenisationLogRequest>
			</web:InsertTokenisationLog>
		</soap:Body>
		</soap:Envelope>
	</xsl:template>

</xsl:stylesheet>