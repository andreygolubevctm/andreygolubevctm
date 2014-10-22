<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:z="http://tempuri.org/"
	xmlns:encoder="xalan://java.net.URLEncoder"
	xmlns:a="http://schemas.datacontract.org/2004/07/Real.Aggregator.Service.DataContracts"
	exclude-result-prefixes="soap z a encoder">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="../../includes/utils.xsl"/>
	<xsl:import href="../includes/get_price_availability.xsl"/>
	<xsl:import href="../includes/hollard_product_details.xsl"/>

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="service"/>
	<xsl:param name="request" />
	<xsl:param name="transactionId">*NONE</xsl:param>

	<!-- Temporary Hard Coding until Hollard gives us some proper error information -->
	<xsl:variable name="productName">
		<xsl:choose>
			<xsl:when test="$service = 'WOOL'">Woolworths And Contents Insurance</xsl:when>
			<xsl:when test="$service = 'REIN'">Real Home &amp; Contents Insurance</xsl:when>
		</xsl:choose>
	</xsl:variable>


<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">

		<xsl:variable name="validationErrors">
			<xsl:call-template name="validateResponse">
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<!-- ACCEPTABLE -->
			<xsl:when test="$validationErrors = '' and /soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteReturned = 'true'">
				<xsl:apply-templates />
			</xsl:when>

			<!-- UNACCEPTABLE -->
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$service = ''">
						<xsl:variable name="initService">
							<xsl:value-of select="substring-before(soap-response/error/@service, 'INIT')" />
						</xsl:variable>

						<xsl:variable name="productId"><xsl:value-of select="$initService" />-02-01</xsl:variable>
						<xsl:variable name="productName">
							<xsl:choose>
								<xsl:when test="$initService = 'WOOL'">Woolworths And Contents Insurance</xsl:when>
								<xsl:when test="$initService = 'REIN'">Real Home &amp; Contents Insurance</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<results>
							<xsl:element name="result">
								<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
								<xsl:attribute name="service"><xsl:value-of select="$initService" /></xsl:attribute>
								<productAvailable>N</productAvailable>
								<xsl:copy-of select="soap-response" />
								<headline>
									<name><xsl:value-of select="$productName" /></name>
									<feature/>
								</headline>
								<brandCode><xsl:value-of select="$service" /></brandCode>
							</xsl:element>
						</results>
					</xsl:when>
					<xsl:otherwise>
						<results>
							<xsl:variable name="productId"><xsl:value-of select="$service" />-02-01</xsl:variable>
							<xsl:element name="result">
								<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
								<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
								<xsl:attribute name="type">quote</xsl:attribute>
								<productAvailable>
									<xsl:choose>
										<!-- Our REIN_init_inbound has caught and re-written bad output during token authorisation, so lets set E
										<xsl:when test="/results/price/available = 'E'">E</xsl:when>
										In case there's server problems AFTER token handling too
										E is used on FE to hide the rows, as they're not having underwriting reject (value N), just technical ones -->
										<xsl:when test="error">E</xsl:when>
										<xsl:when test="/soap-response/error">E</xsl:when>
										<xsl:otherwise>N</xsl:otherwise>
									</xsl:choose>
								</productAvailable>
								<transactionId><xsl:value-of select="$transactionId"/></transactionId>

								<xsl:choose>
									<!-- In case there's server problems AFTER token handling pass the errors -->
									<xsl:when test="/error[1]">
										<xsl:copy-of select="/error[1]"></xsl:copy-of>
									</xsl:when>

									<xsl:when test="/soap-response/error[1]">
										<xsl:copy-of select="/soap-response/error[1]"></xsl:copy-of>
									</xsl:when>

									<!-- Again, init_inbound has re-written bad output during token auth, pass the error -->
									<xsl:when test="/results/price/error">
										<xsl:copy-of select="/results/price/error"></xsl:copy-of>
									</xsl:when>

									<xsl:when test="/soap:Envelope/soap:Body/soap:Fault/faultcode">
										<xsl:call-template name="error_message">
											<xsl:with-param name="service"><xsl:value-of select="$service" /></xsl:with-param>
											<xsl:with-param name="error_type">returned_fault</xsl:with-param>
											<xsl:with-param name="message"><xsl:value-of select="/soap:Envelope/soap:Body/soap:Fault/faultcode"></xsl:value-of></xsl:with-param>
											<xsl:with-param name="code"></xsl:with-param>
											<xsl:with-param name="data"></xsl:with-param>
										</xsl:call-template>
									</xsl:when>

									<xsl:when test="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteReturned = 'false'">
										<xsl:call-template name="error_message">
											<xsl:with-param name="service"><xsl:value-of select="$service" /></xsl:with-param>
											<xsl:with-param name="error_type">unknown</xsl:with-param>
											<xsl:with-param name="message">QuoteReturned=false</xsl:with-param>
											<xsl:with-param name="code"></xsl:with-param>
											<xsl:with-param name="data"></xsl:with-param>
										</xsl:call-template>
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

									<!-- FALLBACK MESSAGE -->
									<xsl:otherwise>
										<xsl:call-template name="error_message">
											<xsl:with-param name="service"><xsl:value-of select="$service" /></xsl:with-param>
											<xsl:with-param name="error_type">unknown</xsl:with-param>
											<xsl:with-param name="message"></xsl:with-param>
											<xsl:with-param name="code"></xsl:with-param>
											<xsl:with-param name="data"></xsl:with-param>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>

								<headline>
									<name><xsl:value-of select="$productName" /></name>
									<feature/>
								</headline>
								<brandCode><xsl:value-of select="$service" /></brandCode>
							</xsl:element>
						</results>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!--
For Production the following quote URL will be available:
https://quote.realinsurance.com.au/quotelines/car/referral/comparethemarket?t=<Encrypted Token>&n=<Quote Number>&p=<Product Code>
-->
	<xsl:template match="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse">
		<results>
			<xsl:for-each select="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteResult/a:Quote">

				<xsl:variable name="productId">
					<xsl:choose>
						<xsl:when test="a:Code = 'ESS'"><xsl:value-of select="$service" />-02-01</xsl:when>
						<xsl:otherwise><xsl:value-of select="$service" />-02-02</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="currentProduct"><xsl:value-of select="/" /></xsl:variable>

				<xsl:variable name="productType">
					<xsl:choose>
						<xsl:when test="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Product = 'Home' and /soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Product = 'Contents'">HHZ</xsl:when>
						<xsl:when test="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Product = 'Home'">HHB</xsl:when>
						<xsl:when test="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Product = 'Contents'">HHC</xsl:when>
					</xsl:choose>
				</xsl:variable>

				<xsl:element name="result">
					<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
					<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
					<xsl:attribute name="type">quote</xsl:attribute>

					<productAvailable>Y</productAvailable>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>

					<headlineOffer>ONLINE</headlineOffer>
					<leadNo><xsl:value-of select="a:QuoteNumber" /></leadNo>

					<onlineAvailable>
						<xsl:call-template name="getPriceAvailability">
							<xsl:with-param name="productId" select="$productId" />
							<xsl:with-param name="priceType">ONLINE</xsl:with-param>
						</xsl:call-template>
					</onlineAvailable>

					<offlineAvailable>
						<xsl:call-template name="getPriceAvailability">
							<xsl:with-param name="productId" select="$productId" />
							<xsl:with-param name="priceType">OFFLINE</xsl:with-param>
						</xsl:call-template>
					</offlineAvailable>

					<callbackAvailable>
						<xsl:call-template name="getPriceAvailability">
							<xsl:with-param name="productId" select="$productId" />
							<xsl:with-param name="priceType">CALLBACK</xsl:with-param>
						</xsl:call-template>
					</callbackAvailable>

					<price>
						<xsl:call-template name="priceInfo">
							<xsl:with-param name="price" select="/" />
						</xsl:call-template>
					</price>

					<headline>
						<name><xsl:value-of select="a:ProductName" /></name>
						<description><xsl:value-of select="a:MainText" /></description>
						<offer><xsl:value-of select="a:CompareText" /></offer>
						<info><xsl:value-of select="a:ShortDescription" /></info>
						<terms><xsl:value-of select="a:OfferTerms" /></terms>
					</headline>

					<!-- Build each product (Building & Contents) -->
					<xsl:call-template name="productType" >
						<xsl:with-param name="type">HHB</xsl:with-param>
						<xsl:with-param name="value" select="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Product[text() = 'Home']/following-sibling::a:Value"/>
						<xsl:with-param name="component" select="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Product[text() = 'Home']"/>
					</xsl:call-template>
					<xsl:call-template name="productType" >
						<xsl:with-param name="type">HHC</xsl:with-param>
						<xsl:with-param name="value" select="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Product[text() = 'Contents']/following-sibling::a:Value"/>
						<xsl:with-param name="component" select="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Product[text() = 'Contents']"/>
					</xsl:call-template>

					<xsl:call-template name="productDetails" >
						<xsl:with-param name="productId" select="$productId" />
						<xsl:with-param name="productType"><xsl:value-of select="$productType"></xsl:value-of></xsl:with-param>
					</xsl:call-template>

					<name><xsl:value-of select="a:ProductName" /></name>
					<des><xsl:value-of select="a:MainText" /></des>
					<feature><xsl:value-of select="a:CompareText" /></feature>
					<info><xsl:value-of select="a:ShortDescription" /></info>
					<terms><xsl:value-of select="a:OfferTerms" /></terms>

					<discount>
						<online>
							<xsl:choose>
								<xsl:when test="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Product = 'Home' and /soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Product = 'Contents'">99</xsl:when>
								<xsl:when test="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Product = 'Home'">99</xsl:when>
								<xsl:when test="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Product = 'Contents'">99</xsl:when>
							</xsl:choose>
						</online>
						<offline>
							<xsl:choose>
								<xsl:when test="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Product = 'Home' and /soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Product = 'Contents'">99</xsl:when>
								<xsl:when test="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Product = 'Home'">99</xsl:when>
								<xsl:when test="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Product = 'Contents'">99</xsl:when>
							</xsl:choose>
						</offline>
					</discount>

				</xsl:element>
			</xsl:for-each>
		</results>
	</xsl:template>

	<xsl:template name="priceInfo">
		<xsl:param name="price"/>
		<annual>
			<xsl:choose>
				<xsl:when test="a:PaymentOptions/a:PriceBreakdown[a:Category = 'Annual'] and
								a:PaymentOptions/a:PriceBreakdown[a:Category = 'Annual'] != ''">
					<available>Y</available>
					<total>
						<xsl:call-template name="util_mathCeil">
								<xsl:with-param name="num" select="a:PaymentOptions/a:PriceBreakdown/a:Category[text() = 'Annual']/following-sibling::a:TotalAmountPaid" />
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
				<xsl:when test="a:PaymentOptions/a:PriceBreakdown[a:Category = 'Monthly'] and
								a:PaymentOptions/a:PriceBreakdown[a:Category = 'Monthly'] != ''">

					<available>Y</available>

					<firstPayment><xsl:value-of select="format-number(a:PaymentOptions/a:PriceBreakdown/a:Category[text() = 'Monthly']/following-sibling::a:FirstPayment,'#.00')" /></firstPayment>
					<paymentNumber><xsl:value-of select="a:PaymentOptions/a:PriceBreakdown/a:Category[text() = 'Monthly']/following-sibling::a:NumberOfAdditionalPayments" /></paymentNumber>
					<amount><xsl:value-of select="format-number(a:PaymentOptions/a:PriceBreakdown/a:Category[text() = 'Monthly']/preceding-sibling::a:AdditionalPayment,'#.00')" /></amount>
					<total><xsl:value-of select="format-number(a:PaymentOptions/a:PriceBreakdown/a:Category[text() = 'Monthly']/following-sibling::a:TotalAmountPaid,'#.00')" /></total>

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
		<xsl:param name="value"/>
		<xsl:param name="component"/>
			<xsl:choose>
				<xsl:when test="$type != ''">
					<xsl:element name="{$type}">
						<description>
							<xsl:choose>
								<xsl:when test="$component != ''">
									<xsl:value-of select="$type" />
								</xsl:when>
							</xsl:choose>
						</description>
						<excess>
							<amount><xsl:value-of select="$value" /></amount>
						</excess>
						<insuredValues></insuredValues> <!-- Hollard don't pass this back.... -->
					</xsl:element>
				</xsl:when>
			</xsl:choose>
	</xsl:template>

	<!-- VALIDATION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<xsl:template name="validateResponse">

		<!-- Check that we have a quote, otherwise do nothing and let other -->
		<!-- processes handle the error (since it's not a validation problem anymore). -->
		<xsl:if test="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteReturned = 'true'">
			<xsl:for-each select="/soap:Envelope/soap:Body/z:GetHomeQuoteResponse/z:GetHomeQuoteResult/a:QuoteResult/a:Quote">
				<xsl:if test="not(a:AnnualPremium)">
					<validationError>MISSING: /a:AnnualPremium <xsl:value-of select="position()" />,</validationError>
				</xsl:if>
				<xsl:if test="not(a:MainText)">
					<validationError>MISSING: /a:MainText <xsl:value-of select="position()" />,</validationError>
				</xsl:if>
				<xsl:if test="not(a:MonthlyPremium)">
					<validationError>MISSING: /a:MonthlyPremium <xsl:value-of select="position()" />,</validationError>
				</xsl:if>
				<xsl:if test="not(a:OfferTerms)">
					<validationError>MISSING: /a:OfferTerms <xsl:value-of select="position()" />,</validationError>
				</xsl:if>
				<xsl:if test="not(a:ProductName)">
					<validationError>MISSING: /a:ProductName <xsl:value-of select="position()" />,</validationError>
				</xsl:if>
				<xsl:if test="not(a:QuoteNumber)">
					<validationError>MISSING: /a:QuoteNumber <xsl:value-of select="position()" />,</validationError>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>