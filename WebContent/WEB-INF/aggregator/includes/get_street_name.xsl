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
		<xsl:value-of select="$address/fullAddressLineOne" />
	</xsl:template>
</xsl:stylesheet>