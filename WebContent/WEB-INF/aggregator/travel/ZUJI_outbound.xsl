<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns="http://pricingapi.agaassistance.com.au/PricingRequest.xsd">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<xsl:import href="utilities/date_functions.xsl" />
<xsl:import href="utilities/allianz_util_functions.xsl" />

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
				<Destination><RegionCode>WORLD</RegionCode></Destination>
			</xsl:when>
			<xsl:otherwise>

				<xsl:choose>
					<!-- REGION 1 -->
					<!-- Africa -->	
					<xsl:when test="destinations/af/af !=''"><Destination><RegionCode>WORLD</RegionCode></Destination></xsl:when>
					<!-- Americas -->
					<xsl:when test="destinations/am/us !=''"><Destination><RegionCode>USASC</RegionCode></Destination></xsl:when>
					<xsl:when test="destinations/am/ca !=''"><Destination><RegionCode>WORLD</RegionCode></Destination></xsl:when>
					<xsl:when test="destinations/am/sa !=''"><Destination><RegionCode>USASC</RegionCode></Destination></xsl:when>
					<xsl:when test="destinations/as/jp !=''"><Destination><RegionCode>WORLD</RegionCode></Destination></xsl:when>
					<!-- Middle East -->
					<xsl:when test="destinations/me/me !=''"><Destination><RegionCode>WORLD</RegionCode></Destination></xsl:when>
					<xsl:when test="destinations/do/do !=''"><Destination><RegionCode>WORLD</RegionCode></Destination></xsl:when>

					<!-- REGION 2 -->
					<!-- Europe, UK -->
					<xsl:when test="destinations/eu/eu !=''"><Destination><RegionCode>EURUK</RegionCode></Destination></xsl:when>
					<xsl:when test="destinations/eu/uk !=''"><Destination><RegionCode>EURUK</RegionCode></Destination></xsl:when>

					<!-- REGION 3 -->
					<!-- China, HK, India, Thailand, Indonesia -->
					<xsl:when test="destinations/as/ch !=''"><Destination><RegionCode>ASNJP</RegionCode></Destination></xsl:when>
					<xsl:when test="destinations/as/hk !=''"><Destination><RegionCode>ASNJP</RegionCode></Destination></xsl:when>
					<xsl:when test="destinations/as/in !=''"><Destination><RegionCode>ASNJP</RegionCode></Destination></xsl:when>
					<xsl:when test="destinations/as/th !=''"><Destination><RegionCode>ASNJP</RegionCode></Destination></xsl:when>

					<!-- REGION 4 -->
					<!-- Bali, New Zealand, Pacific Islands -->
					<xsl:when test="destinations/pa/ba !=''"><Destination><RegionCode>PACBL</RegionCode></Destination></xsl:when>
					<xsl:when test="destinations/pa/in !=''"><Destination><RegionCode>ASNJP</RegionCode></Destination></xsl:when>
					<xsl:when test="destinations/pa/nz !=''"><Destination><RegionCode>PACBL</RegionCode></Destination></xsl:when>
					<xsl:when test="destinations/pa/pi !=''"><Destination><RegionCode>PACBL</RegionCode></Destination></xsl:when>

					<!-- REGION 5 -->
					<!-- Australia -->
					<xsl:when test="destinations/au/au !=''"><Destination><RegionCode>AUS</RegionCode></Destination></xsl:when>
					<!-- Other -->
					<xsl:otherwise>
						<Destination><RegionCode>WORLD</RegionCode></Destination>
					</xsl:otherwise>
					
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- SOAP Request ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<PricingRequest xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://pricingapi.agaassistance.com.au/PricingRequest.xsd">
		<ClientCode>ZUJIAU</ClientCode>
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
</xsl:stylesheet>