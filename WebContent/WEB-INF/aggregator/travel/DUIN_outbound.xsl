<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:SimpleDateFormat="java.text.SimpleDateFormat" xmlns:Date="java.util.Date" exclude-result-prefixes="SimpleDateFormat Date">
	
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

		<xsl:variable name="region">
				<xsl:choose>
			<xsl:when test="policyType = 'S'">
				<xsl:call-template name="getRegionMapping">
					<xsl:with-param name="selectedRegions" select="mappedCountries/DUIN/regions" />
				</xsl:call-template>
			</xsl:when>
				<xsl:otherwise>WW</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		
		<xsl:variable name="policyType">
					<xsl:choose>
				<xsl:when test="policyType = 'S'">SINGLE</xsl:when>
				<xsl:otherwise>AMT</xsl:otherwise>
					</xsl:choose>					
		</xsl:variable>
				

<!-- DATE CALCS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<xsl:variable name="today" select="SimpleDateFormat:format(SimpleDateFormat:new('dd/MM/yyyy'),Date:new())" />
		
		<xsl:variable name="thisYear">
			<xsl:value-of select="substring($today,7,4)" />
		</xsl:variable>
		
		<xsl:variable name="defaultYear">
			<xsl:value-of select="$thisYear - oldest"/>
		</xsl:variable>
		<xsl:variable name="adultDob">
			<xsl:value-of select="concat(substring($today,1,2), '/', substring($today,4,2), '/', $defaultYear)" />
		</xsl:variable>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<soap:Body>
		<QuoteRequest><Input>
				<policy_request>
					<policy_criteria>
						<policy_type><xsl:value-of select="$policyType"/></policy_type>
						<quote_date><xsl:value-of select="$today" /></quote_date>
						<policy_type_brief>TRAVEL</policy_type_brief>
						<product_type_brief>TRAVEL</product_type_brief>
						<quantity_adults><xsl:value-of select="adults"/></quantity_adults>
						<quantity_children><xsl:value-of select="children"/></quantity_children>
						<xsl:choose>
							<xsl:when test="policyType = 'S'">
								<cover_start_date><xsl:value-of select="dates/fromDate"/></cover_start_date>
								<cover_end_date><xsl:value-of select="dates/toDate"/></cover_end_date>
							</xsl:when>
							<xsl:otherwise>
								<cover_start_date><xsl:value-of select="$today"/></cover_start_date>
							</xsl:otherwise>
						</xsl:choose>
					</policy_criteria>
					<xsl:choose>
						<xsl:when test="policyType = 'S'">
							<regions>
								<region>
									<region_brief><xsl:value-of select="$region" /></region_brief>
								</region>
							</regions>
						</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
					<travellers>
						<traveller>
							<line_id>1</line_id>
							<type>ADULT</type>
							<dob><xsl:value-of select="$adultDob" /></dob>
						</traveller>
						<xsl:choose>
							<xsl:when test="adults = '2'">
							<traveller>
								<line_id>2</line_id>
								<type>ADULT</type>
								<dob><xsl:value-of select="$adultDob" /></dob>
							</traveller>
							</xsl:when>
						</xsl:choose>
					</travellers>
				</policy_request>
			</Input>
		</QuoteRequest>
	</soap:Body>
</soap:Envelope>
	</xsl:template>
</xsl:stylesheet>
