<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:s="http://www.w3.org/2003/05/soap-envelope"
	xmlns:b="http://schemas.datacontract.org/2004/07/Civica.WHICSServices"
	xmlns:t="http://tempuri.org/"
	exclude-result-prefixes="xsl soap s b t">

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>
	<xsl:param name="fundid">ahm</xsl:param>

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="fundErrors">
		<errors>
			<!-- AHM can't provide a list of codes so just return the message -->
			<error code="?">999</error>
		</errors>
	</xsl:variable>
	<xsl:include href="../../includes/health_fund_errors.xsl"/>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<result>
			<fund><xsl:value-of select="$fundid" /></fund>

			<xsl:variable name="status"><xsl:value-of select="/s:Envelope/s:Body/t:EnrolMemberResponse/t:EnrolMemberResult/b:Status" /></xsl:variable>
			<success>
				<xsl:choose>
					<xsl:when test="$status='Success'">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</success>

			<xsl:if test="$status='Success'">
				<policyNo>
					<xsl:value-of select="/s:Envelope/s:Body/t:EnrolMemberResponse/t:EnrolMemberResult/b:Client" />
				</policyNo>
			</xsl:if>

			<errors>
				<!-- Error returned by SOAP aggregator -->
				<xsl:if test="local-name(/*) = 'error'">
					<xsl:call-template name="maperrors">
						<xsl:with-param name="code" select="/error/code" />
						<xsl:with-param name="message" select="/error/message" />
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="/s:Envelope/s:Body/t:EnrolMemberResponse/t:EnrolMemberResult/b:SystemError != ''">
					<xsl:call-template name="maperrors">
						<xsl:with-param name="code" select="/s:Envelope/s:Body/t:EnrolMemberResponse/t:EnrolMemberResult/b:SystemError" />
						<xsl:with-param name="message" select="/s:Envelope/s:Body/t:EnrolMemberResponse/t:EnrolMemberResult/b:Status" />
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="count(/s:Envelope/s:Body/t:EnrolMemberResponse/t:EnrolMemberResult/b:APILogicalError/*) &gt; 0">
					<xsl:variable name="message"><xsl:text>APILogicalError: </xsl:text><xsl:value-of select="/s:Envelope/s:Body/t:EnrolMemberResponse/t:EnrolMemberResult/b:APILogicalError/b:StatusDescription" /></xsl:variable>
					<xsl:call-template name="maperrors">
						<xsl:with-param name="code" select="/s:Envelope/s:Body/t:EnrolMemberResponse/t:EnrolMemberResult/b:APILogicalError/b:StatusCode" />
						<xsl:with-param name="message" select="$message" />
					</xsl:call-template>
				</xsl:if>
			</errors>
		</result>
	</xsl:template>
</xsl:stylesheet>