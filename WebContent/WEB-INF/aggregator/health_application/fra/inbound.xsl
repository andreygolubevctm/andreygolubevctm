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
	<xsl:param name="fundid">fra</xsl:param>

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="fundErrors">
		<errors>
			<!-- Frank don't return error codes per se so just return the message -->
			<error code="?">999</error>
		</errors>
	</xsl:variable>
	<xsl:include href="../../includes/health_fund_errors.xsl"/>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="s:Envelope/s:Body/hsl:SubmitMembershipTransactionResponse/hsl:SubmitMembershipTransactionResult">
		<result>
			<fund><xsl:value-of select="$fundid" /></fund>

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
				<xsl:if test="count(a:Errors/*) &gt; 0">
					<xsl:call-template name="maperrors">
						<xsl:with-param name="code" select="101" />
						<xsl:with-param name="message" select="a:Errors" />
					</xsl:call-template>
				</xsl:if>
			</errors>
		</result>
	</xsl:template>

	<!-- Error returned by SOAP aggregator -->
	<xsl:template match="/error">
		<result>
			<fund><xsl:value-of select="$fundid" /></fund>
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

<!-- IGNORE THE HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="s:Header">
	</xsl:template>

</xsl:stylesheet>