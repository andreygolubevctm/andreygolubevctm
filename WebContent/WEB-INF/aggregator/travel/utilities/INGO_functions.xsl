<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:variable name="bannedISOList">AFG,COD,COG,HTI,IRN,IRQ,LBN,LBR,PAK,PRK,PSE,SDN,SOM,SYR,TCD,TLS,UGA,YEM,ZWE</xsl:variable>

	<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- CHECK BANNED LIST START -->
	<xsl:template name="checkCountrySelectionIsOnBannedList">
		<xsl:param name="selectedRegions" />
		<xsl:param name="delimiter" select="','" />
		<xsl:choose>
			<!-- Check if $selectedRegions is a comma seperated list -->
			<xsl:when test="contains($selectedRegions, $delimiter)">
				<!-- If it is, retrieve the first item that is positioned before the first $delimiter position -->
				<xsl:variable name="selectedRegion">
					<xsl:value-of select="substring-before($selectedRegions,$delimiter)"/>
				</xsl:variable>

				<xsl:choose>
					<!-- If the $selectedRegion is on the $bannedISOList, return true  -->
					<xsl:when test="contains($bannedISOList, $selectedRegion)">Y</xsl:when>
					<xsl:otherwise>
						<!-- otherwise check the remaining items on the selected country list that is positioned AFTER the first delimiter position  -->
						<xsl:call-template name="checkCountrySelectionIsOnBannedList">
							<xsl:with-param name="selectedRegions" select="substring-after($selectedRegions, $delimiter)" />
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="contains($bannedISOList, $selectedRegions)">Y</xsl:when>
					<xsl:otherwise>N</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- CHECK BANNED LIST END -->
</xsl:stylesheet>