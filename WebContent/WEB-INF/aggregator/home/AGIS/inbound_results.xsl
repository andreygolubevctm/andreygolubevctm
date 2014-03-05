<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="../../includes/utils.xsl"/>
	<xsl:import href="../includes/get_price_availability.xsl"/>
	<xsl:import href="../includes/product_details.xsl"/>

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId">*NONE</xsl:param>
	<xsl:param name="defaultProductId"><xsl:value-of select="$productId" /></xsl:param>
	<xsl:param name="service"></xsl:param>
	<xsl:param name="request" />
	<xsl:param name="certServer"></xsl:param>
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<results>
			<xsl:for-each select="/soapenv:Envelope/soapenv:Body/response/quotesList/quote">
				<xsl:choose>
					<!-- ACCEPTABLE -->
					<xsl:when test="onlinePrice/price/lumpSumPayable and string-length(onlinePrice/price/lumpSumPayable) > 0">
						<xsl:call-template name="priceAvailable" >
							<xsl:with-param name="price" select="onlinePrice/price"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="offlinePrice/price/lumpSumPayable and string-length(offlinePrice/price/lumpSumPayable) > 0">
						<xsl:call-template name="priceAvailable" >
							<xsl:with-param name="price" select="offlinePrice/price"/>
						</xsl:call-template>
					</xsl:when>

					<!-- UNACCEPTABLE -->
					<xsl:otherwise>
							<result productId="{$defaultProductId}" service="{$service}">
								<productAvailable>N</productAvailable>
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
							</result>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</results>
	</xsl:template>


<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="priceAvailable">

		<xsl:param name="price"/>

		<xsl:element name="result">
			<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
			<xsl:variable name="priceProductId">
				<xsl:choose>
					<xsl:when test="$productId != '*NONE'"><xsl:value-of select="$productId" /></xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="brand/code" />-<xsl:value-of select="underwriter/code" />-<xsl:value-of select="product/code" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="productId"><xsl:value-of select="$priceProductId" /></xsl:attribute>

			<productAvailable>Y</productAvailable>
			<transactionId><xsl:value-of select="$transactionId"/></transactionId>

			<headlineOffer>
				<xsl:choose>
					<xsl:when test="headlineOffer='' and onlinePrice">ONLINE</xsl:when>
					<xsl:when test="headlineOffer='' and offlinePrice">OFFLINE</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="headlineOffer" />
					</xsl:otherwise>
				</xsl:choose>
			</headlineOffer>
			<leadNo><xsl:value-of select="$price/leadNumber" /></leadNo>

			<onlineAvailable>
				<xsl:call-template name="getPriceAvailability">
					<xsl:with-param name="productId" select="$priceProductId" />
					<xsl:with-param name="priceType">ONLINE</xsl:with-param>
				</xsl:call-template>
			</onlineAvailable>

			<offlineAvailable>
				<xsl:call-template name="getPriceAvailability">
					<xsl:with-param name="productId" select="$priceProductId" />
					<xsl:with-param name="priceType">OFFLINE</xsl:with-param>
				</xsl:call-template>
			</offlineAvailable>

			<callbackAvailable>
				<xsl:call-template name="getPriceAvailability">
					<xsl:with-param name="productId" select="$priceProductId" />
					<xsl:with-param name="priceType">CALLBACK</xsl:with-param>
				</xsl:call-template>
			</callbackAvailable>

			<price>
				<xsl:call-template name="priceInfo" >
					<xsl:with-param name="price" select="$price" />
				</xsl:call-template>
			</price>

			<productDes><xsl:value-of select="brand/description" /></productDes>

			<conditions>
				<xsl:for-each select="conditionList/condition/text()">
					<condition><xsl:value-of select="." /></condition>
				</xsl:for-each>
			</conditions>

			<headline>
				<xsl:choose>
					<xsl:when test="components/component[@type = 'HHB'] and components/component[@type = 'HHC']">
						<xsl:call-template name="productInfo" >
							<xsl:with-param name="price" select="$price" />
							<xsl:with-param name="productId" select="$priceProductId" />
							<xsl:with-param name="productType">HHZ</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="components/component[@type = 'HHB']">
						<xsl:call-template name="productInfo" >
							<xsl:with-param name="price" select="$price" />
							<xsl:with-param name="productId" select="$priceProductId" />
							<xsl:with-param name="productType">HHB</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="components/component[@type = 'HHC']">
						<xsl:call-template name="productInfo" >
							<xsl:with-param name="price" select="$price" />
							<xsl:with-param name="productId" select="$priceProductId" />
							<xsl:with-param name="productType">HHC</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</headline>

			<quoteUrl><xsl:value-of select="$price/quoteUrl" /></quoteUrl>

			<underwriter><xsl:value-of select="underwriter/description" /></underwriter>
			<brandCode><xsl:value-of select="brand/code" /></brandCode>

			<!-- Build each product (Building & Contents) -->
			<xsl:call-template name="productType" >
				<xsl:with-param name="type">HHB</xsl:with-param>
				<xsl:with-param name="component" select="components/component[@type = 'HHB']"/>
			</xsl:call-template>
			<xsl:call-template name="productType" >
				<xsl:with-param name="type">HHC</xsl:with-param>
				<xsl:with-param name="component" select="components/component[@type = 'HHC']"/>
			</xsl:call-template>

			<telNo><xsl:value-of select="insurerContact" /></telNo>

			<!-- Hard Coded to 9999 for all providers as per business decision -->
			<vdn>
				<xsl:choose>
					<xsl:when test="insurerContact='1800 042 757'">3401</xsl:when><!-- Budget -->
					<xsl:when test="insurerContact='1800 010 414'">1740</xsl:when><!-- Virgin -->
					<xsl:when test="insurerContact='1800 003 631'">9999</xsl:when><!-- Dodo -->
					<xsl:when test="insurerContact='1800 045 295'">3475</xsl:when><!-- Ozicare -->
					<xsl:otherwise>9999</xsl:otherwise>
				</xsl:choose>
			</vdn>

			<openingHours>Monday to Friday (8am-8pm EST) and Saturday (8am-5pm EST)</openingHours>

			<pdsaUrl><xsl:value-of select="pdsaUrl" /></pdsaUrl>
			<pdsbUrl><xsl:value-of select="pdsbUrl" /></pdsbUrl>
			<fsgUrl><xsl:value-of select="fsgUrl" /></fsgUrl>

			<xsl:choose>
				<xsl:when test="components/component[@type = 'HHB'] and components/component[@type = 'HHC']">
					<xsl:call-template name="productDetails" >
						<xsl:with-param name="productId" select="$priceProductId" />
						<xsl:with-param name="productType">HHZ</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="components/component[@type = 'HHB']">
					<xsl:call-template name="productDetails" >
						<xsl:with-param name="productId" select="$priceProductId" />
						<xsl:with-param name="productType">HHB</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="components/component[@type = 'HHC']">
					<xsl:call-template name="productDetails" >
						<xsl:with-param name="productId" select="$priceProductId" />
						<xsl:with-param name="productType">HHC</xsl:with-param>
					</xsl:call-template>
				</xsl:when>

			</xsl:choose>

			<acn>111 586 353</acn>
			<afsLicenceNo>285571</afsLicenceNo>

			<discount>
				<online>
					<xsl:choose>
						<xsl:when test="components/component[@type = 'HHB'] and components/component[@type = 'HHC']">
							<xsl:choose>
								<xsl:when test="brand/code = 'BUDD'">35</xsl:when>
								<xsl:when test="brand/code = 'VIRG'">15</xsl:when>
								<xsl:when test="brand/code = 'EXDD'">25</xsl:when>
								<xsl:when test="brand/code = 'OZIC'"></xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="components/component[@type = 'HHB']">
							<xsl:choose>
								<xsl:when test="brand/code = 'BUDD'">20</xsl:when>
								<xsl:when test="brand/code = 'VIRG'"></xsl:when>
								<xsl:when test="brand/code = 'EXDD'">10</xsl:when>
								<xsl:when test="brand/code = 'OZIC'"></xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="components/component[@type = 'HHC']">
							<xsl:choose>
								<xsl:when test="brand/code = 'BUDD'">20</xsl:when>
								<xsl:when test="brand/code = 'VIRG'"></xsl:when>
								<xsl:when test="brand/code = 'EXDD'">10</xsl:when>
								<xsl:when test="brand/code = 'OZIC'"></xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</online>
				<offline>
					<xsl:choose>
						<xsl:when test="components/component[@type = 'HHB'] and components/component[@type = 'HHC']">
							<xsl:choose>
								<xsl:when test="brand/code = 'BUDD'">25</xsl:when>
								<xsl:when test="brand/code = 'VIRG'">15</xsl:when>
								<xsl:when test="brand/code = 'EXDD'">25</xsl:when>
								<xsl:when test="brand/code = 'OZIC'"></xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="components/component[@type = 'HHB']">
							<xsl:choose>
								<xsl:when test="brand/code = 'BUDD'">10</xsl:when>
								<xsl:when test="brand/code = 'VIRG'"></xsl:when>
								<xsl:when test="brand/code = 'EXDD'">10</xsl:when>
								<xsl:when test="brand/code = 'OZIC'"></xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="components/component[@type = 'HHC']">
							<xsl:choose>
								<xsl:when test="brand/code = 'BUDD'">10</xsl:when>
								<xsl:when test="brand/code = 'VIRG'"></xsl:when>
								<xsl:when test="brand/code = 'EXDD'">10</xsl:when>
								<xsl:when test="brand/code = 'OZIC'"></xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</offline>
			</discount>

		</xsl:element>

	</xsl:template>

<!-- SUPPORT TEMPLATES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<xsl:template name="productInfo">

	<xsl:param name="price"/>
	<xsl:param name="productId"/>
	<xsl:param name="productType"/>

	<information><xsl:value-of select="$price/information" /></information>
	<name><xsl:value-of select="$price/name" /></name>
	<des><xsl:value-of select="$price/des" /></des>
	<feature>
		<!-- This is a temporary measure until the service can dynamically pass the product feature -->
		<!-- <xsl:value-of select="$price/feature" /> -->
		<xsl:call-template name="feature" >
			<xsl:with-param name="productId" select="$productId" />
			<xsl:with-param name="productType" select="$productType" />
		</xsl:call-template>
	</feature>
	<info><xsl:value-of select="$price/info" /></info>
	<terms><xsl:value-of select="$price/terms" /></terms>
</xsl:template>

<xsl:template name="priceInfo">
	<xsl:param name="price"/>

	<annual>
		<xsl:choose>
			<xsl:when test="$price/lumpSumPayable">
				<available>Y</available>
				<total>
					<xsl:call-template name="util_mathCeil">
						<xsl:with-param name="num" select="$price/lumpSumPayable" />
					</xsl:call-template>
				</total>
			</xsl:when>
			<xsl:otherwise>
				<available>N</available>
			</xsl:otherwise>
		</xsl:choose>
	</annual>
	<monthly>
		<xsl:choose>
			<xsl:when test="$price/firstPaymentAmount and
							$price/numberOfPayments and
							$price/paymentAmount and
							$price/totalAmount and
							$price/firstPaymentAmount != '' and
							$price/numberOfPayments != '' and
							$price/paymentAmount != '' and
							$price/totalAmount != ''">

				<available>Y</available>

				<firstPayment><xsl:value-of select="format-number($price/firstPaymentAmount,'#.00')" /></firstPayment>
				<paymentNumber><xsl:value-of select="$price/numberOfPayments" /></paymentNumber>
				<amount><xsl:value-of select="format-number($price/paymentAmount,'#.00')" /></amount>
				<total>
					<xsl:call-template name="util_mathCeil">
						<xsl:with-param name="num" select="$price/totalAmount" />
					</xsl:call-template>
				</total>

			</xsl:when>
			<xsl:otherwise>
				<available>N</available>
			</xsl:otherwise>
		</xsl:choose>

	</monthly>
	<fortnightly>
		<available>N</available>
	</fortnightly>
</xsl:template>

<xsl:template name="productType">

	<xsl:param name="type"/>
	<xsl:param name="component"/>
	<xsl:variable name="checkType"><xsl:value-of select="$component/@type" /></xsl:variable>
		<xsl:choose>
			<!-- EXISTS -->
			<xsl:when test="$checkType = $type">
				<xsl:element name="{$checkType}">
					<description><xsl:value-of select="$checkType" /></description>
					<excess>
						<amount><xsl:value-of select="$component/totalExcess" /></amount>
					</excess>
					<insuredValues><xsl:value-of select="$component/insuredValue" /></insuredValues>
				</xsl:element>
			</xsl:when>

			<!-- DOESNT EXIST -->
			<xsl:otherwise>
				<xsl:element name="{$type}">
					<description></description>
					<excess>
						<amount></amount>
					</excess>
					<insuredValues></insuredValues>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
</xsl:template>

</xsl:stylesheet>