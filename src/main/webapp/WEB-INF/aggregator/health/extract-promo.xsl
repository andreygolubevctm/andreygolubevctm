<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes" />

<xsl:include href="/WEB-INF/aggregator/includes/utils.xsl"/>

	<xsl:param name="hospital"></xsl:param>
	<xsl:param name="extras"></xsl:param>

	<xsl:template match="/promoData">
		<xsl:variable name="unescapedHospital">
			<xsl:call-template name="util_replace">
				<xsl:with-param name="text" select="$hospital" />
				<xsl:with-param name="replace" select="'&amp;amp;'" />
				<xsl:with-param name="with" select="'&amp;'" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="unescapedExtras">
			<xsl:call-template name="util_replace">
				<xsl:with-param name="text" select="$extras" />
				<xsl:with-param name="replace" select="'&amp;amp;'" />
				<xsl:with-param name="with" select="'&amp;'" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="promoText" select="promoText" />
		<xsl:variable name="discountText" select="discountText" />
		<xsl:variable name="providerPhoneNumber" select="providerPhoneNumber" />

		<xsl:variable name="promoHospitalAndExtras" select="promo[@hospital=$unescapedHospital and @extras=$unescapedExtras]" />
		<xsl:variable name="promoHospitalOnly" select="promo[@hospital=$unescapedHospital and not(@extras)]" />
		<xsl:variable name="promoExtrasOnly" select="promo[@extras=$unescapedExtras and not(@hospital)]" />

		<providerPhoneNumber><xsl:value-of select="providerPhoneNumber" /></providerPhoneNumber>
		<providerDirectPhoneNumber><xsl:value-of select="providerDirectPhoneNumber" /></providerDirectPhoneNumber>

		<xsl:choose>
			<xsl:when  test="string-length($hospital) > 0 and string-length($extras) > 0">

				<xsl:copy-of select="$promoHospitalAndExtras/*" />

				<!-- If doesn't have custom promoText, use top-level promoText -->
				<xsl:if test="not($promoHospitalAndExtras/promoText)">
					<promoText><xsl:value-of select="$promoText" /></promoText>
				</xsl:if>

				<!-- If doesn't have custom discountText, use top-level discountText -->
				<xsl:if test="not($promoHospitalAndExtras/discountText)">
					<discountText><xsl:value-of select="$discountText" /></discountText>
				</xsl:if>
			</xsl:when>

			<xsl:when test="string-length($hospital) > 0 and string-length($extras) = 0">

				<xsl:copy-of select="$promoHospitalOnly/*" />

				<xsl:if test="not($promoHospitalOnly/promoText)">
					<promoText><xsl:value-of select="$promoText" /></promoText>
				</xsl:if>
				<xsl:if test="not($promoHospitalOnly/discountText)">
					<discountText><xsl:value-of select="$discountText" /></discountText>
				</xsl:if>
			</xsl:when>

			<xsl:when test="string-length($hospital) = 0 and string-length($extras) > 0">

				<xsl:copy-of select="$promoExtrasOnly/*" />

				<xsl:if test="not($promoExtrasOnly/promoText)">
					<promoText><xsl:value-of select="$promoText" /></promoText>
				</xsl:if>
				<xsl:if test="not($promoExtrasOnly/discountText)">
					<discountText><xsl:value-of select="$discountText" /></discountText>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>