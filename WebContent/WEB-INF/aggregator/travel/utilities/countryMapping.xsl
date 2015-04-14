<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- REGION MAPPING START -->
	<xsl:template name="getRegionMapping">
		<xsl:param name="selectedRegions" />
		<xsl:param name="delimiter" select="','" />

		<xsl:choose>
			<xsl:when test="contains($selectedRegions, $delimiter)">
				<xsl:value-of select="substring-before($selectedRegions,$delimiter)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$selectedRegions"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- REGION MAPPING END -->
	<!-- COUNTRY AND REGION MAPPING START -->
	<xsl:template name="getRegionCountryMapping">
		<xsl:param name="groupCode" />
		<xsl:param name="selectedCountries" />
		<xsl:param name="selectedRegions" />
		<xsl:param name="delimiter" select="','" />
		<xsl:choose>
			<xsl:when test="contains($selectedCountries, $delimiter)">
				<xsl:variable name="selectedCountry">
					<xsl:value-of select="substring-before($selectedCountries,$delimiter)"/>
				</xsl:variable>
				<xsl:variable name="selectedRegion">
					<xsl:value-of select="substring-before($selectedRegions,$delimiter)"/>
				</xsl:variable>

				<xsl:call-template name="buildCountryRegionMapping">
					<xsl:with-param name="groupCode" select="$groupCode" />
					<xsl:with-param name="selectedCountry" select="$selectedCountry" />
					<xsl:with-param name="selectedRegion" select="$selectedRegion" />
				</xsl:call-template>

				<xsl:call-template name="getRegionCountryMapping">
					<xsl:with-param name="groupCode" select="$groupCode" />
					<xsl:with-param name="selectedCountries" select="substring-after($selectedCountries,',')" />
					<xsl:with-param name="selectedRegions" select="substring-after($selectedRegions,',')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="buildCountryRegionMapping">
					<xsl:with-param name="groupCode" select="$groupCode" />
					<xsl:with-param name="selectedCountry" select="$selectedCountries" />
					<xsl:with-param name="selectedRegion" select="$selectedRegions" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="buildCountryRegionMapping">
		<xsl:param name="groupCode" />
		<xsl:param name="selectedCountry" />
		<xsl:param name="selectedRegion" />
		<xsl:choose>
			<xsl:when test="$groupCode = 'ALNZ'">
				<xsl:call-template name="buildALNZMapping">
					<xsl:with-param name="selectedCountry" select="$selectedCountry" />
					<xsl:with-param name="selectedRegion" select="$selectedRegion" />

				</xsl:call-template>
			</xsl:when>

		</xsl:choose>
	</xsl:template>

	<!-- OTIS & VIRGIN-->
	<xsl:template name="buildALNZMapping">
		<xsl:param name="selectedCountry" />
		<xsl:param name="selectedRegion" />
		<xsl:param name="delimiter" select="':'" />
		<xsl:element name="Destination">
			<xsl:element name="RegionCode"><xsl:value-of select="$selectedRegion" /></xsl:element>
			<xsl:choose>
				<xsl:when test="contains($selectedCountry, ':')">
					<xsl:element name="CountryCode">
						<xsl:value-of select="substring-before($selectedCountry,$delimiter)"/>
					</xsl:element>
					<xsl:element name="LocationCode">
						<xsl:value-of select="substring-after($selectedCountry,$delimiter)"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="CountryCode"><xsl:value-of select="$selectedCountry" /></xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<!-- COUNTRY AND REGION MAPPING END -->

	<!-- COUNTRY MAPPING START -->
	<xsl:template name="getCountryMapping">
		<xsl:param name="groupCode" />
		<xsl:param name="selectedCountries" />
		<xsl:param name="delimiter" select="','" />
		<xsl:choose>
			<xsl:when test="contains($selectedCountries, $delimiter)">
				<xsl:variable name="selectedCountry">
					<xsl:value-of select="substring-before($selectedCountries,$delimiter)"/>
				</xsl:variable>

				<xsl:call-template name="buildCountryMapping">
					<xsl:with-param name="groupCode" select="$groupCode" />
					<xsl:with-param name="selectedCountry" select="$selectedCountry" />
				</xsl:call-template>

				<xsl:call-template name="getCountryMapping">
					<xsl:with-param name="groupCode" select="$groupCode" />
					<xsl:with-param name="selectedCountries" select="substring-after($selectedCountries,',')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="buildCountryMapping">
					<xsl:with-param name="groupCode" select="$groupCode" />
					<xsl:with-param name="selectedCountry" select="$selectedCountries" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="buildCountryMapping">
		<xsl:param name="groupCode" />
		<xsl:param name="selectedCountry" />
		<xsl:choose>
			<xsl:when test="$groupCode = 'AGIS'">
				<xsl:call-template name="buildAGISMapping">
					<xsl:with-param name="selectedCountry" select="$selectedCountry" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$groupCode = 'ALNZ05OLD'">
				<xsl:call-template name="buildALNZ05OLDMapping">
					<xsl:with-param name="selectedCountry" select="$selectedCountry" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$groupCode = 'AMEX'">
				<xsl:call-template name="buildAMEXMapping">
					<xsl:with-param name="selectedCountry" select="$selectedCountry" />
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- AMEX -->
	<xsl:template name="buildAMEXMapping">
		<xsl:param name="selectedCountry" />
		<xsl:value-of select="$selectedCountry" />
	</xsl:template>

	<!-- WEBJET & ZUJI -->
	<xsl:template name="buildALNZ05OLDMapping">
		<xsl:param name="selectedCountry" />
		<RegionCode><xsl:value-of select="$selectedCountry" /></RegionCode>
	</xsl:template>

	<!-- BUDD & FFOW -->
	<xsl:template name="buildAGISMapping">
		<xsl:param name="selectedCountry" />
		<countryCode><xsl:value-of select="$selectedCountry" /></countryCode>
	</xsl:template>
	<!-- COUNTRY MAPPING END -->
</xsl:stylesheet>