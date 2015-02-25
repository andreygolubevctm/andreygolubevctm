<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soap">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="includes/product_info.xsl"/>
	<xsl:import href="utilities/unavailable.xsl" />

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId">*NONE</xsl:param>
	<xsl:param name="defaultProductId"><xsl:value-of select="$productId" /></xsl:param>
	<xsl:param name="service">DUIN</xsl:param>
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />


<!-- MAIN TEMPLATE and ERRORS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<xsl:choose>
		<!-- ACCEPTABLE -->
			<xsl:when test="/soap:Envelope/soap:Body/policy_response/calculated_multi_values/bulk_premiums/bulk_premium">
				<xsl:apply-templates select="/soap:Envelope/soap:Body/policy_response" />
		</xsl:when>

		<!-- UNACCEPTABLE -->
		<xsl:otherwise>
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-49</xsl:with-param>
				</xsl:call-template>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/soap:Envelope/soap:Body/policy_response">
		<results>

			<xsl:for-each select="calculated_multi_values/bulk_premiums/bulk_premium">
				<xsl:variable name="destinationCode">
					<xsl:choose>
						<xsl:when test="$request/travel/destinations/am/us">Area3</xsl:when>
						<xsl:when test="$request/travel/destinations/am/ca">Area3</xsl:when>
						<xsl:when test="$request/travel/destinations/am/sa">Area3</xsl:when>
						<xsl:when test="$request/travel/destinations/as/jp">Area3</xsl:when>
						<xsl:when test="$request/travel/destinations/do/do">Area3</xsl:when>

						<xsl:when test="$request/travel/destinations/af/af">Area2</xsl:when>
						<xsl:when test="$request/travel/destinations/eu/eu">Area2</xsl:when>
						<xsl:when test="$request/travel/destinations/eu/uk">Area2</xsl:when>
						<xsl:when test="$request/travel/destinations/as/ch">Area2</xsl:when>
						<xsl:when test="$request/travel/destinations/as/hk">Area2</xsl:when>
						<xsl:when test="$request/travel/destinations/as/in">Area2</xsl:when>
						<xsl:when test="$request/travel/destinations/as/th">Area2</xsl:when>
						<xsl:when test="$request/travel/destinations/me/me">Area2</xsl:when>
						<xsl:when test="$request/travel/destinations/pa/in">Area2</xsl:when>

						<xsl:when test="$request/travel/destinations/pa/ba">Area1</xsl:when>
						<xsl:when test="$request/travel/destinations/pa/nz">Area1</xsl:when>
						<xsl:when test="$request/travel/destinations/pa/pi">Area1</xsl:when>

						<xsl:when test="$request/travel/destinations/au/au">Domestic</xsl:when>

						<xsl:otherwise>Area3</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="adults" select="$request/travel/adults" />
				<xsl:variable name="children">
					<xsl:choose>
						<xsl:when test="$request/travel/children"><xsl:value-of select="$request/travel/children" /></xsl:when>
						<xsl:otherwise >0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="ages">
					<xsl:choose>
						<xsl:when test="$adults = '2'">
							<xsl:value-of select="$request/travel/oldest" />,<xsl:value-of select="$request/travel/oldest" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$request/travel/oldest" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="fromDate" select="$request/travel/dates/fromDate" />
				<xsl:variable name="toDate" select="$request/travel/dates/toDate" />

				<xsl:variable name="domestic">
					<xsl:choose>
						<xsl:when test="count($request/travel/destinations/*) = 1 and $request/travel/destinations/au/au">Yes</xsl:when>
						<xsl:otherwise>No</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- lc = lower case  -->
				<xsl:variable name="lcPlanId">
					<xsl:value-of select="translate(plan_id, $uppercase, $smallcase)" />
				</xsl:variable>

				<xsl:variable name="newProductId">
						<xsl:choose>
							<xsl:when test="$lcPlanId = 'backpacker'">DUIN-TRAVEL-50</xsl:when> <!-- Plan C - Backpackers International -->
							<xsl:when test="$lcPlanId = 'aftl'">DUIN-TRAVEL-51</xsl:when> <!-- Plan D - Frequent Traveller (Leisure) -->
							<xsl:when test="$lcPlanId = 'aftb'">DUIN-TRAVEL-52</xsl:when> <!-- Plan E - Frequent Traveller (Business) -->
							<xsl:when test="$lcPlanId = 'comprehensive_ski'">DUIN-TRAVEL-53</xsl:when>	<!-- Comprehensive Snow Cover -->
							<xsl:when test="$lcPlanId = 'comprehensivedom'">DUIN-TRAVEL-54</xsl:when>	<!-- Plan B - Comprehensive Australia Only -->
							<xsl:when test="$lcPlanId = 'comprehensivedom_ski'">DUIN-TRAVEL-55</xsl:when>	<!-- Comprehensive Snow Cover -->
							<xsl:otherwise>DUIN-TRAVEL-49</xsl:otherwise><!-- Plan A - Comprehensive International. Done so that if a new product is slipped in, it won't prevent results from returning-->
						</xsl:choose>
				</xsl:variable>
				<xsl:variable name="formattedTodayDate">
					<xsl:value-of select="substring($today,9,2)" />/<xsl:value-of select="substring($today,6,2)" />/<xsl:value-of select="substring($today,1,4)" />
				</xsl:variable>

				<xsl:variable name="planID">
					<xsl:choose>
							<xsl:when test="$lcPlanId = 'aftl'">Plan D - Annual Frequent Traveller (Leisure) (37 days)</xsl:when>
							<xsl:when test="$lcPlanId = 'aftb'">Plan E - Annual Frequent Traveller (Business) (90 days)</xsl:when>
							<xsl:otherwise><xsl:value-of select="plan_id"/></xsl:otherwise>
						</xsl:choose>
				</xsl:variable>
				<xsl:variable name="planName">
					<xsl:choose>
							<xsl:when test="$lcPlanId = 'aftl'">Plan D - Annual Frequent Traveller &lt;br /&gt;(Leisure) &lt;span class=&quot;daysPerTrip&quot;&gt;(37 days)&lt;/span&gt;</xsl:when>
							<xsl:when test="$lcPlanId = 'aftb'">Plan E - Annual Frequent Traveller &lt;br /&gt;(Business) &lt;span class=&quot;daysPerTrip&quot;&gt;(90 days)&lt;/span&gt;</xsl:when>
							<xsl:otherwise><xsl:value-of select="plan_name"/></xsl:otherwise>
						</xsl:choose>
				</xsl:variable>

<!-- INBOUND XSL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
				<xsl:element name="price">
					<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
					<xsl:attribute name="productId"><xsl:value-of select="$newProductId" /></xsl:attribute>
					<available>Y</available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>
					<provider><xsl:value-of select="$service"/></provider>
					<trackCode>8</trackCode>
					<name><xsl:value-of select="$planID"/></name>
					<des><xsl:value-of select="$planName"/></des>
					<price><xsl:value-of select="format-number(premium,'#.00')"/></price>
					<priceText>$<xsl:value-of select="format-number(premium,'#.00')"/></priceText>
					<xsl:call-template name="productInfo">
							<xsl:with-param name="productId" select="$newProductId" />
					</xsl:call-template>
					<infoDes>Specialising in offering online travel insurance to
						Australians, DUinsure offer well priced insurance worldwide for
						anyone aged 65 years and under, on all types of trips of up to 12
						months duration (with the possibility of extension out to 2 years in
						total). DUinsure policies are also attractive to those planning to
						work whilst overseas, as they cover work and activities whilst
						abroad at no additional premium.
					</infoDes>
					<subTitle>http://www.duinsure.com.au/sites/duinsureaus.nsf/images/pdf/$file/pw.pdf</subTitle>
					<acn>000 000 000</acn>
					<afsLicenceNo>00000</afsLicenceNo>
<!-- QUOTE URL ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
					<quoteUrl>
						<xsl:choose>
							<xsl:when test="cover_type = 'AMT'">
								<xsl:text>http://www.duinsure.com.au/sites/duinsureaus.nsf/quote1?open%26policyTypeId=</xsl:text>
								<xsl:value-of select="plan_id" />
								<xsl:text>%26startDate=</xsl:text>
								<xsl:value-of select="$formattedTodayDate" />
								<xsl:text>%26affID=ctm1</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>http://www.duinsure.com.au/sites/duinsureaus.nsf/quote1?open%26policyTypeId=</xsl:text>
								<xsl:value-of select="cover_type" />
								<xsl:text>%26destinationCode=</xsl:text>
								<xsl:value-of select="$destinationCode" />
								<xsl:text>%26startDate=</xsl:text>
								<xsl:value-of select="translate($fromDate, '/', '-')" />
								<xsl:text>%26endDate=</xsl:text>
								<xsl:value-of select="translate($toDate, '/', '-')" />
								<xsl:text>%26numberOfAdults=</xsl:text>
								<xsl:value-of select="$adults" />
								<xsl:text>%26numberOfChildren=</xsl:text>
								<xsl:value-of select="$children" />
								<xsl:text>%26adultAges=</xsl:text>
								<xsl:value-of select="$ages" />
								<xsl:text>%26affID=ctm1</xsl:text>
								<xsl:if test="$newProductId = 'DUIN-TRAVEL-53' or $newProductId = 'DUIN-TRAVEL-55'"> <!-- The Ski products -->
									<xsl:text>%26ski=true</xsl:text>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</quoteUrl>
				</xsl:element>
			</xsl:for-each>
		</results>
	</xsl:template>
</xsl:stylesheet>