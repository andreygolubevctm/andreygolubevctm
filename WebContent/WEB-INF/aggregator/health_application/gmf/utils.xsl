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
    	
		<xsl:value-of select="$year" />-<xsl:value-of select="format-number($month,'00')" />-<xsl:value-of select="format-number($day,'00')" />
	</xsl:template>
	<xsl:template name="subtract_1_day">
		<xsl:param name="isoDate"/>
		
		<!-- Oh date fields - how I hate you that you make me write such hackery -->
    	<xsl:variable name="year" 		select="substring-before($isoDate,'-')" />
    	<xsl:variable name="monthTemp" select="substring-after($isoDate,'-')" />
    	<xsl:variable name="month" 		select="substring-before($monthTemp,'-')" />    	
    	<xsl:variable name="day" 		select="substring-after($monthTemp,'-')" />
		
		<xsl:variable name="days31">01 03 05 07 08 10 12</xsl:variable>   
		<xsl:variable name="days30">04 06 09 11</xsl:variable>
		
		<xsl:variable name="prevYear" select="format-number(number($year)-1,'00')" />
		<xsl:variable name="prevMonth" select="format-number(number($month)-1,'00')" />
		<xsl:variable name="prevDay" select="format-number(number($day)-1,'00')" />
		
		<xsl:choose>
			<!-- 1st of the year -->
			<xsl:when test="$day='01' and $month='01'">
				<xsl:value-of select="concat($prevYear,'-12-31')" />
			</xsl:when>
			<!-- 1st of the month (prev month has 31 days) -->
			<xsl:when test="$day='01' and contains($days31,$prevMonth)">
				<xsl:value-of select="concat($year,'-',$prevMonth,'-31')" />
			</xsl:when>
			<!-- 1st of the month (prev month has 30 days) -->
			<xsl:when test="$day='01' and contains($days30,$prevMonth)">
				<xsl:value-of select="concat($year,'-',$prevMonth,'-30')" />
			</xsl:when>
			<!-- 1st of the month (prev month is february and a leap year) -->
			<xsl:when test="$day='01' and $prevMonth='02' and number($year) mod 4=0">
				<xsl:value-of select="concat($year,'-',$prevMonth,'-29')" />
			</xsl:when>
			<!-- 1st of the month (prev month is february and not a leap year) -->
			<xsl:when test="$day='01' and $prevMonth='02'">
				<xsl:value-of select="concat($year,'-',$prevMonth,'-28')" />
			</xsl:when>
			<!-- Any other day -->
			<xsl:otherwise>
				<xsl:value-of select="concat($year,'-',$month,'-',$prevDay)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
</xsl:stylesheet>