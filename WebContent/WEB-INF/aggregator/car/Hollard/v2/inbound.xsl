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

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="urlRoot" />
	<xsl:param name="service" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="kms" />
	<xsl:param name="transactionId">*NONE</xsl:param>

	<!-- <xsl:variable name="request" select="document('../../../rating/car/Example_Req_In.xml')" /> -->

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">

		<xsl:variable name="productId"><xsl:value-of select="$service"/>-01-02</xsl:variable>

		<xsl:variable name="validationErrors">
			<xsl:call-template name="validateResponse">
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<!-- ACCEPTABLE -->
			<xsl:when test="$validationErrors = '' and /soap:Envelope/soap:Body/z:GetMotorQuoteResponse/z:GetMotorQuoteResult/a:QuoteReturned = 'true'">
				<xsl:apply-templates />
			</xsl:when>

			<!-- UNACCEPTABLE -->
			<xsl:otherwise>
				<results>
					<xsl:element name="price">
						<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
						<xsl:attribute name="service"><xsl:value-of select="$service"/></xsl:attribute>
						<available>
							<xsl:choose>
								<!-- Our init_inbound has caught and re-written bad output during token authorisation, so lets set E -->
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

							<!-- Again, init_inbound has re-written bad output during token auth, pass the error -->
							<xsl:when test="/results/price/error">
								<xsl:copy-of select="/results/price/error"></xsl:copy-of>
							</xsl:when>

							<xsl:when test="/soap:Envelope/soap:Body/soap:Fault/faultcode">
								<xsl:call-template name="error_message">
									<xsl:with-param name="service"><xsl:value-of select="$service"/></xsl:with-param>
									<xsl:with-param name="error_type">returned_fault</xsl:with-param>
									<xsl:with-param name="message"><xsl:value-of select="/soap:Envelope/soap:Body/soap:Fault/faultcode"></xsl:value-of></xsl:with-param>
									<xsl:with-param name="code"></xsl:with-param>
									<xsl:with-param name="data"></xsl:with-param>
								</xsl:call-template>
							</xsl:when>

							<xsl:when test="/soap:Envelope/soap:Body/z:GetMotorQuoteResponse/z:GetMotorQuoteResult/a:QuoteReturned = 'false'">
								<xsl:call-template name="error_message">
									<xsl:with-param name="service">${service}</xsl:with-param>
									<xsl:with-param name="error_type">unknown</xsl:with-param>
									<xsl:with-param name="message">QuoteReturned=false</xsl:with-param>
									<xsl:with-param name="code"></xsl:with-param>
									<xsl:with-param name="data"></xsl:with-param>
								</xsl:call-template>
							</xsl:when>

							<xsl:when test="$validationErrors != ''">
								<xsl:call-template name="error_message">
									<xsl:with-param name="service"><xsl:value-of select="$service"/></xsl:with-param>
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
									<xsl:with-param name="service"><xsl:value-of select="$service"/></xsl:with-param>
									<xsl:with-param name="error_type">unknown</xsl:with-param>
									<xsl:with-param name="message"></xsl:with-param>
									<xsl:with-param name="code"></xsl:with-param>
									<xsl:with-param name="data"></xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>

						<headlineOffer>ONLINE</headlineOffer>

						<xsl:call-template name="ranking">
							<xsl:with-param name="productId">*NONE</xsl:with-param>
						</xsl:call-template>

					</xsl:element>
				</results>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- QUOTE DATA ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<xsl:template match="/soap:Envelope/soap:Body/z:GetMotorQuoteResponse/z:GetMotorQuoteResult/a:QuoteExcess">
	</xsl:template>

	<xsl:template match="/soap:Envelope/soap:Body/z:GetMotorQuoteResponse/z:GetMotorQuoteResult/a:QuoteReturned">
	</xsl:template>

	<xsl:template match="/soap:Envelope/soap:Body/z:GetMotorQuoteResponse/z:GetMotorQuoteResult/a:QuoteResult">

		<results>
			<xsl:for-each select="a:Quote">

				<xsl:variable name="productId">
					<xsl:choose>
						<xsl:when test="a:Code = 'COMP'"><xsl:value-of select="$service"/>-01-02</xsl:when>
						<xsl:otherwise><xsl:value-of select="$service"/>-01-01</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:element name="price">
					<xsl:attribute name="service"><xsl:value-of select="$service"/></xsl:attribute>
					<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
					<xsl:attribute name="type">quote</xsl:attribute>

					<available>Y</available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>

					<headlineOffer>ONLINE</headlineOffer>

					<onlineAvailable>Y</onlineAvailable>
					<offlineAvailable>Y</offlineAvailable>

					<callbackAvailable>N</callbackAvailable>
					<callbackAvailableWithModifications>N</callbackAvailableWithModifications>

					<onlinePrice>
						<xsl:call-template name="price">
							<xsl:with-param name="premium" select="a:AnnualPremium" />
						</xsl:call-template>
					</onlinePrice>
					<offlinePrice>
						<xsl:call-template name="price">
							<xsl:with-param name="premium" select="a:AnnualPremium" />
						</xsl:call-template>
					</offlinePrice>

					<discount>
							<online></online>
							<offline></offline>
					</discount>

					<excess>
						<total><xsl:value-of select="/soap:Envelope/soap:Body/z:GetMotorQuoteResponse/z:GetMotorQuoteResult/a:QuoteExcess/a:QuoteExcess/a:Value" /></total>
					</excess>

					<brandCode><xsl:value-of select="$service"/></brandCode>
					<acn>111 586 353</acn>

					<leadNo><xsl:value-of select="a:QuoteNumber" /></leadNo>
					<transferring />

					<xsl:call-template name="ranking">
						<xsl:with-param name="productId" select="$productId" />
					</xsl:call-template>

				</xsl:element>
			</xsl:for-each>
		</results>
	</xsl:template>

	<xsl:template name="price">
		<xsl:param name="premium" />
		<lumpSumTotal>
			<xsl:call-template name="util_mathCeil">
				<xsl:with-param name="num" select="$premium" />
			</xsl:call-template>
		</lumpSumTotal>
		<xsl:for-each select="a:PaymentOptions/a:PriceBreakdown" >
			<xsl:if test="a:Category = 'Monthly'">
				<instalmentFirst><xsl:value-of select="format-number(a:FirstPayment, '#.##')" /></instalmentFirst>
				<instalmentCount><xsl:value-of select="format-number(a:NumberOfAdditionalPayments, '#.##')" /></instalmentCount>
				<instalmentPayment><xsl:value-of select="format-number(a:AdditionalPayment, '#.##')" /></instalmentPayment>
				<instalmentTotal><xsl:value-of select="format-number(a:TotalAmountPaid, '#.##')" /></instalmentTotal>
			</xsl:if>
		</xsl:for-each>
		<name><xsl:value-of select="a:ProductName" /></name>
		<des><xsl:value-of select="a:MainText" /></des>
		<feature><xsl:value-of select="a:CompareText" /></feature>
		<terms><xsl:value-of select="a:OfferTerms" /></terms>
		<info></info>
	</xsl:template>

	<!-- VALIDATION ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<xsl:template name="validateResponse">

		<xsl:if test="/soap:Envelope/soap:Body/z:GetMotorQuoteResponse/z:GetMotorQuoteResult/a:QuoteReturned = 'true'">

			<!-- Missing quote -->
			<xsl:if test="not(/soap:Envelope/soap:Body/z:GetMotorQuoteResponse/z:GetMotorQuoteResult/a:QuoteResult/a:Quote)">
				<validationError>MISSING: /a:GetMotorQuoteResult/a:QuoteResult,</validationError>
			</xsl:if>

			<xsl:for-each select="/soap:Envelope/soap:Body/z:GetMotorQuoteResponse/z:GetMotorQuoteResult/a:QuoteResult/a:Quote">

				<!-- Product name -->
				<xsl:if test="not(a:ProductName)">
					<validationError>MISSING: /a:ProductName <xsl:value-of select="position()" />,</validationError>
				</xsl:if>

				<!-- Offer terms -->
				<xsl:if test="not(a:OfferTerms)">
					<validationError>MISSING: /a:OfferTerms <xsl:value-of select="position()" />,</validationError>
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
</xsl:stylesheet>