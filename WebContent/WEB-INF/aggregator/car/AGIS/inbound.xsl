<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="../../includes/ranking.xsl"/>
	<xsl:import href="../../includes/utils.xsl"/>
	<xsl:import href="../../includes/get_price_availability.xsl"/>

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="validationErrors"></xsl:param>
	<xsl:param name="productId">*NONE</xsl:param>
	<xsl:param name="defaultProductId"><xsl:value-of select="$productId" /></xsl:param>
	<xsl:param name="service">*NONE</xsl:param>
	<xsl:param name="defaultProductList"></xsl:param>
	<xsl:param name="defaultServiceList"></xsl:param>
	<xsl:param name="certServer"></xsl:param>
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">

		<xsl:variable name="validationErrors">
			<xsl:call-template name="validateResponse">
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<!-- If we have no validation errors apply the templates like normal. -->
			<xsl:when test="$validationErrors = '' and /soapenv:Envelope/soapenv:Body/response/quoteList">
				<xsl:apply-templates />
			</xsl:when>
			<xsl:otherwise>
				<results>
					<xsl:choose>
						<xsl:when test="contains($defaultProductList, '@')">
							<xsl:call-template name="multiRenderError">
								<xsl:with-param name="validationErrors" select="$validationErrors"/>
								<xsl:with-param name="defaultProductList" select="$defaultProductList"/>
								<xsl:with-param name="defaultServiceList" select="$defaultServiceList"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="renderError">
								<xsl:with-param name="validationErrors" select="$validationErrors"/>
								<xsl:with-param name="defaultProductId" select="$defaultProductId"/>
								<xsl:with-param name="service" select="$service"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</results>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="soapenv:Envelope/soapenv:Body/response">
		<results>

			<xsl:for-each select="quoteList/quote">

				<!-- VARIABLES -->
				<xsl:variable name="carbonOffsetText">
					<xsl:value-of select="conditionList/condition[contains(text(),'Includes cost to offset ')]" />
				</xsl:variable>
				<xsl:variable name="carbonOffset">
					<xsl:value-of select="substring-before(substring-after($carbonOffsetText, 'Includes cost to offset '),' tonnes')" />
				</xsl:variable>
				<xsl:variable name="currentBrand">
					<xsl:value-of select="brand/code" />
				</xsl:variable>

				<xsl:element name="price">
					<xsl:variable name="serviceId">
						<xsl:choose>
							<xsl:when test="$service != '*NONE'"><xsl:value-of select="$service" /></xsl:when>
							<xsl:otherwise>
								<xsl:text>AGIS_</xsl:text><xsl:value-of select="$currentBrand" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="priceProductId">
						<xsl:choose>
							<xsl:when test="$productId != '*NONE'"><xsl:value-of select="$productId" /></xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$currentBrand" />-<xsl:value-of select="underwriter/code" />-<xsl:value-of select="product/code" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:attribute name="service"><xsl:value-of select="$serviceId" /></xsl:attribute>
					<xsl:attribute name="productId"><xsl:value-of select="$priceProductId" /></xsl:attribute>

					<available>Y</available>
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

					<onlineAvailable>
						<xsl:choose>
							<xsl:when test="onlinePrice">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</onlineAvailable>

					<offlineAvailable>
						<xsl:choose>
							<xsl:when test="offlinePrice">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</offlineAvailable>

					<callbackAvailable>
						<xsl:call-template name="getPriceAvailability">
							<xsl:with-param name="productId" select="$priceProductId" />
							<xsl:with-param name="priceType">CALLBACK</xsl:with-param>
							<xsl:with-param name="hasModifications">N</xsl:with-param>
						</xsl:call-template>
					</callbackAvailable>
					<callbackAvailableWithModifications>
						<xsl:call-template name="getPriceAvailability">
							<xsl:with-param name="productId" select="$priceProductId" />
							<xsl:with-param name="priceType">CALLBACK</xsl:with-param>
							<xsl:with-param name="hasModifications">Y</xsl:with-param>
						</xsl:call-template>
					</callbackAvailableWithModifications>

					<xsl:call-template name="priceInfo">
						<xsl:with-param name="tagName">onlinePrice</xsl:with-param>
						<xsl:with-param name="price" select="onlinePrice" />
						<xsl:with-param name="carbonOffset" select="$carbonOffset"/>
						<xsl:with-param name="productId" select="$priceProductId" />
					</xsl:call-template>

					<xsl:call-template name="priceInfo">
						<xsl:with-param name="tagName">offlinePrice</xsl:with-param>
						<xsl:with-param name="price" select="offlinePrice" />
						<xsl:with-param name="carbonOffset" select="$carbonOffset"/>
						<xsl:with-param name="productId" select="$priceProductId" />
					</xsl:call-template>

					<productDes><xsl:value-of select="product/description" /></productDes>
					<underwriter><xsl:value-of select="underwriter/description" /></underwriter>
					<brandCode><xsl:value-of select="$currentBrand" /></brandCode>
					<acn>111 586 353</acn>
					<afsLicenceNo>285571</afsLicenceNo>

					<excess>
						<base><xsl:value-of select="baseExcess" /></base>
						<total><xsl:value-of select="totalExcess" /></total>
						<xsl:for-each select="additionalExcessList/excess">
							<excess>
								<description><xsl:value-of select="description" /></description>
								<amount>$<xsl:value-of select="amount" /></amount>
							</excess>
						</xsl:for-each>
					</excess>
					<conditions>
						<xsl:for-each select="conditionList/condition/text()">
							<xsl:choose>
								<xsl:when test="contains(.,'years old') and not (contains(.,'excess'))">
									<ageRestriction><xsl:value-of select="." /></ageRestriction>
								</xsl:when>
								<xsl:otherwise>
									<ageRestriction/>
								</xsl:otherwise>
							</xsl:choose>
							<condition><xsl:value-of select="." /></condition>
						</xsl:for-each>

						<!-- Add conditions for product specific excesses -->
						<xsl:for-each select="additionalExcessList/excess">
							<xsl:if test="description = 'Male Drivers.'">
								<condition>Includes an additional excess of $<xsl:value-of select="amount" /> for Male Drivers.</condition>
							</xsl:if>
							<xsl:if test="description = 'Non-Retired Drivers.'">
								<condition>Includes an additional excess of $<xsl:value-of select="amount" /> for Non-Retired Drivers.</condition>
							</xsl:if>
						</xsl:for-each>

					</conditions>
					<xsl:choose>
					<xsl:when test="onlinePrice/leadNumber">
						<leadNo><xsl:value-of select="onlinePrice/leadNumber" /></leadNo>
					</xsl:when>
					<xsl:otherwise>
						<leadNo><xsl:value-of select="offlinePrice/leadNumber" /></leadNo>
					</xsl:otherwise>
					</xsl:choose>

					<quoteUrl><xsl:value-of select="onlinePrice/quoteUrl" /></quoteUrl>

					<telNo><xsl:value-of select="insurerContact" /></telNo>
					<vdn>
						<xsl:choose>
							<xsl:when test="insurerContact='1800 042 783'">1648</xsl:when>
							<xsl:when test="insurerContact='1800 010 414'">1740</xsl:when>
							<xsl:when test="insurerContact='1800 010 506'">1742</xsl:when>
							<xsl:when test="insurerContact='1800 550 055'">1851</xsl:when>
							<xsl:when test="insurerContact='1800 729 537'">1871</xsl:when>
							<xsl:when test="insurerContact='1800 724 682'">1985</xsl:when>
							<xsl:when test="insurerContact='1800 042 757'">3401</xsl:when>
							<xsl:when test="insurerContact='1800 048 489'">3407</xsl:when>
							<xsl:when test="insurerContact='1800 041 124'">3471</xsl:when>
							<xsl:when test="insurerContact='1800 045 295'">3475</xsl:when>
							<xsl:when test="insurerContact='1800 059 369'">3558</xsl:when>
							<xsl:when test="insurerContact='1800 003 631'">DOAG</xsl:when>
							<xsl:otherwise>9999</xsl:otherwise>
						</xsl:choose>
					</vdn>
					<openingHours>Monday to Friday (8am-8pm EST) and Saturday (8am-5pm EST)</openingHours>

					<pdsaUrl><xsl:value-of select="pdsaUrl" /></pdsaUrl>
					<pdsaDesLong><xsl:value-of select="pdsaDesLong" /></pdsaDesLong>
					<pdsaDesShort><xsl:value-of select="pdsaDesShort" /></pdsaDesShort>
					<pdsbUrl><xsl:value-of select="pdsbUrl" /></pdsbUrl>
					<pdsbDesLong><xsl:value-of select="pdsbDesLong" /></pdsbDesLong>
					<pdsbDesShort><xsl:value-of select="pdsbDesShort" /></pdsbDesShort>
					<fsgUrl><xsl:value-of select="fsgUrl" /></fsgUrl>

					<disclaimer>
						<xsl:choose>
							<xsl:when test="$currentBrand = 'EXPO'">
								<![CDATA[
									*Discount applies to Australia Post Gold Comprehensive motor policies initiated and purchased online. Australia Post reserves the right to amend the discount amount. Discount applies to premium only (not fees and statutory charges) and does not extend to renewing motor policies.  The discount does not apply to any other products advertised on the Australia Post website and is not available in conjunction with any other offers.
									<br><br>The discount offer is not available if:
									<br>- the motor vehicle has any existing, unrepaired damage (including accident, rust and hail),
									<br>- if the motor vehicle has any modification from the manufacturer's original design, or
									<br>- the person purchasing the policy online is a past or present Australia Post policy holder.<br>
								]]>
							</xsl:when>
							<xsl:otherwise>
								<![CDATA[
								The indicative quote includes any applicable online discount and is subject to meeting the insurer's underwriting criteria and may change due to factors such as:
								<br>- Driver's history or offences or claims
								<br>- Age or licence type of additional drivers
								<br>- Vehicle condition, accessories and modifications<br>
								]]>
							</xsl:otherwise>
						</xsl:choose>
					</disclaimer>

					<transferring />

					<xsl:call-template name="ranking">
						<xsl:with-param name="productId">
							<xsl:choose>
								<xsl:when test="$productId != '*NONE'">
									<xsl:value-of select="$productId" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$currentBrand" />-<xsl:value-of select="underwriter/code" />-<xsl:value-of select="product/code" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
					</xsl:call-template>

					<discount>
						<online>
							<xsl:choose>
								<xsl:when test="$currentBrand = 'BUDD'">25</xsl:when>
								<xsl:when test="$currentBrand = 'VIRG'">20</xsl:when>
								<xsl:when test="$currentBrand = 'EXDD'">10</xsl:when>
								<xsl:when test="$currentBrand = '1FOW'"></xsl:when>
								<xsl:when test="$currentBrand = 'OZIC'"></xsl:when>
								<xsl:when test="$currentBrand = 'EXPO'">20</xsl:when>
								<xsl:when test="$currentBrand = 'IECO'"></xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</online>
						<offline>
							<xsl:choose>
								<xsl:when test="$currentBrand = 'BUDD'">10</xsl:when>
								<xsl:when test="$currentBrand = 'VIRG'">10</xsl:when>
								<xsl:when test="$currentBrand = 'EXDD'">10</xsl:when>
								<xsl:when test="$currentBrand = '1FOW'"></xsl:when>
								<xsl:when test="$currentBrand = 'OZIC'"></xsl:when>
								<xsl:when test="$currentBrand = 'EXPO'">10</xsl:when>
								<xsl:when test="$currentBrand = 'IECO'"></xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</offline>
					</discount>

				</xsl:element>
			</xsl:for-each>

			<xsl:variable name="actualProductList">
				<xsl:for-each select="quoteList/quote">
					<xsl:value-of select="brand/code" />-<xsl:value-of select="underwriter/code" />-<xsl:value-of select="product/code" /><xsl:text>@</xsl:text>
				</xsl:for-each>
			</xsl:variable>

			<xsl:variable name="actualServiceList">
				<xsl:for-each select="quoteList/quote">
					<xsl:text>AGIS_</xsl:text><xsl:value-of select="brand/code" /><xsl:text>@</xsl:text>
				</xsl:for-each>
			</xsl:variable>

			<xsl:if test="contains($defaultProductList, '@')">
				<xsl:call-template name="deriveError">
					<xsl:with-param name="validationErrors" select="$validationErrors"/>
					<xsl:with-param name="defaultProductList" select="$defaultProductList"/>
					<xsl:with-param name="defaultServiceList" select="$defaultServiceList"/>
					<xsl:with-param name="actualProductList" select="$actualProductList"/>
					<xsl:with-param name="actualServiceList" select="$actualServiceList"/>
				</xsl:call-template>
			</xsl:if>

		</results>
	</xsl:template>

<!-- SUPPORT TEMPLATES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="priceInfo">
		<xsl:param name="tagName" />
		<xsl:param name="price" />
		<xsl:param name="carbonOffset" />
		<xsl:param name="productId" />

		<xsl:element name="{$tagName}">
			<lumpSumTotal>
				<xsl:call-template name="util_mathCeil">
					<xsl:with-param name="num" select="$price/lumpSumPayable" />
				</xsl:call-template>
			</lumpSumTotal>

			<instalmentFirst><xsl:value-of select="format-number($price/firstPaymentAmount,'#.00')" /></instalmentFirst>
			<instalmentCount><xsl:value-of select="$price/numberOfPayments" /></instalmentCount>
			<instalmentPayment><xsl:value-of select="format-number($price/paymentAmount,'#.00')" /></instalmentPayment>
			<instalmentTotal><xsl:value-of select="format-number($price/totalAmount,'#.##')" /></instalmentTotal>

			<name><xsl:value-of select="$price/name" /></name>
			<des><xsl:value-of select="$price/des" /></des>
			<feature><xsl:value-of select="$price/feature" /></feature>
			<info><xsl:value-of select="$price/info" /></info>
			<terms><xsl:value-of select="$price/terms" /></terms>
			<carbonOffset><xsl:value-of select="$carbonOffset" /></carbonOffset>
			<kms />
		</xsl:element>

	</xsl:template>


	<!-- VALIDATION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<xsl:template name="validateResponse">

		<!-- Check that we have a quote, otherwise do nothing and let other -->
		<!-- processes handle the error (since it's not a validation problem anymore). -->
		<xsl:if test="/soapenv:Envelope/soapenv:Body/response/quoteList/quote">
			<xsl:choose>
				<!-- Check if we have our online and or our offline price - Online is not mandatory, so only validate if it's an online quote. -->
				<xsl:when test="not(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/onlinePrice) and (/soapenv:Envelope/soapenv:Body/response/quoteList/quote/headlineOffer = 'ONLINE')">
					<validationError>MISSING: onlineprice</validationError>
				</xsl:when>

				<xsl:when test="not(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/offlinePrice)">
					<validationError>MISSING: offlineprice</validationError>
				</xsl:when>

				<xsl:otherwise>
					<xsl:if test="/soapenv:Envelope/soapenv:Body/response/quoteList/quote/headlineOffer = 'ONLINE'">

						<xsl:variable name="onlineLumpSumTest"><xsl:value-of select="format-number(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/onlinePrice/lumpSumPayable,'#.00')" /></xsl:variable>
						<xsl:variable name="onlineTotalAmountTest"><xsl:value-of select="format-number(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/onlinePrice/totalAmount,'#.00')" /></xsl:variable>

						<xsl:choose>
								<xsl:when test="not(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/onlinePrice/lumpSumPayable)">
									<validationError>MISSING: onlinePrice/lumpSumPayable,</validationError>
								</xsl:when>
								<xsl:when test="$onlineLumpSumTest = 'NaN'">
									<validationError>NOT GREATER THAN ZERO: onlinePrice/lumpSumPayable,</validationError>
								</xsl:when>
								<xsl:when test="$onlineLumpSumTest &lt;= 0">
									<validationError>NOT GREATER THAN ZERO: onlinePrice/lumpSumPayable,</validationError>
								</xsl:when>
						</xsl:choose>
						<xsl:choose>
								<xsl:when test="not(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/onlinePrice/totalAmount)">
									<validationError>MISSING: onlinePrice/totalAmount,</validationError>
								</xsl:when>
								<xsl:when test="$onlineTotalAmountTest = 'NaN'">
									<validationError>NOT GREATER THAN ZERO: onlinePrice/lumpSumPayable,</validationError>
								</xsl:when>
								<xsl:when test="$onlineTotalAmountTest &lt;= 0">
									<validationError>NOT GREATER THAN ZERO: onlinePrice/totalAmount,</validationError>
								</xsl:when>
						</xsl:choose>

						<xsl:if test="not(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/onlinePrice/name)">
							<validationError>MISSING: onlinePrice/name,</validationError>
						</xsl:if>
						<xsl:if test="not(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/onlinePrice/des)">
							<validationError>MISSING: onlinePrice/des,</validationError>
						</xsl:if>

						<xsl:choose>
							<!-- Only check terms, if we have a feature. -->
							<xsl:when test="not(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/onlinePrice/feature)">
								<validationError>MISSING: onlinePrice/feature,</validationError>
							</xsl:when>
							<xsl:when test="/soapenv:Envelope/soapenv:Body/response/quoteList/quote/onlinePrice/feature = ''">
								<!-- Feature can be empty, this will exit this choose and not validate the terms
								if this is not empty we must validate terms. -->
							</xsl:when>
							<xsl:when test="not(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/onlinePrice/terms)">
								<validationError>MISSING: onlinePrice/terms,</validationError>
							</xsl:when>
							<xsl:when test="/soapenv:Envelope/soapenv:Body/response/quoteList/quote/onlinePrice/terms = ''">
								<validationError>EMPTY: onlinePrice/terms,</validationError>
							</xsl:when>
						</xsl:choose>
					</xsl:if>

					<xsl:variable name="offlineLumpSumTest"><xsl:value-of select="format-number(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/offlinePrice/lumpSumPayable,'#.00')" /></xsl:variable>
					<xsl:variable name="offlineTotalAmountTest"><xsl:value-of select="format-number(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/offlinePrice/totalAmount,'#.00')" /></xsl:variable>

					<xsl:choose>
						<xsl:when test="not(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/offlinePrice/lumpSumPayable)">
							<validationError>MISSING: offlinePrice/lumpSumPayable,</validationError>
						</xsl:when>
						<xsl:when test="$offlineLumpSumTest = 'NaN'">
							<validationError>NOT GREATER THAN ZERO: offlinePrice/lumpSumPayable,</validationError>
						</xsl:when>
						<xsl:when test="$offlineLumpSumTest &lt;= 0">
							<validationError>IS NOT GREATER THAN ZERO: offlinePrice/lumpSumPayable,</validationError>
						</xsl:when>
					</xsl:choose>

					<xsl:choose>
						<xsl:when test="not(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/offlinePrice/totalAmount)">
							<validationError>MISSING: offlinePrice/totalAmount,</validationError>
						</xsl:when>
						<xsl:when test="$offlineTotalAmountTest = 'NaN'">
							<validationError>NOT GREATER THAN ZERO: offlinePrice/totalAmount,</validationError>
						</xsl:when>
						<xsl:when test="$offlineTotalAmountTest &lt;= 0">
							<validationError>IS NOT GREATER THAN ZERO: offlinePrice/totalAmount,</validationError>
						</xsl:when>
					</xsl:choose>

					<xsl:if test="not(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/offlinePrice/name)">
						<validationError>MISSING: offlinePrice/name,</validationError>
					</xsl:if>

					<xsl:if test="not(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/offlinePrice/des)">
						<validationError>MISSING: offlinePrice/des,</validationError>
					</xsl:if>
					<xsl:choose>
						<!-- Only check terms, if we have a feature. -->
						<xsl:when test="not(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/offlinePrice/feature)">
							<validationError>MISSING: offlinePrice/feature,</validationError>
						</xsl:when>
						<xsl:when test="/soapenv:Envelope/soapenv:Body/response/quoteList/quote/offlinePrice/feature = ''">
							<!-- Feature can be empty, this will exit this choose and not validate the terms
							if this is not empty we must validate terms. -->
						</xsl:when>
						<xsl:when test="not(/soapenv:Envelope/soapenv:Body/response/quoteList/quote/offlinePrice/terms)">
							<validationError>MISSING: offlinePrice/terms,</validationError>
						</xsl:when>
						<xsl:when test="/soapenv:Envelope/soapenv:Body/response/quoteList/quote/offlinePrice/terms = ''">
							<validationError>EMPTY: offlinePrice/terms,</validationError>
						</xsl:when>
					</xsl:choose>

				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template name="renderError">
		<xsl:param name="validationErrors" />
		<xsl:param name="defaultProductId" />
		<xsl:param name="service" />
		<price productId="{$defaultProductId}" service="{$service}">
			<available>N</available>
			<transactionId><xsl:value-of select="$transactionId"/></transactionId>
			<xsl:choose>

				<xsl:when test="/soapenv:Envelope/soapenv:Body/soapenv:Fault/faultstring">
					<xsl:call-template name="error_message">
						<xsl:with-param name="service" select="$service"/>
						<xsl:with-param name="error_type">returned_fault</xsl:with-param>
						<xsl:with-param name="message"><xsl:value-of select="/soapenv:Envelope/soapenv:Body/soapenv:Fault/faultcode[1]"/></xsl:with-param>
						<xsl:with-param name="code"></xsl:with-param>
						<xsl:with-param name="data"><xsl:value-of select="/soapenv:Envelope/soapenv:Body/soapenv:Fault/faultstring[1]"/></xsl:with-param>
					</xsl:call-template>
				</xsl:when>

				<xsl:when test="/soapenv:Envelope/soapenv:Body/response/errorList/error/code = '11582'">
					<!--  This is an unconfirmed error code - awaiting confirmation on knockout error codes. -->
					<xsl:call-template name="error_message">
						<xsl:with-param name="service" select="$service"/>
						<xsl:with-param name="error_type">knock_out</xsl:with-param>
						<xsl:with-param name="message"><xsl:value-of select="/soapenv:Envelope/soapenv:Body/response/errorList/error/message"/></xsl:with-param>
						<xsl:with-param name="code"></xsl:with-param>
						<xsl:with-param name="data"></xsl:with-param>
					</xsl:call-template>
				</xsl:when>

				<xsl:when test="/soapenv:Envelope/soapenv:Body/response/errorList/error/code">

					<xsl:variable name="categories">
						<xsl:call-template name="join">
							<xsl:with-param name="list" select="/soapenv:Envelope/soapenv:Body/response/errorList/error/category" />
							<xsl:with-param name="separator" select="','" />
						</xsl:call-template>
					</xsl:variable>

					<xsl:variable name="elements">
						<xsl:call-template name="join">
							<xsl:with-param name="list" select="/soapenv:Envelope/soapenv:Body/response/errorList/error/element" />
							<xsl:with-param name="separator" select="','" />
						</xsl:call-template>
					</xsl:variable>

					<xsl:variable name="codes">
						<xsl:call-template name="join">
							<xsl:with-param name="list" select="/soapenv:Envelope/soapenv:Body/response/errorList/error/code" />
							<xsl:with-param name="separator" select="','" />
						</xsl:call-template>
					</xsl:variable>

					<xsl:call-template name="error_message">
						<xsl:with-param name="service" select="$service"/>
						<xsl:with-param name="error_type">returned_error</xsl:with-param>
						<xsl:with-param name="message">
							<xsl:call-template name="join">
								<xsl:with-param name="list" select="/soapenv:Envelope/soapenv:Body/response/errorList/error/message" />
								<xsl:with-param name="separator" select="','" />
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="code"></xsl:with-param>
						<xsl:with-param name="data">
							Category: <xsl:value-of select="$categories"/>; Element: <xsl:value-of select="$elements"/>; Code: <xsl:value-of select="$codes"/>
						</xsl:with-param>
					</xsl:call-template>

				</xsl:when>

				<xsl:when test="error[1]">
					<!-- Pass through error created by CtM soap error handling -->
					<xsl:copy-of select="error[1]"></xsl:copy-of>
				</xsl:when>

				<xsl:when test="$validationErrors != ''">
					<xsl:call-template name="error_message">
						<xsl:with-param name="service" select="$service"/>
						<xsl:with-param name="error_type">invalid</xsl:with-param>
						<xsl:with-param name="message">
						<xsl:copy-of select="$validationErrors"></xsl:copy-of>
						</xsl:with-param>
						<xsl:with-param name="code"></xsl:with-param>
						<xsl:with-param name="data"></xsl:with-param>
					</xsl:call-template>
				</xsl:when>

				<xsl:otherwise>
					<!-- Fall through, unknown error -->
					<xsl:call-template name="error_message">
						<xsl:with-param name="service" select="$service"/>
						<xsl:with-param name="error_type">unknown</xsl:with-param>
						<xsl:with-param name="message"></xsl:with-param>
						<xsl:with-param name="code"></xsl:with-param>
						<xsl:with-param name="data"></xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>

			<headlineOffer>ONLINE</headlineOffer>
			<onlinePrice>
				<lumpSumTotal>9999999999</lumpSumTotal>
				<name></name>
				<des></des>
				<feature></feature>
				<terms></terms>
				<info></info>
			</onlinePrice>
			<trackCode></trackCode>
			<name></name>
			<des></des>
			<feature></feature>
			<terms></terms>
			<info></info>

			<xsl:call-template name="ranking">
				<xsl:with-param name="productId">*NONE</xsl:with-param>
			</xsl:call-template>
		</price>
	</xsl:template>


	<!-- recursive named template -->
	<xsl:template name="multiRenderError">
		<xsl:param name="validationErrors" />
		<xsl:param name="defaultProductList" />
		<xsl:param name="defaultServiceList" />

		<xsl:variable name="defaultProductId">
			<xsl:value-of select="substring-before($defaultProductList, '@')" />
		</xsl:variable>
		<xsl:variable name="service">
			<xsl:value-of select="substring-before($defaultServiceList, '@')" />
		</xsl:variable>

		<xsl:call-template name="renderError">
			<xsl:with-param name="validationErrors" select="$validationErrors"/>
			<xsl:with-param name="defaultProductId" select="$defaultProductId"/>
			<xsl:with-param name="service" select="$service"/>
		</xsl:call-template>

		<xsl:variable name="defaultProductList">
			<xsl:value-of select="substring-after($defaultProductList, '@')" />
		</xsl:variable>
		<xsl:variable name="defaultServiceList">
			<xsl:value-of select="substring-after($defaultServiceList, '@')" />
		</xsl:variable>

		<!-- evaluate and recurse -->
		<xsl:if test="contains($defaultProductList, '@')">
			<xsl:call-template name="multiRenderError" >
				<xsl:with-param name="validationErrors" select="$validationErrors"/>
				<xsl:with-param name="defaultProductList" select="$defaultProductList"/>
				<xsl:with-param name="defaultServiceList" select="$defaultServiceList"/>
			</xsl:call-template>
		</xsl:if>

	</xsl:template>

	<!-- recursive named template -->
	<xsl:template name="deriveError">
		<xsl:param name="validationErrors" />
		<xsl:param name="defaultProductList" />
		<xsl:param name="defaultServiceList" />
		<xsl:param name="actualProductList" />
		<xsl:param name="actualServiceList" />

		<xsl:variable name="defaultProductId">
			<xsl:value-of select="substring-before($defaultProductList, '@')" />
		</xsl:variable>
		<xsl:variable name="service">
			<xsl:value-of select="substring-before($defaultServiceList, '@')" />
		</xsl:variable>

		<xsl:if test="not(contains($actualProductList, $defaultProductId))">
			<xsl:call-template name="renderError">
				<xsl:with-param name="validationErrors" select="$validationErrors"/>
				<xsl:with-param name="defaultProductId" select="$defaultProductId"/>
				<xsl:with-param name="service" select="$service"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:variable name="defaultProductList">
			<xsl:value-of select="substring-after($defaultProductList, '@')" />
		</xsl:variable>
		<xsl:variable name="defaultServiceList">
			<xsl:value-of select="substring-after($defaultServiceList, '@')" />
		</xsl:variable>

		<!-- evaluate and recurse -->
		<xsl:if test="contains($defaultProductList, '@')">
			<xsl:call-template name="deriveError" >
				<xsl:with-param name="validationErrors" select="$validationErrors"/>
				<xsl:with-param name="defaultProductList" select="$defaultProductList"/>
				<xsl:with-param name="defaultServiceList" select="$defaultServiceList"/>
				<xsl:with-param name="actualProductList" select="$actualProductList"/>
				<xsl:with-param name="actualServiceList" select="$actualServiceList"/>
			</xsl:call-template>
		</xsl:if>

	</xsl:template>

</xsl:stylesheet>