<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cal="java.util.GregorianCalendar" xmlns:sdf="java.text.SimpleDateFormat">

	<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/date_functions.xsl" />
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
						<xsl:with-param name="selectedRegions" select="mappedCountries/FAST/regions" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>R1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

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

		<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
			<soap:Body>
				<QuoteRequest>
					<ClientId>ctm/P@ssW0rd1</ClientId>
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
									<region_brief><xsl:value-of select="$region" /></region_brief>
									<country_code><xsl:value-of select="$region" /></country_code>
								</region>
							</regions>
							<travellers>
								<traveller>
									<line_id>1</line_id>
									<type>ADULT</type>
									<age><xsl:value-of select="oldest" /></age>
								</traveller>
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
											<xsl:with-param name="i">1</xsl:with-param>
											<xsl:with-param name="index">2</xsl:with-param>
											<xsl:with-param name="count" select="children" />
										</xsl:call-template>
									</xsl:when>
								</xsl:choose>
							</travellers>
						</policy_request>
					</Input>
				</QuoteRequest>
			</soap:Body>
		</soap:Envelope>

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

	<!-- Had to put the printChildren function in here as a custom version (to avoid affecting Tick) as Fast cover actually counts the line id which is throwing off handover.
	Issue: Even though we'll send 2 children, the way the id's were set and how Fast cover uses them causes them to return 3 children for the handover url which increases for every child a customer adds.
	Fix: The fix below increments the line_id by having a starting value of 2.

	If we were to use adults as the starting value, for some reason selecting 1 adult causes the exact same issue as the line ids would be:
	criteria: 1 adult, 2 children
	result: line_id 1, line_id 2, line_id 3

	Applying the fix above now does this
	criteria: 1 adult, 2 children
	result: line_id 1, line_id 3, line_id 4

	It seems they've reserved line_id 2 for a second adult. Adding a second adult works as expected on handover
	-->
	<xsl:template name="printChildren">
		<xsl:param name="i" />
		<xsl:param name="index" />
		<xsl:param name="count" />

		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<traveller>
				<line_id><xsl:value-of select="$i + $index"/></line_id>
				<type>CHILD</type>
				<age>18</age>
			</traveller>

			<xsl:call-template name="printChildren">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="index" select="$index" />
				<xsl:with-param name="count" select="$count" />
			</xsl:call-template>
		</xsl:if>

	</xsl:template>
</xsl:stylesheet>