<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/date_functions.xsl" />

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="today" />
	<xsl:param name="username" />
	<xsl:param name="password" />
	<xsl:param name="request" />
	<xsl:param name="agentCode" />

<!-- KEYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/travel">

<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<xsl:variable name="currency" >AUD</xsl:variable>
		<xsl:variable name="countryOfResidence">AUS</xsl:variable>

		<xsl:variable name="areaCode">
			<xsl:choose>
				<!-- WORLDWIDE -->
				<xsl:when test="destinations/am/us">L</xsl:when>
				<xsl:when test="destinations/am/ca">L</xsl:when>
				<xsl:when test="destinations/do/do">L</xsl:when>
				<xsl:when test="destinations/me/me">L</xsl:when>

				<!-- AFRICA -->

				<xsl:when test="destinations/af/af">I</xsl:when>
				<!-- SOUTH AMERICA -->
				<xsl:when test="destinations/am/sa">F</xsl:when>

				<!-- EUROPE -->
				<xsl:when test="destinations/eu/eu">J</xsl:when>
				<xsl:when test="destinations/eu/uk">J</xsl:when>


				<!-- ASIA -->
				<xsl:when test="destinations/as/in">H</xsl:when>
				<xsl:when test="destinations/pa/in">H</xsl:when>
				<xsl:when test="destinations/as/th">H</xsl:when>
				<xsl:when test="destinations/as/jp">H</xsl:when>
				<xsl:when test="destinations/as/ch">H</xsl:when>
				<xsl:when test="destinations/as/hk">H</xsl:when>
				<xsl:when test="destinations/pa/nz">H</xsl:when>
				<xsl:when test="destinations/pa/pi">H</xsl:when>
				<xsl:when test="destinations/pa/ba">H</xsl:when>

				<!-- DOMESTIC -->
				<xsl:when test="destinations/au/au">A</xsl:when>

				<!-- Default to WORLDWIDE -->
				<xsl:otherwise>L</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- FROM XSLX DOCUMENTATION START -->
		<xsl:variable name="sourceCode">CTM001</xsl:variable>

		<xsl:variable name="isDomestic">
			<xsl:choose>
				<xsl:when test="$areaCode = 'A'">Y</xsl:when>
				<xsl:otherwise>N</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="productSetStandard">
			<xsl:value-of select="$agentCode" />
			<xsl:choose>
				<xsl:when test="policyType = 'S' and $isDomestic = 'Y'">SDS</xsl:when>
				<xsl:when test="policyType = 'S' and $isDomestic = 'N'">STS</xsl:when>
				<xsl:otherwise>MTS</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="productSetPremium">
			<xsl:value-of select="$agentCode" />
			<xsl:choose>
				<xsl:when test="policyType = 'S' and $isDomestic = 'Y'">SDP</xsl:when>
				<xsl:when test="policyType = 'S' and $isDomestic = 'N'">STP</xsl:when>
				<xsl:otherwise>MTP</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="groupType">
			<xsl:choose>
				<xsl:when test="adults != '0' and children != '0' and children &lt;= '3'">FAM</xsl:when>
				<xsl:when test="adults = '2'and children = '0'">CPL</xsl:when>
				<xsl:when test="adults = '1' and children = '0'">IND</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!-- FROM XSLX DOCUMENTATION END -->

		<xsl:variable name="startDate">
			<xsl:choose>
				<xsl:when test="policyType = 'S'">
						<xsl:value-of select="dates/fromDate" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat(substring($today,9,2), '/', substring($today,6,2), '/', substring($today,1,4))" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- DOB CALCULATION START -->
		<xsl:variable name="thisYear">
			<xsl:value-of select="substring($today,1,4)" />
		</xsl:variable>

		<xsl:variable name="defaultYear">
			<xsl:value-of select="$thisYear - oldest"/>
		</xsl:variable>
		<xsl:variable name="adultDob">
			<xsl:value-of select="concat(substring($today,9,2), '/', substring($today,6,2), '/', $defaultYear)" />
		</xsl:variable>

		<xsl:variable name="duration">
			<xsl:choose>
				<xsl:when test="policyType = 'S'">
					<xsl:value-of select="soapDuration" />
				</xsl:when>
				<xsl:otherwise>60</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Default to 18 years old as per partner's request -->
		<xsl:variable name="childDOB">
			<xsl:call-template name="formatDate">
				<xsl:with-param name="today" select="$today" />
				<xsl:with-param name="oldest" select="'18'" />
				<xsl:with-param name="seperator" select="'/'" />
				<xsl:with-param name="dateFormat" select="'ddmmYYYY'" />
			</xsl:call-template>
		</xsl:variable>

		<!-- DOB CALCULATION END -->

		<!--
			If more than 1 region selected - default to WW
			If user selected Africa - default to WW
			Else - substitute the region code
		-->

		<xmlRequest>
			<requestType>quote</requestType>
			<locale>en_AU</locale>
			<userInformation>
				<userID><xsl:value-of select="$username" /></userID>
				<userPWD><xsl:value-of select="$password" /></userPWD>
			</userInformation>
			<policyInformation ID="standard_product">
				<getPolicySummary>Y</getPolicySummary>
				<currency><xsl:value-of select="$currency" /></currency>
				<countryOfResidence><xsl:value-of select="$countryOfResidence" /></countryOfResidence>
				<groupType><xsl:value-of select="$groupType" /></groupType>
				<areaCode><xsl:value-of select="$areaCode" /></areaCode>
				<agentCode><xsl:value-of select="$agentCode" /></agentCode>
				<sourceCode><xsl:value-of select="$sourceCode" /></sourceCode>
				<productSet><xsl:value-of select="$productSetStandard" /></productSet>
				<startDate><xsl:value-of select="$startDate" /></startDate>
				<duration><xsl:value-of select="$duration" /></duration>
			</policyInformation>
			<policyInformation ID="premier_product">
				<getPolicySummary>Y</getPolicySummary>
				<currency><xsl:value-of select="$currency" /></currency>
				<countryOfResidence><xsl:value-of select="$countryOfResidence" /></countryOfResidence>
				<groupType><xsl:value-of select="$groupType" /></groupType>
				<areaCode><xsl:value-of select="$areaCode" /></areaCode>
				<agentCode><xsl:value-of select="$agentCode" /></agentCode>
				<sourceCode><xsl:value-of select="$sourceCode" /></sourceCode>
				<productSet><xsl:value-of select="$productSetPremium" /></productSet>
				<startDate><xsl:value-of select="$startDate" /></startDate>
				<duration><xsl:value-of select="$duration" /></duration>
			</policyInformation>
			<partyMembers>
				<partyMember id="1">
					<dob fte="n"><xsl:value-of select="$adultDob" /></dob>
				</partyMember>
				<xsl:choose>
					<xsl:when test="adults = 2">
						<partyMember id="2">
							<dob fte="n"><xsl:value-of select="$adultDob" /></dob>
						</partyMember>
					</xsl:when>
				</xsl:choose>

				<xsl:choose>
					<xsl:when test="children != 0">
						<xsl:variable name="start">
							<xsl:value-of select="adults" />
						</xsl:variable>
						<xsl:variable name="end">
							<xsl:value-of select="adults + children" />
						</xsl:variable>
						<xsl:call-template name="getChildMembers">
							<xsl:with-param name="start" select="$start" />
							<xsl:with-param name="end" select="$end" />
							<xsl:with-param name="dob" select="$childDOB" />
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>

			</partyMembers>
		</xmlRequest>

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

	<xsl:template name="getChildMembers">
		<xsl:param name="start" />
		<xsl:param name="end" />
		<xsl:param name="dob" />

		<xsl:if test="not($start = $end)">
			<xsl:element name="partyMember">
				<xsl:attribute name="id"><xsl:value-of select="$start + 1" /></xsl:attribute>
				<dob fte="n"><xsl:value-of select="$dob" /></dob>
			</xsl:element>
			<xsl:call-template name="getChildMembers">
				<xsl:with-param name="start" select="$start + 1" />
				<xsl:with-param name="end" select="$end" />
				<xsl:with-param name="dob" select="$dob" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
