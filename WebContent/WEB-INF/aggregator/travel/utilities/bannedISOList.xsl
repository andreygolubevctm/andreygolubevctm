<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:variable name="bannedISOListREALWOOL">AUS</xsl:variable>

	<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- CHECK BANNED LIST START 
		=== NOTE. 
		=== The case below is only for REAL/WOOL they only want to prevent a quote from returning only if AUS is selected
		=== with one other country. The rest of the banning code is found in the CountryMappingDAO.java sql code
	-->
	<xsl:template name="checkCountrySelectionIsOnBannedList">
		<xsl:param name="providerCode" />
		<xsl:param name="selectedRegions" />
		<xsl:param name="delimiter" select="','" />

		<!-- grab the specific ISO list per provider -->
		<xsl:variable name="bannedISOList">
			<xsl:choose>
				<xsl:when test="$providerCode = 'REALWOOL'"><xsl:value-of select="$bannedISOListREALWOOL" /></xsl:when>
			</xsl:choose>
		</xsl:variable>
		
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
							<xsl:with-param name="providerCode" select="$providerCode" />
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