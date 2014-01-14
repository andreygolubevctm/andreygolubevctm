<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">	
	<xsl:template name="ranking">
		<xsl:param name="productId" />
		<ranking>
			<xsl:choose>
				<xsl:when test="$productId = 'BUDD-05-01'">
					<env>0</env>
					<onlinedeal>0</onlinedeal>
					<payasdrive>0</payasdrive>
					<household>0.9</household>
				</xsl:when>
				<xsl:when test="$productId = 'BUDD-05-04'">
					<env>0</env>
					<onlinedeal>1</onlinedeal>
					<payasdrive>0</payasdrive>
					<household>0.7</household>
				</xsl:when>				
				<xsl:when test="$productId = 'CBCK-05-08'">
					<env>0</env>
					<onlinedeal>0</onlinedeal>
					<payasdrive>0</payasdrive>
					<household>0</household>					
				</xsl:when>								
				<xsl:when test="$productId = 'IECO-05-09'">
					<env>1</env>
					<onlinedeal>0</onlinedeal>
					<payasdrive>0</payasdrive>
					<household>0</household>
				</xsl:when>
				<xsl:when test="$productId = 'OZIC-05-04'">
					<env>0</env>
					<onlinedeal>0</onlinedeal>
					<payasdrive>0</payasdrive>
					<household>0</household>
				</xsl:when>
				<xsl:when test="$productId = 'OZIC-05-01'">
					<env>0</env>
					<onlinedeal>0</onlinedeal>
					<payasdrive>0</payasdrive>
					<household>0</household>
				</xsl:when>				
				<xsl:when test="$productId = 'VIRG-05-11'">
					<env>0</env>
					<onlinedeal>0</onlinedeal>
					<payasdrive>0</payasdrive>
					<household>0.8</household>
				</xsl:when>
				<xsl:when test="$productId = 'EXPO-05-13'">
					<env>0</env>
					<onlinedeal>0</onlinedeal>
					<payasdrive>0</payasdrive>
					<household>0.9</household>
				</xsl:when>
				<xsl:when test="$productId = 'RETI-05-03'">
					<env>0</env>
					<onlinedeal>0</onlinedeal>
					<payasdrive>0</payasdrive>
					<household>0</household>
				</xsl:when>
				<xsl:when test="$productId = '1FOW-05-02'">
					<env>0</env>
					<onlinedeal>0</onlinedeal>
					<payasdrive>0</payasdrive>
					<household>0</household>
				</xsl:when>
				<xsl:when test="$productId = 'PAYD-01-01'">
					<env>0</env>
					<onlinedeal>0</onlinedeal>
					<payasdrive>1</payasdrive>
					<household>0.6</household>
				</xsl:when>
				<xsl:when test="$productId = 'AI-01-01'">
					<env>0</env>
					<onlinedeal>0</onlinedeal>
					<payasdrive>0</payasdrive>
					<household>0</household>
				</xsl:when>				
				<xsl:otherwise>
					<env>0</env>
					<onlinedeal>0</onlinedeal>
					<payasdrive>0</payasdrive>
					<household>0</household>
				</xsl:otherwise>				
			</xsl:choose>
		</ranking>		
	</xsl:template>

</xsl:stylesheet>