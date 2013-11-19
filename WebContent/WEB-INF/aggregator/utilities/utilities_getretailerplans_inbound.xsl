<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:ext="http://switchwise.com.au/" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:a="http://schemas.microsoft.com/2003/10/Serialization/Arrays"
	exclude-result-prefixes="soapenv ext i a">

	<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="transactionId">*NONE</xsl:param>
	<xsl:param name="packagetype" />
	<xsl:param name="classtype" />

	<xsl:variable name="elementname"><xsl:value-of select="$classtype" /></xsl:variable>

	<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<!-- Check response for problems -->
		<xsl:choose>
			<xsl:when test="ext:ArrayOfLookupValue">
				<xsl:call-template name="ResultOk" />
			</xsl:when>

			<!-- Response passes our error checking -->
			<xsl:otherwise>
				<xsl:call-template name="ResultError">
					<xsl:with-param name="message" select="'Failed to fetch provider plans.'" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<xsl:template name="ResultError">
		<xsl:param name="status">ERROR</xsl:param>
		<xsl:param name="message"></xsl:param>

		<results>
			<status><xsl:value-of select="$status" /></status>
			<transactionId><xsl:value-of select="$transactionId" /></transactionId>
			<errors>
				<xsl:if test="$message != ''">
					<error>
						<code><xsl:text>0</xsl:text></code>
						<message><xsl:value-of select="$message" /></message>
					</error>
				</xsl:if>
			</errors>
		</results>
	</xsl:template>



	<xsl:template name="ResultOk">
		<xsl:param name="status">OK</xsl:param>

		<results>
			<status><xsl:value-of select="$status" /></status>
			<transactionId><xsl:value-of select="$transactionId" /></transactionId>
			<errors />

			<xsl:element name="{$elementname}">
					<xsl:apply-templates select="ext:ArrayOfLookupValue/*" />
			</xsl:element>
		</results>
	</xsl:template>



	<xsl:template match="ext:LookupValue">
		<plan>
			<description><xsl:value-of select="ext:Description"/></description>
			<value><xsl:value-of select="ext:Value"/></value>
		</plan>
	</xsl:template>



	<!-- A recursive copy -->
	<xsl:template match="*">
		<xsl:element name="{name()}">
			<!-- <xsl:copy-of select="@*" /> -->
			<xsl:apply-templates select="node()" />
		</xsl:element>
	</xsl:template>

	<xsl:template name="urlencode">
		<xsl:param name="text" />
		<xsl:call-template name="string-replace-all">
			<xsl:with-param name="text">
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="$text" />
					<xsl:with-param name="replace" select="'&amp;'" />
					<xsl:with-param name="by" select="'%26'" />
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="replace" select="' '" />
			<xsl:with-param name="by" select="'%20'" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="string-replace-all">
		<xsl:param name="text" />
		<xsl:param name="replace" />
		<xsl:param name="by" />
		<xsl:choose>
			<xsl:when test="contains($text, $replace)">
				<xsl:value-of select="substring-before($text,$replace)" />
				<xsl:value-of select="$by" />
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="substring-after($text,$replace)" />
					<xsl:with-param name="replace" select="$replace" />
					<xsl:with-param name="by" select="$by" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
