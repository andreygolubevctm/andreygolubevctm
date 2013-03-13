<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:a="HSL.OMS.Public.Data"
	xmlns:hsl="http://HSL.OMS.Public.API.Service"
	xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="xsl a hsl s">	

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->	
	<xsl:template match="s:Envelope/s:Body/hsl:SubmitMembershipTransactionResponse/hsl:SubmitMembershipTransactionResult">
		<result>
			<xsl:variable name="errorCount"><xsl:value-of select="count(a:Errors/*)" /></xsl:variable>
			<success>
				<xsl:choose>
					<xsl:when test="not(a:TransactionID) or a:TransactionID='' or a:TransactionID='0'">false</xsl:when>
					<xsl:when test="$errorCount!=0">false</xsl:when>
					<xsl:otherwise>true</xsl:otherwise>
				</xsl:choose>
			</success>
			
			<policyNo>
				<xsl:value-of select="a:TransactionID" />
			</policyNo>
			
			<errors>
				<error>
					<code>101</code>
					<text><xsl:value-of select="a:Errors"/></text> 
				</error>
			</errors>
		</result>
	</xsl:template>
	
<!-- IGNORE THE HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="s:Header">
	</xsl:template>	
		
</xsl:stylesheet>