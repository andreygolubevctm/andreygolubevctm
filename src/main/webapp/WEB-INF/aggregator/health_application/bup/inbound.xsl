<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:s="http://www.w3.org/2003/05/soap-envelope"
	xmlns:t="http://bupa.com.au/wsdl/WebFacadeCtmService-v1.0"
	exclude-result-prefixes="xsl soap s t">

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>
	<xsl:param name="fundid">bup</xsl:param>

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="fundErrors">
		<errors>
			<!-- Bupa has an unknown list of codes so just return the message -->
			<error code="999">000</error>
		</errors>
	</xsl:variable>
	<xsl:include href="../../includes/health_fund_errors.xsl"/>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/s:Envelope/s:Body/t:EnrolNewMembershipCtmResponse">
		<result>
			<fund><xsl:value-of select="$fundid" /></fund>

			<xsl:variable name="status">
				<xsl:choose>
					<xsl:when test="t:EnrolNewMembershipCtmResult != ''">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<success>
				<xsl:value-of select="$status" />
			</success>

			<xsl:if test="$status='true'">
			<policyNo>
				<xsl:value-of select="t:EnrolNewMembershipCtmResult" />
			</policyNo>
			</xsl:if>
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

	<!-- Disregard the Header -->
	<xsl:template match="s:Header">
	</xsl:template>

</xsl:stylesheet>