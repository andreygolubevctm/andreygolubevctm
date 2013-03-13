<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:ai="http://www.softsure.co.za/"
	exclude-result-prefixes="soap ai">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->	
	<xsl:import href="../includes/utils.xsl"/>
	<xsl:import href="../includes/ranking.xsl"/>
	<xsl:import href="../includes/product_info.xsl"/>	

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>
	
<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<xsl:choose>
		<!-- ACCEPTABLE -->
		<xsl:when test="(contains(/soap:Envelope/soap:Body/ai:GetSpecifiedVehiclePremiumResponse,'Unacceptable') = false) and (contains(soap:Envelope/soap:Body/ai:GetSpecifiedVehiclePremiumResponse/ai:GetSpecifiedVehiclePremiumResult,'NOQUOTE') = false) and (contains(soap:Envelope/soap:Body/ai:GetSpecifiedVehiclePremiumResponse/ai:GetSpecifiedVehiclePremiumResult,'ERROR') = false) and (string-length(substring-before(soap:Envelope/soap:Body/ai:GetSpecifiedVehiclePremiumResponse/ai:GetSpecifiedVehiclePremiumResult,'|')) != 0)">
			<xsl:apply-templates />
		</xsl:when>

		<!-- UNACCEPTABLE -->
		<xsl:otherwise>
			<results>
				<xsl:element name="price">
					<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
					<xsl:attribute name="service">AI</xsl:attribute>	
					<available>N</available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>
					<xsl:choose>
						<xsl:when test="error">
							<xsl:copy-of select="error"></xsl:copy-of>	
						</xsl:when>
						<xsl:otherwise>
							<error service="AI" type="unavailable">
								<code></code>
								<message>unavailable</message>
								<data></data>
							</error>
						</xsl:otherwise>

					</xsl:choose>
					
					<headlineOffer>ONLINE</headlineOffer>
					<onlinePrice>				
						<lumpSumTotal>9999999999</lumpSumTotal>

				<xsl:call-template name="productInfo">
					<xsl:with-param name="productId" select="$productId" />
					<xsl:with-param name="priceType" select="headline" />
					<xsl:with-param name="kms" select="''" />
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
	<xsl:template match="soap:Envelope/soap:Body/ai:GetSpecifiedVehiclePremiumResponse">
	
		<!-- AI don't pass the excess in the response, so get it from the request -->
		<xsl:variable name="excess">
			<xsl:choose>
				<xsl:when test="$request/excess &gt;= 800">1200</xsl:when>
				<xsl:otherwise>600</xsl:otherwise>
			</xsl:choose>										
		</xsl:variable>
		
		<!-- Extract the lump sum premium (it's the first item in the string) -->
		<xsl:variable name="aiLumpSum" select="substring-before(ai:GetSpecifiedVehiclePremiumResult, '|')" />
		
		<results>	
			<xsl:element name="price">
				<xsl:attribute name="service">AI</xsl:attribute>
				<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
		
				<available>Y</available>	
				<transactionId><xsl:value-of select="$transactionId"/></transactionId>
				
				<headlineOffer>ONLINE</headlineOffer>
				
				<xsl:call-template name="priceInfo">
					<xsl:with-param name="tagName">onlinePrice</xsl:with-param>
					<xsl:with-param name="premiumData" select="ai:GetSpecifiedVehiclePremiumResult" />
				</xsl:call-template>

				<xsl:call-template name="priceInfo">
					<xsl:with-param name="tagName">offlinePrice</xsl:with-param>
					<xsl:with-param name="premiumData" select="ai:GetSpecifiedVehiclePremiumResult" />
				</xsl:call-template>
				
				<productDes>AI Car Insurance</productDes>
				<underwriter>The Hollard Insurance Company (PTY) LTD</underwriter>
				<brandCode>AI</brandCode>
				<acn>78 090 584 473</acn>
				<afsLicenceNo>241436</afsLicenceNo>						
				<excess>
					<total><xsl:value-of select="$excess" /></total>
					<excess>
						<description>Male driver under the age of 30 or less than 2 years driving experience</description>
						<amount>$1500</amount>
					</excess>
					<excess>
						<description>Female driver under the age of 30 or less than 2 years driving experience</description>
						<amount>$900</amount>
					</excess>					
					<excess>
						<description>Unlisted drivers</description>
						<amount>$1000</amount>
					</excess>
					<excess>
						<description>Single car accident excess</description>
						<amount>$300</amount>
					</excess>
					<excess>
						<description>Theft / Malicious Damage excess</description>
						<amount>$1000</amount>
					</excess>										
					<excess>
						<description>Claim within first 6 months of policy inception</description>
						<amount>$600</amount>
					</excess>							
												
				</excess>
				<conditions>
					<condition> </condition>
				</conditions>	
					
				<leadNo></leadNo>
				
				<telNo>1300 284 875</telNo>
				<openingHours>Monday to Friday (9am-7pm EST)</openingHours>
					
				<quoteUrl>https://b2b.aiinsurance.com.au/AIOnlineBuy/Buy/KnockOutQuestions/QUOTE#</quoteUrl>
				
				<refnoUrl>ajax/json/get_ai_refno.jsp?PremiumQuoted=<xsl:value-of select="$aiLumpSum"/>&amp;ExcessQuoted=<xsl:value-of select="$excess"/></refnoUrl>
				<pdsaUrl>http://www.aiinsurance.com.au/Docs/Pds_a.pdf</pdsaUrl>
				<pdsaDesLong>Product Disclosure Statement Part A</pdsaDesLong>
				<pdsaDesShort>PDS A</pdsaDesShort>				
				<pdsbUrl>http://www.aiinsurance.com.au/Docs/Pds_b.pdf</pdsbUrl>
				<pdsbDesLong>Product Disclosure Statement Part B</pdsbDesLong>
				<pdsbDesShort>PDS B</pdsbDesShort>				
				<fsgUrl />
				
				<disclaimer>
					<![CDATA[
					The indicative quote includes any applicable online discount and is subject to meeting the insurers underwriting criteria and may change due to factors such as:<br>
					- Driver's history or offences or claims<br>
					- Age or licence type of additional drivers<br>
					- Vehicle condition, accessories and modifications<br>
					]]>
				</disclaimer>				
				
				<transferring />				
				
				<xsl:call-template name="ranking">
					<xsl:with-param name="productId" select="$productId" />
				</xsl:call-template>					
			</xsl:element>						
		</results>
	</xsl:template>
	
	<!-- Create the onlinePrice & offlinePrice elements -->
	<xsl:template name="priceInfo">
		<xsl:param name="tagName" />
		<xsl:param name="premiumData" />

		<xsl:element name="{$tagName}">	
			
			<xsl:call-template name="extractPremiums">
				<xsl:with-param name="premiumData" select="$premiumData" />
			</xsl:call-template>
						 
			<xsl:call-template name="productInfo">
				<xsl:with-param name="productId" select="$productId" />
				<xsl:with-param name="priceType" select="$tagName" />
				<xsl:with-param name="kms" select="''" />
				
			</xsl:call-template>
			
		 </xsl:element>
	 </xsl:template>
	 
	<!-- Converts pipe separated values to xml -->
	<xsl:template name="extractPremiums">
		<xsl:param name="premiumData" />
	 	<xsl:param name="pos">0</xsl:param>
	 	
	 	<xsl:if test="contains($premiumData, '|')">
		 	<xsl:variable name="item" select="substring-before($premiumData, '|')" />
		 	<xsl:variable name="rest" select="substring-after($premiumData, '|')" />
				 	
	 		<xsl:choose>
	 			<xsl:when test="$pos = 0">
	 				<lumpSumTotal>
						<xsl:call-template name="util_mathCeil">
							<xsl:with-param name="num" select="$item" />
						</xsl:call-template>
					</lumpSumTotal>
	 			</xsl:when>
	 			<xsl:when test="$pos = 7">
					<instalmentFirst><xsl:value-of select="format-number($item + 110,'#.00')" /></instalmentFirst>
					<instalmentCount>11</instalmentCount>
					<instalmentPayment><xsl:value-of select="format-number($item,'#.00')" /></instalmentPayment>
				 	<instalmentTotal>
						<xsl:call-template name="util_mathCeil">
							<xsl:with-param name="num" select="($item * 12) + 110" />
						</xsl:call-template>
					</instalmentTotal>				 	
	 			</xsl:when>
	 		</xsl:choose>
	 		
			<xsl:if test="$pos &lt; 7">
				<xsl:call-template name="extractPremiums">
					<xsl:with-param name="premiumData" select="$rest" />
					<xsl:with-param name="pos" select="$pos + 1" />
				</xsl:call-template >
			</xsl:if>
	 	</xsl:if>
	 </xsl:template>	 
</xsl:stylesheet>