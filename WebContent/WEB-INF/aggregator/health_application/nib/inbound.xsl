<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:nib="http://www.nib.com.au/Broker/Gateway"
	exclude-result-prefixes="xsl soap nib">

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>
	<xsl:param name="fundid">nib</xsl:param>

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="fundErrors">
		<errors>
			<error code="WDD1">000</error>
			<error code="WDD2">000</error>
			<error code="WDD3">000</error>
			<error code="WDD4">000</error>
			<error code="352">067</error>
			<error code="C04">068</error>
			<error code="C041">068</error>
			<error code="47">000</error>
			<error code="H25">000</error>
			<error code="D62">000</error>
			<error code="B60">075</error>
			<error code="1731">059</error>
			<error code="445">073</error>
			<error code="C103">072</error>
			<error code="C104">072</error>
			<error code="D29">074</error>
			<error code="D401">071</error>
			<error code="D501">070</error>
			<error code="WCC1">028</error>
			<error code="WCD1">027</error>
			<error code="WCE1">069</error>
			<error code="WCL1">039</error>
		</errors>
	</xsl:variable>
	<xsl:include href="../../includes/health_fund_errors.xsl"/>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/soap:Envelope/soap:Body/nib:EnrolResponse/nib:EnrolResult">
		<result>
			<fund><xsl:value-of select="$fundid" /></fund>

			<xsl:variable name="errorStatus"><xsl:value-of select="nib:Status" /></xsl:variable>

			<!--
				"Allowable" error list (see HLT-490)
				If the web service returns one of these it 'should' be safe to ignore and believe the join to be successful.
			-->
			<xsl:variable name="hasRealErrors">
				<xsl:for-each select="nib:Errors/*">
					<xsl:choose>
						<xsl:when test="nib:Message='FetchDirectHist: No Health Policy associated with this Client'"></xsl:when>
						<xsl:when test="starts-with(nib:Message, 'EnrolMember: Campaign code is invalid')"></xsl:when>
						<xsl:when test="nib:Parameter='H25'"></xsl:when>
						<xsl:when test="nib:Parameter='D62'"></xsl:when>
						<xsl:when test="nib:Parameter='WDD1'"></xsl:when>
						<xsl:otherwise>Y</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:variable>
			<success>
				<xsl:choose>
					<!-- Fail if had error that is not on the allowable list -->
					<xsl:when test="$errorStatus = 'Errors' and contains($hasRealErrors, 'Y')">false</xsl:when>

					<xsl:otherwise>true</xsl:otherwise>
				</xsl:choose>
			</success>
			<policyNo>
				<xsl:value-of select="nib:Membership/nib:MemberNo" />
			</policyNo>
			<errors>
				<xsl:if test="$errorStatus = 'Errors'">
					<xsl:for-each select="nib:Errors/*">
						<xsl:call-template name="maperrors">
							<xsl:with-param name="parameter" select="nib:Parameter" />
							<xsl:with-param name="code" select="nib:Code" />
							<xsl:with-param name="message" select="nib:Message" />
						</xsl:call-template>
					</xsl:for-each>
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
</xsl:stylesheet>