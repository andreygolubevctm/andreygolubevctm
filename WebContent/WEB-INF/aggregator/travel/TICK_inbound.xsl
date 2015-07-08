<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/string_formatting.xsl" />
	<xsl:import href="utilities/handoverMapping.xsl" />
	<xsl:import href="utilities/unavailable.xsl" />
	<xsl:import href="utilities/amt_formatting.xsl" />

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
			<!-- ACCEPTABLE. no errors or warnings -->
			<xsl:when test="not(/policy_response/messages/errors/error) and not(/policy_response/messages/warnings/warning)">
				<xsl:apply-templates />
			</xsl:when>
			<!-- UNACCEPTABLE -->
			<xsl:otherwise>
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-40</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/policy_response">
		<results>
			<xsl:for-each select="products/product">

				<xsl:variable name="productName">
					<xsl:choose>
						<xsl:when test="$request/travel/policyType = 'S'"><xsl:value-of select="name"/></xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="formatProductName">
								<xsl:with-param name="providerName">Tick</xsl:with-param>
								<xsl:with-param name="productName" select="name" />
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:element name="price">
					<xsl:attribute name="service">TICK</xsl:attribute>
					<xsl:attribute name="productId">TICK-TRAVEL-<xsl:value-of select="id"/></xsl:attribute>

					<available><xsl:value-of select="available" /></available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>
					<provider>TICK</provider>
					<trackCode>66</trackCode>
					<name>Tick Travel Insurance <xsl:value-of select="$productName" /></name>
					<des>Tick Travel Insurance <xsl:value-of select="$productName" /></des>
					<price><xsl:value-of select="format-number(premium,'#.00')"/></price>
					<priceText>$<xsl:value-of select="format-number(premium,'#.00')"/></priceText>

					<info>
						<!-- MUST HAVE EXCESS, MEDICAL, CANCELLATION AND LUGGAGE AS THEY ARE REQUIRED FIELDS FOR THE PRICE PRESENTATION PAGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
						<!-- Check if we have any excess values -->
						<xsl:choose>
							<xsl:when test="benefits/excess/id/text() = '11'"></xsl:when>
							<xsl:otherwise><excess>
								<label>Excess</label>
								<desc>Excess on Claims</desc>
								<value>0</value>
								<text>$0</text>
								<order/>
								</excess></xsl:otherwise>
						</xsl:choose>

						<!-- Check if we have any overseas medical fees -->
						<xsl:choose>
							<xsl:when test="benefits/medical/id/text() = '22'"></xsl:when>
							<xsl:otherwise><medical>
								<label>Overseas Medical</label>
								<desc>Overseas Medical and Hospital Expenses</desc>
								<value>0</value>
								<text>N/A</text>
								<order/>
							</medical></xsl:otherwise>
						</xsl:choose>

						<!-- Check if we have any cancellation fees -->
						<xsl:choose>
							<xsl:when test="benefits/cancellation_fee/id/text() = '21'"></xsl:when>
							<xsl:otherwise><cxdfee>
								<label>Cancellation Fees</label>
								<desc>Cancellation and Amendment Fees</desc>
								<value>0</value>
								<text>N/A</text>
								<order/>
							</cxdfee></xsl:otherwise>
						</xsl:choose>

						<!-- Check if we have any luggage and personal effects fees -->
						<xsl:choose>
							<xsl:when test="benefits/luggage/id/text() = '29'"></xsl:when>
							<xsl:otherwise><luggage>
								<label>Luggage and PE Delay</label>
								<desc>Delayed Luggage Allowance</desc>
								<value>0</value>
								<text>N/A</text>
								<order/>
							</luggage></xsl:otherwise>
						</xsl:choose>

						<xsl:for-each select="benefits/node()">
							<xsl:if test="name() != ''">
								<xsl:variable name="nodeName">
									<xsl:choose>
										<xsl:when test="name() = 'cancellation_fee'">cxdfee</xsl:when>
										<xsl:otherwise><xsl:value-of select="name()" /></xsl:otherwise>
									</xsl:choose>
								</xsl:variable>

								<xsl:element name="{$nodeName}">
									<xsl:for-each select="*">
										<xsl:if test="name() != 'id'">
											<xsl:if test="name() = 'desc'">
												<xsl:element name="label"><xsl:value-of select="text()" /></xsl:element>
											</xsl:if>
											<xsl:choose>
												<xsl:when test="name() = 'value' and text() = 'Unlimited'">
													<xsl:call-template name="convertToValue">
														<xsl:with-param name="amount"><xsl:value-of select="text()" /></xsl:with-param>
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:element name="{name()}"><xsl:value-of select="text()" /></xsl:element>
												</xsl:otherwise>
											</xsl:choose>

										</xsl:if>
									</xsl:for-each>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
					</info>

					<infoDes><xsl:value-of select="/policy_response/provider/about" /></infoDes>
					<subTitle><xsl:value-of select="pds" /></subTitle>

					<acn>000 000 000</acn>
					<afsLicenceNo>00000</afsLicenceNo>
					<quoteUrl><xsl:value-of select="quoteurl" /></quoteUrl>
				</xsl:element>
			</xsl:for-each>
		</results>
	</xsl:template>
</xsl:stylesheet>