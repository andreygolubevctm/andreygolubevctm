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
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-198</xsl:with-param>
				</xsl:call-template>
			</results>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/results">
		<results>

			<xsl:for-each select="result">
				<xsl:variable name="policyTypeId">
					<xsl:choose>
						<xsl:when test="@productId = 'TRAVEL-198'">1</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-199'">2</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-200'">3</xsl:when>
						<xsl:otherwise>4</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="destinationCode">
					<xsl:choose>
						<!-- Worldwide -->
						<xsl:when test="$request/travel/destinations/af/af">WORLD</xsl:when>
						<xsl:when test="$request/travel/destinations/am/ca">WORLD</xsl:when>
						<xsl:when test="$request/travel/destinations/as/jp">WORLD</xsl:when>
						<xsl:when test="$request/travel/destinations/me/me">WORLD</xsl:when>
						<xsl:when test="$request/travel/destinations/do/do">WORLD</xsl:when>

						<!-- USA, South & Central America -->
						<xsl:when test="$request/travel/destinations/am/us">USASC</xsl:when>
						<xsl:when test="$request/travel/destinations/am/sa">USASC</xsl:when>

						<!-- Europe/UK -->
						<xsl:when test="$request/travel/destinations/eu/eu">EURUK</xsl:when>
						<xsl:when test="$request/travel/destinations/eu/uk">EURUK</xsl:when>

						<!-- Asia, Excluding Japan -->
						<xsl:when test="$request/travel/destinations/as/ch">ASNJP</xsl:when>
						<xsl:when test="$request/travel/destinations/as/hk">ASNJP</xsl:when>
						<xsl:when test="$request/travel/destinations/as/in">ASNJP</xsl:when>
						<xsl:when test="$request/travel/destinations/as/th">ASNJP</xsl:when>

						<!-- Pacific Islands & Bali -->
						<xsl:when test="$request/travel/destinations/pa/in">PACBL</xsl:when>
						<xsl:when test="$request/travel/destinations/pa/pi">PACBL</xsl:when>
						<xsl:when test="$request/travel/destinations/pa/ba">PACBL</xsl:when>

						<!-- New Zealand -->
						<xsl:when test="$request/travel/destinations/pa/nz">NZL</xsl:when>

						<!-- Australia -->
						<xsl:when test="$request/travel/destinations/au/au">AUS</xsl:when>

						<!-- Multi-trip -->
						<xsl:when test="@productId = 'TRAVEL-201'">WORLD</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-202'">NZL</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-203'">AUS</xsl:when>

						<xsl:otherwise>WORLD</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="fromDate" select="$request/travel/dates/fromDate" />
				<xsl:variable name="toDate" select="$request/travel/dates/toDate" />

				<xsl:variable name="adults" select="$request/travel/adults" />
				<xsl:variable name="children">
					<xsl:choose>
						<xsl:when test="$request/travel/children"><xsl:value-of select="$request/travel/children" /></xsl:when>
						<xsl:otherwise >0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

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
					<trackCode>31</trackCode>
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
									<label>Overseas Medical</label>
									<desc>Overseas Medical</desc>
									<value>0</value>
									<text>N/A</text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'medicalAssi' and $domestic = 'Yes'">
								<xsl:element name="{@propertyId}">
									<label>Overseas Medical Assistance</label>
									<desc>Overseas Emergency Medical Assistance</desc>
									<value>0</value>
									<text>N/A</text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'medical' and $policyTypeId = 3">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Overseas Emergency Medical and Hospital Expenses</desc>
									<value>0</value>
									<text>Unlimited</text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'medical' and $adults = 2 and $children &gt; 0 and text != 'Unlimited'">
								<xsl:variable name="newValue" select="value*2"/>
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Overseas Emergency Medical and Hospital Expenses</desc>
									<value><xsl:value-of select="$newValue" /></value>
									<text><xsl:value-of select='format-number($newValue, "$###,###.##")' /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'medical'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Overseas Emergency Medical and Hospital Expenses</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'luggage' and $request/travel/policyType = 'A' ">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Luggage and Personal Effects - No Depreciation</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
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
						<xsl:value-of select="productInfo[@propertyId='subTitle']/text"/>
					</subTitle>

					<acn>000 000 000</acn>
					<afsLicenceNo>00000</afsLicenceNo>
					<quoteUrl>
						<xsl:text>https://www.webjet.com.au/insurance?policyTypeId=</xsl:text>
						<xsl:value-of select="$policyTypeId" />
						<xsl:text>%26destinationCode=</xsl:text>
						<xsl:value-of select="$destinationCode" />
						<xsl:text>%26startDate=</xsl:text>
						<xsl:value-of select="$fromDate" />
						<xsl:text>%26endDate=</xsl:text>
						<xsl:value-of select="$toDate" />
						<xsl:text>%26numberOfAdults=</xsl:text>
						<xsl:value-of select="$adults" />
						<xsl:text>%26numberOfChildren=</xsl:text>
						<xsl:value-of select="$children" />
						<xsl:text>%26transaction_Id=</xsl:text>
						<xsl:value-of select="$transactionId" />
						<xsl:text>%26affID=ctm</xsl:text>


					</quoteUrl>
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