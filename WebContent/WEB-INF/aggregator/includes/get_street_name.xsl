<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!--
	get_street_name

	This template takes an xml fragment created by the online address capture
	and determines which of the fields should be used for the various
	methods that the user can input the address.

	It takes a single parameter, the root node of the address.
	It returns a single line in the format:

		UNIT / HOUSENO STREETNAME       - If a unit entered (std or non-std)
		HOUSENO STREETNAME       		- If only street number entered (std or non-std)

-->
	<xsl:template name="get_street_name">
		<xsl:param name="address" />

		<xsl:choose>
			<!-- Non-Standard -->
			<xsl:when test="$address/nonStd='Y'">
				<xsl:value-of select="$address/fullAddressLineOne" />
			</xsl:when>

			<!-- Standard Address -->
			<xsl:otherwise>
				<xsl:choose>
				<!-- Smart capture unit and street number -->
				<xsl:when test="$address/unitSel != '' and $address/houseNoSel != ''">
					<xsl:value-of select="concat($address/unitSel, ' / ', $address/houseNoSel, ' ', $address/streetName)" />
				</xsl:when>

				<!-- Manual capture unit, Smart capture street number -->
				<xsl:when test="$address/unitShop != '' and $address/houseNoSel != ''">
					<xsl:value-of select="concat($address/unitShop, ' / ', $address/houseNoSel, ' ', $address/streetName)" />
				</xsl:when>

				<!-- Manual capture unit and street number -->
				<xsl:when test="$address/unitShop != '' and $address/streetNum != ''">
					<xsl:value-of select="concat($address/unitShop, ' / ', $address/streetNum, ' ', $address/streetName)" />
				</xsl:when>

				<!-- Smart capture street number (only, no unit) -->
				<xsl:when test="$address/houseNoSel != ''">
					<xsl:value-of select="concat($address/houseNoSel, ' ', $address/streetName)" />
				</xsl:when>

				<!-- Manual capture street number (only, no unit) -->
				<xsl:otherwise>
					<xsl:value-of select="concat($address/streetNum, ' ', $address/streetName)" />
				</xsl:otherwise>
				</xsl:choose>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>