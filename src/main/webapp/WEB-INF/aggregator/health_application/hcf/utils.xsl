<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan">

	<xsl:template name="format_date">
		<xsl:param name="eurDate"/>

    	<xsl:variable name="day" 		select="substring-before($eurDate,'/')" />
    	<xsl:variable name="month-temp" select="substring-after($eurDate,'/')" />
    	<xsl:variable name="month" 		select="substring-before($month-temp,'/')" />    	
    	<xsl:variable name="year" 		select="substring-after($month-temp,'/')" />
    	
		<xsl:value-of select="format-number($day,'00')" />
		<xsl:value-of select="format-number($month,'00')" />		
		<xsl:value-of select="$year" />
	</xsl:template>	
	
	<xsl:template name="title_code">
		<xsl:param name="title" />
		<xsl:choose>
			<xsl:when test="$title='MR'">001</xsl:when>
			<xsl:when test="$title='MRS'">002</xsl:when>
			<xsl:when test="$title='MISS'">003</xsl:when>
			<xsl:when test="$title='MS'">004</xsl:when>
			<xsl:when test="$title='DR'">007</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="cc_type">
		<xsl:param name="type" />
		<xsl:choose>
			<xsl:when test="$type='v'">VC</xsl:when>
			<xsl:when test="$type='m'">MC</xsl:when>
			<xsl:when test="$type='a'">AE</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>