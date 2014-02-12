<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:auf="http://ws.australianunity.com.au/B2B/Broker">

	<xsl:include href="../utils.xsl"/>

	<xsl:output indent="yes" />

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="auf:BankAccountDetails/auf:AccountNumber/text()">
		<xsl:call-template name="mask_banknumber">
			<xsl:with-param name="banknumber" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="auf:CreditCardDetails/auf:Number/text()">
		<xsl:call-template name="mask_creditcard">
			<xsl:with-param name="creditcard" select="."/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="auf:CCVNumber/text()">
		<xsl:value-of select="translate(., '0123456789', '**********')" />
	</xsl:template>

</xsl:stylesheet>