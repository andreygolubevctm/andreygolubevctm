<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:au="http://ws.australianunity.com.au/B2B/Broker"
	exclude-result-prefixes="xsl soap au">

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>
	<xsl:param name="fundid">auf</xsl:param>

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="fundErrors">
		<errors>
			<!-- Australian Unity can't provide a list of codes so just return the message -->
			<error code="999">000</error>
		</errors>
	</xsl:variable>
	<xsl:include href="../../includes/health_fund_errors.xsl"/>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/soap:Envelope/soap:Body/au:ProcessApplicationResponse/au:ProcessApplicationResult">
		<result>
			<fund><xsl:value-of select="$fundid" /></fund>

			<xsl:variable name="status"><xsl:value-of select="au:Status" /></xsl:variable>
			<success>
				<xsl:choose>
					<xsl:when test="$status='Success'">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</success>

			<xsl:if test="$status='Success'">
			<policyNo>
				<xsl:value-of select="au:PolicyNumber" />
			</policyNo>
			</xsl:if>
			<errors>
				<xsl:for-each select="au:ValidationErrors/*">
					<xsl:call-template name="maperrors">
						<xsl:with-param name="code" select="au:Reason" />
						<xsl:with-param name="message" select="au:DisplayErrorMessage" />
					</xsl:call-template>
				</xsl:for-each>
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
</xsl:stylesheet>