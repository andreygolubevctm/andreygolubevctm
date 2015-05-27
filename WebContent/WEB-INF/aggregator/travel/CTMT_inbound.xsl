<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="utilities/unavailable.xsl" />

	<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="service"></xsl:param>
	<xsl:param name="transactionId">*NONE</xsl:param>

	<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<xsl:choose>
			<!-- ACCEPTABLE -->
			<xsl:when test="/response">
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
	<xsl:template match="/response">
		<results>
			<xsl:variable name="transactionId" select="transactionId"/>
			<xsl:for-each select="payload/quote">
				<price>
					<xsl:attribute name="service"><xsl:value-of select="./@service" /></xsl:attribute>
					<xsl:attribute name="productId"><xsl:value-of select="./@productId" /></xsl:attribute>
					<available>
						<xsl:choose>
							<xsl:when test="@available='true'">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</available>
					<xsl:if test="@available != 'true'">
						<error>
							<data />
							<messge>unavailable</messge>
							<type>unavailable</type>
							<service><xsl:value-of select="./@service" /></service>
						</error>
					</xsl:if>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>
					<trackCode><xsl:value-of select="./@trackCode" /></trackCode>
					<name><xsl:value-of select="product/shortTitle"/></name>
					<des><xsl:value-of select="product/longTitle"/></des>
					<price><xsl:value-of select="price"/></price>
					<priceText><xsl:value-of select="priceText"/></priceText>

					<info>
						<xsl:for-each select="benefit[not(@type='CUSTOM')]">
							<xsl:choose>
								<xsl:when test="@type='EXCESS'">
									<excess>
										<label>Excess</label>
										<desc>
											<xsl:choose>
												<xsl:when test="string-length(description) > 0"><xsl:value-of select="description" /></xsl:when>
												<xsl:otherwise>Excess on Claims</xsl:otherwise>
											</xsl:choose>
										</desc>
										<value><xsl:value-of select="value"/></value>
										<text><xsl:value-of select="text"/></text>
										<order/>
									</excess>
								</xsl:when>
								<xsl:when test="@type='CXDFEE'">
									<cxdfee>
										<label>Cancellation Fees</label>
										<desc>
											<xsl:choose>
												<xsl:when test="string-length(description) > 0"><xsl:value-of select="description" /></xsl:when>
												<xsl:otherwise>Cancellation Fees and Lost Deposits</xsl:otherwise>
											</xsl:choose>
										</desc>
										<value><xsl:value-of select="value"/></value>
										<text><xsl:value-of select="text"/></text>
										<order/>
									</cxdfee>
								</xsl:when>
								<xsl:when test="@type='MEDICAL'">
									<medical>
										<label>Overseas Medical</label>
										<desc>
											<xsl:choose>
												<xsl:when test="string-length(description) > 0"><xsl:value-of select="description" /></xsl:when>
												<xsl:otherwise>Overseas Emergency Medical</xsl:otherwise>
											</xsl:choose>
										</desc>
										<value><xsl:value-of select="value"/></value>
										<text><xsl:value-of select="text"/></text>
										<order/>
									</medical>
								</xsl:when>
								<xsl:when test="@type='LUGGAGE'">
									<luggage>
										<label>Luggage and PE</label>
										<desc>
											<xsl:choose>
												<xsl:when test="string-length(description) > 0"><xsl:value-of select="description" /></xsl:when>
												<xsl:otherwise>Luggage and Personal Effects</xsl:otherwise>
											</xsl:choose>
										</desc>
										<value><xsl:value-of select="value"/></value>
										<text><xsl:value-of select="text"/></text>
										<order/>
									</luggage>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>

						<xsl:for-each select="benefit[@type='CUSTOM']">
							<xsl:element name="benefit_{position()}">
								<label><xsl:value-of select="label" /></label>
								<desc><xsl:value-of select="description" /></desc>
								<value><xsl:value-of select="value" /></value>
								<text><xsl:value-of select="text" /></text>
								<order/>
							</xsl:element>
						</xsl:for-each>
					</info>

					<infoDes><xsl:value-of select="product/description"/></infoDes>
					<subtitle><xsl:value-of select="product/pdsUrl"/></subtitle>
					<quoteUrl><xsl:value-of select="quoteUrl"/></quoteUrl>
					<encodeUrl>
						<xsl:choose>
							<xsl:when test="encodeQuoteUrl='true'">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</encodeUrl>
				</price>
			</xsl:for-each>
		</results>
	</xsl:template>

</xsl:stylesheet>