<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId">*NONE</xsl:param>
	<xsl:param name="defaultProductId"><xsl:value-of select="$productId" /></xsl:param>
	<xsl:param name="service"></xsl:param>
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<xsl:choose>
		<!-- ACCEPTABLE -->
		<xsl:when test="/results/result/premium">
			<xsl:apply-templates />
		</xsl:when>

		<!-- UNACCEPTABLE -->
		<xsl:otherwise>
			<results>
				<!--0 Results returned so no need to call 6 product variations
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-49</xsl:with-param>
				</xsl:call-template>
				-->
			</results>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/results">
		<results>

			<xsl:for-each select="result">

				<xsl:variable name="policyType">
					<xsl:choose>
						<!-- BARE ESSENTIALS -->
						<xsl:when test="@productId = 'TRAVEL-70'">1</xsl:when>

						<!-- SILVER -->
						<xsl:when test="@productId = 'TRAVEL-71'">2</xsl:when>

						<!-- GOLD -->
						<xsl:when test="@productId = 'TRAVEL-72'">3</xsl:when>

						<!-- ANNUAL MULTI TRIP GOLD 30 -->
						<xsl:when test="@productId = 'TRAVEL-73'">4</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-76'">4</xsl:when>

						<!-- ANNUAL MULTI TRIP GOLD 45 -->
						<xsl:when test="@productId = 'TRAVEL-74'">5</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-77'">5</xsl:when>

						<!-- ANNUAL MULTI TRIP GOLD 60 -->
						<xsl:when test="@productId = 'TRAVEL-75'">6</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-78'">6</xsl:when>

						<!-- DOMESTIC -->
						<xsl:when test="@productId = 'TRAVEL-79'">7</xsl:when>

						<!-- BARE ESSENTIALS + WINTER SPORTS -->
						<xsl:when test="@productId = 'TRAVEL-167'">8</xsl:when>

						<!-- SILVER + WINTER SPORTS -->
						<xsl:when test="@productId = 'TRAVEL-168'">9</xsl:when>

						<!-- GOLD + WINTER SPORTS -->
						<xsl:when test="@productId = 'TRAVEL-169'">10</xsl:when>

						<!-- ANNUAL MULTI TRIP GOLD 30 + WINTER SPORTS  -->
						<xsl:when test="@productId = 'TRAVEL-171'">11</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-174'">11</xsl:when>

						<!-- ANNUAL MULTI TRIP GOLD 45 + WINTER SPORTS -->
						<xsl:when test="@productId = 'TRAVEL-172'">12</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-175'">12</xsl:when>

						<!-- ANNUAL MULTI TRIP GOLD 60 + WINTER SPORTS -->
						<xsl:when test="@productId = 'TRAVEL-173'">13</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-176'">13</xsl:when>

						<!-- DOMESTIC + WINTER SPORTS -->
						<xsl:when test="@productId = 'TRAVEL-170'">14</xsl:when>

						<!-- OTHERS -->
						<xsl:otherwise >1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="destinationCode">
					<xsl:choose>
						<!-- WORLDWIDE* INCLUDING NORTH AND SOUTH AMERICA AND ANTARCTICA -->
						<xsl:when test="$request/travel/destinations/am/us">7</xsl:when>
						<xsl:when test="$request/travel/destinations/am/ca">7</xsl:when>
						<xsl:when test="$request/travel/destinations/am/sa">7</xsl:when>


						<!-- WORLDWIDE* EXCLUDING NORTH AND SOUTH AMERICA AND ANTARCTICA -->
						<xsl:when test="$request/travel/destinations/af/af">6</xsl:when>
						<xsl:when test="$request/travel/destinations/me/me">6</xsl:when>
						<xsl:when test="$request/travel/destinations/eu/eu">6</xsl:when>
						<xsl:when test="$request/travel/destinations/eu/uk">6</xsl:when>
						<xsl:when test="$request/travel/destinations/do/do">6</xsl:when>

						<!-- ASIA -->
						<xsl:when test="$request/travel/destinations/as/jp">9</xsl:when>
						<xsl:when test="$request/travel/destinations/as/ch">9</xsl:when>
						<xsl:when test="$request/travel/destinations/as/hk">9</xsl:when>
						<xsl:when test="$request/travel/destinations/as/in">9</xsl:when>
						<xsl:when test="$request/travel/destinations/as/th">9</xsl:when>
						<xsl:when test="$request/travel/destinations/pa/in">9</xsl:when>

						<!-- NEW ZEALAND, PACIFIC AND BALI -->
						<xsl:when test="$request/travel/destinations/pa/ba">5</xsl:when>
						<xsl:when test="$request/travel/destinations/pa/nz">5</xsl:when>
						<xsl:when test="$request/travel/destinations/pa/pi">5</xsl:when>

						<!-- DOMESTIC -->
						<xsl:when test="$request/travel/destinations/au/au">8</xsl:when>

						<xsl:otherwise>6</xsl:otherwise>
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
						<xsl:when test="$adults > 1">
							<xsl:value-of select="$request/travel/oldest" /><xsl:text>,</xsl:text><xsl:value-of select="$request/travel/oldest" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$request/travel/oldest" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="fromDate" select="$request/travel/dates/fromDate" />
				<xsl:variable name="toDate" select="$request/travel/dates/toDate" />
				<xsl:variable name="startDateFormatted"><xsl:value-of select="substring($fromDate,7,4)" /><xsl:value-of select="substring($fromDate,4,2)" /><xsl:value-of select="substring($fromDate,1,2)" /></xsl:variable>
				<xsl:variable name="endDateFormatted"><xsl:value-of select="substring($toDate,7,4)" /><xsl:value-of select="substring($toDate,4,2)" /><xsl:value-of select="substring($toDate,1,2)" /></xsl:variable>

				<xsl:variable name="domestic">
					<xsl:choose>
						<xsl:when test="count($request/travel/destinations/*) = 1 and $request/travel/destinations/au/au">Yes</xsl:when>
						<xsl:otherwise>No</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:element name="price">
					<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
					<xsl:attribute name="productId">
						<xsl:choose>
							<xsl:when test="$productId != '*NONE'"><xsl:value-of select="$productId" /></xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$service" />-<xsl:value-of select="@productId" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>

					<available>Y</available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>
					<provider><xsl:value-of select="provider"/></provider>
					<trackCode>22</trackCode>
					<name><xsl:value-of select="name"/></name>
					<des><xsl:value-of select="des"/></des>
					<price><xsl:value-of select="format-number(premium,'#.00')"/></price>
					<priceText><xsl:value-of select="premiumText"/></priceText>

					<info>
						<xsl:for-each select="productInfo">
							<xsl:choose>
							<xsl:when test="@propertyId = 'subTitle'"></xsl:when>
							<xsl:when test="@propertyId = 'infoDes'"></xsl:when>
							<xsl:when test="@propertyId = 'medical' and $domestic = 'Yes'">
								<xsl:element name="{@propertyId}">
									<label>Overseas Medical</label><desc>Overseas Emergency Medical and Hospital Expenses</desc><value>0</value><text>N/A</text><order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'medicalAssi' and $domestic = 'Yes'">
								<xsl:element name="{@propertyId}">
									<label>Overseas Medical Assistance</label><desc>Overseas Emergency Medical Assistance</desc><value>0</value><text>N/A</text><order/>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:element name="{@propertyId}">
									<xsl:copy-of select="*"/>
								</xsl:element>
							</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</info>

					<infoDes>
						<xsl:value-of select="productInfo[@propertyId='infoDes']/text" />
					</infoDes>
					<subTitle>
						<xsl:if test="$request/travel/adults = '2' and $request/travel/children = '0'">
							<xsl:value-of select="productInfo[@propertyId='subTitle']/text"/>
						</xsl:if>
					</subTitle>

					<acn>000 000 000</acn>
					<afsLicenceNo>00000</afsLicenceNo>

					<quoteUrl>http://quote.insureandgo.com.au/?affid=256%26utm_source=comparethemarket%26utm_medium=referral%26utm_campaign=affiliate%26policyTypeID=<xsl:value-of select="$policyType" />%26destinationCode=<xsl:value-of select="$destinationCode" />%26leaveDate=<xsl:value-of select="$startDateFormatted" />%26returnDate=<xsl:value-of select="$endDateFormatted" />%26numberofAdults=<xsl:value-of select="$adults" />%26numberofChildren=<xsl:value-of select="$children" />%26adultAges=<xsl:value-of select="$ages" /></quoteUrl>
				</xsl:element>
			</xsl:for-each>

		</results>
	</xsl:template>


	<!-- UNAVAILABLE PRICE -->
	<xsl:template name="unavailable">
		<xsl:param name="productId" />

		<xsl:element name="price">
			<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
			<xsl:attribute name="productId"><xsl:value-of select="$service" />-<xsl:value-of select="$productId" /></xsl:attribute>

			<available>N</available>
			<transactionId><xsl:value-of select="$transactionId"/></transactionId>
			<xsl:choose>
				<xsl:when test="error">
					<xsl:copy-of select="error"></xsl:copy-of>
				</xsl:when>
				<xsl:otherwise>
					<error service="{$service}" type="unavailable">
						<code></code>
						<message>unavailable</message>
						<data></data>
					</error>
				</xsl:otherwise>
			</xsl:choose>
			<name></name>
			<des></des>
			<info></info>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>