<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:lb="urn:Lifebroker.EnterpriseAPI"
	exclude-result-prefixes="soapenv">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="keywords" select="document('life_keywords.xml')" />
	<xsl:variable name="luFeatureNames" select="$keywords//featureNames" />

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/error">
		<xsl:element name="results">
			<xsl:element name="features">
				<xsl:element name="success">false</xsl:element>
				<xsl:element name="error">
					<xsl:element name="code"><xsl:value-of select="code" /></xsl:element>
					<xsl:element name="message"><xsl:value-of select="message" /></xsl:element>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="/lb:features">
		<xsl:element name="results">
			<xsl:element name="success">true</xsl:element>
			<xsl:element name="features">
				<xsl:for-each select="lb:product">
					<xsl:variable name="id" select="@id" />
					<xsl:element name="product">
						<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
						<xsl:call-template name="getFeatures">
							<xsl:with-param name="features" select="lb:feature"/>
						</xsl:call-template>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template name="getFeatures">
		<xsl:param name="features" />

		<xsl:for-each select="$features">

			<xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
			<xsl:variable name="available"><xsl:value-of select="lb:available"/></xsl:variable>

			<xsl:for-each select="$luFeatureNames/item">
				<xsl:if test="contains(@key, $id)">
					<xsl:element name="feature">
						<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
						<xsl:element name="name"><xsl:value-of select="text()"/></xsl:element>
						<xsl:element name="available"><xsl:value-of select="$available"/></xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:for-each>

		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>