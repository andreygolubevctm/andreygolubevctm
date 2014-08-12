<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/unavailable.xsl"/>

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
				<xsl:with-param name="productId">TRAVEL-164</xsl:with-param>
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

				<xsl:variable name="product">
					<xsl:value-of select="@productId" />
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
					<trackCode>32</trackCode>
					<name><xsl:value-of select="name"/></name>
					<des><xsl:value-of select="des"/></des>
					<price><xsl:value-of select="format-number(premium,'#.00')"/></price>
					<priceText><xsl:value-of select="premiumText"/></priceText>

					<info>
						<xsl:for-each select="productInfo">
							<xsl:choose>
							<xsl:when test="@propertyId = 'subTitle'"></xsl:when>
							<xsl:when test="@propertyId = 'infoDes'"></xsl:when>
							<xsl:when test="@propertyId = 'medical'and $product = 'TRAVEL-164'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="$defaultProductId" /></label>
									<desc>Medical Expenses Onboard a Ship</desc>
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
						<xsl:choose>
							<xsl:when test="contains(name, 'International Comprehensive')">
								<xsl:text>https://travel.qbe.com/qbe/QBETravel?login=true%26aid=K4JWRJ7IQQOLNWIEQDCUV6UHMI%26doc=OUZCES2QVUV72CBJJAXDFAF2LPGQG7ROT2UQVOIHBBQWH7TPZ7JA</xsl:text>
							</xsl:when>
							<xsl:when test="name = 'Elements'">
								<xsl:text>https://travel.qbe.com/qbe/QBETravel?login=true%26aid=K4JWRJ7IQQOLNWIEQDCUV6UHMI%26doc=QQLCLVFKE6SLQRU5VFSJ2CAR5U</xsl:text>
							</xsl:when>
							<xsl:when test="name = 'Australian Domestic'">
								<xsl:text>https://travel.qbe.com/qbe/QBETravel?login=true%26aid=K4JWRJ7IQQOLNWIEQDCUV6UHMI%26doc=U6RGEU44NKJZVZBJM7K2YZQJN46GNJBH3Q36OGRL7JANVQJ5E7ZQ</xsl:text>
							</xsl:when>
							<xsl:when test="contains(name, 'Annual')">
								<xsl:text>https://travel.qbe.com/qbe/QBETravel?login=true%26aid=K4JWRJ7IQQOLNWIEQDCUV6UHMI%26doc=4QAWJWCU2JJN2ABHQ44GJ6TUTGK6PTK556VN4DJ5IEQ7NYS5HO4Q</xsl:text>
							</xsl:when>
							<xsl:when test="contains(name, 'Essentials')">
								<xsl:text>https://tpos.qbe.com/qbe/QBETravel?login=true%26aid=BDS4ZI3ERA4YSLU4WKT5FIBIJU%26doc=BOENGRGPKRFB3TE3N6ZAUE7EXRJSMQPZGLKPCSGLHPHPF5LVAKSC45CXT4QVKKTKXQHLLJKA2FVYW</xsl:text>
							</xsl:when>
						</xsl:choose>
					</quoteUrl>
				</xsl:element>
			</xsl:for-each>

		</results>
	</xsl:template>

</xsl:stylesheet>