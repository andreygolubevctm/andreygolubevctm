<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns="http://pricingapi.agaassistance.com.au/PricingRequest.xsd">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<xsl:import href="utilities/date_functions.xsl" />

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<xsl:param name="partnerId" />
<xsl:param name="sourceId" />
<xsl:param name="today" />

<!-- KEYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<xsl:template match="/travel">

	<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="thisYear">
		<xsl:value-of select="substring($today,1,4)" />
	</xsl:variable>

	<xsl:variable name="defaultYear">
		<xsl:value-of select="$thisYear - oldest" />
	</xsl:variable>

	<xsl:variable name="childYear">
		<xsl:value-of select="$thisYear - 18" />
	</xsl:variable>

	<xsl:variable name="startDate">
		<xsl:choose>
			<xsl:when test="policyType = 'A'"><xsl:value-of select="$today" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="concat(substring(dates/fromDate,7,4),'-',substring(dates/fromDate,4,2),'-',substring(dates/fromDate,1,2))" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="endDate">
		<xsl:choose>
			<xsl:when test="policyType = 'A'">
				<xsl:value-of select="concat(substring($today,1,4)+1,'-',substring($today,6,2),'-',substring($today,9,2))" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(substring(dates/toDate,7,4),'-',substring(dates/toDate,4,2),'-',substring(dates/toDate,1,2))" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="quoteType">
		<xsl:choose>
			<xsl:when test="policyType = 'S'">SGL</xsl:when>
			<xsl:otherwise>MULTI</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="adultDOB">
		<xsl:call-template name="formatDate">
			<xsl:with-param name="today" select="$today" />
			<xsl:with-param name="oldest" select="oldest" />
			<xsl:with-param name="seperator" select="'-'" />
			<xsl:with-param name="dateFormat" select="'YYYYmmdd'" />
		</xsl:call-template>
	</xsl:variable>
	<!-- Default to 10 years old as per documentation since we don't ask for a child's age -->
	<xsl:variable name="childDOB">
		<xsl:call-template name="getBirthDate">
			<xsl:with-param name="today" select="$today" />
			<xsl:with-param name="yearsAgo" select="10" />
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="destinations">
		<xsl:choose>
			<xsl:when test="policyType = 'A'">
				<Destination><RegionCode>WORLD</RegionCode><CountryCode>WWID</CountryCode></Destination>
			</xsl:when>
			<xsl:otherwise>
				<!-- Africa -->
				<xsl:choose><xsl:when test="destinations/af/af !=''"><Destination><RegionCode>AFRCA</RegionCode><CountryCode>AFR</CountryCode></Destination></xsl:when></xsl:choose>
				<!-- Americas -->
				<xsl:choose><xsl:when test="destinations/am/us !=''"><Destination><RegionCode>AMS</RegionCode><CountryCode>USA</CountryCode></Destination></xsl:when></xsl:choose>
				<xsl:choose><xsl:when test="destinations/am/ca !=''"><Destination><RegionCode>AMS</RegionCode><CountryCode>CAN</CountryCode></Destination></xsl:when></xsl:choose>
				<xsl:choose><xsl:when test="destinations/am/sa !=''"><Destination><RegionCode>AMS</RegionCode><CountryCode>STAM</CountryCode></Destination></xsl:when></xsl:choose>
				<!-- Middle East -->
				<xsl:choose><xsl:when test="destinations/me/me !=''"><Destination><RegionCode>ZASI</RegionCode><CountryCode>MEA</CountryCode></Destination></xsl:when></xsl:choose>
				<!-- Europe, UK -->
				<xsl:choose><xsl:when test="destinations/eu/eu !=''"><Destination><RegionCode>ZEUR</RegionCode><CountryCode>EUR</CountryCode></Destination></xsl:when></xsl:choose>
				<xsl:choose><xsl:when test="destinations/eu/uk !=''"><Destination><RegionCode>ZEUR</RegionCode><CountryCode>GBR</CountryCode></Destination></xsl:when></xsl:choose>
				<!-- China, HK, Japan, India, Thailand, Indonesia -->
				<xsl:choose><xsl:when test="destinations/as/ch !=''"><Destination><RegionCode>ZASI</RegionCode><CountryCode>CHN</CountryCode></Destination></xsl:when></xsl:choose>
				<xsl:choose><xsl:when test="destinations/as/hk !=''"><Destination><RegionCode>ZASI</RegionCode><CountryCode>HKG</CountryCode></Destination></xsl:when></xsl:choose>
				<xsl:choose><xsl:when test="destinations/as/jp !=''"><Destination><RegionCode>ZASI</RegionCode><CountryCode>JPN</CountryCode></Destination></xsl:when></xsl:choose>
				<xsl:choose><xsl:when test="destinations/as/in !=''"><Destination><RegionCode>ZASI</RegionCode><CountryCode>IND</CountryCode></Destination></xsl:when></xsl:choose>
				<xsl:choose><xsl:when test="destinations/as/th !=''"><Destination><RegionCode>ZASI</RegionCode><CountryCode>THA</CountryCode></Destination></xsl:when></xsl:choose>
				<xsl:choose><xsl:when test="destinations/pa/in !=''"><Destination><RegionCode>ZASI</RegionCode><CountryCode>IDN</CountryCode></Destination></xsl:when></xsl:choose>
				<!-- Bali, New Zealand, Pacific Islands -->
				<xsl:choose><xsl:when test="destinations/pa/ba !=''"><Destination><RegionCode>ZASI</RegionCode><CountryCode>IDN</CountryCode><LocationCode>BAL</LocationCode></Destination></xsl:when></xsl:choose>
				<xsl:choose><xsl:when test="destinations/pa/nz !=''"><Destination><RegionCode>NZL</RegionCode><CountryCode>NZL</CountryCode></Destination></xsl:when></xsl:choose>
				<xsl:choose><xsl:when test="destinations/pa/pi !=''"><Destination><RegionCode>PACIF</RegionCode><CountryCode>PAC</CountryCode></Destination></xsl:when></xsl:choose>
				<!-- Australia -->
				<xsl:choose><xsl:when test="destinations/au/au !=''"><Destination><RegionCode>AUS</RegionCode><CountryCode>AUS</CountryCode></Destination></xsl:when></xsl:choose>
				<!-- Other -->
				<xsl:choose><xsl:when test="destinations/do/do !=''"><Destination><RegionCode>WORLD</RegionCode><CountryCode>WWID</CountryCode></Destination></xsl:when></xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- SOAP Request ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<PricingRequest xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://pricingapi.agaassistance.com.au/PricingRequest.xsd">
		<ClientCode>OTIAU</ClientCode>
		<QuoteType><xsl:value-of select="$quoteType" /></QuoteType>
		<CoverStartDate><xsl:value-of select="$startDate" /></CoverStartDate>
		<CoverEndDate><xsl:value-of select="$endDate" /></CoverEndDate>
		<Destinations>
			<xsl:copy-of select="$destinations" />
		</Destinations>
		<Travellers>
			<Traveller>
				<Type>ADULT</Type>
				<DateOfBirth><xsl:value-of select="$adultDOB" /></DateOfBirth>
			</Traveller>
			<xsl:choose>
				<xsl:when test="adults = 2">
				<Traveller>
					<Type>ADULT</Type>
					<DateOfBirth><xsl:value-of select="$adultDOB" /></DateOfBirth>
				</Traveller>
				</xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="children != 0">
					<xsl:call-template name="printChildren">
						<xsl:with-param name="i">1</xsl:with-param>
						<xsl:with-param name="count" select="children" />
						<xsl:with-param name="childDOB" select="$childDOB" />
					</xsl:call-template>

				</xsl:when>
			</xsl:choose>
		</Travellers>
	</PricingRequest>
	</xsl:template>

	<xsl:template name="printChildren">
		<xsl:param name="i" />
		<xsl:param name="count" />
		<xsl:param name="childDOB" />

		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
				<Traveller>
					<Type>CHILD</Type>
					<DateOfBirth><xsl:value-of select="$childDOB" /></DateOfBirth>
				</Traveller>
			<xsl:call-template name="printChildren">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count" select="$count" />
				<xsl:with-param name="childDOB" select="$childDOB" />
			</xsl:call-template>
		</xsl:if>

	</xsl:template>
</xsl:stylesheet>