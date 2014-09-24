<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="productDetails">
		<xsl:param name="productId" />
		<xsl:param name="productType" />

		<xsl:choose>

			<xsl:when test="$productId = 'REIN-02-01'">
				<additionalExcess>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'"></xsl:when>
						<xsl:when test="$productType = 'HHC'"></xsl:when>
						<xsl:when test="$productType = 'HHZ'"></xsl:when>
					</xsl:choose>
				</additionalExcess>
			</xsl:when>

			<xsl:when test="$productId = 'REIN-02-02'">
				<additionalExcess>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'"></xsl:when>
						<xsl:when test="$productType = 'HHC'"></xsl:when>
						<xsl:when test="$productType = 'HHZ'"></xsl:when>
					</xsl:choose>
				</additionalExcess>
			</xsl:when>

			<xsl:when test="$productId = 'WOOL-02-01'">
				<additionalExcess>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'"></xsl:when>
						<xsl:when test="$productType = 'HHC'"></xsl:when>
						<xsl:when test="$productType = 'HHZ'"></xsl:when>
					</xsl:choose>
				</additionalExcess>
			</xsl:when>

			<xsl:when test="$productId = 'WOOL-02-02'">
				<additionalExcess>
					<xsl:choose>
						<xsl:when test="$productType = 'HHB'"></xsl:when>
						<xsl:when test="$productType = 'HHC'"></xsl:when>
						<xsl:when test="$productType = 'HHZ'"></xsl:when>
					</xsl:choose>
				</additionalExcess>
			</xsl:when>

	<!-- DEFAULT -->
			<xsl:otherwise>
				<disclaimer></disclaimer>
				<specialConditions></specialConditions>
				<additionalExcess></additionalExcess>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>