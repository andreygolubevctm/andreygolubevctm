<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cal="java.util.GregorianCalendar" xmlns:sdf="java.text.SimpleDateFormat">

	<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/ws_from_documentation_util_functions.xsl" />
	<xsl:import href="utilities/countryMapping.xsl" />

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="today" />
	<xsl:param name="SPName" />
	<xsl:param name="CustLoginId" />
	<xsl:param name="password" />


<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/travel">

<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<xsl:variable name="policyType">
			<xsl:choose>
				<xsl:when test="policyType = 'S'">SINGLE</xsl:when>
				<xsl:otherwise>AMT</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="leaveDate">
			<xsl:value-of select="dates/fromDate" />
		</xsl:variable>

		<xsl:variable name="returnDate">
			<xsl:choose>
				<xsl:when test="policyType = 'S'"><xsl:value-of select="dates/toDate" /></xsl:when>
				<xsl:otherwise>
					<xsl:variable name="yearResult" select="cal:add(YEAR, 1)"/> <!-- Add 20 Days. The current day is inclusive which pushes it to 21 days total. yearResult is just a variable to hold the result -->
					<xsl:value-of select="sdf:format(sdf:new('dd/MM/yyyy'),cal:getTime())" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="region">
			<region_brief>
			<xsl:choose>
				<xsl:when test="policyType = 'S'">
					<xsl:call-template name="getRegionMapping">
						<xsl:with-param name="selectedRegions" select="mappedCountries/TICK/regions" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>R1</xsl:otherwise>
			</xsl:choose>
			</region_brief>
		</xsl:variable>

		<!-- Yes TICK needs two entries for this to work hence the look up of region -->
		<xsl:variable name="country">
			<country_code>
				<xsl:choose>
					<xsl:when test="policyType = 'S'">
							<xsl:call-template name="getRegionMapping">
								<xsl:with-param name="selectedRegions" select="mappedCountries/TICK/countries" />
							</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>R1</xsl:otherwise>
				</xsl:choose>
			</country_code>
		</xsl:variable>

<!-- REQUEST ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<QuoteRequest>
			<ClientId>507</ClientId>
			<Input>
				<policy_request>
					<policy_criteria>
						<policy_type><xsl:value-of select="$policyType" /></policy_type>
						<quote_date><xsl:value-of select="sdf:format(sdf:new('dd/MM/yyyy'),cal:getTime())" /></quote_date>
						<quantity_adults><xsl:value-of select="adults" /></quantity_adults>
						<quantity_children><xsl:value-of select="children" /></quantity_children>
						<cover_start_date><xsl:value-of select="$leaveDate" /></cover_start_date>
						<cover_end_date><xsl:value-of select="$returnDate" /></cover_end_date>
					</policy_criteria>
					<regions>
						<region>
							<xsl:copy-of select="$region" />
							<xsl:copy-of select="$country" />
						</region>
					</regions>
					<travellers>
						<traveller>
							<line_id>1</line_id>
							<type>ADULT</type>
							<age><xsl:value-of select="oldest" /></age>
						</traveller>
					</travellers>
					<xsl:if test="adults = 2">
						<traveller>
							<line_id>2</line_id>
							<type>ADULT</type>
							<age><xsl:value-of select="oldest" /></age>
						</traveller>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="children != 0">
							<xsl:call-template name="printChildren">
								<xsl:with-param name="i" select="adults" />
								<xsl:with-param name="count" select="children" />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</policy_request>
			</Input>
		</QuoteRequest>
	</xsl:template>
</xsl:stylesheet>
