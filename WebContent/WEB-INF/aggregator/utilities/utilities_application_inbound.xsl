<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:ext="http://switchwise.com.au/" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"
	exclude-result-prefixes="soapenv ext i">

	<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

	<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="transactionId">*NONE</xsl:param>

	<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<!-- Check response for problems -->
		<xsl:choose>
			<xsl:when test="count(error) &gt; 0">
				<xsl:call-template name="ResultError" />
			</xsl:when>

			<xsl:when test="count(ext:ApplicationResult/ext:ValidationMessages/ValidationMessage) &gt; 0">
				<xsl:call-template name="ResultError">
					<xsl:with-param name="message" select="'Form validation issues:'" />
				</xsl:call-template>
			</xsl:when>

			<!-- Response passes our error checking -->
			<xsl:otherwise>
				<xsl:call-template name="ResultOk" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="ResultError">
		<xsl:param name="status">ERROR</xsl:param>
		<xsl:param name="message"></xsl:param>

		<results>
			<status><xsl:value-of select="$status" /></status>
			<transactionId><xsl:value-of select="$transactionId" /></transactionId>
			<ReceiptID><xsl:value-of select="ext:ApplicationResult/ext:ReceiptID" /></ReceiptID>
			<errors>
				<xsl:if test="$message != ''">
					<error>
						<code><xsl:text>0</xsl:text></code>
						<message><xsl:value-of select="$message" /></message>
					</error>
				</xsl:if>

				<xsl:for-each select="ext:ApplicationResult/ext:ValidationMessages/ValidationMessage">
					<error>
						<code><xsl:text>0</xsl:text></code>
						<message><xsl:value-of select="PropertyName" />: <xsl:value-of select="ErrorMessage" /></message>
					</error>
				</xsl:for-each>

				<xsl:for-each select="error">
					<error>
						<code><xsl:value-of select="code" /></code>
						<message><xsl:value-of select="message" /></message>
					</error>
				</xsl:for-each>
			</errors>
		</results>
	</xsl:template>

	<xsl:template name="ResultOk">
		<xsl:param name="status">OK</xsl:param>

		<results>
			<status><xsl:value-of select="$status" /></status>
			<transactionId><xsl:value-of select="$transactionId" /></transactionId>
			<ReceiptID><xsl:value-of select="ext:ApplicationResult/ext:ReceiptID" /></ReceiptID>
			<errors />
		</results>
	</xsl:template>

	<!-- A recursive copy -->
	<xsl:template match="*">
		<xsl:element name="{name()}">
			<xsl:copy-of select="@*" />
			<xsl:apply-templates select="node()" />
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
