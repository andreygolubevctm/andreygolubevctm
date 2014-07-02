<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cal="java.util.GregorianCalendar" xmlns:sdf="java.text.SimpleDateFormat" xmlns:java="http://xml.apache.org/xslt/java" exclude-result-prefixes="java">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- xsl:import href="../includes/utils.xsl"/ -->

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="partnerReference" />
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

		<xsl:variable name="countryCode">
				<xsl:choose>
					<xsl:when test="policyType = 'S'">
					<!-- China -->
						<xsl:choose><xsl:when test="destinations/as/ch != ''"><countryCode>CHN</countryCode></xsl:when></xsl:choose>
						<!-- HongKong -->
						<xsl:choose><xsl:when test="destinations/as/hk != ''"><countryCode>HKG</countryCode></xsl:when></xsl:choose>
						<!-- Japan -->
						<xsl:choose><xsl:when test="destinations/as/jp != ''"><countryCode>JPN</countryCode></xsl:when></xsl:choose>
						<!-- South America -->
						<xsl:choose><xsl:when test="destinations/am/sa != ''"><countryCode>SA</countryCode></xsl:when></xsl:choose>
						<xsl:choose><xsl:when test="destinations/af/af != ''"><countryCode>AF</countryCode></xsl:when></xsl:choose>
						<xsl:choose><xsl:when test="destinations/am/us != ''"><countryCode>USA</countryCode></xsl:when></xsl:choose>
						<xsl:choose><xsl:when test="destinations/am/ca != ''"><countryCode>CAN</countryCode></xsl:when></xsl:choose>

						<xsl:choose>
							<xsl:when test="destinations/me/me != ''"><countryCode>WW</countryCode></xsl:when>
							<xsl:when test="destinations/do/do != ''"><countryCode>WW</countryCode></xsl:when>
						</xsl:choose>

						<!-- REGION 2 (EU) -->
						<xsl:choose><xsl:when test="destinations/eu/eu != ''"><countryCode>EU</countryCode></xsl:when></xsl:choose>
						<xsl:choose><xsl:when test="destinations/eu/uk != ''"><countryCode>GBR</countryCode></xsl:when></xsl:choose>

						<!-- REGION 3 (AS) -->
						<xsl:choose><xsl:when test="destinations/as/in != ''"><countryCode>IND</countryCode></xsl:when></xsl:choose>
						<xsl:choose><xsl:when test="destinations/as/th != ''"><countryCode>THA</countryCode></xsl:when></xsl:choose>

						<!-- REGION 4 (PA) -->
						<xsl:choose><xsl:when test="destinations/pa/ba != ''"><countryCode>BAL</countryCode></xsl:when></xsl:choose>
						<xsl:choose><xsl:when test="destinations/pa/in != ''"><countryCode>IDN</countryCode></xsl:when></xsl:choose>
						<xsl:choose><xsl:when test="destinations/pa/nz != ''"><countryCode>NZL</countryCode></xsl:when></xsl:choose>
						<xsl:choose><xsl:when test="destinations/pa/pi != ''"><countryCode>PC</countryCode></xsl:when></xsl:choose>

						<!-- REGION 5 (AU) -->
						<!-- Australia -->
						<xsl:choose><xsl:when test="destinations/au/au != ''"><countryCode>AUS</countryCode></xsl:when></xsl:choose>
					</xsl:when>
					<xsl:otherwise><countryCode>WW</countryCode></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="startDate">
			<xsl:choose>
				<xsl:when test="policyType = 'S'">
						<xsl:call-template name="util_isoDate">
								<xsl:with-param name="eurDate" select="dates/fromDate" />
							</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$today" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="endDate">
			<xsl:choose>
				<xsl:when test="policyType = 'S'">
						<xsl:call-template name="util_isoDate">
								<xsl:with-param name="eurDate" select="dates/toDate" />
							</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
						<!-- Used Java as a more reliable way of calculating dates
						http://docs.oracle.com/javase/7/docs/api/java/util/GregorianCalendar.html
						Printed YEAR in JSP file to get the number 1 which is the first parameter in the add() function
						Printed DAY_OF_MONTH in JSP file to get the number 5

						Did try calls like cal:get(cal:DAY_OF_MONTH) but it always returned 1 which is incorrect and also tried passing DAY_OF_MONTH to the add function with no success

						Formula is: today plus one year minus 1 day
						-->
						<xsl:variable name="today" select="cal:getInstance()"/>
						<xsl:variable name="yearPlus" select="cal:add(1, 1)"/> <!-- Year -->
						<xsl:variable name="dayMinus" select="cal:add(5, -1)"/> <!-- Day -->
					<xsl:value-of select="sdf:format(sdf:new('yyyy-MM-dd'),cal:getTime())" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- REQUEST DETAILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ <xsl:value-of select="java:format(sdf:new('yyyy-MMMM-dd'), cal:getTime($todayPlus))"/> -->
		<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" env:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
			<env:Header/>
			<env:Body>
				<ns2:request xmlns:ns2="https://ecommerce.disconline.com.au/services/schema/3.1/travel_quote">
					<header>
						<partnerId><xsl:value-of select="$partnerId" /></partnerId>
						<sourceId><xsl:value-of select="$sourceId" /></sourceId>
						<schemaVersion>3.1</schemaVersion>
						<partnerReference><xsl:value-of select="$partnerReference" /></partnerReference>
						<extension/>
						<clientIpAddress><xsl:value-of select="clientIpAddress" /></clientIpAddress>
					</header>
					<details>
						<destinations>
							<destination>
								<xsl:copy-of select="$countryCode" />
							</destination>
						</destinations>
						<travelDates>
							<departureDate><xsl:value-of select="$startDate" /></departureDate>
							<returnDate><xsl:value-of select="$endDate" /></returnDate>
						</travelDates>
						<travellers>
							<adultTravellers>
								<adultTraveller>
									<age><xsl:value-of select="oldest" /></age>
								</adultTraveller>
								<xsl:choose>
									<xsl:when test="adults = '2'">
										<adultTraveller>
											<age><xsl:value-of select="oldest" /></age>
										</adultTraveller>
									</xsl:when>
								</xsl:choose>
							</adultTravellers>
						</travellers>
					</details>
				</ns2:request>
			</env:Body>
		</env:Envelope>

	</xsl:template>

<!-- UTILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- ISO Date format -->
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