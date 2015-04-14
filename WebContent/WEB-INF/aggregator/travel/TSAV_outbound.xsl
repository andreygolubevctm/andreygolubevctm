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
		<!--
			If more than 1 region selected - default to WW
			If user selected Africa - default to WW
			Else - substitute the region code
		-->
		<!-- region mapping for other products ie comprehensive, AMT, ski & domestic -->
		<xsl:variable name="region">
			<xsl:choose>
				<xsl:when test="policyType = 'S'">
					<xsl:call-template name="getRegionMapping">
						<xsl:with-param name="selectedRegions" select="mappedCountries/TSAV/comprehensive/regions" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>R1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- region mapping for essentials and bare essential products -->
		<xsl:variable name="essentialsRegion">

			<xsl:choose>
				<xsl:when test="policyType = 'S'">
					<xsl:call-template name="getRegionMapping">
						<xsl:with-param name="selectedRegions" select="mappedCountries/TSAV/essentials/regions" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>R1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- region mapping for essentials and bare essential products -->
		<xsl:variable name="elementsRegion">

			<xsl:choose>
				<xsl:when test="policyType = 'S'">
					<xsl:call-template name="getRegionMapping">
						<xsl:with-param name="selectedRegions" select="mappedCountries/TSAV/elements/regions" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>R1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="comprehensiveIds">164,165,166,187</xsl:variable>

		<xsl:variable name="elementsIds">
			<xsl:if test="children = 0">163</xsl:if>
		</xsl:variable>

		<xsl:variable name="essentialIds">181,218</xsl:variable>

		<request>
<!-- HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
			<header>
				<partnerReference><xsl:value-of select="transactionId" /></partnerReference>
				<clientIpAddress><xsl:value-of select="clientIpAddress" /></clientIpAddress>
			</header>

<!-- REQUEST DETAILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<!--
			If children entered - set to (FAM)ily
			If 2 adults - DUO
			Otherwise, (SIN)gle
		-->
			<product id="comprehensive">
				<ids><xsl:value-of select="$comprehensiveIds" /></ids>
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
			</product>
			<xsl:if test="children = 0">
				<product id="essentials">
					<ids><xsl:value-of select="$elementsIds" /></ids>
					<details>
						<age><xsl:value-of select="oldest" /></age>
						<region><xsl:value-of select="$elementsRegion" /></region>
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
				</product>
			</xsl:if>
			<product id="elements">
				<ids><xsl:value-of select="$essentialIds" /></ids>
				<details>
					<age><xsl:value-of select="oldest" /></age>
					<region><xsl:value-of select="$essentialsRegion" /></region>
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
			</product>
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