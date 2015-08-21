<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="xsl soap">

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>
	<xsl:param name="fundid">wfd</xsl:param>

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="fundErrors">
		<errors>
			<!-- We simply want to return the original message -->
			<error code="?">999</error>
		</errors>
	</xsl:variable>
	<xsl:include href="../../includes/health_fund_errors.xsl"/>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<result>
			<fund><xsl:value-of select="$fundid" /></fund>

			<xsl:variable name="success">
				<xsl:choose>
					<!-- Not a SOAP error and success is true -->
					<xsl:when test="not(/error) and /result/success='true'">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<success><xsl:value-of select="$success" /></success>

			<policyNo>
			<xsl:if test="$success='true'">
					<xsl:value-of select="/result/policyNo" />
			</xsl:if>
			</policyNo>

			<errors>
				<!-- Not a SOAP error -->
				<xsl:if test="not(/error)">
					<xsl:for-each select="/result/errors/error">
						<xsl:call-template name="maperrors">
							<xsl:with-param name="code" select="code" />
							<xsl:with-param name="message" select="text" />
						</xsl:call-template>
					</xsl:for-each>
				</xsl:if>
				<!-- IS a SOAP error -->
				<xsl:if test="/error != ''">
					<xsl:call-template name="maperrors">
						<xsl:with-param name="code" select="/error/code" />
						<xsl:with-param name="message" select="error/message" />
					</xsl:call-template>
				</xsl:if>
			</errors>
		</result>
	</xsl:template>
</xsl:stylesheet>