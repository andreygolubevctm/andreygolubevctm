<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/string_formatting.xsl" />

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId">*NONE</xsl:param>
	<xsl:param name="defaultProductId"><xsl:value-of select="$productId" /></xsl:param>
	<xsl:param name="service"></xsl:param>
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>
	<xsl:param name="agentCode" />

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<xsl:choose>
		<!-- UNACCEPTABLE -->
		<xsl:when test="/xmlResponse/product/errors">
			<results>
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-26</xsl:with-param>
				</xsl:call-template>
			</results>
		</xsl:when>
		<xsl:when test="/error">
			<results>
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-26</xsl:with-param>
				</xsl:call-template>
			</results>
		</xsl:when>
		<!-- ACCEPTABLE -->
		<xsl:otherwise>
			<xsl:apply-templates />
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- VARS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="standard_product">standard_product</xsl:variable>
	<xsl:variable name="premier_product">premier_product</xsl:variable>
	<xsl:variable name="code_cancellation">CANCELLATION</xsl:variable>
	<xsl:variable name="code_excess">STANDARD_EXCESS</xsl:variable>
	<xsl:variable name="code_overseas_medical">MEDICAL_REPATRIATION</xsl:variable>
	<xsl:variable name="code_baggage">BAGGAGE_DELAY</xsl:variable>
	<xsl:variable name="uppercase"><xsl:text>ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:text></xsl:variable>
	<xsl:variable name="lowercase"><xsl:text>abcdefghijklmnopqrstuvwxyz</xsl:text></xsl:variable>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/xmlResponse">
		<results>
			<xsl:for-each select="product">
				<xsl:variable name="isDomestic">
					<xsl:choose>
						<xsl:when test="areaCode = 'G'">Y</xsl:when>
						<xsl:otherwise>N</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>


				<xsl:variable name="uniqueId">
						<xsl:choose>
							<xsl:when test="@ID = $standard_product and productSet = 'COZSTS'">193</xsl:when><!-- Single International Standard Trip -->
							<xsl:when test="@ID = $premier_product and productSet = 'COZSTP'">194</xsl:when><!-- Single International PremierTrip -->
							<xsl:when test="@ID = $standard_product and productSet = 'COZSDS'">195</xsl:when><!-- Single Domestic Standard Trip -->
							<xsl:when test="@ID = $premier_product and productSet = 'COZSDP'">196</xsl:when><!-- Single Domestic Premier Trip -->
							<xsl:when test="@ID = $standard_product and productSet = 'COZMTS'">197</xsl:when><!-- AMT Standard -->
							<xsl:when test="@ID = $premier_product and productSet = 'COZMTP'">198</xsl:when><!-- AMT Premier -->
						</xsl:choose>
				</xsl:variable>
				<xsl:element name="price">
					<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
					<xsl:attribute name="productId"><xsl:value-of select="$service" />-TRAVEL-<xsl:value-of select="$uniqueId" /></xsl:attribute>

					<available>Y</available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>
					<provider><xsl:value-of select="provider"/></provider>
					<trackCode>7</trackCode>
					<name><xsl:value-of select="productName/text()"/></name>
					<des><xsl:value-of select="productName/text()"/></des>
					<price><xsl:value-of select="format-number(price/text(),'#.00')"/></price>
					<priceText>$<xsl:value-of select="format-number(price/text(),'#.00')"/></priceText>

					<info>
						<!-- MUST HAVE EXCESS, MEDICAL, CANCELLATION AND LUGGAGE AS THEY ARE REQUIRED FIELDS FOR THE PRICE PRESENTATION PAGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
						<!-- Check if we have any cancellation fees -->
						<xsl:choose>
							<xsl:when test="section/sectionCode/text() = $code_cancellation"></xsl:when>
							<xsl:otherwise><cxdfee>
								<label>Cancellation Fees</label>
								<desc>Cancellation and Amendment Fees</desc>
								<value>N/A</value>
								<text>0</text>
								<order/>
								</cxdfee></xsl:otherwise>
						</xsl:choose>

						<!-- Check if we have any excess fees -->
						<xsl:choose>
							<xsl:when test="section/sectionCode/text() = $code_excess"></xsl:when>
							<xsl:otherwise><excess>
								<label>Excess</label>
								<desc>Excess on Claims</desc>
								<value>0</value>
								<text>0</text>
								<order/>
								</excess></xsl:otherwise>
						</xsl:choose>

						<!-- Check if we have any overseas medical fees -->
						<xsl:choose>
							<xsl:when test="section/sectionCode/text() = $code_overseas_medical"></xsl:when>
							<xsl:otherwise><medical>
								<label>Overseas Medical</label>
								<desc>Overseas Medical and Hospital Expenses</desc>
								<value>0</value>
								<text>0</text>
								<order/>
								</medical></xsl:otherwise>
						</xsl:choose>

						<!-- Check if we have any luggage and personal effects fees -->
						<xsl:choose>
							<xsl:when test="section/sectionCode/text() = $code_baggage"></xsl:when>
							<xsl:otherwise><luggage>
								<label>Luggage and PE Delay</label>
								<desc>Delayed Luggage Allowance</desc>
								<value>0</value>
								<text>0</text>
								<order/>
								</luggage></xsl:otherwise>
						</xsl:choose>

						<xsl:for-each select="section">
							<xsl:choose>
								<xsl:when test="@webShow != 'N'">
									<xsl:choose>
										<xsl:when test="sectionCode/text() = $code_cancellation">
											<cxdfee>
												<label>Cancellation Fees</label>
												<desc>Cancellation Fees</desc>
												<value><xsl:value-of select="amount/text()" /></value>
												<text>$<xsl:value-of select="format-number(amount/text(),'#,###,###')"/></text>
												<order/>
											</cxdfee>
										</xsl:when>
										<xsl:when test="sectionCode/text() = $code_excess">
											<xsl:variable name="excess">
												<xsl:choose>
													<xsl:when test="contains(amount/text(), '/')"><xsl:value-of select="amount/text()"/></xsl:when>
													<xsl:otherwise><xsl:value-of select="format-number(amount/text(),'#,###,###')"/></xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<excess>
												<label>Excess</label>
												<desc>Excess on Claims</desc>
												<value><xsl:value-of select="$excess" /></value>
												<text><xsl:choose>
													<xsl:when test="contains($excess, '$')"></xsl:when>
													<xsl:otherwise>$</xsl:otherwise></xsl:choose><xsl:value-of select="$excess"/>
												</text>
												<order/>
											</excess>
										</xsl:when>
										<xsl:when test="sectionCode/text() = $code_overseas_medical">
											<medical>
												<label>Overseas Medical</label>
												<desc>Overseas Medical and Hospital Expenses</desc>
												<value><xsl:value-of select="amount/text()" /></value>
												<text>$<xsl:value-of select="format-number(amount/text(),'#,###,###')"/></text>
												<order/>
											</medical>
										</xsl:when>
										<xsl:when test="sectionCode/text() = $code_baggage">
											<luggage>
												<label>Luggage and PE Delay</label>
												<desc>Luggage and PE Delay</desc>
												<value><xsl:value-of select="amount/text()" /></value>
												<text>$<xsl:value-of select="format-number(amount/text(),'#,###,###')"/></text>
												<order/>
											</luggage>
										</xsl:when>
										<xsl:otherwise>
											<xsl:element name="benefit{webOrder/text()}{webSubSectionOrder/text()}">
												<label><xsl:value-of select="sectionName/text()" /></label>
												<desc><xsl:value-of select="sectionName/text()" /></desc>
												<value><xsl:value-of select="amount/text()" /></value>
												<text>$<xsl:value-of select="format-number(amount/text(),'#,###,###')"/></text>
												<order/>
											</xsl:element>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</info>


					<infoDes>
						Columbus Direct offers great value cover at competitive prices and is one of only two providers to have achieved a 5-star rating for international travel insurance in the 2011 survey by independent ratings agency, CANSTAR. Customer satisfaction and value-for-money are the driving forces behind Columbus and the company takes pride in delivering an efficient, hassle-free service for customers. Columbus Direct Travel Insurance Pty Limited (ABN 99 107 050 582) is an AFSL Licence holder: No. 246636.
						<xsl:choose>
							<xsl:when test="$uniqueId = '193' or $uniqueId = '197'">
								<xsl:text> &lt;br&gt; &lt;br&gt; *Note: $250 excess applies to claims under Overseas Medical Expenses and Emergency Repatriation only.</xsl:text>
							</xsl:when>
						</xsl:choose>
					</infoDes>
					<subTitle>
						https://www.columbusdirect.com.au/pdfs/coz/PDS.pdf
					</subTitle>					<acn></acn>
					<afsLicenceNo></afsLicenceNo>
					<quoteUrl>http://www.columbusdirect.com.au/travel-insurance/travel-insurance-ctm?default=true%26sourcecode=CTM001</quoteUrl>
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
				<xsl:when test="/xmlResponse/product/errors">
					<xsl:copy-of select="/xmlResponse/product/errors"></xsl:copy-of>
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

	<xsl:template name="formatNumber">
		<xsl:param name="value" />
		<xsl:choose>
			<xsl:when test="$value = 0">0</xsl:when>
			<xsl:otherwise><xsl:value-of select="format-number($value,'#,###,###')"/></xsl:otherwise>
		</xsl:choose>
		</xsl:template>
</xsl:stylesheet>