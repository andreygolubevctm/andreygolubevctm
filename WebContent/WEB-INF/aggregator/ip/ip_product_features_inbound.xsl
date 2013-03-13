<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	exclude-result-prefixes="soapenv"
	xmlns:x="urn:Lifebroker.EnterpriseAPI">
	
<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="keywords" select="document('ip_keywords.xml')" />
	<xsl:variable name="luFeatureNames" select="$keywords//featureNames" />
		
<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<features>
		<xsl:for-each select="x:features">
			<xsl:call-template name="getproducts" />
		</xsl:for-each>
	    </features>
	</xsl:template>
	
	<xsl:template name="getproducts">
		<xsl:for-each select="*">
			<xsl:call-template name="getfeatures" />
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="getfeatures">
		<xsl:for-each select="*">
			<xsl:variable name="id">
				<xsl:value-of select="@id" />
			</xsl:variable>
			<xsl:variable name="available">
				<xsl:value-of select=".//*[name()='available']" />
			</xsl:variable>
			<xsl:variable name="name"><xsl:value-of select="$luFeatureNames/item[@key=$id]" /></xsl:variable>
			<xsl:if test="$name != ''">
				<feature>	
					<id><xsl:copy-of select="$id"/></id>
					<name><xsl:value-of select="$name"/></name>
					<available><xsl:value-of select="$available"/></available>
				</feature>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>