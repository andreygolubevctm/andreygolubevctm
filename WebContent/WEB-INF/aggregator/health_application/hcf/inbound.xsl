<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="xsl">	

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>
	<xsl:param name="fundid">hcf</xsl:param>

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:include href="../../includes/health_fund_errors.xsl"/>

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
						
						<xsl:call-template name="maperrors">
							<xsl:with-param name="code" select="." />
							<xsl:with-param name="message" select="/GetHCFSaleInfo/GetErrorDetails/*[name()=$detailName]" />
						</xsl:call-template>
					</xsl:if>
				</xsl:for-each>
			</errors>
		</result>
	</xsl:template>
	
	<!-- Error returned by SOAP aggregator -->
	<xsl:template match="/error">
		<result>
			<success>false</success>
			<policyNo></policyNo>
			<errors>
				<xsl:call-template name="maperrors">
					<xsl:with-param name="code" select="code" />
					<xsl:with-param name="message" select="message" />
				</xsl:call-template>
			</errors>
		</result>
	</xsl:template>
</xsl:stylesheet>