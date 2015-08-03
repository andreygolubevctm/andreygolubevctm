<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="/">
		<soap-response>
				<results>
					<xsl:for-each select="soap-response/results/result">
							<xsl:choose>
								<xsl:when test="@type = 'quote'">
									<xsl:variable name="productId" select="@productId" />
									<xsl:variable name="service" select="@service" />
									<xsl:variable name="type" select="@type" />
									<result service="{$service}" type="{$type}" productId="{$productId}">
										<xsl:apply-templates select="*" />
										<xsl:for-each select="/soap-response/results/result">
											<xsl:variable name="productId2" select="@productId" />
											<xsl:variable name="service2" select="@service" />
											<xsl:variable name="type2" select="@type" />
											<xsl:choose>
												<xsl:when test="$productId2 = $productId and $type2 = 'content'">
													<xsl:apply-templates select="*" />
												</xsl:when>
											</xsl:choose>
										</xsl:for-each>
									</result>
								</xsl:when>
							</xsl:choose>
					</xsl:for-each>
				</results>
		</soap-response>
	</xsl:template>

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>