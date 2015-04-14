<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/countryMapping.xsl" />

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
				<xsl:when test="policyType = 'S'">
					<xsl:call-template name="getRegionMapping">
						<xsl:with-param name="selectedRegions" select="mappedCountries/EASY/regions" />
					</xsl:call-template>
				</xsl:when>
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