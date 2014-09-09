<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan"
	exclude-result-prefixes="xalan">
	<xsl:output omit-xml-declaration="yes" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

	<!-- apologies for this messy code XSLT 1.0 doesn't support regex -->
	<xsl:template match="surname | name | firstname | firstName| lastname | lastName">
		<xsl:variable name="nameTextTemp" select="text()" />
		<xsl:variable name="toReplace">&gt;,&lt;,://,www.,.com,@,.co,.net,.org,.asn,.ws,.us,.mobi</xsl:variable>
		<xsl:variable name="nameText">
			<xsl:call-template name="replaceTokens">
				<xsl:with-param name="nameText" select="$nameTextTemp"/>
				<xsl:with-param name="tokens" select="$toReplace"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="nameText2">
			<xsl:choose>
				<xsl:when test="string-length( normalize-space($nameText) ) &gt; 60">
					<xsl:value-of select="substring( $nameText, 0, 60 )"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="normalize-space($nameText)" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{name()}"><xsl:value-of select="$nameText2" /></xsl:element>
	</xsl:template>

	<xsl:template name="replaceTokens">
		<xsl:param name="nameText" />
		<xsl:param name="tokens" />
		<xsl:choose>
			<xsl:when test="string-length($tokens) > 0">
				<xsl:variable name="token" select="substring-before(concat($tokens, ','), ',')"/>
				<xsl:variable name="nameTextTemp" >
					<xsl:call-template name="replace">
						<xsl:with-param name="text" select="$nameText" />
						<xsl:with-param name="replace" select="$token" />
						<xsl:with-param name="by" select="''" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:call-template name="replaceTokens">
					<xsl:with-param name="nameText" select="$nameTextTemp"/>
					<xsl:with-param name="tokens" select="substring-after($tokens, ',')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$nameText" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="replace">
		<xsl:param name="text" />
		<xsl:param name="replace" />
		<xsl:param name="by" />
		<xsl:choose>
			<xsl:when test="contains($text, $replace)">
				<xsl:value-of select="substring-before($text,$replace)" />
				<xsl:value-of select="$by" />
				<xsl:call-template name="replace">
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