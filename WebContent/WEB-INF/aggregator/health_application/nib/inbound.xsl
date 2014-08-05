<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:nib="http://www.nib.com.au/Broker/Gateway"
	exclude-result-prefixes="xsl s nib">

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
			<error code="ClientHistory.PreviousNibMemer">067</error>
			<error code="PartnerHistory.PreviousNibMemer">076</error>
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
	<xsl:template match="/">
		<result>
			<fund><xsl:value-of select="$fundid" /></fund>

			<xsl:for-each select="/s:Envelope/s:Body/nib:EnrolResponse/nib:EnrolResult">
				<xsl:variable name="errorStatus"><xsl:value-of select="nib:Status" /></xsl:variable>

				<!--
					"Allowable" error list (see HLT-490)
					If the web service returns one of these it 'should' be safe to ignore and believe the join to be successful.
				-->
				<xsl:variable name="allowableErrors">WDD1,WDD2,WDD3,WDD4,H25,D62</xsl:variable>
				<xsl:variable name="hasRealErrors">
					<xsl:for-each select="nib:Errors/*">
						<xsl:choose>
							<xsl:when test="nib:Message='FetchDirectHist: No Health Policy associated with this Client'">
								<xsl:variable name="allowedError">nib:Message='FetchDirectHist: No Health Policy associated with this Client'</xsl:variable>
							</xsl:when>
							<xsl:when test="starts-with(nib:Message, 'EnrolMember: Campaign code is invalid')"></xsl:when>
							<xsl:when test="contains($allowableErrors, nib:Parameter)"></xsl:when>
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
					<xsl:if test="$errorStatus = 'Errors' and contains($hasRealErrors, 'Y')">
						<xsl:for-each select="nib:Errors/*">
						<xsl:variable name="errorCode">
							<xsl:choose>
								<xsl:when test="nib:Code =''"><xsl:value-of select="nib:Parameter" /></xsl:when>
								<xsl:otherwise><xsl:value-of select="nib:Code" /></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
							<xsl:call-template name="maperrors">
								<xsl:with-param name="parameter" select="nib:Parameter" />
								<xsl:with-param name="code" select="$errorCode" />
								<xsl:with-param name="message" select="nib:Message" />
							</xsl:call-template>
						</xsl:for-each>
					</xsl:if>
				</errors>
				<xsl:if test="$errorStatus = 'Errors'">
					<allowedErrors>
						<xsl:for-each select="nib:Errors/*">
							<xsl:if test="contains($allowableErrors, nib:Parameter)">
								<xsl:call-template name="maperrors">
									<xsl:with-param name="parameter" select="nib:Parameter" />
									<xsl:with-param name="code" select="nib:Code" />
									<xsl:with-param name="message" select="nib:Message" />
								</xsl:call-template>
							</xsl:if>
			</xsl:for-each>
					</allowedErrors>
				</xsl:if>
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