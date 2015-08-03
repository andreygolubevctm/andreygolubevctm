<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="soap-response">
		<results>
			<xsl:for-each select="*/price">
				<result>

					<xsl:apply-templates select="@*" />
					<xsl:apply-templates select="./*" />

					<headline>
						<xsl:choose>
							<xsl:when test="headlineOffer = 'ONLINE'">
								<xsl:apply-templates select="onlinePrice/*" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="offlinePrice/*" />
							</xsl:otherwise>
						</xsl:choose>
					</headline>
				</result>
			</xsl:for-each>
		</results>
	</xsl:template>

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>