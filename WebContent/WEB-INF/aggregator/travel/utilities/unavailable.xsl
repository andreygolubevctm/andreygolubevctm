<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- UNAVAILABLE PRICE -->
	<xsl:template name="unavailable">
		<xsl:param name="productId" />
		<results>
			<xsl:element name="price">
				<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
				<xsl:attribute name="productId"><xsl:value-of select="$service" />-<xsl:value-of select="$productId" /></xsl:attribute>

				<available>N</available>
				<transactionId><xsl:value-of select="$transactionId"/></transactionId>
					<error service="{$service}" type="unavailable">
						<code>
							<xsl:choose>
								<xsl:when test="error/code"><xsl:value-of select="error/code" /></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</code>
						<message>
							<xsl:choose>
								<xsl:when test="error/message"><xsl:value-of select="error/message" /></xsl:when>
								<xsl:otherwise>unavailable</xsl:otherwise>
							</xsl:choose>
						</message>
						<data></data>
					</error>
				<name></name>
				<des></des>
				<info></info>
			</xsl:element>
		</results>
	</xsl:template>
</xsl:stylesheet>