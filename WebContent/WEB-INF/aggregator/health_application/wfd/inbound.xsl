<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="xsl">

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<result>
			<xsl:variable name="status"><xsl:value-of select="'Success'" /></xsl:variable>
			<success>
				<xsl:choose>
					<xsl:when test="$status='Success'">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</success>
			
			<xsl:if test="$status='Success'">
			<policyNo>
				<xsl:value-of select="/result/policyNo" />
			</policyNo>
			</xsl:if>
			<errors>
				<xsl:for-each select="ValidationErrors/*">
				<error>
					<code><xsl:value-of select="Reason" /></code>
					<text><xsl:value-of select="DisplayErrorMessage" /></text> 
				</error>
				</xsl:for-each>
			</errors>
		</result>
	</xsl:template>
</xsl:stylesheet>