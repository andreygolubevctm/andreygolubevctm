<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- today comes in as YYYY-mm-dd by default -->
	<xsl:template name="formatDate">
		<xsl:param name="today"/>
		<xsl:param name="oldest"/>
		<xsl:param name="seperator"/>
		<xsl:param name="dateFormat"/>
		<xsl:variable name="thisYear">
			<xsl:value-of select="substring($today,1,4)" />
		</xsl:variable>

		<xsl:variable name="defaultYear">
			<xsl:value-of select="$thisYear - $oldest"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$dateFormat = 'YYYYmmdd'">
				<xsl:value-of select="concat($defaultYear, $seperator, substring($today,6,2), $seperator, substring($today,9,2))" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(substring($today,9,2), $seperator, substring($today,6,2), $seperator, $defaultYear)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getBirthDate">
		<xsl:param name="today"/>
		<xsl:param name="yearsAgo"/>
		<xsl:value-of select="concat(substring($today, 1, 4)-$yearsAgo, '-', substring($today,6,2), '-', substring($today,9,2))" />
	</xsl:template>
</xsl:stylesheet>