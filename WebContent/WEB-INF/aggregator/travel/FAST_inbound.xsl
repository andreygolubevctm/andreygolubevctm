<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv">
	
<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

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
		<!-- ACCEPTABLE -->
		<xsl:when test="/results/result/premium">
			<xsl:apply-templates />
		</xsl:when>
		
		<!-- UNACCEPTABLE -->
		<xsl:otherwise>
			<results>
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-40</xsl:with-param>
				</xsl:call-template>
				<!-- 0 Results returned so no need to call 6 product variations
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-14</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-15</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-16</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-17</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId">TRAVEL-18</xsl:with-param>
				</xsl:call-template>	
				 -->							
			</results>
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
					<trackCode>14</trackCode>
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
									<label>Overseas Medical</label><desc>Overseas Medical</desc><value>0</value><text>N/A</text><order>1</order>
								</xsl:element>
							</xsl:when>
							<xsl:when test="@propertyId = 'medicalassi' and $domestic = 'Yes'">
								<xsl:element name="{@propertyId}">
									<label>Overseas Medical Assistance</label><desc>Overseas Emergency Medical Assistance</desc><value>0</value><text>N/A</text><order>1</order>
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
					<subTitle><xsl:value-of select="productInfo[@propertyId='subTitle']/text"/></subTitle>

					
					<acn>000 000 000</acn>
					<afsLicenceNo>00000</afsLicenceNo>
					<quoteUrl>http://fastcover.com.au/ref?id=ctm%26page=home</quoteUrl>
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