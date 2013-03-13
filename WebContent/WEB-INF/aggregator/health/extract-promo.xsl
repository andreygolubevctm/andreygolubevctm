<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes" />

	<xsl:param name="hospital"></xsl:param>
	<xsl:param name="extras"></xsl:param>
	
	<xsl:template match="/promoData">
		<xsl:choose>
			<xsl:when test="promo[@hospital=$hospital and @extras=$extras]">
				<xsl:copy-of select="promo[@hospital=$hospital and @extras=$extras]/*" />
			</xsl:when>
			<xsl:when test="promo[@hospital=$hospital and not(@extras)]">
				<xsl:copy-of select="promo[@hospital=$hospital and not(@extras)]/*" />
			</xsl:when>
			<xsl:when test="promo[@extras=$extras and not(@hospital)]">
				<xsl:copy-of select="promo[@extras=$extras and not(@hospital)] /*"/>
			</xsl:when>			
		</xsl:choose>
	</xsl:template>	
	
</xsl:stylesheet>