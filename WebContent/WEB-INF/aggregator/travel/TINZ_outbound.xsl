<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- xsl:import href="../includes/utils.xsl"/ -->

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="today" />

<!-- KEYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/travel">

<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<!-- Order of regions of most expensive to cheapest below is correct-->
		<xsl:variable name="region">
				<xsl:choose>

					<!-- Multi-Trip -->
					<xsl:when test="policyType = 'A'">R1</xsl:when>

					<!-- REGION 4 (R4) -->
					<xsl:when test="destinations/am/us">R4</xsl:when>
					<xsl:when test="destinations/am/ca">R4</xsl:when>

					<!-- REGION 3 (R3) -->
					<xsl:when test="destinations/af/af">R3</xsl:when>
					<!-- China -->
					<xsl:when test="destinations/as/ch">R3</xsl:when>
					<!-- HongKong -->
					<xsl:when test="destinations/as/hk">R3</xsl:when>
					<!-- Japan -->
					<xsl:when test="destinations/as/jp">R3</xsl:when>
					<!-- India -->
					<xsl:when test="destinations/as/in">R3</xsl:when>
					<!-- Thailand -->
					<xsl:when test="destinations/as/th">R3</xsl:when>
					<!-- Middle East -->
					<xsl:when test="destinations/me/me">R3</xsl:when>
					<!-- Indonesia -->
					<xsl:when test="destinations/pa/in">R3</xsl:when>

					<xsl:when test="destinations/eu/eu">R3</xsl:when>
					<xsl:when test="destinations/eu/uk">R3</xsl:when>
					<xsl:when test="destinations/do/do">R3</xsl:when>

					<xsl:when test="destinations/am/sa">R3</xsl:when>

					<!-- REGION 2 (R2) -->
					<xsl:when test="destinations/pa/ba">R2</xsl:when>
					<xsl:when test="destinations/pa/nz">R2</xsl:when>
					<xsl:when test="destinations/pa/pi">R2</xsl:when>

					<!-- REGION 1 (R1) -->
					<xsl:when test="destinations/au/au">R1</xsl:when>

					<!-- Default to REGION 3 (WW) -->
					<xsl:otherwise>R3</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

		<request>
<!-- HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
			<header>
				<partnerReference><xsl:value-of select="transactionId" /></partnerReference>
				<clientIpAddress><xsl:value-of select="clientIpAddress" /></clientIpAddress>
			</header>

<!-- REQUEST DETAILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<!--
			If children entered - set to (FAM)ily
			Otherwise, (SIN)gle
		-->
			<details>
				<age><xsl:value-of select="oldest" /></age>
				<region><xsl:value-of select="$region" /></region>
				<type>
					<xsl:choose>
						<xsl:when test="children != '0'">FAM</xsl:when>
						<xsl:when test="adults = '2'">DUO</xsl:when>
						<xsl:otherwise>SIN</xsl:otherwise>
					</xsl:choose>
				</type>
				<multiTrip>
					<xsl:choose>
						<xsl:when test="policyType = 'A'">Y</xsl:when>
						<xsl:otherwise>N</xsl:otherwise>
					</xsl:choose>
				</multiTrip>
				<startDate>
					<xsl:call-template name="util_isoDate">
						<xsl:with-param name="eurDate" select="dates/fromDate" />
					</xsl:call-template>
				</startDate>
				<endDate>
					<xsl:call-template name="util_isoDate">
						<xsl:with-param name="eurDate" select="dates/toDate" />
					</xsl:call-template>
				</endDate>
			</details>
		</request>

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