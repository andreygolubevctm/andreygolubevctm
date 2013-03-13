<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:a="http://services.fastr.com.au/Payment/Data"
	xmlns:i="http://www.w3.org/2001/XMLSchema-instance"	
	xmlns:b="http://schemas.microsoft.com/2003/10/Serialization/Arrays"
	xmlns:avea="http://services.fastr.com.au/Payment"
	exclude-result-prefixes="s a i b avea">	

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->	
	<xsl:import href="../includes/utils.xsl"/>

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- POLICY DETAILS AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->	
	<xsl:template match="avea:ProcessAndUpdateMainInsuredResult">
		<results>	
		<xsl:element name="policyDetails">
			<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
			<xsl:attribute name="service">AVEA</xsl:attribute>	
									
				<available>Y</available>
				<policyNumber><xsl:value-of select="a:Policies/a:Policy/a:PolicyNumber"/></policyNumber>
				<policySchedule><xsl:value-of select="a:Policies/a:Policy/a:PolicySchedule/a:DocumentUrl"/></policySchedule>			

	 	</xsl:element>			
		</results>
	</xsl:template>
	
	<!-- ERROR -->
	<xsl:template match="/error">
		<results>
			<xsl:element name="policyDetails">
				<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
				<xsl:attribute name="service">AVEA</xsl:attribute>	
				
				<available>N</available>
				<transactionId><xsl:value-of select="$transactionId"/></transactionId>
				<error service="AVEA" type="unavailable">
					<code></code>
					<message>There was an error processing payment</message>
					<data></data>
				</error>
				
			</xsl:element>
		</results>
	</xsl:template>	
	
</xsl:stylesheet>