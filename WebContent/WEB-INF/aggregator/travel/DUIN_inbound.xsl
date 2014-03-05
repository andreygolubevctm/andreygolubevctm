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
						<xsl:when test="@productId = 'TRAVEL-49'">Comprehensive</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-50'">Backpacker</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-51'">AFTL</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-52'">AFTB</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-197'">ComprehensiveDom</xsl:when>
						<xsl:otherwise >Comprehensive</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

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
					<trackCode>8</trackCode>
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
					<subTitle>
							<xsl:value-of select="productInfo[@propertyId='subTitle']/text"/>
					</subTitle>

					<acn>000 000 000</acn>
					<afsLicenceNo>00000</afsLicenceNo>
					<!-- <quoteUrl>http://www.duinsure.com.au/sites/duinsureaus.nsf/quote1?open%26affid=ctm1</quoteUrl> -->
					<quoteUrl>
						<xsl:choose>
							<xsl:when test="$policyType = 'AMT'">
								<xsl:text>http://www.duinsure.com.au/sites/duinsureaus.nsf/quote1?open%26policyTypeId=</xsl:text>
								<xsl:value-of select="$policyType" />
								<xsl:text>%26startDate=</xsl:text>
								<xsl:value-of select="$today" />
								<xsl:text>%26affID=ctm1</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>http://www.duinsure.com.au/sites/duinsureaus.nsf/quote1?open%26policyTypeId=</xsl:text>
								<xsl:value-of select="$policyType" />
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
							</xsl:otherwise>
						</xsl:choose>
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