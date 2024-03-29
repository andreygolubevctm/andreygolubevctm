<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:template name="getPriceAvailability">
	
		<xsl:param name="productId"/>
		<xsl:param name="priceType"/>
		<xsl:param name="hasModifications"/>
		
		
		<xsl:choose>
		
		<!-- has no modifications callback availability -->
			<xsl:when test="$hasModifications = 'N' and $priceType = 'CALLBACK'">
			
					<xsl:choose>
						<xsl:when test="$productId = 'BUDD-05-01'">Y</xsl:when>
						<xsl:when test="$productId = 'BUDD-05-04'">Y</xsl:when>
						<xsl:when test="$productId = 'BUDD-05-15'">Y</xsl:when>
						<xsl:when test="$productId = 'VIRG-05-17'">Y</xsl:when>
						<xsl:when test="$productId = 'IECO-05-09'">Y</xsl:when>
						<xsl:when test="$productId = 'IHAF-05-13'">Y</xsl:when>
						<xsl:when test="$productId = 'EXPO-05-16'">Y</xsl:when>
						<xsl:when test="$productId = '1FOW-05-02'">Y</xsl:when>
						<xsl:when test="$productId = 'OZIC-05-01'">Y</xsl:when>
						<xsl:when test="$productId = 'OZIC-05-04'">Y</xsl:when>
						<xsl:when test="$productId = 'CBCK-05-08'">Y</xsl:when>
						<xsl:when test="$productId = 'RETI-05-03'">Y</xsl:when>
						<xsl:when test="$productId = 'EXDD-05-04'">Y</xsl:when>
						
						<xsl:when test="$productId = 'AI-01-01'">Y</xsl:when>
						<xsl:when test="$productId = 'AI-01-02'">Y</xsl:when>
						<xsl:when test="$productId = 'AI-01-04'">Y</xsl:when>
						
						<xsl:when test="$productId = 'REIN-01-01'">N</xsl:when>
						<xsl:when test="$productId = 'REIN-01-02'">N</xsl:when>

						<xsl:when test="$productId = 'WOOL-01-01'">N</xsl:when>
						<xsl:when test="$productId = 'WOOL-01-02'">N</xsl:when>

						<xsl:otherwise>N</xsl:otherwise>
					</xsl:choose>
				
			</xsl:when>
			
		<!-- has modifications callback availability -->
			<xsl:when test="$hasModifications = 'Y' and $priceType = 'CALLBACK'">
				
				<xsl:choose>
					<xsl:when test="$productId = 'BUDD-05-01'">Y</xsl:when>
					<xsl:when test="$productId = 'BUDD-05-04'">Y</xsl:when>
					<xsl:when test="$productId = 'BUDD-05-15'">Y</xsl:when>
					<xsl:when test="$productId = 'VIRG-05-17'">Y</xsl:when>
					<xsl:when test="$productId = 'IECO-05-09'">Y</xsl:when>
					<xsl:when test="$productId = 'EXPO-05-16'">Y</xsl:when>
					<xsl:when test="$productId = '1FOW-05-02'">Y</xsl:when>
					<xsl:when test="$productId = 'OZIC-05-01'">Y</xsl:when>
					<xsl:when test="$productId = 'OZIC-05-04'">Y</xsl:when>
					<xsl:when test="$productId = 'CBCK-05-08'">Y</xsl:when>
					<xsl:when test="$productId = 'RETI-05-03'">Y</xsl:when>
					<xsl:when test="$productId = 'EXDD-05-04'">Y</xsl:when>
					
					<xsl:when test="$productId = 'AI-01-01'">Y</xsl:when>
					<xsl:when test="$productId = 'AI-01-02'">Y</xsl:when>
					<xsl:when test="$productId = 'AI-01-04'">Y</xsl:when>
					
					<xsl:when test="$productId = 'REIN-01-01'">N</xsl:when>
					<xsl:when test="$productId = 'REIN-01-02'">N</xsl:when>

					<xsl:when test="$productId = 'WOOL-01-01'">N</xsl:when>
					<xsl:when test="$productId = 'WOOL-01-02'">N</xsl:when>

					<xsl:otherwise>N</xsl:otherwise>
				</xsl:choose>
				
			</xsl:when>
			
		</xsl:choose>
		
	</xsl:template>
	
</xsl:stylesheet>