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
			<xsl:variable name="success">
				<xsl:choose>
					<xsl:when test="/result/success='true'">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<success><xsl:value-of select="$success" /></success>
			
			<xsl:if test="$success='true'">
			<policyNo>
				<xsl:value-of select="/result/policyNo" />
			</policyNo>
			</xsl:if>
			<errors>
				<xsl:for-each select="/result/errors/error">
				<error>
						<code><xsl:value-of select="code" /></code>
						<text><xsl:value-of select="text" /></text> 
				</error>
				</xsl:for-each>
			</errors>
		</result>
	</xsl:template>
</xsl:stylesheet>