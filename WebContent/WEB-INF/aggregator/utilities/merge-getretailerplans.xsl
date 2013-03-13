<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="soap-response">
		<results>
			<Electricity>
				<xsl:apply-templates select="results/Electricity/*" />
			</Electricity>
			<Gas>
				<xsl:apply-templates select="results/Gas/*" />
			</Gas>
		</results>
	</xsl:template>

	<xsl:template match="node()|@*">
		<xsl:copy>
	  		<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>