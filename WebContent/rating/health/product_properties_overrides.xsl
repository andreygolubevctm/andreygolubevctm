<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes" indent="no"></xsl:output>

	<xsl:variable name="overrides" select="/data/overrides/*" />

	<xsl:template match="/">
		<xsl:apply-templates select="/data/phio"/>
	</xsl:template>

	<xsl:template match="*[name() != 'data' 
							and name() != 'override' 
							and name() != 'overrides']">
	
		<xsl:variable name="fullXpath">
			<xsl:for-each select="ancestor-or-self::*">
				<xsl:text>/</xsl:text><xsl:value-of select="name()" />
			</xsl:for-each>
		 </xsl:variable>
		 <xsl:variable name="thisXpath"><xsl:value-of select="substring-after($fullXpath, '/data/phio/')" /></xsl:variable>
		 
		 <xsl:variable name="overrideValue">
		 	<xsl:value-of select="$overrides[@xpath=$thisXpath]" />
		 </xsl:variable>
		 
		 <xsl:copy>
		 	<xsl:choose>
		 		<xsl:when test="$overrideValue != ''">
		 			<xsl:value-of select="$overrideValue" />
		 		</xsl:when>
		 		<xsl:otherwise>
		 			<xsl:apply-templates />
		 		</xsl:otherwise>
		 	</xsl:choose>
		 </xsl:copy>
		 
	</xsl:template>
</xsl:stylesheet>