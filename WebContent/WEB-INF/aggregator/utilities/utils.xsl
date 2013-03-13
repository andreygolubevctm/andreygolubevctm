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
	
	<xsl:template name="string-replace-all">
		<xsl:param name="text" />
		<xsl:param name="replace" />
		<xsl:param name="by" />
		<xsl:choose>
			<xsl:when test="contains($text, $replace)">
				<xsl:value-of select="substring-before($text,$replace)" />
				<xsl:value-of select="$by" />
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="substring-after($text,$replace)" />
					<xsl:with-param name="replace" select="$replace" />
					<xsl:with-param name="by" select="$by" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="substring-before-last">
    	<!--passed template parameter -->
        <xsl:param name="list"/>
        <xsl:param name="delimiter"/>
        
        <xsl:choose>
            <xsl:when test="contains($list, $delimiter)">
        		<!-- get everything in front of the first delimiter -->
                <xsl:value-of select="substring-before($list,$delimiter)"/>
                <xsl:choose>
                    <xsl:when test="contains(substring-after($list,$delimiter),$delimiter)">
                        <xsl:value-of select="$delimiter"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:call-template name="substring-before-last">
                    <!-- store anything left in another variable -->
                    <xsl:with-param name="list" select="substring-after($list,$delimiter)"/>
                    <xsl:with-param name="delimiter" select="$delimiter"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
	<xsl:template name="substring-after-last">
		<!--passed template parameter -->
        <xsl:param name="list"/>
        <xsl:param name="delimiter"/>
        
        <xsl:choose>
        	<xsl:when test="contains($list, $delimiter)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="list" select="substring-after($list, $delimiter)"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$list"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>