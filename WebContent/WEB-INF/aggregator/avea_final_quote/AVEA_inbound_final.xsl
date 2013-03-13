<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:a="http://services.fastr.com.au/Quotation/Data"
	xmlns:i="http://www.w3.org/2001/XMLSchema-instance"	
	xmlns:b="http://schemas.microsoft.com/2003/10/Serialization/Arrays"
	xmlns:avea="http://services.fastr.com.au/Quotation"
	xmlns:xalan="http://xml.apache.org/xalan"
	xmlns:e="http://services.fastr.com.au/Error"
	exclude-result-prefixes="s a i b avea">	

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->	
	<xsl:import href="../includes/utils.xsl"/>

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->	
	<xsl:template match="avea:RequestFinalQuotationResult">
	
		<!-- Extract the basic excess amount -->
		<xsl:variable name="aveaBasicExcess" select="a:MotorPremium/a:BasicExcess" />
		<xsl:variable name="aveaSystemImposedExcess" select="a:MotorPremium/a:ImposedExcess" />
		<xsl:variable name="aveaTotalExcess" select="$aveaBasicExcess + $aveaSystemImposedExcess" />
		<xsl:variable name="aveaQuoteGenerated" select="a:QuotationGenerated" />		
		
		<!-- Extract the quote number -->
		<xsl:variable name="aveaLeadNumber" select="a:QuotationNumber" />

		<!-- Extract the quote url -->
		<xsl:variable name="aveaQuoteUrl" select="a:InsurerQuotationUrl" />

		<results>	
			<xsl:element name="price">
				<xsl:attribute name="service">AVEA</xsl:attribute>
				<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
		
				<available>
					<xsl:choose>
						<xsl:when test="$aveaQuoteGenerated='true'">Y</xsl:when>
						<xsl:otherwise>N</xsl:otherwise>
					</xsl:choose>				
				</available>	
				<transactionId><xsl:value-of select="$transactionId"/></transactionId>
				
				<onlinePrice>
					<xsl:call-template name="price">
						<xsl:with-param name="annualPremium" select="a:MotorPremium/a:Premium" />
						<xsl:with-param name="monthlyPremium" select="a:MotorPremium/a:AvailablePaymentMethods/a:PaymentMethod[4]/a:InstalmentAmount" />						
					</xsl:call-template>
				</onlinePrice>													

				<excess><xsl:value-of select="$aveaTotalExcess"/></excess>
				<leadNo><xsl:value-of select="$aveaLeadNumber"/></leadNo>
				<quoteUrl><xsl:value-of select="$aveaQuoteUrl"/></quoteUrl>
								
			</xsl:element>
									
		</results>
	</xsl:template>
	
	<xsl:template name="price">
		<xsl:param name="annualPremium" />
		<xsl:param name="monthlyPremium" />		
		<lumpSumTotal>
			<xsl:value-of select="format-number($annualPremium,'######.00')"/>
		</lumpSumTotal>
		<instalmentFirst>
			<xsl:value-of select="format-number($monthlyPremium,'######.00')"/>			
		</instalmentFirst>
		<instalmentCount>11</instalmentCount>
		<instalmentPayment>
			<xsl:value-of select="format-number($monthlyPremium,'######.00')"/>		
		</instalmentPayment>
 		<instalmentTotal>
			<xsl:value-of select="format-number(($monthlyPremium * 12),'######.00')"/>		
 		</instalmentTotal>
	</xsl:template>		

	<!-- ERROR -->
	<xsl:template match="/error">
		<results>
			<xsl:element name="price">
				<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
				<xsl:attribute name="service">AVEA</xsl:attribute>	
				<available>false</available>
				<transactionId><xsl:value-of select="$transactionId"/></transactionId>
				<xsl:choose>
					<xsl:when test="error">
						<xsl:copy-of select="error"></xsl:copy-of>	
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="errorData">
							<xsl:value-of select="data" disable-output-escaping="yes" />
						</xsl:variable>
						<xsl:variable name="afterReason" select="substring-after($errorData,'&lt;Reason&gt;')" />
						<error service="AVEA" type="unavailable">
							<code></code>
							<message><xsl:value-of select="substring-before($afterReason,'&lt;/Reason&gt;')" /></message>
							<data></data>
						</error>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</results>
	</xsl:template>
	
</xsl:stylesheet>