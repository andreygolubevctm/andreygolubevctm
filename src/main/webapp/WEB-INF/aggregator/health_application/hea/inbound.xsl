<?xml version="1.0" encoding="UTF-8"?>
<!-- Place Holder File-->
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
	<xsl:param name="fundid">thf</xsl:param>

	<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="fundErrors">
		<errors>
			<error code="?">999</error>
		</errors>
	</xsl:variable>
	<xsl:include href="../../includes/health_fund_errors.xsl"/>

	<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<result>
			<fund><xsl:value-of select="$fundid" /></fund>

			<!-- Normal result -->
			<xsl:for-each select="/s:Envelope/s:Body/hsl:SubmitMembershipSTPResponse/hsl:SubmitMembershipSTPResult">
				<xsl:variable name="errorCount"><xsl:value-of select="count(a:Errors/*)" /></xsl:variable>
				<success>
					<xsl:choose>
						<xsl:when test="not(a:TransactionID) or a:TransactionID='' or a:TransactionID='0'">false</xsl:when>
						<xsl:when test="$errorCount!=0">false</xsl:when>
						<xsl:otherwise>true</xsl:otherwise>
					</xsl:choose>
				</success>

				<policyNo>
					<xsl:value-of select="a:MemberNo" />
				</policyNo>

				<errors>
					<xsl:if test="$errorCount &gt; 0">
						<xsl:call-template name="maperrors">
							<xsl:with-param name="code" select="101" />
							<xsl:with-param name="message" select="a:Errors" />
						</xsl:call-template>
					</xsl:if>
				</errors>
			</xsl:for-each>

			<!-- Webservice errors -->
			<xsl:if test="count(/s:Envelope/s:Body/s:Fault) &gt; 0">
				<success>false</success>
				<policyNo></policyNo>
				<errors>
					<xsl:for-each select="/s:Envelope/s:Body/s:Fault">
						<xsl:call-template name="maperrors">
							<xsl:with-param name="code" select="faultcode" />
							<xsl:with-param name="message" select="faultstring" />
						</xsl:call-template>
					</xsl:for-each>
				</errors>
			</xsl:if>

			<!-- Error returned by SOAP aggregator -->
			<xsl:if test="local-name(/*) = 'error'">
				<success>false</success>
				<policyNo></policyNo>
				<errors>
					<xsl:call-template name="maperrors">
						<xsl:with-param name="code" select="/error/code" />
						<xsl:with-param name="message" select="/error/message" />
					</xsl:call-template>
				</errors>
			</xsl:if>
		</result>
	</xsl:template>

</xsl:stylesheet>