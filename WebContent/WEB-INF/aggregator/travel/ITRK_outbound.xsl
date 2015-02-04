<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cal="java.util.GregorianCalendar" xmlns:sdf="java.text.SimpleDateFormat">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- xsl:import href="../includes/utils.xsl"/ -->

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="today" />
	<xsl:param name="username" />
	<xsl:param name="password" />

<!-- KEYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/travel">

<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<!--
			If more than 1 region selected - default to WW
			If user selected Africa - default to WW
			Else - substitute the region code
		-->


		<xsl:variable name="region">
			<xsl:choose>
				<xsl:when test="destinations/af/af">WW</xsl:when>
				<xsl:when test="destinations/am/us">WW</xsl:when>
				<xsl:when test="destinations/am/ca">WW</xsl:when>
				<xsl:when test="destinations/am/sa">WW</xsl:when>
				<xsl:when test="destinations/as/jp">WW</xsl:when>
				<xsl:when test="destinations/me/me">WW</xsl:when>
				<xsl:when test="destinations/do/do">WW</xsl:when>

				<xsl:when test="destinations/eu/eu">EU</xsl:when>
				<xsl:when test="destinations/eu/uk">EU</xsl:when>

				<xsl:when test="destinations/as/ch">AS</xsl:when>
				<xsl:when test="destinations/as/hk">AS</xsl:when>
				<xsl:when test="destinations/as/in">AS</xsl:when>
				<xsl:when test="destinations/as/th">AS</xsl:when>
				<xsl:when test="destinations/pa/in">AS</xsl:when>

				<xsl:when test="destinations/pa/ba">PC</xsl:when>
				<xsl:when test="destinations/pa/nz">PC</xsl:when>
				<xsl:when test="destinations/pa/pi">PC</xsl:when>

				<xsl:otherwise>WW</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fromDate">
			<xsl:choose>
				<xsl:when test="policyType = 'S'">
					<xsl:call-template name="util_isoDate"><xsl:with-param name="eurDate" select="dates/fromDate" /></xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$today" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="toDate">
			<xsl:choose>
				<xsl:when test="policyType = 'S'">
					<xsl:call-template name="util_isoDate"><xsl:with-param name="eurDate" select="dates/toDate" /></xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="dayResult" select="cal:add(5, 20)"/> <!-- Add 89 Days. The current day is inclusive which pushes it to 90 days total -->
					<xsl:value-of select="sdf:format(sdf:new('yyyy-MM-dd'),cal:getTime())" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:quot="http://www.1cover.com.au/ws/schemas/quotes" xmlns:typ="http://www.1cover.com.au/ws/schemas/types">
			<soapenv:Header>
				<wsse:Security soapenv:mustUnderstand="0" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurityutility-1.0.xsd">
					<wsse:UsernameToken>
						<wsse:Username><xsl:value-of select="$username" /></wsse:Username>
						<wsse:Password><xsl:value-of select="$password" /></wsse:Password>
					</wsse:UsernameToken>
				</wsse:Security>
			</soapenv:Header>
			<soapenv:Body>
				<quot:GetQuotesRequest>
					<quot:partner-id>2</quot:partner-id>
					<quot:source-id>1</quot:source-id>
					<quot:schema-version>2</quot:schema-version>
					<quot:partner-reference>1</quot:partner-reference>
					<quot:client-ip-address><xsl:value-of select="clientIpAddress" /></quot:client-ip-address>
					<quot:destination>
						<typ:destination-id><xsl:value-of select="$region" /></typ:destination-id>
					</quot:destination>
					<quot:number-of-adults><xsl:value-of select="adults" /></quot:number-of-adults>
					<quot:number-of-children><xsl:value-of select="children" /></quot:number-of-children>
					<quot:start-date><xsl:value-of select="$fromDate" /></quot:start-date>
					<quot:end-date><xsl:value-of select="$toDate" /></quot:end-date>
					<quot:affiliate-id>63</quot:affiliate-id>
					<quot:adult-age><xsl:value-of select="oldest" /></quot:adult-age>
					<xsl:if test="adults = 2">
						<quot:adult-age><xsl:value-of select="oldest" /></quot:adult-age>
					</xsl:if>
				</quot:GetQuotesRequest>
			</soapenv:Body>
		</soapenv:Envelope>

	</xsl:template>


<!-- UTILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="util_isoDate">
		<xsl:param name="eurDate"/>

		<xsl:variable name="day" 		select="substring-before($eurDate,'/')" />
		<xsl:variable name="month-temp" select="substring-after($eurDate,'/')" />
		<xsl:variable name="month" 		select="substring-before($month-temp,'/')" />
		<xsl:variable name="year" 		select="substring-after($month-temp,'/')" />

		<xsl:value-of select="$year" />
		<xsl:value-of select="'-'" />
		<xsl:value-of select="format-number($month, '00')" />
		<xsl:value-of select="'-'" />
		<xsl:value-of select="format-number($day, '00')" />
	</xsl:template>
</xsl:stylesheet>