<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">

	<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/handoverMapping.xsl" />
	<xsl:import href="utilities/util_functions.xsl" />
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
			<!-- ACCEPTABLE. no errors or warnings -->
			<xsl:when test="not(/soap:Envelope/soap:Body/policy_response/messages/errors/error) and not(/soap:Envelope/soap:Body/policy_response/messages/warnings/warning)">
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
	<xsl:template match="/soap:Envelope/soap:Body/policy_response">
		<results>
			<xsl:for-each select="products/product">

				<xsl:variable name="productName">
					<xsl:choose>
						<xsl:when test="$request/travel/policyType = 'S'"><xsl:value-of select="name"/></xsl:when>
						<xsl:otherwise>
							<xsl:variable name="updateAMTPortion">
								<xsl:call-template name="string-replace-all">
									<xsl:with-param name="text"><xsl:value-of select="name"/></xsl:with-param>
									<xsl:with-param name="replace">Fast Cover Annual</xsl:with-param>
									<xsl:with-param name="by">Fast Cover AMT&lt;br /&gt;</xsl:with-param>
								</xsl:call-template>
							</xsl:variable>

							<xsl:variable name="updateFirstBracket">
								<xsl:call-template name="string-replace-all">
									<xsl:with-param name="text"><xsl:value-of select="$updateAMTPortion"/></xsl:with-param>
									<xsl:with-param name="replace">(</xsl:with-param>
									<xsl:with-param name="by">&lt;span class=&quot;daysPerTrip&quot;&gt;(</xsl:with-param>
								</xsl:call-template>
							</xsl:variable>

							<xsl:variable name="updateLastBracket">
								<xsl:call-template name="string-replace-all">
									<xsl:with-param name="text"><xsl:value-of select="$updateFirstBracket"/></xsl:with-param>
									<xsl:with-param name="replace">)</xsl:with-param>
									<xsl:with-param name="by">)&lt;/span&gt;</xsl:with-param>
								</xsl:call-template>
							</xsl:variable>

							<xsl:value-of select="$updateLastBracket" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:element name="price">
					<xsl:attribute name="service"><xsl:value-of select="/soap:Envelope/soap:Body/policy_response/provider/code" /></xsl:attribute>
					<xsl:attribute name="productId">
						<xsl:call-template name="string-replace-all">
							<xsl:with-param name="text"><xsl:value-of select="id"/></xsl:with-param>
							<xsl:with-param name="replace"> - <xsl:value-of select="name"/></xsl:with-param>
							<xsl:with-param name="by" select="''" />
						</xsl:call-template>
					</xsl:attribute>

					<available><xsl:value-of select="available" /></available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>
					<provider><xsl:value-of select="/soap:Envelope/soap:Body/policy_response/provider/name" /></provider>
					<trackCode>14</trackCode>
					<name><xsl:value-of select="$productName"/></name>
					<des><xsl:value-of select="$productName"/></des>
					<price><xsl:value-of select="format-number(premium,'#.00')"/></price>
					<priceText>$<xsl:value-of select="format-number(premium,'#.00')"/></priceText>

					<info>
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
											<xsl:element name="{name()}"><xsl:value-of select="text()" /></xsl:element>
										</xsl:if>
									</xsl:for-each>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
					</info>

					<infoDes>Fast Cover are travel insurance specialists as they only sell travel insurance.&lt;br&gt;From quote to the claims process, Fast Cover pride themselves on providing a service which is fast and simple.&lt;br&gt;Fast Cover Travel Insurance sells quality travel insurance that's flexible, easy to understand and great value for money.&lt;br&gt;&lt;ul&gt;&lt;li&gt;14 day money back guarantee&lt;/li&gt;&lt;li&gt;Kids covered Free of additional charge&lt;/li&gt;&lt;li&gt;5% OFF when you book for 2 adults&lt;/li&gt;&lt;li&gt;Underwritten by Allianz&lt;/li&gt;&lt;li&gt;No age limits&lt;/li&gt;&lt;li&gt;Suitable for holidays/work&lt;/li&gt;&lt;/ul&gt;All policies include:&lt;br&gt;&lt;ul&gt;&lt;li&gt;Unlimited Overseas Medical Cover&lt;/li&gt;&lt;li&gt;Unlimited Cancellation Cover&lt;/li&gt;&lt;li&gt;Unlimited Worldwide Emergency Assistance Cover&lt;/li&gt;&lt;li&gt;Travel Delay Cover&lt;/li&gt;&lt;li&gt;Missed Connections Cover&lt;/li&gt;&lt;li&gt;Cover for 43 pre-existing medical conditions – no medical required, see PDS for full list.&lt;/li&gt;&lt;/ul&gt;</infoDes>
					<subTitle><xsl:value-of select="pds" /></subTitle>

					<acn>000 000 000</acn>
					<afsLicenceNo>00000</afsLicenceNo>
					<quoteUrl><xsl:value-of select="quoteurl" /></quoteUrl>
				</xsl:element>
			</xsl:for-each>
		</results>
	</xsl:template>
</xsl:stylesheet>