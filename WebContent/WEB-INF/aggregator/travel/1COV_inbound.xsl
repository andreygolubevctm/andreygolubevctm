<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv">
	
<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:import href="../includes/date_difference.xsl"/>

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
		<!-- ACCEPTABLE -->
		<xsl:when test="/results/result/premium">
			<xsl:apply-templates />
		</xsl:when>
		
		<!-- UNACCEPTABLE -->
		<xsl:otherwise>
			<results>
				<!--0 Results returned-->
			</results>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/results">
		<results>	
						
			<xsl:for-each select="result">

				<xsl:variable name="policyType">
					<xsl:choose>				
						<xsl:when test="@productId = 'TRAVEL-57'">1</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-58'">4</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-59'">3</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-60'">1</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-61'">2</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-62'">2</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-63'">5</xsl:when>
						<xsl:when test="@productId = 'TRAVEL-64'">5</xsl:when>
						<xsl:otherwise >1</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="destinationCode">
					<xsl:choose>
						<xsl:when test="$request/travel/destinations/af/af">WW</xsl:when>
						<xsl:when test="$request/travel/destinations/am/us">WW</xsl:when>
						<xsl:when test="$request/travel/destinations/am/ca">WW</xsl:when>
						<xsl:when test="$request/travel/destinations/am/sa">WW</xsl:when>
						<xsl:when test="$request/travel/destinations/as/jp">WW</xsl:when>
						<xsl:when test="$request/travel/destinations/me/me">WW</xsl:when>
						<xsl:when test="$request/travel/destinations/do/do">WW</xsl:when>
						
						<xsl:when test="$request/travel/destinations/eu/eu">EU</xsl:when>
						<xsl:when test="$request/travel/destinations/eu/uk">EU</xsl:when>
						
						<xsl:when test="$request/travel/destinations/as/ch">AS</xsl:when>
						<xsl:when test="$request/travel/destinations/as/hk">AS</xsl:when>
						<xsl:when test="$request/travel/destinations/as/in">AS</xsl:when>
						<xsl:when test="$request/travel/destinations/as/th">AS</xsl:when>
						
						<xsl:when test="$request/travel/destinations/pa/ba">PC</xsl:when>
						<xsl:when test="$request/travel/destinations/pa/in">PC</xsl:when>
						<xsl:when test="$request/travel/destinations/pa/nz">PC</xsl:when>
						<xsl:when test="$request/travel/destinations/pa/pi">PC</xsl:when>
										
						<xsl:when test="$request/travel/destinations/au/au">AU</xsl:when>

						<xsl:otherwise>WW</xsl:otherwise>								
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="adults" select="$request/travel/adults" />
				<xsl:variable name="children">
					<xsl:choose>				
						<xsl:when test="$request/travel/children"><xsl:value-of select="$request/travel/children" /></xsl:when>
						<xsl:otherwise >0</xsl:otherwise>
					</xsl:choose>
 				</xsl:variable>			

				<xsl:variable name="oldest" select="$request/travel/oldest" />
				
				<xsl:variable name="fromDate" select="$request/travel/dates/fromDate" />
				<xsl:variable name="toDate" select="$request/travel/dates/toDate" />

				<xsl:variable name="fromDateFormatted">
					<xsl:if test="$fromDate != ''">
						<xsl:value-of select="substring($fromDate,1,2)" />-<xsl:value-of select="substring($fromDate,4,2)" />-<xsl:value-of select="substring($fromDate,7,4)" />
					</xsl:if>
				</xsl:variable>
				
				<xsl:variable name="startDateFormatted"><xsl:value-of select="substring($fromDate,7,4)" />-<xsl:value-of select="substring($fromDate,4,2)" />-<xsl:value-of select="substring($fromDate,1,2)" /></xsl:variable>		
				<xsl:variable name="endDateFormatted"><xsl:value-of select="substring($toDate,7,4)" />-<xsl:value-of select="substring($toDate,4,2)" />-<xsl:value-of select="substring($toDate,1,2)" /></xsl:variable>		

				<xsl:variable name="durationDays">
					<xsl:choose>				
						<xsl:when test="$request/travel/policyType = 'S'">
						  <xsl:call-template name="date_difference">
						    <xsl:with-param name="start" select="$startDateFormatted" />
						    <xsl:with-param name="end" select="$endDateFormatted" />
						  </xsl:call-template>
						</xsl:when>
						<xsl:otherwise >365</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:variable name="durationDays"><xsl:value-of select="number(substring-before(substring-after($durationDays,'P'),'D'))+1" /></xsl:variable>
					
				<xsl:element name="price">
					<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
					<xsl:attribute name="productId">
						<xsl:choose>
							<xsl:when test="$productId != '*NONE'"><xsl:value-of select="$productId" /></xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$service" />-<xsl:value-of select="@productId" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					<available>Y</available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>
					<provider><xsl:value-of select="provider"/></provider>
					<trackCode>9</trackCode>
					<name><xsl:value-of select="name"/></name>
					<des><xsl:value-of select="des"/></des>
					<price><xsl:value-of select="format-number(premium,'#.00')"/></price>
					<priceText><xsl:value-of select="premiumText"/></priceText>
					 
					<info>
						<xsl:for-each select="productInfo">
							<xsl:choose>
							<xsl:when test="@propertyId = 'subTitle'"></xsl:when>
							<xsl:when test="@propertyId = 'infoDes'"></xsl:when>
							<xsl:otherwise>
								<xsl:element name="{@propertyId}">
									<xsl:copy-of select="*"/>
								</xsl:element>
							</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</info>
					
					<infoDes>
						<xsl:value-of select="productInfo[@propertyId='infoDes']/text" />
					</infoDes>
					<subTitle>
					</subTitle>
					
					<acn>000 000 000</acn>
					<afsLicenceNo>00000</afsLicenceNo>
					<quoteUrl>http://www.1cover.com.au/travel-insurance/view-quote.html?policyTypeId=<xsl:value-of select="$policyType" />%26destinationCode=<xsl:value-of select="$destinationCode" />%26durationDays=<xsl:value-of select="$durationDays" />%26numberOfAdults=<xsl:value-of select="$adults" />%26numberOfChildren=<xsl:value-of select="$children" />%26adultAges=<xsl:value-of select="$oldest" />%26affID=10169</quoteUrl>
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
				<xsl:when test="error">
					<xsl:copy-of select="error"></xsl:copy-of>
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
</xsl:stylesheet>