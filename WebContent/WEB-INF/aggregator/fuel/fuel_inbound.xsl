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
		<xsl:when test="/results/result/premium or /results/result/premium2">
			<xsl:choose>
				<xsl:when test="/results[@type = 'metro']">
					<xsl:call-template name="metro" />
				</xsl:when>
				<xsl:when test="/results[@type = 'regional']">
					<xsl:call-template name="regional" />
				</xsl:when>
			</xsl:choose>
		</xsl:when>
		
		<!-- UNACCEPTABLE -->
		<xsl:otherwise>
			<results>
				<source><xsl:value-of select="/results/@type" /></source>
				<error><xsl:value-of select="/results/error" /></error>
				<results>0</results>
			</results>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="metro">
		<results>
			<source>metro</source>		
			<xsl:if test='//error'>
				<error><xsl:value-of select='//error' /></error>
			</xsl:if>
			<xsl:if test='//time'>
				<timeDiff><xsl:value-of select='//time' /></timeDiff>
			</xsl:if>
			<xsl:if test='//update'>
				<update><xsl:value-of select='//update' /></update>
			</xsl:if>
			<results><xsl:value-of select="count(//result)" /></results>
			<xsl:for-each select="//result">						
			
				<xsl:variable name="premium"><xsl:value-of select='format-number(premium, "####")' /></xsl:variable>
				<xsl:variable name="premiumText"><xsl:value-of select="$premium div 10" /></xsl:variable>
				
				<!-- nice fuel names -->
				<xsl:variable name="fuelText">
					<xsl:choose>
						<xsl:when test="fuelid = 2">Unleaded</xsl:when>
						<xsl:when test="fuelid = 3">Diesel</xsl:when>
						<xsl:when test="fuelid = 4">LPG</xsl:when>
						<xsl:when test="fuelid = 5">Premium Unleaded 95</xsl:when>
						<xsl:when test="fuelid = 6">E10</xsl:when>
						<xsl:when test="fuelid = 7">Premium Unleaded 98</xsl:when>
						<xsl:when test="fuelid = 8">Bio-Diesel 20</xsl:when>
						<xsl:when test="fuelid = 9">Premium Diesel</xsl:when>
						<xsl:otherwise>Unknown</xsl:otherwise>												
					</xsl:choose>
				</xsl:variable>				
			
			
				<xsl:element name="price">
					<xsl:attribute name="service">MMOT</xsl:attribute>
					<xsl:attribute name="productId"><xsl:value-of select="siteid" />-<xsl:value-of select="fuelid" /></xsl:attribute>
					
					<provider><xsl:value-of select="brand" /></provider>
					<available>Y</available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>
					<name><xsl:value-of select="name" /></name>
					<price><xsl:value-of select="$premium" /></price>
					<priceText><xsl:value-of select="$premiumText" /></priceText>												
	
					<siteid><xsl:value-of select="siteid" /></siteid>					
					<state><xsl:value-of select="state" /></state>
					<suburb><xsl:value-of select="suburb" /></suburb>
					<address><xsl:value-of select="address" /></address>
					<postcode><xsl:value-of select="postcode" /></postcode>
					<lat><xsl:value-of select="lat" /></lat>
					<long><xsl:value-of select="long" /></long>
					<fuelid><xsl:value-of select="fuelid" /></fuelid>
					<fuelText><xsl:value-of select="$fuelText" /></fuelText>

					<created><xsl:value-of select="created" /></created>
				</xsl:element>
			</xsl:for-each>
						
		</results>
	</xsl:template>
	
	
	
	<xsl:template name="regional">
	
		<!-- nice fuel names -->
		<xsl:variable name="fuel1">
			<xsl:choose>
				<xsl:when test="//fuel1 = 2">Unleaded</xsl:when>
				<xsl:when test="//fuel1 = 3">Diesel</xsl:when>
				<xsl:when test="//fuel1 = 4">LPG</xsl:when>
				<xsl:when test="//fuel1 = 5">Premium Unleaded 95</xsl:when>
				<xsl:when test="//fuel1 = 6">E10</xsl:when>
				<xsl:when test="//fuel1 = 7">Premium Unleaded 98</xsl:when>
				<xsl:when test="//fuel1 = 8">Bio-Diesel 20</xsl:when>
				<xsl:when test="//fuel1 = 9">Premium Diesel</xsl:when>
				<xsl:otherwise></xsl:otherwise>												
			</xsl:choose>
		</xsl:variable>
		
		<!-- nice fuel names -->
		<xsl:variable name="fuel2">
			<xsl:choose>
				<xsl:when test="//fuel2 = 2">Unleaded</xsl:when>
				<xsl:when test="//fuel2 = 3">Diesel</xsl:when>
				<xsl:when test="//fuel2 = 4">LPG</xsl:when>
				<xsl:when test="//fuel2 = 5">Premium Unleaded 95</xsl:when>
				<xsl:when test="//fuel2 = 6">E10</xsl:when>
				<xsl:when test="//fuel2 = 7">Premium Unleaded 98</xsl:when>
				<xsl:when test="//fuel2 = 8">Bio-Diesel 20</xsl:when>
				<xsl:when test="//fuel2 = 9">Premium Diesel</xsl:when>
				<xsl:otherwise></xsl:otherwise>												
			</xsl:choose>
		</xsl:variable>						
	
		<results>
			<source>regional</source>
			
			<fuel1><xsl:value-of select='//fuel1' /></fuel1>
			<fuel2><xsl:value-of select='//fuel2' /></fuel2>
			<fuel1Text><xsl:value-of select='$fuel1' /></fuel1Text>
			<fuel2Text><xsl:value-of select='$fuel2' /></fuel2Text>
			
			<xsl:if test='//error'>
				<error><xsl:value-of select='//error' /></error>
			</xsl:if>
			<xsl:if test='//time'>
				<timeDiff><xsl:value-of select='//time' /></timeDiff>
			</xsl:if>
			<xsl:if test='//update'>
				<update><xsl:value-of select='//update' /></update>
			</xsl:if>
			<results><xsl:value-of select="count(//result)" /></results>
			
			<xsl:for-each select="//result">
			
				<xsl:variable name="premium"><xsl:value-of select='format-number(premium, "####")' /></xsl:variable>
				<xsl:variable name="premiumText">
					<xsl:choose>
						<xsl:when test="$premium = 'NaN'"> </xsl:when>
						<xsl:otherwise><xsl:value-of select='format-number($premium div 10, "####.0")' /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>	
				
				<xsl:variable name="premium2"><xsl:value-of select='format-number(premium2, "####")' /></xsl:variable>
				<xsl:variable name="premium2Text">
					<xsl:choose>
						<xsl:when test="$premium2 = 'NaN'"> </xsl:when>
						<xsl:otherwise><xsl:value-of select='format-number($premium2 div 10, "####.0")' /></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>												
						
				<xsl:element name="price">
					<xsl:attribute name="service">MMOT</xsl:attribute>
					<xsl:attribute name="productId"><xsl:number value="position()"/>-<xsl:value-of select="fuelid" /></xsl:attribute>
					
					<available>Y</available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>
					<city><xsl:value-of select="name" /></city>
					<price><xsl:value-of select="$premium" /></price>
					<priceText><xsl:value-of select="$premiumText" /></priceText>
					<price2><xsl:value-of select="$premium2" /></price2>
					<price2Text><xsl:value-of select="$premium2Text" /></price2Text>
					<state><xsl:value-of select="state" /></state>
					<created><xsl:value-of select="created" /></created>
				</xsl:element>
			</xsl:for-each>
						
		</results>
	</xsl:template>	

</xsl:stylesheet>