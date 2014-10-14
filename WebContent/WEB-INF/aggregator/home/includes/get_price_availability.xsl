<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="getPriceAvailability">

		<xsl:param name="productId"/>
		<xsl:param name="priceType"/>

		<xsl:choose>

		<!-- online availability -->
			<xsl:when test="$priceType = 'ONLINE'">

				<xsl:choose>
					<xsl:when test="$productId = 'BUDD-05-29'">Y</xsl:when>
					<xsl:when test="$productId = 'VIRG-05-26'">Y</xsl:when>
					<xsl:when test="$productId = 'EXDD-05-21'">Y</xsl:when>
					<xsl:when test="$productId = 'REIN-02-01'">Y</xsl:when>
					<xsl:when test="$productId = 'REIN-02-02'">Y</xsl:when>
					<xsl:when test="$productId = 'WOOL-02-01'">Y</xsl:when>
					<xsl:when test="$productId = 'WOOL-02-02'">Y</xsl:when>

					<xsl:otherwise>N</xsl:otherwise>
				</xsl:choose>

			</xsl:when>

		<!-- offline availability -->
			<xsl:when test="$priceType = 'OFFLINE'">

				<xsl:choose>
					<xsl:when test="$productId = 'BUDD-05-29'">Y</xsl:when>
					<xsl:when test="$productId = 'VIRG-05-26'">Y</xsl:when>
					<xsl:when test="$productId = 'EXDD-05-21'">Y</xsl:when>
					<xsl:when test="$productId = 'REIN-02-01'">Y</xsl:when>
					<xsl:when test="$productId = 'REIN-02-02'">Y</xsl:when>
					<xsl:when test="$productId = 'WOOL-02-01'">Y</xsl:when>
					<xsl:when test="$productId = 'WOOL-02-02'">Y</xsl:when>

					<xsl:otherwise>N</xsl:otherwise>
				</xsl:choose>

			</xsl:when>

		<!-- callback availability -->
			<xsl:when test="$priceType = 'CALLBACK'">

					<xsl:choose>
						<xsl:when test="$productId = 'BUDD-05-29'">N</xsl:when>
						<xsl:when test="$productId = 'VIRG-05-26'">N</xsl:when>
						<xsl:when test="$productId = 'EXDD-05-21'">N</xsl:when>
						<xsl:when test="$productId = 'REIN-02-01'">N</xsl:when>
						<xsl:when test="$productId = 'REIN-02-02'">N</xsl:when>
						<xsl:when test="$productId = 'WOOL-02-01'">N</xsl:when>
						<xsl:when test="$productId = 'WOOL-02-02'">N</xsl:when>

						<xsl:otherwise>N</xsl:otherwise>
					</xsl:choose>

			</xsl:when>

		</xsl:choose>

	</xsl:template>

</xsl:stylesheet>