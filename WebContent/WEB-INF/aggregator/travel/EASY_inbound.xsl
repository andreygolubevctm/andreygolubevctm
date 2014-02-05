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
					<xsl:with-param name="productId">TRAVEL-22</xsl:with-param>
				</xsl:call-template>
			</results>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/results">
		<results>

			<xsl:for-each select="result">

				<xsl:variable name="isNewZeland">
					<xsl:choose>
						<xsl:when test="count($request/travel/destinations/*) = 1 and count($request/travel/destinations/pa/*) = 1 and $request/travel/destinations/pa/nz">Yes</xsl:when>
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
					<trackCode>
						<xsl:choose>
							<xsl:when test="@productId = 'TRAVEL-37' or @productId = 'TRAVEL-38'">13</xsl:when>
							<xsl:otherwise>12</xsl:otherwise>
						</xsl:choose>
					</trackCode>
					<name><xsl:value-of select="name"/></name>
					<des><xsl:value-of select="des"/></des>
					<price><xsl:value-of select="format-number(premium,'#.00')"/></price>
					<priceText><xsl:value-of select="premiumText"/></priceText>

					<info>
						<xsl:for-each select="productInfo">
							<xsl:choose>
							<xsl:when test="@propertyId = 'subTitle'"></xsl:when>
							<xsl:when test="@propertyId = 'infoDes'"></xsl:when>
							<xsl:when test="@propertyId = 'skiPack' and $isNewZeland = 'Yes'">
								<xsl:element name="{@propertyId}">
									<label>Ski Pack</label>
									<desc>Ski Pack</desc>
									<value>9999999</value>
									<text>Free</text>
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
						<xsl:choose>
							<xsl:when test="@productId = 'TRAVEL-37'">
						<xsl:value-of select="productInfo[@propertyId='infoDes']/text" />
								<xsl:text> &lt;br&gt; &lt;br&gt; Cover is for Worldwide excluding USA, South and Central America and Antarctica if more than 72 hours of any one trip is to these destinations.</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="productInfo[@propertyId='infoDes']/text" />
							</xsl:otherwise>
						</xsl:choose>
					</infoDes>
					<subTitle>
							<xsl:value-of select="productInfo[@propertyId='subTitle']/text"/>
					</subTitle>

					<acn>000 000 000</acn>
					<afsLicenceNo>00000</afsLicenceNo>
					<xsl:choose>
						<!-- SINGLE TRIP -->
						<xsl:when test="@productId = 'TRAVEL-22'"><quoteUrl>https://travel.qbe.com/qbe/QBETravel?login=true%26aid=G6EPHBAYS3HJC5ADUZBO2I2IFM%26doc=QQLCLVFKE6SLQRU5VFSJ2CAR5U</quoteUrl></xsl:when>
						<xsl:when test="@productId = 'TRAVEL-185'"><quoteUrl>https://travel.qbe.com/qbe/QBETravel?login=true%26aid=G6EPHBAYS3HJC5ADUZBO2I2IFM%26doc=OUZCES2QVUV72CBJJAXDFAF2LPGQG7ROT2UQVOIHBBQWH7TPZ7JA</quoteUrl></xsl:when>
						<xsl:when test="@productId = 'TRAVEL-186'"><quoteUrl>https://travel.qbe.com/qbe/QBETravel?login=true%26aid=G6EPHBAYS3HJC5ADUZBO2I2IFM%26doc=OUZCES2QVUV72CBJJAXDFAF2LPGQG7ROT2UQVOIHBBQWH7TPZ7JA</quoteUrl></xsl:when>
						<!-- MULTI TRIP -->
						<xsl:otherwise>
							<quoteUrl>https://travel.qbe.com/qbe/QBETravel?login=true%26aid=G6EPHBAYS3HJC5ADUZBO2I2IFM%26doc=4QAWJWCU2JJN2ABHQ44GJ6TUTGK6PTK556VN4DJ5IEQ7NYS5HO4Q</quoteUrl>
						</xsl:otherwise>
					</xsl:choose>
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