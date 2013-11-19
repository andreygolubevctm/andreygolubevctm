<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="soap-response">
		<results>
			<xsl:apply-templates select="*/success" />
			<xsl:apply-templates select="*/error" />
			<xsl:apply-templates select="*/selection" />
		</results>
	</xsl:template>

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>