<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:z="http://tempuri.org/"
	xmlns:encoder="xalan://java.net.URLEncoder"
	xmlns:a="http://schemas.datacontract.org/2004/07/Real.Aggregator.Service.DataContracts"
	exclude-result-prefixes="soap z a encoder">


<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="../../../includes/utils.xsl"/>
	<xsl:import href="../../../includes/ranking.xsl"/>
	<xsl:import href="../../../includes/get_price_availability.xsl"/>

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="urlRoot" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="kms" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">

		<xsl:variable name="productId">WOOL-01-02</xsl:variable>

		<xsl:variable name="validationErrors">
			<xsl:call-template name="validateResponse">
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>

			<!-- ACCEPTABLE -->
			<xsl:when test="$validationErrors = '' and /soap:Envelope/soap:Body/z:GetQuoteResponse/z:GetQuoteResult/a:QuoteReturned = 'true'">
				<xsl:apply-templates />
			</xsl:when>

			<!-- UNACCEPTABLE -->
			<xsl:otherwise>
				<results>
					<xsl:element name="price">
						<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
						<xsl:attribute name="service">WOOL</xsl:attribute>
						<available>
							<xsl:choose>
								<!-- Our WOOL_init_inbound has caught and re-written bad output during token authorisation, so lets set E -->
								<xsl:when test="/results/price/available = 'E'">E</xsl:when>
								<!-- In case there's server problems AFTER token handling too -->
								<!-- E is used on FE to hide the rows, as they're not having underwriting reject (value N), just technical ones -->
								<xsl:when test="error">E</xsl:when>
								<xsl:when test="/soap-response/error">E</xsl:when>
								<xsl:otherwise>N</xsl:otherwise>
							</xsl:choose>
						</available>
						<transactionId><xsl:value-of select="$transactionId"/></transactionId>
						<xsl:choose>

							<!-- In case there's server problems AFTER token handling pass the errors -->
							<xsl:when test="/error[1]">
								<xsl:copy-of select="/error[1]"></xsl:copy-of>
							</xsl:when>

							<xsl:when test="/soap-response/error[1]">
								<xsl:copy-of select="/soap-response/error[1]"></xsl:copy-of>
							</xsl:when>

							<!-- Again, WOOL_init_inbound has re-written bad output during token auth, pass the error -->
							<xsl:when test="/results/price/error">
								<xsl:copy-of select="/results/price/error"></xsl:copy-of>
							</xsl:when>

							<xsl:when test="/soap:Envelope/soap:Body/s:Fault/faultcode">
								<xsl:call-template name="error_message">
									<xsl:with-param name="service">WOOL</xsl:with-param>
									<xsl:with-param name="error_type">returned_fault</xsl:with-param>
									<xsl:with-param name="message"><xsl:value-of select="/soap:Envelope/soap:Body/s:Fault/faultcode"></xsl:value-of></xsl:with-param>
									<xsl:with-param name="code"></xsl:with-param>
									<xsl:with-param name="data"></xsl:with-param>
								</xsl:call-template>
							</xsl:when>

							<xsl:when test="/soap:Envelope/soap:Body/z:GetQuoteResponse/z:GetQuoteResult/a:QuoteReturned = 'false'">
								<xsl:call-template name="error_message">
									<xsl:with-param name="service">WOOL</xsl:with-param>
									<xsl:with-param name="error_type">unknown</xsl:with-param>
									<xsl:with-param name="message">QuoteReturned=false</xsl:with-param>
									<xsl:with-param name="code"></xsl:with-param>
									<xsl:with-param name="data"></xsl:with-param>
								</xsl:call-template>
							</xsl:when>

							<xsl:when test="$validationErrors != ''">
								<xsl:call-template name="error_message">
									<xsl:with-param name="service">WOOL</xsl:with-param>
									<xsl:with-param name="error_type">invalid</xsl:with-param>
									<xsl:with-param name="message">
									<xsl:copy-of select="$validationErrors"></xsl:copy-of>
									</xsl:with-param>
									<xsl:with-param name="code"></xsl:with-param>
									<xsl:with-param name="data"></xsl:with-param>
								</xsl:call-template>
							</xsl:when>

							<!-- FALLBACK MESSAGE -->
							<xsl:otherwise>
								<xsl:call-template name="error_message">
									<xsl:with-param name="service">WOOL</xsl:with-param>
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
								<xsl:with-param name="productId" select="$productId" />
								<xsl:with-param name="priceType"> </xsl:with-param>
								<xsl:with-param name="kms" select="$kms" />
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

<!--
For Production the following quote URL will be available:
https://quote.realinsurance.com.au/quotelines/car/referral/comparethemarket?t=<Encrypted Token>&n=<Quote Number>&p=<Product Code>
-->
	<xsl:template match="/soap:Envelope/soap:Body/z:GetQuoteResponse/z:GetQuoteResult">
		<results>
			<xsl:for-each select="a:QuoteResult/a:Quote">

				<xsl:variable name="quoteUrl">
					<xsl:value-of select="$urlRoot" />
					<xsl:text>?utm_source=comparethemarket&amp;utm_medium=referral&amp;utm_campaign=websale&amp;t=</xsl:text>
					<xsl:value-of select="encoder:encode($request/token)" />
					<xsl:text>&amp;n=</xsl:text><xsl:value-of select="a:QuoteNumber" />
					<xsl:text>&amp;p=</xsl:text><xsl:value-of select="a:Code" />
					<xsl:text>&amp;CODE=WOWCTM</xsl:text>
				</xsl:variable>

				<xsl:variable name="productId">
					<xsl:choose>
						<xsl:when test="a:ProductName = 'Comprehensive'">WOOL-01-02</xsl:when>
						<xsl:otherwise>WOOL-01-01</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="newKms">
					<xsl:value-of select="translate(a:OfferTerms,'Ofer TmsoKM','')" />
				</xsl:variable>

				<xsl:element name="price">
					<xsl:attribute name="service">WOOL</xsl:attribute>
					<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>

					<available>Y</available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>

					<headlineOffer>ONLINE</headlineOffer>

					<onlineAvailable>Y</onlineAvailable>
					<offlineAvailable>Y</offlineAvailable>

					<callbackAvailable>
						<xsl:call-template name="getPriceAvailability">
							<xsl:with-param name="productId" select="$productId" />
							<xsl:with-param name="priceType">CALLBACK</xsl:with-param>
							<xsl:with-param name="hasModifications">N</xsl:with-param>
						</xsl:call-template>
					</callbackAvailable>
					<callbackAvailableWithModifications>
						<xsl:call-template name="getPriceAvailability">
							<xsl:with-param name="productId" select="$productId" />
							<xsl:with-param name="priceType">CALLBACK</xsl:with-param>
							<xsl:with-param name="hasModifications">Y</xsl:with-param>
						</xsl:call-template>
					</callbackAvailableWithModifications>

					<onlinePrice>
						<xsl:call-template name="price">
							<xsl:with-param name="premium" select="a:AnnualPremium" />
							<xsl:with-param name="monthlyPremium" select="a:MonthlyPremium" />
							<xsl:with-param name="kms" select="$newKms" />
							<xsl:with-param name="productId" select="$productId" />
						</xsl:call-template>
					</onlinePrice>
					<offlinePrice>
						<xsl:call-template name="price">
							<xsl:with-param name="premium" select="a:AnnualPremium" />
							<xsl:with-param name="monthlyPremium" select="a:MonthlyPremium" />
							<xsl:with-param name="kms" select="$newKms" />
							<xsl:with-param name="productId" select="$productId" />
						</xsl:call-template>
					</offlinePrice>

					<discount>
							<online></online>
							<offline></offline>
					</discount>

					<xsl:choose>
						<!-- Differing fields for Pay As You Drive (WOOL-01-01) -->
						<xsl:when test="a:Code = 'PAYD'">
							<conditions>
								<condition>
									Indicative quote based on <xsl:value-of select="$newKms"/> annual kilometres.
								</condition>
							</conditions>
							<productDes>Woolworths Drive less pay less</productDes>
							<disclaimer>
								<![CDATA[
								The indicative quote includes any applicable online discount and is subject to meeting the insurer's underwriting criteria and may change due to factors such as:<br>
								- Driver's history or offences or claims<br>
								- Age or licence type of additional drivers<br>
								- Vehicle condition, accessories and modifications<br>
								]]>
							</disclaimer>
							<excess>
								<total><xsl:value-of select="a:BasicExcess" /></total>
							</excess>
							<pdsaUrl>http://insurance.woolworths.com.au/sites/default/files/Woolworths_Car%20Insurance_PDS.pdf</pdsaUrl>
						</xsl:when>

						<!-- Differing fields for Comprehensive (WOOL-01-02) -->
						<xsl:otherwise>
							<conditions/>
							<productDes>Woolworths Comprehensive</productDes>
							<disclaimer>The indicative quote includes any applicable online discount and is subject to meeting the insurer's underwriting criteria and may change due to factors such as:&lt;br&gt;- Driver's history or offences or claims&lt;br&gt;- Age or licence type of additional drivers&lt;br&gt;- Vehicle condition, accessories and modifications&lt;br&gt;</disclaimer>
							<excess>
								<base><xsl:value-of select="a:BasicExcess" /></base>
								<total><xsl:value-of select="a:BasicExcess" /></total>
							</excess>
							<pdsaUrl>http://insurance.woolworths.com.au/sites/default/files/Woolworths_Car%20Insurance_PDS.pdf</pdsaUrl>
						</xsl:otherwise>
					</xsl:choose>

					<!-- Where??? Awarded Money magazine's Best of the Best 2013 award for Cheapest Car Insurance for our Comprehensive cover. -->

					<underwriter>The Hollard Insurance Company Pty Ltd ABN 78 090 584 473</underwriter>
					<brandCode>WOOL</brandCode>
					<acn>111 586 353</acn>
					<afsLicenceNo>241436</afsLicenceNo>


					<leadNo><xsl:value-of select="a:QuoteNumber" /></leadNo>
					<telNo>1300 782 182</telNo>

					<openingHours>Monday to Friday (8am-8pm EST) and Saturday (9am-5pm EST)</openingHours>

					<quoteUrl><xsl:value-of select="$quoteUrl" /></quoteUrl>
					<pdsaDesLong>Product Disclosure Statement</pdsaDesLong>
					<pdsaDesShort>PDS</pdsaDesShort>
					<pdsbUrl />
					<pdsbDesLong />
					<pdsbDesShort />
					<fsgUrl />

					<transferring />

					<xsl:call-template name="ranking">
						<xsl:with-param name="productId" select="$productId" />
					</xsl:call-template>

					<name><xsl:value-of select="a:ProductName" /></name>
					<des><xsl:value-of select="a:Description" /></des>
					<feature><xsl:value-of select="a:SpecialConditions" /></feature>
					<info><xsl:value-of select="a:ShortDescription" /></info>
					<terms><xsl:value-of select="a:OfferTerms" /></terms>

				</xsl:element>
			</xsl:for-each>
		</results>
	</xsl:template>

	<xsl:template name="price">
		<xsl:param name="premium" />
		<xsl:param name="monthlyPremium" />
		<xsl:param name="kms" />
		<xsl:param name="productId" />
		<lumpSumTotal>
			<xsl:call-template name="util_mathCeil">
				<xsl:with-param name="num" select="$premium" />
			</xsl:call-template>
		</lumpSumTotal>
		<instalmentFirst><xsl:value-of select="format-number(a:MonthlyPremium,'#.##')" /></instalmentFirst>
		<instalmentCount>11</instalmentCount>
		<instalmentPayment><xsl:value-of select="format-number(a:MonthlyPremium,'#.##')" /></instalmentPayment>
		<instalmentTotal><xsl:value-of select="format-number(a:MonthlyPremium * 12,'#.##')" /></instalmentTotal>
		<xsl:call-template name="productInfo">
			<xsl:with-param name="productId"><xsl:value-of select="$productId" /></xsl:with-param>
			<xsl:with-param name="priceType"> </xsl:with-param>
			<xsl:with-param name="kms" select="translate(a:OfferTerms,'Ofer TmsoKM','')" />
		</xsl:call-template>

	</xsl:template>

	<!-- VALIDATION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<xsl:template name="validateResponse">

		<xsl:if test="/soap:Envelope/soap:Body/z:GetQuoteResponse/z:GetQuoteResult/a:QuoteReturned = 'true'">

			<!-- Missing quote -->
			<xsl:if test="not(/soap:Envelope/soap:Body/z:GetQuoteResponse/z:GetQuoteResult/a:QuoteResult/a:Quote)">
				<validationError>MISSING: /a:GetQuoteResult/a:Quote,</validationError>
			</xsl:if>

			<xsl:for-each select="/soap:Envelope/soap:Body/z:GetQuoteResponse/z:GetQuoteResult/a:QuoteResult/a:Quote">

				<!-- Product name -->
				<xsl:if test="not(a:ProductName)">
					<validationError>MISSING: /a:ProductName <xsl:value-of select="position()" />,</validationError>
				</xsl:if>

				<!-- Offer terms -->
				<xsl:if test="not(a:OfferTerms)">
					<validationError>MISSING: /a:OfferTerms <xsl:value-of select="position()" />,</validationError>
				</xsl:if>

				<!-- Excess -->
				<xsl:if test="not(a:BasicExcess)">
					<validationError>MISSING: /a:BasicExcess <xsl:value-of select="position()" />,</validationError>
				</xsl:if>

				<!-- Annual Premium -->
				<xsl:if test="not(a:AnnualPremium)">
					<validationError>MISSING: /a:AnnualPremium <xsl:value-of select="position()" />,</validationError>
				</xsl:if>

				<!-- Annual Premium -->
				<xsl:if test="not(a:MonthlyPremium)">
					<validationError>MISSING: /a:MonthlyPremium <xsl:value-of select="position()" />,</validationError>
				</xsl:if>

			</xsl:for-each>

		</xsl:if>

	</xsl:template>

	<xsl:template name="productInfo">
		<xsl:param name="productId" />
		<xsl:param name="priceType" />
		<xsl:param name="kms" />

		<xsl:choose>

			<!-- WOOL #1 -->
			<xsl:when test="$productId = 'WOOL-01-01'">
				<name>Woolworths Drive Less Pay Less</name>
				<des><![CDATA[
					Available to people who drive less than average for their age and postcode. See how this can lower your comprehensive insurance premium.
					]]>
				</des>
				<feature>
					<![CDATA[
						Get a $100 WISH Gift Card.<sup>#</sup>
					]]>
				</feature>
				<info>
					<![CDATA[

					]]>
				</info>
				<terms>
					<![CDATA[
						<p>
							<sup>#</sup>$100 Woolworths Insurance WISH Gift Card, for use at participating stores only, listed at www.everydaygiftcards.com.au. Card sent within 45 days of your first monthly/annual premium being paid. Terms of use apply, which includes 12 months to spend the full $100 value stored on the Card. The offer is applied to policies purchased from 1 October 2014 and ends 30 January 2015.
						</p>
						<p>
							Benefits are subject to the terms and conditions including the limits and exclusions of the insurance policy. Cover is issued by The Hollard Insurance Company Pty Ltd ABN 78 090 584 473 AFSL No. 241436 (Hollard). Woolworths Ltd ABN 88 000 014 675 AR No. 245476 (Woolworths) acts as Hollard's Authorised Representative. Any advice provided is general only and may not be right for you. Before you purchase this product you should carefully read the Combined Product Disclosure Statement and Financial Services Guide (Combined PDS FSG) to decide if it is right for you.
						</p>
					]]>
				</terms>
				<carbonOffset />
				<kms><xsl:value-of select="$kms" /></kms>

			</xsl:when>
			<!-- WOOL #2 -->
			<xsl:when test="$productId = 'WOOL-01-02'">
				<name>Woolworths Comprehensive</name>
				<des><![CDATA[
					Thorough cover from bonnet to boot. Super insurance at a low supermarket price.
					]]>
				</des>
				<feature>
					<![CDATA[
						Get a $100 WISH Gift Card.<sup>#</sup>
					]]>
				</feature>
				<info>
					<![CDATA[
					]]>
				</info>
				<terms>
					<![CDATA[
						<p>
							<sup>#</sup>$100 Woolworths Insurance WISH Gift Card, for use at participating stores only, listed at www.everydaygiftcards.com.au. Card sent within 45 days of your first monthly/annual premium being paid. Terms of use apply, which includes 12 months to spend the full $100 value stored on the Card. The offer is applied to policies purchased from 1 October 2014 and ends 30 January 2015.
						</p>
						<p>
							Benefits are subject to the terms and conditions including the limits and exclusions of the insurance policy. Cover is issued by The Hollard Insurance Company Pty Ltd ABN 78 090 584 473 AFSL No. 241436 (Hollard). Woolworths Ltd ABN 88 000 014 675 AR No. 245476 (Woolworths) acts as Hollard's Authorised Representative. Any advice provided is general only and may not be right for you. Before you purchase this product you should carefully read the Combined Product Disclosure Statement and Financial Services Guide (Combined PDS FSG) to decide if it is right for you.
						</p>
					]]>
				</terms>
				<carbonOffset />
				<kms><xsl:value-of select="$kms" /></kms>

			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>