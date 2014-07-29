<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv">
	
<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="utilities/unavailable.xsl"/>

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId">*NONE</xsl:param>
	<xsl:param name="defaultProductId"><xsl:value-of select="$productId" /></xsl:param>
	<xsl:param name="service"></xsl:param>
	<xsl:param name="request" />	
	<xsl:param name="quoteUrl" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>	
		
<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<xsl:choose>
		<!-- ACCEPTABLE -->
		<xsl:when test="/results/result/premium">
			<xsl:apply-templates />
		</xsl:when>
		
		<!-- UNACCEPTABLE -->
		<xsl:otherwise>
				<xsl:call-template name="unavailable">
						<xsl:with-param name="productId">TRAVEL-144</xsl:with-param>
					</xsl:call-template>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/results">
		<results>	
						
			<xsl:for-each select="result">
				
				<xsl:variable name="domestic">
					<xsl:choose>
						<xsl:when test="count($request/travel/destinations/*) = 1 and $request/travel/destinations/au/au">Yes</xsl:when>
						<xsl:otherwise>No</xsl:otherwise>								
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="policyType">
					<xsl:choose>
						<xsl:when test="@productId = 'TRAVEL-144'">1</xsl:when> <!-- Comprehensive -->
						<xsl:when test="@productId = 'TRAVEL-145'">2</xsl:when> <!-- Budget (Medical Only) -->
						<xsl:when test="@productId = 'TRAVEL-146'">3</xsl:when> <!-- AMT (37 Days) -->
						<xsl:when test="@productId = 'TRAVEL-160'">4</xsl:when> <!-- AMT (90 Days) -->
						<xsl:otherwise >1</xsl:otherwise> <!-- Default to Standard -->
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="destinationCode">
					<xsl:choose>
						<!-- REGION 1 (R1) -->
						<xsl:when test="$request/travel/destinations/am/us">WW</xsl:when>
						<xsl:when test="$request/travel/destinations/am/ca">WW</xsl:when>
						<xsl:when test="$request/travel/destinations/am/sa">WW</xsl:when>
						<xsl:when test="$request/travel/destinations/af/af">WW</xsl:when>
						<xsl:when test="$request/travel/destinations/me/me">WW</xsl:when>
						<xsl:when test="$request/travel/destinations/do/do">WW</xsl:when>

						<!-- REGION 2 (R2) -->
						<xsl:when test="$request/travel/destinations/eu/eu">EU</xsl:when>
						<xsl:when test="$request/travel/destinations/eu/uk">EU</xsl:when>

						<!-- REGION 3 (R3) -->
						<!-- China -->
						<xsl:when test="$request/travel/destinations/as/ch">AS</xsl:when>
						<!-- India -->
						<xsl:when test="$request/travel/destinations/as/in">AS</xsl:when>
						<!-- Japan -->
						<xsl:when test="$request/travel/destinations/as/jp">AS</xsl:when>
						<!-- HongKong -->
						<xsl:when test="$request/travel/destinations/as/hk">AS</xsl:when>
						<!-- Thailand -->
						<xsl:when test="$request/travel/destinations/as/th">AS</xsl:when>
						<!-- Indonesia -->
						<xsl:when test="$request/travel/destinations/pa/in">AS</xsl:when>
						<!-- Bali -->
						<xsl:when test="$request/travel/destinations/pa/ba">AS</xsl:when>

						<!-- REGION 4 (R4) -->
						<xsl:when test="$request/travel/destinations/pa/nz">PC</xsl:when>
						<xsl:when test="$request/travel/destinations/pa/pi">PC</xsl:when>
						<xsl:when test="$request/travel/destinations/au/au">AU</xsl:when>

						<!-- Default to REGION 1 (WW) -->
						<xsl:otherwise>WW</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

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
					<trackCode>25</trackCode>
					<name><xsl:value-of select="name"/></name>
					<des><xsl:value-of select="des"/></des>
					<price><xsl:value-of select="format-number(premium,'#.00')"/></price>
					<priceText><xsl:value-of select="premiumText"/></priceText>
					 
					<info>
						<xsl:for-each select="productInfo">
							<xsl:choose>
							<xsl:when test="@propertyId = 'subTitle'"></xsl:when>
							<xsl:when test="@propertyId = 'infoDes'"></xsl:when>
							<xsl:when test="@propertyId = 'medical' and $domestic = 'Yes'">
								<xsl:element name="{@propertyId}">
									<label>Overseas Medical</label><desc>Overseas Emergency Medical and Hospital Expenses</desc><value>0</value><text>N/A</text><order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'medicalAssi' and $domestic = 'Yes'">
								<xsl:element name="{@propertyId}">
									<label>Overseas Medical Assistance</label><desc>Overseas Emergency Medical Assistance</desc><value>0</value><text>N/A</text><order/>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'medical'">
								<xsl:element name="{@propertyId}">
									<label><xsl:value-of select="label" /></label>
									<desc>Overseas Emergency Medical</desc>
									<value><xsl:value-of select="value" /></value>
									<text><xsl:value-of select="text" /></text>
									<order/>
								</xsl:element>
							</xsl:when>
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
						<xsl:value-of select="productInfo[@propertyId='subTitle']/text"/>
					</subTitle>
					
					<acn>000 000 000</acn>
					<afsLicenceNo>00000</afsLicenceNo>
					<quoteUrl><xsl:text>https://</xsl:text>
						<xsl:value-of select="$quoteUrl" />
						<xsl:text>/affiliate/CompareTheMarket?policyTypeId=</xsl:text>
						<xsl:value-of select="$policyType" />
						<xsl:text>%26destinationCode=</xsl:text>
						<xsl:value-of select="$destinationCode" />
						<xsl:text>%26startDate=</xsl:text>
						<xsl:value-of select="translate($request/travel/dates/fromDate, '/', '-')" />
						<xsl:text>%26endDate=</xsl:text>
						<xsl:value-of select="translate($request/travel/dates/toDate, '/', '-')" />
						<xsl:text>%26numberOfAdults=</xsl:text>
						<xsl:value-of select="$request/travel/adults" />
						<xsl:text>%26numberOfChildren=</xsl:text>
						<xsl:value-of select="$request/travel/children" />
						<xsl:text>%26Ages=</xsl:text>
						<xsl:value-of select="$request/travel/oldest" />
						<xsl:if test="$request/travel/adults = '2'">
							<xsl:text>,</xsl:text><xsl:value-of select="$request/travel/oldest" />
						</xsl:if>
						<xsl:text>%26affID=10064</xsl:text>
					</quoteUrl>
				</xsl:element>		
			</xsl:for-each>
			
		</results>
	</xsl:template>
</xsl:stylesheet>