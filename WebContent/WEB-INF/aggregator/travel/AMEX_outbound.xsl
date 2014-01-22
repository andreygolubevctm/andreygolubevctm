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
					<!-- Multi-Trip -->
					<xsl:when test="policyType = 'A'">R4</xsl:when>

					<!-- REGION 1(R1) -->
					<xsl:when test="destinations/af/af">R1</xsl:when>
					<xsl:when test="destinations/as/jp">R1</xsl:when>
					<xsl:when test="destinations/me/me">R1</xsl:when>
					<xsl:when test="destinations/am/ca">R1</xsl:when>
					<xsl:when test="destinations/am/sa">R1</xsl:when>
					<xsl:when test="destinations/do/do">R1</xsl:when>
					<xsl:when test="destinations/am/us">R1</xsl:when>

					<!-- REGION 2 (R2) -->
					<xsl:when test="destinations/eu/eu">R2</xsl:when>
					<xsl:when test="destinations/eu/uk">R2</xsl:when>

					<!-- REGION 3 (R3) -->
					<!-- China -->
					<xsl:when test="destinations/as/ch">R3</xsl:when>
					<!-- HongKong -->
					<xsl:when test="destinations/as/hk">R3</xsl:when>
					<!-- India -->
					<xsl:when test="destinations/as/in">R3</xsl:when>
					<!-- Indonesia -->
					<xsl:when test="destinations/pa/in">R3</xsl:when>
					<!-- Thailand -->
					<xsl:when test="destinations/as/th">R3</xsl:when>

					<!-- REGION 4 (R4) -->
					<xsl:when test="destinations/pa/ba">R4</xsl:when>
					<xsl:when test="destinations/pa/nz">R4</xsl:when>
					<xsl:when test="destinations/pa/pi">R4</xsl:when>

					<!-- REGION 5 (AU) -->
					<xsl:when test="destinations/au/au"></xsl:when>

					<!-- Default to REGION 1 (PA) -->
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
			If children entered and adults >= 1 and policyType is Multitrip - set to (FAM)ily
			If children entered and adults >= 1 and policyType is single trip - set to Single
			If 2 adults - FAM
			Otherwise, (SIN)gle
		-->
			<details>
				<age><xsl:value-of select="oldest" /></age>
				<region><xsl:value-of select="$region" /></region>
				<type>
					<xsl:choose>
						<xsl:when test="policyType = 'A'">
							<xsl:choose>
								<xsl:when test="children != '0' and adults >= '1'">FAM</xsl:when>
								<xsl:when test="adults > '1'">FAM</xsl:when>
								<xsl:when test="children = '0' and adults = '1'">SIN</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="children != '0' and adults = '1'">SIN</xsl:when>
								<xsl:when test="adults > '1'">FAM</xsl:when>
								<xsl:when test="children = '0' and adults = '1'">SIN</xsl:when>
							</xsl:choose>
						</xsl:otherwise>
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