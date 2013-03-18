<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:encoder="xalan://java.net.URLEncoder"
	exclude-result-prefixes="soapenv xalan">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="../includes/utils.xsl"/>
	<xsl:import href="../includes/ranking.xsl"/>
	<xsl:import href="../includes/product_info.xsl"/>

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="urlRoot" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>


<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">

		<!-- TEMPORARY HACK 3 - Prevent young drivers -->

		<xsl:variable name="yngDobAdd25">
			<xsl:choose>
				<xsl:when test="$request/drivers/young/exists='Y'">
					<xsl:value-of select="concat(substring($request/drivers/young/dob,7,4) + 25 ,'-',substring($request/drivers/young/dob,4,2),'-',substring($request/drivers/young/dob,1,2))" />
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="isUnder25">
			<xsl:choose>
				<xsl:when test="translate($yngDobAdd25,'-' ,'' ) > translate($today,'-' ,'' )">Y</xsl:when>
				<xsl:otherwise>N</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>

		<!-- ACCEPTABLE -->
		<!-- TEMPORARY HACK 1 - Prevent vehicles with damage -->
		<xsl:when test="/PremiumResponse/Product/QuoteResults/QuoteResult/TotalAnnualPremium and $request/vehicle/damage != 'Y' and $isUnder25='N'">
			<xsl:apply-templates />
		</xsl:when>

		<!-- UNACCEPTABLE -->
		<xsl:otherwise>
			<results>
				<xsl:element name="price">
					<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
					<xsl:attribute name="service">REAL</xsl:attribute>
					<available>N</available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>
					<xsl:choose>
						<xsl:when test="error">
							<xsl:copy-of select="error"></xsl:copy-of>
						</xsl:when>
						<xsl:when test="string">
							<error service="Real" type="unavailable">
								<code></code>
								<message><xsl:value-of select="string"></xsl:value-of></message>
								<data></data>
								<xsl:if test="$isUnder25 ='Y'">
									<reason>Youngest Driver Under 25</reason>
								</xsl:if>
								<xsl:if test="$request/vehicle/damage ='Y'">
									<reason>Vehicle Damage</reason>
								</xsl:if>
							</error>
						</xsl:when>
						<xsl:otherwise>
							<error service="Real" type="unavailable">
								<code></code>
								<message>unavailable</message>
								<data></data>
							</error>
						</xsl:otherwise>
					</xsl:choose>

					<headlineOffer>ONLINE</headlineOffer>
					<onlinePrice>
						<lumpSumTotal>9999999999</lumpSumTotal>

						<xsl:call-template name="productInfo">
							<xsl:with-param name="productId" select="$productId" />
							<xsl:with-param name="priceType"> </xsl:with-param>
							<xsl:with-param name="kms" select="' '" />
						</xsl:call-template>
					</onlinePrice>

					<xsl:call-template name="ranking">
						<xsl:with-param name="productId">*NONE</xsl:with-param>
					</xsl:call-template>

				</xsl:element>
			</results>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/PremiumResponse">
		<results>
			<xsl:for-each select="Product">

				<xsl:for-each select="QuoteResults/QuoteResult">

					<!-- KILOMETRES -->
					<xsl:variable name="kmsYear">
						<xsl:value-of select="Benefits/Benefit/name[contains(text(),' km/year')]" />
					</xsl:variable>

					<xsl:variable name="kms">
						<xsl:value-of select="substring-before($kmsYear, ' km/year')" />
					</xsl:variable>

					<xsl:variable name="quoteUrl">
						<xsl:value-of select="concat($urlRoot,
													'?PubId=AG',
													'&amp;ProductId=1',
													'&amp;QuoteRef=',		QuoteNumber,
													'&amp;FNAME=', 			encoder:encode($request/drivers/regular/firstname),
													'&amp;LNAME=', 			encoder:encode($request/drivers/regular/surname),
													'&amp;ContactEmail=', 	encoder:encode($request/contact/email),
													'&amp;Telephone=', 		encoder:encode($request/contact/phone)
													)"/>
					</xsl:variable>

					<!-- BASE EXCESS -->
					<xsl:variable name="excess">
						<xsl:for-each select="Benefits/Benefit">
							<xsl:if test="contains(name/text(), 'Basic Excess')">
								<xsl:value-of select="value" />
							</xsl:if>
						</xsl:for-each>
					</xsl:variable>

					<xsl:element name="price">
						<xsl:attribute name="service">REAL</xsl:attribute>
						<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>

						<available>Y</available>
						<transactionId><xsl:value-of select="$transactionId"/></transactionId>

						<headlineOffer>OFFLINE</headlineOffer>
						<!-- <onlinePrice>
							<xsl:call-template name="price">
								<xsl:with-param name="premium" select="TotalAnnualPremium" />
								<xsl:with-param name="kms" select="$kms" />
							</xsl:call-template>
						</onlinePrice>			 -->
						<offlinePrice>
							<xsl:call-template name="price">
								<xsl:with-param name="premium" select="TotalAnnualPremium" />
								<xsl:with-param name="kms" select="$kms" />
							</xsl:call-template>
						</offlinePrice>

						<productDes>Pay As You Drive Option</productDes>
						<underwriter>The Hollard Insurance Company Pty Ltd ABN 78 090 584 473</underwriter>
						<brandCode>PAYD</brandCode>
						<acn>111 586 353</acn>
						<afsLicenceNo>241436</afsLicenceNo>
						<excess>
							<total><xsl:value-of select="$excess" /></total>
							<excess>
								<description>Learner Driver Excess</description>
								<amount>$800</amount>
							</excess>
							<excess>
								<description>Inexperienced Driver Excess</description>
								<amount>$800</amount>
							</excess>
							<excess>
								<description>Exceeding Kilometre Range Excess</description>
								<amount>$2,000</amount>
							</excess>

						</excess>

						<conditions>
							<condition>Indicative quote based on <xsl:value-of select="$kms"/> annual kilometres. &lt;br /&gt;This Real Insurance Quote assumes that the policy would start today.</condition>
						</conditions>

						<leadNo><!-- xsl:value-of select="QuoteNumber" / --></leadNo>
						<telNo>1300 301 918</telNo>

						<openingHours>Monday to Friday (8am-7pm EST) and Saturday (9am-5pm EST)</openingHours>

						<quoteUrl></quoteUrl>
						<pdsaUrl>legal/Real_Car_PDS_Web_13042012.pdf</pdsaUrl>
						<pdsaDesLong>Product Disclosure Statement</pdsaDesLong>
						<pdsaDesShort>PDS</pdsaDesShort>
						<pdsbUrl />
						<pdsbDesLong />
						<pdsbDesShort />
						<fsgUrl />

						<disclaimer>
							<![CDATA[
							The indicative quote includes any applicable online discount and is subject to meeting the insurers underwriting criteria and may change due to factors such as:<br>
							- Driver's history or offences or claims<br>
							- Age or licence type of additional drivers<br>
							- Vehicle condition, accessories and modifications<br>
							]]>
						</disclaimer>

						<transferring />

						<xsl:call-template name="ranking">
							<xsl:with-param name="productId" select="$productId" />
						</xsl:call-template>

					</xsl:element>
				</xsl:for-each>

			</xsl:for-each>
		</results>
	</xsl:template>
	<xsl:template name="price">
		<xsl:param name="premium" />
		<xsl:param name="kms" />

		<xsl:variable name="instalment">
			<xsl:value-of select="$premium div 12" />
		</xsl:variable>

		<xsl:variable name="instfmt">
			<!-- xsl:value-of select="format-number($instalment, '#,###.00', 'euro')"/ -->
		</xsl:variable>

		<lumpSumTotal>
			<xsl:call-template name="util_mathCeil">
				<xsl:with-param name="num" select="$premium" />
			</xsl:call-template>
		</lumpSumTotal>
		<instalmentFirst>
			<xsl:value-of select="$instalment" />
		</instalmentFirst>
		<instalmentCount>11</instalmentCount>
		<instalmentPayment>
			<xsl:value-of select="$instalment" />
		</instalmentPayment>
		<instalmentTotal>
			<xsl:call-template name="util_mathCeil">
				<xsl:with-param name="num" select="$premium" />
			</xsl:call-template>
		</instalmentTotal>

		<xsl:call-template name="productInfo">
			<xsl:with-param name="productId" select="$productId" />
			<xsl:with-param name="priceType"> </xsl:with-param>
			<xsl:with-param name="kms" select="$kms" />
		</xsl:call-template>

	</xsl:template>
</xsl:stylesheet>