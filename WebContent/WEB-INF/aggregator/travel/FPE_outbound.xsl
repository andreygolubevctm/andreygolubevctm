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
		<!--
			If more than 1 region selected - default to WW
			If user selected Africa - default to WW
			Else - substitute the region code
		-->
		<xsl:variable name="region">
			<xsl:choose>
				<!-- REGION 1 (WW) -->
				<xsl:when test="destinations/af/af !='' ">WORLD</xsl:when>
				<xsl:when test="destinations/am/us !='' ">WORLD</xsl:when>
				<xsl:when test="destinations/am/ca !='' ">WORLD</xsl:when>
				<xsl:when test="destinations/am/sa !='' ">WORLD</xsl:when>

				<!-- China -->
				<xsl:when test="destinations/as/ch !='' ">WORLD</xsl:when>

				<!-- HongKong -->
				<xsl:when test="destinations/as/hk !='' ">WORLD</xsl:when>

				<!-- Japan -->
				<xsl:when test="destinations/as/jp !='' ">WORLD</xsl:when>

				<!-- Middle East -->
				<xsl:when test="destinations/me/me !='' ">WORLD</xsl:when>

				<!-- Any other country -->
				<xsl:when test="destinations/do/do !='' ">WORLD</xsl:when>

				<!-- REGION 2 (EA Europe & Asia) -->
				<!-- India -->
				<xsl:when test="destinations/as/in !='' ">EUROP</xsl:when>

				<!-- Thailand -->
				<xsl:when test="destinations/as/th !='' ">EUROP</xsl:when>
				<xsl:when test="destinations/pa/in !='' ">EUROP</xsl:when>
				<xsl:when test="destinations/eu !='' ">EUROP</xsl:when>


				<!-- REGION 3 (PA) -->
				<xsl:when test="destinations/pa/ba !='' ">PACIF</xsl:when>
				<xsl:when test="destinations/pa/pi !='' ">PACIF</xsl:when>
				<xsl:when test="destinations/pa/nz !='' ">PACIF</xsl:when>

				<!-- REGION 4 (AU) -->
				<!-- Australia -->
				<xsl:when test="destinations/au/au !='' ">AUS</xsl:when>

				<!-- Default to REGION 1 (WW) -->
				<xsl:otherwise>WORLD</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="thisYear">
			<xsl:value-of select="substring($today,1,4)" />
		</xsl:variable>

		<xsl:variable name="defaultYear">
			<xsl:value-of select="$thisYear - oldest"/>
		</xsl:variable>

		<xsl:variable name="childYear">
			<xsl:value-of select="$thisYear - 18"/>
		</xsl:variable>

		<xsl:variable name="defaultDob">
			<xsl:value-of select="concat(substring($today,9,2),'/',substring($today,6,2),'/',$defaultYear)" />
		</xsl:variable>

		<xsl:variable name="childDob">
			<xsl:value-of select="concat(substring($today,9,2),'/',substring($today,6,2),'/',$childYear)" />
		</xsl:variable>

		<xsl:variable name="startDate">
			<xsl:choose>
				<xsl:when test="policyType = 'A'">
					<xsl:value-of select="concat(substring($today,9,2),'/',substring($today,6,2),'/',substring($today,1,4))" />
					</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="dates/fromDate" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="endDate">
			<xsl:choose>
				<xsl:when test="policyType = 'A'">
					<xsl:value-of select="concat(substring($today,9,2)-1,'/',substring($today,6,2),'/',substring($today,1,4)+1)" />
					</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="dates/fromDate" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>



<FpeQuoteRequest>
	<CallingProcessBrief />
	<ClientId>1154</ClientId>
	<Input>
		<policy_request>
			<policy_criteria>
				<pricing_type_brief>QUICK</pricing_type_brief>
				<sale_type_brief>NEW</sale_type_brief>
				<quote_date>
					<xsl:value-of
						select="concat(substring($today,9,2),'/',substring($today,6,2),'/',substring($today,1,4))" />
				</quote_date>
				<policy_type_brief>TRAVL</policy_type_brief>
				<product_type_brief>TVRTL</product_type_brief>
				<program_id />
				<program_brand_id />
				<input_source_brief>B2CWS</input_source_brief>
				<quantity_adults>
					<xsl:value-of select="adults" />
				</quantity_adults>
				<quantity_children>
					<xsl:value-of select="children" />
				</quantity_children>
				<standard_excess>0</standard_excess>
				<cover_start_date>
					<xsl:value-of select="$startDate" />
				</cover_start_date>
				<cover_end_date>
					<xsl:value-of select="$endDate" />
				</cover_end_date>
			</policy_criteria>
			<single_inputs />
			<regions>
				<region>
					<region_brief><xsl:value-of select="$region" /></region_brief>
					<days_exposed />
					<country_code />
				</region>
			</regions>
			<travellers>
				<traveller>
					<line_id>1</line_id>
					<type>ADULT</type>
					<dob>
						<xsl:value-of select="$defaultDob" />
					</dob>
				</traveller>
				<xsl:if test="adults &gt; 1">
					<traveller>
						<line_id>2</line_id>
						<type>ADULT</type>
						<dob>
							<xsl:value-of select="$defaultDob" />
						</dob>
					</traveller>
				</xsl:if>
				<xsl:if test="children &gt; 0">
					<traveller>
						<line_id>
							<xsl:value-of select="adults + 1" />
						</line_id>
						<type>CHILD</type>
						<dob>
							<xsl:value-of select="$childDob" />
						</dob>
					</traveller>
				</xsl:if>
				<xsl:if test="children &gt; 1">
					<traveller>
						<line_id>
							<xsl:value-of select="adults + 2" />
						</line_id>
						<type>CHILD</type>
						<dob>
							<xsl:value-of select="$childDob" />
						</dob>
					</traveller>
				</xsl:if>
				<xsl:if test="children &gt; 2">
					<traveller>
						<line_id>
							<xsl:value-of select="adults + 3" />
						</line_id>
						<type>CHILD</type>
						<dob>
							<xsl:value-of select="$childDob" />
						</dob>
					</traveller>
				</xsl:if>
				<xsl:if test="children &gt; 3">
					<traveller>
						<line_id>
							<xsl:value-of select="adults + 4" />
						</line_id>
						<type>CHILD</type>
						<dob>
							<xsl:value-of select="$childDob" />
						</dob>
					</traveller>
				</xsl:if>
				<xsl:if test="children &gt; 4">
					<traveller>
						<line_id>
							<xsl:value-of select="adults + 5" />
						</line_id>
						<type>CHILD</type>
						<dob>
							<xsl:value-of select="$childDob" />
						</dob>
					</traveller>
				</xsl:if>
				<xsl:if test="children &gt; 5">
					<traveller>
						<line_id>
							<xsl:value-of select="adults + 6" />
						</line_id>
						<type>CHILD</type>
						<dob>
							<xsl:value-of select="$childDob" />
						</dob>
					</traveller>
				</xsl:if>
				<xsl:if test="children &gt; 6">
					<traveller>
						<line_id>
							<xsl:value-of select="adults + 7" />
						</line_id>
						<type>CHILD</type>
						<dob>
							<xsl:value-of select="$childDob" />
						</dob>
					</traveller>
				</xsl:if>
				<xsl:if test="children &gt; 7">
					<traveller>
						<line_id>
							<xsl:value-of select="adults + 8" />
						</line_id>
						<type>CHILD</type>
						<dob>
							<xsl:value-of select="$childDob" />
						</dob>
					</traveller>
				</xsl:if>
				<xsl:if test="children &gt; 8">
					<traveller>
						<line_id>
							<xsl:value-of select="adults + 9" />
						</line_id>
						<type>CHILD</type>
						<dob>
							<xsl:value-of select="$childDob" />
						</dob>
					</traveller>
				</xsl:if>
				<xsl:if test="children &gt; 9">
					<traveller>
						<line_id>
							<xsl:value-of select="adults + 10" />
						</line_id>
						<type>CHILD</type>
						<dob>
							<xsl:value-of select="$childDob" />
						</dob>
					</traveller>
				</xsl:if>
			</travellers>
			<benefits>
				<benefit>
					<benefit_type_brief>CANX</benefit_type_brief>
					<cover_amount>1000</cover_amount>
					<description />
					<line_id />
				</benefit>
			</benefits>
		</policy_request>
	</Input>
</FpeQuoteRequest>
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