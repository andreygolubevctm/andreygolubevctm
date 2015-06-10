<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:math="http://exslt.org/math"
				extension-element-prefixes="math">
	<xsl:template name="formatProductName">
		<xsl:param name="providerName" />
		<xsl:param name="productName" />

		<!-- format the provider name -->
		<xsl:variable name="newProductName">
			<xsl:call-template name="formatProviderName">
				<xsl:with-param name="providerName" select="$providerName" />
				<xsl:with-param name="productName" select="$productName" />
			</xsl:call-template>
		</xsl:variable>

		<!-- format the product name -->
		<xsl:call-template name="formatDuration">
			<xsl:with-param name="productName" select="$newProductName" />
		</xsl:call-template>

	</xsl:template>

	<xsl:template name="formatProviderName">
		<xsl:param name="providerName" />
		<xsl:param name="productName" />

			<xsl:call-template name="replace-string">
				<xsl:with-param name="text" select="$productName" />
				<xsl:with-param name="replace" select="$providerName" />
				<xsl:with-param name="with" select="concat($providerName, ' AMT &lt;br&gt;')" />
			</xsl:call-template>
	</xsl:template>

	<xsl:template name="formatDuration">
		<xsl:param name="productName" />
		<xsl:variable name="tempProductName">
			<xsl:call-template name="replace-string">
				<xsl:with-param name="text" select="$productName" />
				<xsl:with-param name="replace" select="'('" />
				<xsl:with-param name="with">&lt;br&gt;&lt;span class="daysPerTrip"&gt;(</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="replace-string">
			<xsl:with-param name="text" select="$tempProductName" />
			<xsl:with-param name="replace" select="')'" />
			<xsl:with-param name="with" select="')&lt;span&gt;'" />
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>