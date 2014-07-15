<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="productId"></xsl:param>

	<xsl:template match="error">
		<xsl:call-template name="noQuote" />
	</xsl:template>

	<xsl:template match="soap-response">
		<results>
			<xsl:apply-templates select="results/*" />
		</results>
	</xsl:template>

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="noQuote">
		<xsl:variable name="service">
			<xsl:choose>
				<xsl:when test="$productId = ''">
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-before($productId, '-')" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="productName">
			<xsl:choose>
			<xsl:when test="$service = 'WOOL'">Woolworths And Contents Insurance</xsl:when>
			<xsl:when test="$service = 'REIN'">Real Home &amp; Contents Insurance</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<results>
			<xsl:element name="result">
				<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
				<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
				<productAvailable>N</productAvailable>
				<xsl:copy-of select="error"></xsl:copy-of>
				<!-- <transactionId><xsl:value-of select="/transactionId"/></transactionId> -->
				<headline>
					<name><xsl:value-of select="$productName" /></name>
					<feature/>
				</headline>
			</xsl:element>
		</results>
	</xsl:template>
</xsl:stylesheet>