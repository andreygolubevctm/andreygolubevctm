<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- HANDOVER MAPPING START -->
	<xsl:template name="getHandoverMapping">
		<xsl:param name="handoverValues" />
		<xsl:param name="delimiter" select="','" />

		<xsl:choose>
			<xsl:when test="contains($handoverValues, $delimiter)">
				<xsl:value-of select="substring-before($handoverValues,$delimiter)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$handoverValues"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- HANDOVER MAPPING END -->

	<!-- HANDOVER MAPPING MULTIPLE START -->
	<xsl:template name="getMultipleHandoverMapping">
		<xsl:param name="handoverValues" />
		<xsl:param name="delimiter" select="','" />

		<xsl:choose>
			<xsl:when test="contains($handoverValues, $delimiter)">
				<xsl:variable name="handoverValue">
					<xsl:value-of select="substring-before($handoverValues,$delimiter)"/>
				</xsl:variable>

				<xsl:call-template name="buildREALWOOLHandover">
					<xsl:with-param name="handoverValue" select="$handoverValue" />
				</xsl:call-template>

				<xsl:call-template name="getMultipleHandoverMapping">
					<xsl:with-param name="handoverValues" select="substring-after($handoverValues,',')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="buildREALWOOLHandover">
					<xsl:with-param name="handoverValue" select="$handoverValues" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- REAL & WOOL -->
	<xsl:template name="buildREALWOOLHandover">
		<xsl:param name="handoverValue" />
		<xsl:text>%26DestinationCode[]=</xsl:text><xsl:value-of select="$handoverValue" />
	</xsl:template>
	<!-- HANDOVER MAPPING MULTIPLE END -->
</xsl:stylesheet>