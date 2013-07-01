<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes" />

<xsl:include href="/WEB-INF/aggregator/includes/utils.xsl"/>

	<xsl:param name="hospital"></xsl:param>
	<xsl:param name="extras"></xsl:param>

	<xsl:template match="/promoData">
		<xsl:variable name="unescapedHospital">
			<xsl:call-template name="util_replace">
				<xsl:with-param name="text" select="$hospital" />
				<xsl:with-param name="replace" select="'&amp;amp;'" />
				<xsl:with-param name="with" select="'&amp;'" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="unescapedExtras">
			<xsl:call-template name="util_replace">
				<xsl:with-param name="text" select="$extras" />
				<xsl:with-param name="replace" select="'&amp;amp;'" />
				<xsl:with-param name="with" select="'&amp;'" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="promo[@hospital=$unescapedHospital and @extras=$unescapedExtras]">
				<xsl:copy-of select="promo[@hospital=$unescapedHospital and @extras=$unescapedExtras]/*" />
			</xsl:when>
			<xsl:when test="promo[@hospital=$unescapedHospital and not(@extras)]">
				<xsl:copy-of select="promo[@hospital=$unescapedHospital and not(@extras)]/*" />
			</xsl:when>
			<xsl:when test="promo[@extras=$unescapedExtras and not(@hospital)]">
				<xsl:copy-of select="promo[@extras=$unescapedExtras and not(@hospital)] /*"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>