<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="xsl">	

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->	
	<xsl:template match="/GetHCFSaleInfo">
		<result>
			<xsl:variable name="errorCount"><xsl:value-of select="GetAppInfo/ErrorCount" /></xsl:variable>
			<success>
				<xsl:choose>
					<xsl:when test="$errorCount=0">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</success>
			
			<policyNo>
				<xsl:value-of select="GetHCFGeneratedInfo/CovernoteMemberNumber" />
			</policyNo>
			
			<errors>
				<xsl:for-each select="GetErrorDetails/*">
					<xsl:if test="substring(name(),1,9)='ErrorCode'">
						<xsl:variable name="detailName"><xsl:value-of select="concat('ErrorDetail',substring(name(),10))" /></xsl:variable>
						
						<error>
							<code><xsl:value-of select="." /></code>
							<text><xsl:value-of select="/GetHCFSaleInfo/GetErrorDetails/*[name()=$detailName]" /></text> 
						</error>
					</xsl:if>
				</xsl:for-each>
			</errors>
		</result>
	</xsl:template>
	
	<xsl:template match="/error">
		<result>
			<success>false</success>
			<policyNo></policyNo>
			<errors>
				<error>
					<code><xsl:value-of select="code" /></code>
					<text><xsl:value-of select="message" /></text>
				</error>
			</errors>
		</result>
	</xsl:template>
</xsl:stylesheet>