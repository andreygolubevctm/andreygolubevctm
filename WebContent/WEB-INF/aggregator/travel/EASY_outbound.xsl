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

		<xsl:variable name="region">
			<xsl:choose>
				<xsl:when test="policyType = 'A'">R1</xsl:when>
				<!-- REGION 1 (R1) -->
				<xsl:when test="destinations/am/us">R1</xsl:when>
				<xsl:when test="destinations/am/sa">R1</xsl:when>
				<xsl:when test="destinations/do/do">R1</xsl:when>

				<!-- REGION 2 (R2) -->
				<xsl:when test="destinations/am/ca">R2</xsl:when>
				<xsl:when test="destinations/af/af">R2</xsl:when>

				<!-- REGION 3 (R3) -->
				<xsl:when test="destinations/eu/eu">R3</xsl:when>
				<xsl:when test="destinations/me/me">R3</xsl:when>

				<!-- REGION 4 (R4) -->
				<xsl:when test="destinations/as/jp">R4</xsl:when>
				<xsl:when test="destinations/as/hk">R4</xsl:when>
				<xsl:when test="destinations/as/in">R4</xsl:when>
				<xsl:when test="destinations/as/ch">R4</xsl:when>
				<xsl:when test="destinations/as/th">R4</xsl:when>

				<!-- REGION 5 (R5) -->
				<xsl:when test="destinations/eu/uk">R5</xsl:when>

				<!-- REGION 6 (R6) -->
				<xsl:when test="destinations/pa/pi">R6</xsl:when>

				<!-- REGION 7 (R7) -->
				<xsl:when test="destinations/pa/nz">R7</xsl:when>

				<!-- REGION 8 (R8) -->
				<xsl:when test="destinations/pa/in">R8</xsl:when>
				<xsl:when test="destinations/pa/ba">R8</xsl:when>

				<!-- AUSTRALIA -->
				<xsl:when test="destinations/au/au">R9</xsl:when>

				<!-- Default to REGION 1 (WW) -->
				<xsl:otherwise>R1</xsl:otherwise>
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
			If 2 adults and any children entered - set to (FAM)ily
			If 2 adults - DUO
			Otherwise, (SIN)gle
		-->
			<details>
				<age><xsl:value-of select="oldest" /></age>
				<region><xsl:value-of select="$region" /></region>
				<type>
					<xsl:choose>
					<xsl:when test="adults = '2' and children != '0'">FAM</xsl:when>
						<xsl:when test="adults = '2'">DUO</xsl:when>
						<xsl:when test="adults = '1'">SIN</xsl:when>
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