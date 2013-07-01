<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="file"><xsl:text>../health_application/</xsl:text><xsl:value-of select="$fundid" /><xsl:text>/error_map.xml</xsl:text></xsl:variable>
	<xsl:variable name="fundErrors" select="document($file)" />
	<xsl:variable name="fundErrorMapping" select="$fundErrors//errors" />
	<xsl:variable name="errorMap" select="document('../health_application/error_map.xml')" />
	<xsl:variable name="errorMapping" select="$errorMap//errors" />

	<!-- TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="maperrors">
		<xsl:param name="code"/>
		<xsl:param name="message"/>
		
		<xsl:variable name="errorMapCode">
			<xsl:choose>
				<!-- The ? is a default overide to force all errors to map to a specific internal code -->
				<xsl:when test="$fundErrorMapping/error[@code='?'] != ''"><xsl:value-of select="$fundErrorMapping/error[@code='?']" /></xsl:when>
				<!-- If code not found then auto map to 000 -->
				<xsl:when test="not($fundErrorMapping/error[@code=$code])"><xsl:text>000</xsl:text></xsl:when>
				<!-- Otherwise use the mapped code -->
				<xsl:otherwise><xsl:value-of select="$fundErrorMapping/error[@code=$code]" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="mappedErrorMessage">
			<xsl:choose>
				<!-- Return original message if code not mapped -->
				<xsl:when test="not($errorMapping/error[@code=$errorMapCode])"><xsl:value-of select="$message" /></xsl:when>
				<!-- If code mapped to 999 return the original message -->
				<xsl:when test="$errorMapCode='999'"><xsl:value-of select="$message" /></xsl:when>
				<!-- If code mapped to 000 or 999 return mapped message AND the original message -->
				<xsl:when test="$errorMapCode='000'"><xsl:value-of select="$errorMapping/error[@code=$errorMapCode]" /><xsl:text> </xsl:text><xsl:value-of select="$message" /></xsl:when>
				<!-- Otherwise just return the mapped message -->
				<xsl:otherwise><xsl:value-of select="$errorMapping/error[@code=$errorMapCode]" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
						
		<error>
			<code><xsl:value-of select="$code" /></code>
			<text><xsl:value-of select="$mappedErrorMessage" /></text> 
			<original><xsl:value-of select="$message" /></original> 
		</error>
	</xsl:template>

</xsl:stylesheet>