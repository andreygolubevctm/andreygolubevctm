<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/string_formatting.xsl" />
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
			<xsl:when test="/soapenv:Envelope/soapenv:Body/response/quoteList">
				<xsl:apply-templates />
			</xsl:when>

			<!-- UNACCEPTABLE -->
			<xsl:otherwise>
					<xsl:call-template name="unavailable">
						<xsl:with-param name="productId">TRAVEL-1</xsl:with-param>
					</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="soapenv:Envelope/soapenv:Body/response/header">
	</xsl:template>
	<xsl:template match="soapenv:Envelope/soapenv:Body/response/quoteList">
		<results>
			<xsl:for-each select="quote">
				<xsl:variable name="uniqueId">
					<xsl:choose>
						<xsl:when test="coverType/code = 'J'">7</xsl:when>
						<xsl:when test="coverType/code = 'G'">8</xsl:when>
						<xsl:when test="coverType/code = 'H'">9</xsl:when>
						<xsl:when test="coverType/code = 'I'">10</xsl:when>
						<xsl:when test="coverType/code = 'K'">11</xsl:when>
					</xsl:choose>
				</xsl:variable>


				<!-- Cancellation Fee -->
				<xsl:variable name="cancelFeeValue">
				<xsl:choose>
					<xsl:when test="$request/travel/policyType = 'S'">
						<xsl:choose>
							<xsl:when test="coverType/code = 'J'">7500</xsl:when><!-- Domestic -->
							<xsl:when test="coverType/code = 'G'">12500</xsl:when><!-- Essential -->
							<xsl:when test="coverType/code = 'H'">999999999</xsl:when><!-- Comprehensive -->
							<xsl:when test="coverType/code = 'I'">0</xsl:when><!-- Last Minute -->
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>999999999</xsl:otherwise> <!-- AMT -->
				</xsl:choose>
				</xsl:variable>
				<xsl:variable name="cancelFeeText">
				<xsl:choose>
					<xsl:when test="$request/travel/policyType = 'S'">
						<xsl:choose>
							<xsl:when test="coverType/code = 'J'">$7,500</xsl:when><!-- Domestic -->
							<xsl:when test="coverType/code = 'G'">$12,500</xsl:when><!-- Essential -->
							<xsl:when test="coverType/code = 'H'">Unlimited</xsl:when><!-- Comprehensive -->
							<xsl:when test="coverType/code = 'I'">Nil</xsl:when><!-- Last Minute -->
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>Unlimited</xsl:otherwise> <!-- AMT -->
				</xsl:choose>
				</xsl:variable>

				<!-- Overseas Medical Expenses -->
				<xsl:variable name="medicalValue">
				<xsl:choose>
					<xsl:when test="$request/travel/policyType = 'S'">
						<xsl:choose>
							<xsl:when test="coverType/code = 'J'">0</xsl:when><!-- Domestic -->
							<xsl:otherwise>999999999</xsl:otherwise><!-- Essential, Comprehensive, Last Minute -->
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>999999999</xsl:otherwise> <!-- AMT -->
				</xsl:choose>
				</xsl:variable>
				<xsl:variable name="medicalText">
				<xsl:choose>
					<xsl:when test="$request/travel/policyType = 'S'">
						<xsl:choose>
							<xsl:when test="coverType/code = 'J'">Nil</xsl:when><!-- Domestic -->
							<xsl:otherwise>Unlimited</xsl:otherwise><!-- Essential, Comprehensive, Last Minute -->
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>Unlimited</xsl:otherwise> <!-- AMT -->
				</xsl:choose>
				</xsl:variable>

				<!-- Luggage and Personal Effects -->
				<xsl:variable name="luggageValue">
				<xsl:choose>
					<xsl:when test="$request/travel/policyType = 'S'">
						<xsl:choose>
							<xsl:when test="coverType/code = 'J' or coverType/code = 'G'">5000</xsl:when><!-- Domestic, Essential  -->
							<xsl:when test="coverType/code = 'H'">7500</xsl:when><!-- Comprehensive -->
							<xsl:when test="coverType/code = 'I'">2500</xsl:when><!-- Last Minute -->
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>7500</xsl:otherwise> <!-- AMT -->
				</xsl:choose>
				</xsl:variable>

				<!-- A&G returns both AMT & single trips in one call so the condition below filters the products out depending on which quote type was done by the user -->
				<xsl:choose>
					<xsl:when test="($request/travel/policyType = 'S' and coverType/code != 'K') or ($request/travel/policyType = 'A' and coverType/code = 'K')">
						<xsl:element name="price">
							<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
							<xsl:attribute name="productId">
								<xsl:choose>
									<xsl:when test="$productId != '*NONE'"><xsl:value-of select="$productId" /></xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$service" />-TRAVEL-<xsl:value-of select="$uniqueId" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>

							<available>Y</available>
							<transactionId><xsl:value-of select="$transactionId"/></transactionId>
							<provider><xsl:value-of select="brand/description"/></provider>
							<trackCode>36</trackCode>
							<name><xsl:value-of select="coverType/description"/><xsl:if test="$request/travel/policyType = 'A'"> (30 Days)</xsl:if></name>
							<des><xsl:value-of select="price/des"/><xsl:text> </xsl:text><xsl:value-of select="coverType/description"/>
							<xsl:choose>
								<xsl:when test="$request/travel/policyType = 'A'"> &lt;span class="daysPerTrip"&gt;(30 Days)&lt;/span&gt;</xsl:when>
							</xsl:choose></des>
							<price><xsl:value-of select="price/premium"/></price>
							<priceText>$<xsl:value-of select="price/premium"/></priceText>
							<info>
								<cxdfee>
									<label>Cancellation Fees</label>
									<desc>Cancellation and Amendment Fees</desc>
									<value><xsl:value-of select="$cancelFeeValue" /></value>
									<text><xsl:value-of select="$cancelFeeText" /></text>
									<order/>
								</cxdfee>
								<excess>
									<label>Excess</label>
									<desc>Excess on Claims</desc>
									<value><xsl:value-of select="price/excess" /></value>
									<text>$<xsl:call-template name="formatAmount">
										<xsl:with-param name="amount" select="price/excess" />
										</xsl:call-template></text>
									<order/>
								</excess>
								<medical>
									<label>Overseas Medical</label>
									<desc>Overseas Medical and Hospital Expenses</desc>
									<value><xsl:value-of select="$medicalValue" /></value>
									<text><xsl:value-of select="$medicalText" /></text>
									<order/>
								</medical>
								<luggage>
									<label>Luggage and Personal Effects</label>
									<desc>Luggage and Personal Effects</desc>
									<value><xsl:value-of select="$luggageValue" /></value>
									<text>$<xsl:call-template name="formatAmount">
											<xsl:with-param name="amount" select="$luggageValue" />
										</xsl:call-template></text>
									<order/>
								</luggage>

								<!--  Extra Benefits -->
								<xsl:choose>
									<xsl:when test="$request/travel/policyType = 'S'">
										<xsl:choose>
											<!-- Domestic -->
											<xsl:when test="coverType/code = 'J'">
													<benefit_1>
														<label>Additional Expenses</label>
														<desc>Additional Expenses</desc>
														<value>5000</value>
														<text>$5,000</text>
														<order/>
													</benefit_1>
													<benefit_2>
														<label>Personal Liability</label>
														<desc>Personal Liability</desc>
														<value>1500000</value>
														<text>$1,500,000</text>
														<order/>
													</benefit_2>
													<benefit_3>
														<label>Rental Vehicle Excess</label>
														<desc>Rental Vehicle Excess</desc>
														<value>4000</value>
														<text>$4,000</text>
														<order/>
													</benefit_3>
											</xsl:when>
											<!-- Essential -->
											<xsl:when test="coverType/code = 'G'">
													<benefit_1>
														<label>Additional Expenses</label>
														<desc>Additional Expenses</desc>
														<value>12500</value>
														<text>$12,500</text>
														<order/>
													</benefit_1>
													<benefit_2>
														<label>Personal Liability</label>
														<desc>Personal Liability</desc>
														<value>2000000</value>
														<text>$2,000,000</text>
														<order/>
													</benefit_2>
													<benefit_3>
														<label>Rental Vehicle Excess</label>
														<desc>Rental Vehicle Excess</desc>
														<value>4000</value>
														<text>$4,000</text>
														<order/>
													</benefit_3>
											</xsl:when>
											<!-- Comprehensive -->
											<xsl:when test="coverType/code = 'H'">
													<benefit_1>
														<label>Additional Expenses</label>
														<desc>Additional Expenses</desc>
														<value>40000</value>
														<text>$40,000</text>
														<order/>
													</benefit_1>
													<benefit_2>
														<label>Personal Liability</label>
														<desc>Personal Liability</desc>
														<value>5000000</value>
														<text>$5,000,000</text>
														<order/>
													</benefit_2>
													<benefit_3>
														<label>Rental Vehicle Excess</label>
														<desc>Rental Vehicle Excess</desc>
														<value>6000</value>
														<text>$6,000</text>
														<order/>
													</benefit_3>
											</xsl:when>
											<!-- Last Minute -->
											<xsl:when test="coverType/code = 'I'">
													<benefit_1>
														<label>Additional Expenses</label>
														<desc>Additional Expenses</desc>
														<value>5000</value>
														<text>$5,000</text>
														<order/>
													</benefit_1>
													<benefit_2>
														<label>Personal Liability</label>
														<desc>Personal Liability</desc>
														<value>1000000</value>
														<text>$1,000,000</text>
														<order/>
													</benefit_2>
											</xsl:when>
										</xsl:choose>
									</xsl:when>
									<!-- AMT -->
									<xsl:otherwise>
										<benefit_1>
											<label>Additional Expenses</label>
											<desc>Additional Expenses</desc>
											<value>40000</value>
											<text>$40,000</text>
											<order/>
										</benefit_1>
										<benefit_2>
											<label>Personal Liability</label>
											<desc>Personal Liability</desc>
											<value>5000000</value>
											<text>$5,000,000</text>
											<order/>
										</benefit_2>
										<benefit_3>
											<label>Rental Vehicle Excess</label>
											<desc>Rental Vehicle Excess</desc>
											<value>6000</value>
											<text>$6,000</text>
											<order/>
										</benefit_3>
									</xsl:otherwise>
								</xsl:choose>
							</info>

							<infoDes>
								<xsl:value-of select="price/info" />
							</infoDes>
							<subTitle><xsl:value-of select="pdsaUrl" /></subTitle>

							<acn>111 586 353</acn>
							<afsLicenceNo>285571</afsLicenceNo>

							<quoteUrl><xsl:value-of select="price/quoteUrl" /></quoteUrl>
							<encodeUrl>Y</encodeUrl>
						</xsl:element>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>

		</results>
	</xsl:template>
</xsl:stylesheet>