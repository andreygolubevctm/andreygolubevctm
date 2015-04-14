<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/handoverMapping.xsl" />
	<xsl:import href="utilities/unavailable.xsl" />

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
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-40</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/results">
		<results>

			<xsl:for-each select="result">

				<xsl:variable name="domestic">
					<xsl:choose>
						<xsl:when test="count($request/travel/destinations/*) = 1 and $request/travel/destinations/au/au">Yes</xsl:when>
						<xsl:otherwise>No</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="policyType">
					<xsl:choose>
						<xsl:when test="@productId = 'TRAVEL-40'">1</xsl:when> <!-- Standard -->
						<xsl:when test="@productId = 'TRAVEL-41'">2</xsl:when> <!-- Comprehensive -->
						<xsl:when test="@productId = 'TRAVEL-42'">3</xsl:when> <!-- Comprehensive Snow -->
						<xsl:when test="@productId = 'TRAVEL-43'">4</xsl:when> <!-- Domestic -->
						<xsl:when test="@productId = 'TRAVEL-46'">5</xsl:when> <!-- Comprehensive Cruise -->
						<xsl:when test="@productId = 'TRAVEL-47'">6</xsl:when> <!-- Standard Cruise -->
						<xsl:when test="@productId = 'TRAVEL-48'">7</xsl:when> <!-- Comprehensive Cruise with Snow -->
						<xsl:when test="@productId = 'TRAVEL-44'">8</xsl:when> <!-- Multi Trip Asia (40 days per trip) -->
						<xsl:when test="@productId = 'TRAVEL-45'">9</xsl:when> <!-- Multi Trip Worldwide (40 days per trip) -->
						<xsl:otherwise >1</xsl:otherwise> <!-- Default to Standard -->
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="destinationCode">
					<xsl:choose>
						<xsl:when test="$request/travel/policyType = 'S'">
							<xsl:call-template name="getHandoverMapping">
								<xsl:with-param name="handoverValues" select="$request/travel/mappedCountries/FAST/handoverMapping" />
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>WW</xsl:otherwise>
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
					<trackCode>14</trackCode>
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
							<xsl:when test="@propertyId = 'medical'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Overseas Emergency Medical and Hospital Expenses</desc>
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
					<subTitle><xsl:value-of select="productInfo[@propertyId='subTitle']/text"/></subTitle>


					<acn>000 000 000</acn>
					<afsLicenceNo>00000</afsLicenceNo>
					<quoteUrl>
						<xsl:text>http://fastcover.com.au/ctmref?policyTypeId=</xsl:text>
						<xsl:value-of select="$policyType" />
						<xsl:text>%26destinationCode=</xsl:text>
						<xsl:value-of select="$destinationCode" />
						<xsl:text>%26startDate=</xsl:text>
						<xsl:value-of select="translate($request/travel/dates/fromDate, '/', '-')" />
						<xsl:text>%26endDate=</xsl:text>
						<xsl:value-of select="translate($request/travel/dates/toDate, '/', '-')" />
						<xsl:text>%26numberOfAdults=</xsl:text>
						<xsl:value-of select="$request/travel/adults" />
						<xsl:text>%26numberOfChildren=</xsl:text>
						<xsl:value-of select="$request/travel/children" />
						<xsl:text>%26adultAges=</xsl:text>
						<xsl:value-of select="$request/travel/oldest" />
						<xsl:if test="$request/travel/adults = '2'">
							<xsl:text>,</xsl:text><xsl:value-of select="$request/travel/oldest" />
						</xsl:if>
						</quoteUrl>
				</xsl:element>
			</xsl:for-each>
		</results>
	</xsl:template>
</xsl:stylesheet>