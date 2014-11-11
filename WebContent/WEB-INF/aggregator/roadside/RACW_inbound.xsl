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

	<xsl:variable name="state"><xsl:value-of select="$request/roadside/vehicle/state"/></xsl:variable>

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
					<xsl:with-param name="productId">ROADSIDE-219</xsl:with-param>
				</xsl:call-template>
			</results>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/results">
		<results>

			<xsl:for-each select="result">

				<xsl:variable name="productString">
					<xsl:choose>
						<xsl:when test="@productId = 'ROADSIDE-220'"><xsl:text>classic</xsl:text></xsl:when>
						<xsl:when test="@productId = 'ROADSIDE-221'"><xsl:text>ultimate</xsl:text></xsl:when>
						<xsl:when test="@productId = 'ROADSIDE-222'"><xsl:text>ultimate-plus</xsl:text></xsl:when>
						<xsl:otherwise>
							<xsl:text>standard</xsl:text>
						</xsl:otherwise>
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
					<providerCode>RACW</providerCode>
					<trackCode>40</trackCode>
					<name><xsl:value-of select="name"/></name>
					<des><xsl:value-of select="des"/></des>
					<price><xsl:value-of select="premium"/></price>
					<priceText><xsl:value-of select="premiumText"/></priceText>

					<info>
						<xsl:for-each select="productInfo">
							<xsl:choose>
							<xsl:when test="@propertyId = 'subTitle'"></xsl:when>
							<xsl:when test="@propertyId = 'infoDes'"></xsl:when>
							<xsl:when test="@propertyId = 'additionalBenefits'"></xsl:when>
							<xsl:when test="@propertyId = 'altTravel'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Passenger Transport (When 100km from Home)</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'batteryRep'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Battery Replacement - Home Delivery &amp; Installation</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'fuelSupply'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Emergency Fuel</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'hotline'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Motoring Advice Hotline</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'keyService'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Locksmith Service</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'taxiService'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Taxi Service (If Vehicle is Towed)</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'towing'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Towing Limit – Metro &amp; Regional Centres</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'vehCoverage'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Coverage</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'vehRecovery'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Vehicle Recovery (When 100kms from Home)</desc>
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
					<additionalBenefits>
						<xsl:value-of select="productInfo[@propertyId='additionalBenefits']/text"/>
					</additionalBenefits>
					<acn>000 000 000</acn>
					<afsLicenceNo>000000</afsLicenceNo>
						<!-- Decided not to implement on their side at this time -->
						<!-- <quoteUrl>http://rac.com.au/motoring/roadside-assistance/<xsl:value-of select="$productString" />-form?affid=ctm%26yr=<xsl:value-of select="$request/roadside/vehicle/year"/>%26mk=<xsl:value-of select="$request/roadside/vehicle/make"/>%26mdl=%26st=wa</quoteUrl> -->
						<quoteUrl>http://rac.com.au/motoring/roadside-assistance/<xsl:value-of select="$productString" /></quoteUrl>
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
				<xsl:when test="$state != 'WA'">
					<error service="{$service}" type="unavailable">
						<code></code>
						<message>RACWA is only available in Western Australia</message>
						<data></data>
					</error>
				</xsl:when>
				<xsl:otherwise>
					<error service="{$service}" type="unavailable">
						<code></code>
						<message>unavailable</message>
						<data></data>
					</error>
				</xsl:otherwise>
			</xsl:choose>
			<providerCode>RACW</providerCode>
			<name></name>
			<des></des>
			<info></info>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>