<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="ISO-8859-1" indent="yes" />

	<xsl:param name="vertical"/>
	<xsl:param name="brand"/>
	<xsl:param name="root-url"/>

	<xsl:template match="/">
		<settings>

			<!-- ENVIRONMENT FILE - Top level, should not be overwritten at all-->
			<!--  TODO: Add sub nodes such as 'send' so these can go in the environments file without duplicating the end XML-->
			<xsl:apply-templates select="/settings/*" />

			<!-- VERTICAL FILE -->
			<xsl:if test="$vertical != ''">
				<xsl:variable name="extraSettingsFile" select="document(concat($root-url, 'ctm/brand/ctm/settings_', $vertical, '.xml'))" />
				<xsl:apply-templates select="$extraSettingsFile/settings/*" />
			</xsl:if>

			<!-- BRAND FILE -->
			<xsl:if test="$brand != ''">
				<xsl:variable name="brandSettingsFile" select="document(concat($root-url, 'ctm/brand/ctm/settings_brand_', $brand, '.xml'))" />
				<xsl:apply-templates select="$brandSettingsFile/settings/*" />
			</xsl:if>

			<!-- ALL FILE -->
			<xsl:variable name="allSettingsFile" select="document(concat($root-url, 'ctm/brand/ctm/settings_all.xml'))" />
			<xsl:apply-templates select="$allSettingsFile/settings/*" />

		</settings>
	</xsl:template>

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>
</xsl:transform>