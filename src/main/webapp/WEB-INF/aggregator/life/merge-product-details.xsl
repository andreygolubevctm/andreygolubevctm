<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="soap-response">
		<results>
			<xsl:apply-templates select="*/success" />
			<xsl:apply-templates select="*/error" />

			<!-- This may appear to be a waste of time and truthfully there's probably a better way
				however that other way eludes me. Basically what's happening here is I'm removing
				feature duplicates (by ID) created in the inbound.xsl. -->
			<xsl:element name="features">
				<xsl:for-each select="*/features/product">
					<xsl:element name="product">
						<xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
						<xsl:for-each select="feature">
							<xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
							<xsl:variable name="name"><xsl:value-of select="name"/></xsl:variable>
							<xsl:variable name="available"><xsl:value-of select="available"/></xsl:variable>
							<xsl:if test="not(preceding-sibling::*/name = $name)">
								<xsl:element name="feature">
									<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
									<xsl:element name="name"><xsl:value-of select="$name"/></xsl:element>
									<xsl:element name="available"><xsl:value-of select="$available"/></xsl:element>
								</xsl:element>
							</xsl:if>
						</xsl:for-each>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</results>
	</xsl:template>

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>