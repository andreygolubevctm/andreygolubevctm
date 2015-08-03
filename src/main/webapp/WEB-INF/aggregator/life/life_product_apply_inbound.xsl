<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:lb="urn:Lifebroker.EnterpriseAPI"
	exclude-result-prefixes="soapenv">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/error">
		<xsl:element name="results">
			<xsl:element name="success">false</xsl:element>
			<xsl:element name="error">
				<xsl:element name="code"><xsl:value-of select="code" /></xsl:element>
				<xsl:element name="message"><xsl:value-of select="message" /></xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template match="/lb:selection">
		<xsl:element name="results">
			<xsl:element name="success">true</xsl:element>
			<xsl:element name="selection">
				<xsl:variable name="id" select="@id" />
				<xsl:element name="client">
					<xsl:choose>
						<xsl:when test="lb:client/lb:pds">
							<xsl:element name="pds"><xsl:value-of select="lb:client/lb:pds"/></xsl:element>
							<xsl:element name="info_url"><xsl:value-of select="lb:client/lb:info_url"/></xsl:element>
						</xsl:when>
						<xsl:otherwise>
							<xsl:element name="pds"><xsl:value-of select="lb:pds"/></xsl:element>
							<xsl:element name="info_url"><xsl:value-of select="lb:info_url"/></xsl:element>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<xsl:element name="partner">
					<xsl:if test="lb:partner/lb:pds and lb:partner/lb:info_url">
					<xsl:element name="pds"><xsl:value-of select="lb:partner/lb:pds"/></xsl:element>
					<xsl:element name="info_url"><xsl:value-of select="lb:partner/lb:info_url"/></xsl:element>
					</xsl:if>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>