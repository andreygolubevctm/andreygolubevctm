<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../../../includes/utils.xsl"/>

	<xsl:param name="productId"></xsl:param>

	<xsl:template match="node()|@*">
		<xsl:choose>
			<!-- We sent though a correct error, just copy it -->
			<xsl:when test="/soap-response">
				<xsl:copy-of select="/soap-response/results"/>
			</xsl:when>
			<xsl:when test="/results">
				<xsl:copy-of select="."/>
			</xsl:when>
			<xsl:when test="error/@type">
				<xsl:copy-of select="."/>
			</xsl:when>
			<!-- We didn't get an error we handled earlier. Must be a service fault. -->
			<xsl:otherwise>
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
					<xsl:element name="price">
						<xsl:attribute name="productId"><xsl:value-of select="$productId" /></xsl:attribute>
						<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
						<available>N</available>
						<xsl:call-template name="error_message">
							<xsl:with-param name="service" select="$service"/>
							<xsl:with-param name="error_type">service_call_failed</xsl:with-param>
							<xsl:with-param name="message">
							<xsl:copy-of select="."/>
							</xsl:with-param>
							<xsl:with-param name="code"></xsl:with-param>
							<xsl:with-param name="data"></xsl:with-param>
						</xsl:call-template>
						<headline>
							<name><xsl:value-of select="$productName" /></name>
							<feature/>
						</headline>
					</xsl:element>
				</results>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
</xsl:stylesheet>