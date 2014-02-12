<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="../utils.xsl"/>

	<xsl:output indent="yes" />

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="AccountCreditCardNumber/text()">
		<xsl:variable name="accountNumberSpacesRemoved" select="translate(. , ' ', '')" />
		<xsl:variable name="length" select="string-length($accountNumberSpacesRemoved)" />
		<xsl:choose>
			<xsl:when test="$length = 16">
				<xsl:call-template name="mask_creditcard">
					<xsl:with-param name="creditcard" select="$accountNumberSpacesRemoved"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="mask_banknumber">
					<xsl:with-param name="banknumber" select="."/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ConfirmAccountCreditCardNumber/text()">
		<xsl:variable name="accountNumberSpacesRemoved" select="translate(. , ' ', '')" />
		<xsl:variable name="length" select="string-length($accountNumberSpacesRemoved)" />
		<xsl:choose>
			<xsl:when test="$length = 16">
				<xsl:call-template name="mask_creditcard">
					<xsl:with-param name="creditcard" select="$accountNumberSpacesRemoved"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="mask_banknumber">
					<xsl:with-param name="banknumber" select="."/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="DirectCreditAccount/text()">
		<xsl:call-template name="mask_banknumber">
			<xsl:with-param name="banknumber" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="ConfirmDirectCreditAccount/text()">
		<xsl:call-template name="mask_banknumber">
			<xsl:with-param name="banknumber" select="."/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>