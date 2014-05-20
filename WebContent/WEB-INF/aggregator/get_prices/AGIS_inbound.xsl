<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="../includes/ranking.xsl"/>
	<xsl:import href="../includes/utils.xsl"/>
	<xsl:import href="../includes/get_price_availability.xsl"/>
	<xsl:import href="../includes/product_info.xsl"/>

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId">*NONE</xsl:param>
	<xsl:param name="defaultProductId"><xsl:value-of select="$productId" /></xsl:param>
	<xsl:param name="service"></xsl:param>
	<xsl:param name="certServer"></xsl:param>
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">


		<xsl:choose>
		<!-- ACCEPTABLE -->

		<xsl:when test="/soapenv:Envelope/soapenv:Body/response/quoteList/quote/onlinePrice/lumpSumPayable">
			<xsl:apply-templates />
		</xsl:when>
		<xsl:when test="/soapenv:Envelope/soapenv:Body/response/quoteList/quote/offlinePrice/lumpSumPayable">
			<xsl:apply-templates />
		</xsl:when>

		<!-- UNACCEPTABLE -->
		<xsl:otherwise>
			<results>
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
						<xsl:call-template name="productInfo">
							<xsl:with-param name="productId" select="$defaultProductId" />
							<xsl:with-param name="priceType" select="headline" />
							<xsl:with-param name="kms" select="''" />
						</xsl:call-template>

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




				<xsl:element name="price">
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
						<xsl:call-template name="getPriceAvailability">
							<xsl:with-param name="productId" select="$priceProductId" />
							<xsl:with-param name="priceType">ONLINE</xsl:with-param>
							<xsl:with-param name="hasModifications">N</xsl:with-param>
						</xsl:call-template>
					</onlineAvailable>
					<onlineAvailableWithModifications>
						<xsl:call-template name="getPriceAvailability">
							<xsl:with-param name="productId" select="$priceProductId" />
							<xsl:with-param name="priceType">ONLINE</xsl:with-param>
							<xsl:with-param name="hasModifications">Y</xsl:with-param>
						</xsl:call-template>
					</onlineAvailableWithModifications>

					<offlineAvailable>
						<xsl:call-template name="getPriceAvailability">
							<xsl:with-param name="productId" select="$priceProductId" />
							<xsl:with-param name="priceType">OFFLINE</xsl:with-param>
							<xsl:with-param name="hasModifications">N</xsl:with-param>
						</xsl:call-template>
					</offlineAvailable>
					<offlineAvailableWithModifications>
						<xsl:call-template name="getPriceAvailability">
							<xsl:with-param name="productId" select="$priceProductId" />
							<xsl:with-param name="priceType">OFFLINE</xsl:with-param>
							<xsl:with-param name="hasModifications">Y</xsl:with-param>
						</xsl:call-template>
					</offlineAvailableWithModifications>

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
					<brandCode><xsl:value-of select="brand/code" /></brandCode>
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
							<xsl:when test="brand/code = 'EXPO'">
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
									<xsl:value-of select="brand/code" />-<xsl:value-of select="underwriter/code" />-<xsl:value-of select="product/code" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
					</xsl:call-template>

					<discount>
						<online>
							<xsl:choose>
								<xsl:when test="brand/code = 'BUDD'">20</xsl:when>
								<xsl:when test="brand/code = 'VIRG'"></xsl:when>
								<xsl:when test="brand/code = 'EXDD'">10</xsl:when>
								<xsl:when test="brand/code = '1FOW'"></xsl:when>
								<xsl:when test="brand/code = 'OZIC'"></xsl:when>
								<xsl:when test="brand/code = 'EXPO'">20</xsl:when>
								<xsl:when test="brand/code = 'IECO'"></xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</online>
						<offline>
							<xsl:choose>
								<xsl:when test="brand/code = 'BUDD'">10</xsl:when>
								<xsl:when test="brand/code = 'VIRG'"></xsl:when>
								<xsl:when test="brand/code = 'EXDD'">10</xsl:when>
								<xsl:when test="brand/code = '1FOW'"></xsl:when>
								<xsl:when test="brand/code = 'OZIC'"></xsl:when>
								<xsl:when test="brand/code = 'EXPO'">10</xsl:when>
								<xsl:when test="brand/code = 'IECO'"></xsl:when>
								<xsl:otherwise></xsl:otherwise>
							</xsl:choose>
						</offline>
					</discount>

				</xsl:element>
			</xsl:for-each>

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
			<instalmentTotal>
				<xsl:call-template name="util_mathCeil">
					<xsl:with-param name="num" select="$price/totalAmount" />
				</xsl:call-template>
			</instalmentTotal>

			<!-- Product Information  -->
			<xsl:choose>
				<xsl:when test="brand/code = 'EXDD' or brand/code = 'EXPO'">
			<name><xsl:value-of select="$price/name" /></name>
			<des><xsl:value-of select="$price/des" /></des>
			<feature><xsl:value-of select="$price/feature" /></feature>
			<info><xsl:value-of select="$price/info" /></info>
			<terms><xsl:value-of select="$price/terms" /></terms>
					<carbonOffset />
					<kms />
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="productInfo">
						<xsl:with-param name="productId" select="$productId" />
						<xsl:with-param name="priceType" select="headline" />
						<xsl:with-param name="kms" select="''" />
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>


<!--
			<name><xsl:value-of select="$price/name" /></name>
			<des><xsl:value-of select="$price/des" /></des>
			<feature><xsl:value-of select="$price/feature" /></feature>
			<info><xsl:value-of select="$price/info" /></info>
			<terms><xsl:value-of select="$price/terms" /></terms>
			<carbonOffset />
			<kms />
			 <xsl:choose>
				<xsl:when test="carbonOffset = ''">
					<terms><xsl:value-of select="$price/terms" /></terms>
					<carbonOffset />
					<kms />
				</xsl:when>
				<xsl:otherwise>
-->
					<!-- insert the carbon offset value -->
<!--
					<terms>
						<xsl:call-template name="util_replace">
							<xsl:with-param name="text"  select="$price/terms" />
							<xsl:with-param name="replace">[offset]</xsl:with-param>
							<xsl:with-param name="with" select="$carbonOffset" />
						</xsl:call-template>
					</terms>
					<carbonOffset><xsl:value-of select="$carbonOffset" /></carbonOffset>
					<kms />
				</xsl:otherwise>
			</xsl:choose>
-->
		</xsl:element>

	</xsl:template>

</xsl:stylesheet>