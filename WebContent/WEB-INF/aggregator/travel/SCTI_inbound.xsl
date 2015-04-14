<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/unavailable.xsl"/>
	<xsl:import href="utilities/handoverMapping.xsl"/>

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId">*NONE</xsl:param>
	<xsl:param name="defaultProductId"><xsl:value-of select="$productId" /></xsl:param>
	<xsl:param name="service"></xsl:param>
	<xsl:param name="request" />
	<xsl:param name="rootURL" />
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
				<xsl:with-param name="productId">TRAVEL-193</xsl:with-param>
			</xsl:call-template>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/results">
		<results>

			<xsl:for-each select="result">
				<xsl:variable name="children">
					<xsl:choose>
						<xsl:when test="$request/travel/children"><xsl:value-of select="$request/travel/children" /></xsl:when>
						<xsl:otherwise >0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="adults" select="$request/travel/adults" />
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



				<xsl:variable name="policyType">
					<xsl:choose>
						<xsl:when test="@productId = 'TRAVEL-193'">1</xsl:when>
						<xsl:otherwise>2</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>



				<xsl:variable name="fromDate" select="$request/travel/dates/fromDate" />
				<xsl:variable name="toDate" select="$request/travel/dates/toDate" />

				<xsl:variable name="destinationCode">
					<xsl:choose>
					<!-- Multi-Trip -->
						<xsl:when test="$policyType = 2">
							<xsl:choose>
								<xsl:when test="@productId = 'TRAVEL-194'">PC</xsl:when>
								<xsl:when test="@productId = 'TRAVEL-195'">WW1</xsl:when>
								<xsl:when test="@productId = 'TRAVEL-196'">WW2</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="getHandoverMapping">
								<xsl:with-param name="handoverValues" select="$request/travel/mappedCountries/SCTI/handoverMapping" />
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:message>SCTI <xsl:value-of select="$destinationCode" /></xsl:message>

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
					<trackCode>30</trackCode>
					<name><xsl:value-of select="name"/></name>
					<des><xsl:value-of select="des"/></des>
					<price><xsl:value-of select="format-number(premium,'#.00')"/></price>
					<priceText><xsl:value-of select="premiumText"/></priceText>

					<info>
						<xsl:for-each select="productInfo">
							<xsl:choose>
							<xsl:when test="@propertyId = 'subTitle'"></xsl:when>
							<xsl:when test="@propertyId = 'infoDes'"></xsl:when>
							<xsl:when test="@propertyId = 'cxdfee' and $adults = 2">
								<xsl:variable name="newValue" select="value*2"/>
								<xsl:element name="{@propertyId}">
									<label>Cancellation Fees Cover</label>
									<desc>Cancellation Fees Cover</desc>
									<value><xsl:value-of select="$newValue" /></value>
									<text><xsl:value-of select='format-number($newValue, "$###,###.##")' /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'luggage' and $adults = 2">
								<xsl:variable name="newValue" select="value*2"/>
								<xsl:element name="{@propertyId}">
									<label>Luggage and PE</label>
									<desc>Luggage and Personal Effects</desc>
									<value><xsl:value-of select="$newValue" /></value>
									<text><xsl:value-of select='format-number($newValue, "$###,###.##")' /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'traveldelay' and $adults = 2">
								<xsl:variable name="newValue" select="value*2"/>
								<xsl:element name="{@propertyId}">
									<label>Travel Delay</label>
									<desc>Delayed Journey to a Special Event</desc>
									<value><xsl:value-of select="$newValue" /></value>
									<text><xsl:value-of select='format-number($newValue, "$###,###.##")' /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'accident' and $adults = 2">
								<xsl:variable name="newValue" select="value*2"/>
								<xsl:element name="{@propertyId}">
									<label>Personal Accident</label>
									<desc>Personal Accident</desc>
									<value><xsl:value-of select="$newValue" /></value>
									<text><xsl:value-of select='format-number($newValue, "$###,###.##")' /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'luggagedel' and $adults = 2">
								<xsl:element name="{@propertyId}">
									<label>Luggage and PE Delay</label>
									<desc>Baggage Delay (after 12 hours delay)</desc>
									<value>5000</value>
									<text>$5000</text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'medical'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Overseas Medical Expenses</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'luggagedel'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Baggage Delay (after 12 hours delay)</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'suddenDental'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Emergency Dental Treatment</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'repat'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Return of Mortal Remains</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'rentalExcess'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Rental Vehicle Excess</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'traveldelay'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Delayed Journey to a Special Event</desc>
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
						<xsl:value-of select="$rootURL" />
						<xsl:text>?utm_source=comparethemarket%26utm_medium=affiliate%26utm_campaign=ctm%26affiliate=ctm%26ctm_transactionId=</xsl:text>
						<xsl:value-of select="$transactionId" />
						<xsl:text>%26policyTypeId=</xsl:text>
						<xsl:value-of select="$policyType" />
						<xsl:text>%26destinationCode=</xsl:text>
						<xsl:value-of select="$destinationCode" />
						<xsl:text>%26startDate=</xsl:text>
						<xsl:value-of select="translate($fromDate, '/', '-')" />
						<xsl:text>%26endDate=</xsl:text>
						<xsl:value-of select="translate($toDate, '/', '-')" />
						<xsl:text>%26numberOfChildren=</xsl:text>
						<xsl:value-of select="$children" />
						<xsl:text>%26adultAges=</xsl:text>
						<xsl:value-of select="$ages" />
						<xsl:text>%26intro=979230</xsl:text>
					</quoteUrl>
				</xsl:element>
			</xsl:for-each>
		</results>
	</xsl:template>
</xsl:stylesheet>