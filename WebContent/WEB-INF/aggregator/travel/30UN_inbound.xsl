<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"
				xmlns:ns2="http://www.1cover.com.au/ws/schemas/quotes"
				xmlns:ns3="http://www.1cover.com.au/ws/schemas/types"
				exclude-result-prefixes="SOAP-ENV ns2 ns3">

	<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/unavailable.xsl" />
	<xsl:import href="utilities/string_formatting.xsl" />

	<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId">*NONE</xsl:param>
	<xsl:param name="defaultProductId"><xsl:value-of select="$productId" /></xsl:param>
	<xsl:param name="service"></xsl:param>
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>
	<xsl:param name="myParam">*NONE</xsl:param>

	<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<xsl:choose>
			<!-- UNACCEPTABLE -->
			<!-- Check for error nodes or check if it's an AMT quote and the <ns3:policy-id>6</ns3:policy-id> isn't returned -->
			<xsl:when test="/SOAP-ENV:Envelope/SOAP-ENV:Body/ns2:GetQuotesResponse/ns2:error or /error or ($request/travel/policyType = 'A' and not(//ns3:policy-id = '13'))">
				<!-- UNACCEPTABLE. Check if ns3:error exists or if the /error node exists or if it's an amt policy and the frequent traveller doesn't exist  -->
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-57</xsl:with-param>
				</xsl:call-template>
			</xsl:when>

			<!-- ACCEPTABLE -->
			<xsl:otherwise>
				<xsl:apply-templates select="/SOAP-ENV:Envelope/SOAP-ENV:Body/ns2:GetQuotesResponse" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/SOAP-ENV:Envelope/SOAP-ENV:Body/ns2:GetQuotesResponse">
		<xsl:variable name="partnerName"><xsl:value-of select="ns2:insurer" /></xsl:variable>
		<xsl:variable name="moreInfo"><xsl:value-of select="ns2:more-info" /></xsl:variable>
		<xsl:variable name="pdsURL"><xsl:value-of select="ns2:pds-url" /></xsl:variable>

		<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
		<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
		<results>

			<xsl:for-each select="ns2:quotes">

				<xsl:variable name="uniqueId">
					<xsl:choose>
						<xsl:when test="ns3:policy-id = 13">256</xsl:when> <!-- U30 Single Trip -->
					</xsl:choose>
				</xsl:variable>

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
						<provider><xsl:value-of select="$partnerName"/></provider>
						<trackCode>63</trackCode>
						<des><xsl:value-of select="$partnerName"/><xsl:text> </xsl:text><xsl:value-of select="ns3:policy-name"/></des>
						<price><xsl:call-template name="removeDollarFormatting">
							<xsl:with-param name="oldDollarValue"><xsl:value-of select="ns3:policy-price" /></xsl:with-param>
						</xsl:call-template></price>
						<priceText><xsl:value-of select="ns3:policy-price"/></priceText>

						<info>
							<excess>
								<label>Excess</label>
								<desc>Excess on claims</desc>
								<value><xsl:call-template name="convertToValue">
									<xsl:with-param name="amount"><xsl:value-of select="ns3:Excess" /></xsl:with-param>
								</xsl:call-template></value>
								<text><xsl:value-of select="ns3:Excess" /></text>
								<order />
							</excess>
							<xsl:for-each select="ns3:covers">
								<xsl:variable name="nodeName">
									<xsl:choose>
										<xsl:when test="ns3:cover-id = 1">medical</xsl:when> <!-- OS Medical -->
										<xsl:when test="ns3:cover-id = 31">luggage</xsl:when> <!-- Luggage -->
										<xsl:when test="ns3:cover-id = 7">cxdfee</xsl:when> <!-- Cancellation -->
										<xsl:otherwise>benefit_<xsl:value-of select="ns3:cover-id" /></xsl:otherwise>
									</xsl:choose>
								</xsl:variable>

								<xsl:element name="{$nodeName}">
									<label><xsl:value-of select="ns3:title" /></label>
									<desc><xsl:value-of select="ns3:title" /></desc>
									<value><xsl:call-template name="convertToValue">
										<xsl:with-param name="amount"><xsl:value-of select="ns3:amount" /></xsl:with-param>
									</xsl:call-template></value>
									<text><xsl:if test="ns3:amount = '0'">$</xsl:if><xsl:value-of select="ns3:amount" /></text>
									<order/>
								</xsl:element>
							</xsl:for-each>
						</info>

						<infoDes>
							<xsl:value-of select="$moreInfo" />
						</infoDes>
						<subTitle>
							<xsl:value-of select="$pdsURL"/>
						</subTitle>

						<acn>000 000 000</acn>
						<afsLicenceNo>00000</afsLicenceNo>
						<quoteUrl><xsl:value-of select="ns3:url" />&amp;transactionID=<xsl:value-of select="$transactionId"/></quoteUrl>
						<encodeUrl>Y</encodeUrl>
					</xsl:element>
			</xsl:for-each>

		</results>
	</xsl:template>
</xsl:stylesheet>