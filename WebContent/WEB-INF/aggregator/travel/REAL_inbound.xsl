<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xslt/java"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv java">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
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
				<xsl:with-param name="productId">TRAVEL-211</xsl:with-param>
			</xsl:call-template>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/results">
		<results>

			<xsl:for-each select="result">

				<xsl:variable name="policyType">
					<xsl:choose>
						<xsl:when test="@productId = 'TRAVEL-211'">Basic</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-212'">Comprehensive</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-213'">AMT</xsl:when>
						<xsl:otherwise >Basic</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="destinationCode">
					<xsl:choose>
						<!-- REGION 1 (R1) -->
						<xsl:when test="$request/travel/destinations/am/us">66</xsl:when>
						<xsl:when test="$request/travel/destinations/am/ca">20</xsl:when>
						<xsl:when test="$request/travel/destinations/am/sa">6</xsl:when>
						<xsl:when test="$request/travel/destinations/me/me">263</xsl:when>
						<xsl:when test="$request/travel/destinations/do/do">2</xsl:when>

						<!-- REGION 2 (R2) -->
						<xsl:when test="$request/travel/destinations/af/af">4</xsl:when>
						<xsl:when test="$request/travel/destinations/eu/eu">3</xsl:when>

						<!-- REGION 3 (R3) -->
						<xsl:when test="$request/travel/destinations/eu/uk">219</xsl:when>
						<xsl:when test="$request/travel/destinations/as/ch">194</xsl:when>
						<xsl:when test="$request/travel/destinations/as/jp">202</xsl:when>
						<xsl:when test="$request/travel/destinations/as/hk">198</xsl:when>
						<xsl:when test="$request/travel/destinations/as/in">199</xsl:when>
						<xsl:when test="$request/travel/destinations/as/th">218</xsl:when>
						<xsl:when test="$request/travel/destinations/pa/in">200</xsl:when>

						<!-- REGION 4 (R4) -->
						<xsl:when test="$request/travel/destinations/pa/pi">264</xsl:when>

						<!-- REGION 5 (R5) -->
						<xsl:when test="$request/travel/destinations/pa/ba">248</xsl:when>
						<xsl:when test="$request/travel/destinations/pa/nz">250</xsl:when>

						<!-- DOMESTIC -->
						<xsl:when test="$request/travel/destinations/au/au">252</xsl:when>

						<xsl:otherwise>2</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="ages">
					<xsl:choose>
						<xsl:when test="$request/travel/adults = '2'">
							<xsl:value-of select="$request/travel/oldest" />%26Ages[]=<xsl:value-of select="$request/travel/oldest" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$request/travel/oldest" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="fromDate" select="$request/travel/dates/fromDate" />
				<xsl:variable name="toDate" select="$request/travel/dates/toDate" />
				<xsl:variable name="currentDateFormatted"><xsl:value-of select="substring($today,9,2)" />-<xsl:value-of select="substring($today,6,2)" />-<xsl:value-of select="substring($today,1,4)" /></xsl:variable>

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
					<trackCode>33</trackCode>
					<name><xsl:value-of select="name"/></name>
					<des><xsl:value-of select="des"/></des>
					<price><xsl:value-of select="format-number(premium,'#.00')"/></price>
					<priceText><xsl:value-of select="premiumText"/></priceText>

					<info>
						<xsl:for-each select="productInfo">
							<xsl:choose>
							<xsl:when test="@propertyId = 'subTitle'"></xsl:when>
							<xsl:when test="@propertyId = 'infoDes'"></xsl:when>
							<xsl:when test="@propertyId = 'medical'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Overseas Medical Expenses</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'cxdfee'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Cancellation Fee Cover</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'luggagedel'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Delayed Luggage Allowance</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'rentalVeh'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Rental Car Insurance Excess</desc>
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
						<xsl:choose>
							<xsl:when test="$policyType = 'AMT'">
								<xsl:text>https://travel.realinsurance.com.au/ctm?DestinationCode=</xsl:text>
								<xsl:value-of select="$destinationCode" />
								<xsl:text>%26StartDate=</xsl:text>
								<xsl:value-of select="$currentDateFormatted" />
								<xsl:text>%26EndDate=</xsl:text>
								<xsl:value-of select="$currentDateFormatted" />
								<xsl:text>%26Ages[]=</xsl:text>
								<xsl:value-of select="$ages" />
								<xsl:text>%26AMT=true%26TranID=</xsl:text>
								<xsl:value-of select="$transactionId" />
								<xsl:text>%26AffID=CTM%26AMT=true</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>https://travel.realinsurance.com.au/ctm?%26PolicyTypeID=</xsl:text>
								<xsl:value-of select="$policyType" />
								<xsl:text>%26DestinationCode=</xsl:text>
								<xsl:value-of select="$destinationCode" />
								<xsl:text>%26StartDate=</xsl:text>
								<xsl:value-of select="translate($fromDate, '/', '-')" />
								<xsl:text>%26EndDate=</xsl:text>
								<xsl:value-of select="translate($toDate, '/', '-')" />
								<xsl:text>%26Ages[]=</xsl:text>
								<xsl:value-of select="$ages" />
								<xsl:text>%26TranID=</xsl:text>
								<xsl:value-of select="$transactionId" />
								<xsl:text>%26AffID=CTM</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</quoteUrl>
				</xsl:element>
			</xsl:for-each>
		</results>
	</xsl:template>
</xsl:stylesheet>