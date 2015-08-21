<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="utilities/unavailable.xsl" />

	<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="service" />
	<xsl:param name="transactionId">*NONE</xsl:param>
	<xsl:param name="request" />

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

					<xsl:variable name="planDescription">
						<xsl:choose>
							<xsl:when test="@service='1FOW'">
								<xsl:value-of select="product/longTitle"/>
								<xsl:choose>
									<xsl:when test="$request/travel/policyType = 'A'"> &lt;span class="daysPerTrip"&gt;(30 Days)&lt;/span&gt;</xsl:when>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="@service='VIRG'">
								<xsl:choose>
									<xsl:when test="$request/travel/policyType = 'S'">
										Virgin Money <xsl:value-of select="product/longTitle"/>
									</xsl:when>
									<xsl:otherwise>
										Virgin Money AMT &lt;br&gt;Worldwide &lt;span class="daysPerTrip"&gt;(<xsl:value-of select="product/maxTripDuration"/> days)&lt;span&gt;
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="@service='ZUJI'">
								<xsl:value-of select="product/longTitle"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="product/longTitle"/> <xsl:if test="product/maxTripDuration > 0"> &lt;span class="daysPerTrip"&gt;(<xsl:value-of select="product/maxTripDuration"/> days)&lt;span&gt;</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<name> <xsl:value-of select="product/shortTitle"/></name>
					<des><xsl:value-of select="$planDescription"/></des>
					<price><xsl:value-of select="price"/></price>
					<priceText><xsl:value-of select="priceText"/></priceText>


					<info>
						<xsl:for-each select="benefit">

							<xsl:choose>
								<xsl:when test="@type='EXCESS'">
									<excess>
										<label>Excess</label>
										<desc>
											<xsl:choose>
												<xsl:when test="string-length(description) > 0"><xsl:value-of select="description" /></xsl:when>
												<xsl:otherwise>Excess</xsl:otherwise>
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
								<xsl:otherwise>
									<xsl:element name="benefit_{position()}">
										<label><xsl:value-of select="label" /></label>
										<desc><xsl:value-of select="description" /></desc>
										<value><xsl:value-of select="value" /></value>
										<text><xsl:value-of select="text" /></text>
										<order/>
									</xsl:element>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</info>

					<infoDes><xsl:value-of select="product/description"/></infoDes>
					<subTitle><xsl:value-of select="product/pdsUrl"/></subTitle>
					<xsl:choose>
						<xsl:when test="methodType = 'GET'">
							<quoteUrl><xsl:value-of select="quoteUrl"/></quoteUrl>
						</xsl:when>
						<xsl:otherwise>
							<handoverType>post</handoverType>
							<handoverUrl><xsl:value-of select="quoteUrl"/></handoverUrl>
							<xsl:for-each select="quoteData/child::*" >
								<handoverVar><xsl:value-of select="name()"/></handoverVar>
								<handoverData><xsl:value-of select="."/></handoverData>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					<encodeUrl>
						<xsl:choose>
							<xsl:when test="encodeQuoteUrl='true'">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</encodeUrl>

					<xsl:if test="benefit/exempted = 'true'">
						<exemptedBenefits>
							<xsl:for-each select="benefit">
								<xsl:if test="exempted = 'true'">
									<xsl:choose>
										<xsl:when test="@type='EXCESS'">
											<benefit>excess</benefit>
										</xsl:when>
										<xsl:when test="@type='CXDFEE'">
											<benefit>cxdfee</benefit>
										</xsl:when>
										<xsl:when test="@type='MEDICAL'">
											<benefit>medical</benefit>
										</xsl:when>
										<xsl:when test="@type='LUGGAGE'">
											<benefit>luggage</benefit>
										</xsl:when>
										<xsl:otherwise>
											<benefit>benefit_<xsl:value-of select="position()"/></benefit>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:for-each>
						</exemptedBenefits>
					</xsl:if>

				</price>
			</xsl:for-each>
		</results>
	</xsl:template>

</xsl:stylesheet>