<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:utils="http://comparethemarket.com.au/utils">
<!-- CONSTANTS -->
	<xsl:variable name="LOWERCASE" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="UPPERCASE" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

	<xsl:template name="util_numbersOnly">
		<xsl:param name="value"/>
		<xsl:value-of select="translate($value, translate($value,'0123456789',''),'')" />
	</xsl:template>

	<xsl:template name="util_numbersOnlyDisplay">
		<xsl:param name="value"/>
		<xsl:value-of select="format-number(translate($value, translate($value,'0123456789',''),''), '###,###')" />
	</xsl:template>

	<xsl:template name="util_isoDate">
		<xsl:param name="eurDate"/>

		<xsl:variable name="day" 		select="substring-before($eurDate,'/')" />
		<xsl:variable name="month-temp" select="substring-after($eurDate,'/')" />
		<xsl:variable name="month" 		select="substring-before($month-temp,'/')" />
		<xsl:variable name="year" 		select="substring-after($month-temp,'/')" />

		<xsl:value-of select="$year" />
		<xsl:value-of select="'-'" />
		<xsl:value-of select="format-number($month, '00')" />
		<xsl:value-of select="'-'" />
		<xsl:value-of select="format-number($day, '00')" />
	</xsl:template>

	<xsl:template name="util_reversedDate">
		<xsl:param name="eurDate"/>

		<xsl:variable name="day" 		select="substring-before($eurDate,'/')" />
		<xsl:variable name="month-temp" select="substring-after($eurDate,'/')" />
		<xsl:variable name="month" 		select="substring-before($month-temp,'/')" />
		<xsl:variable name="year" 		select="substring-after($month-temp,'/')" />

		<xsl:value-of select="$year" />
		<xsl:value-of select="'/'" />
		<xsl:value-of select="format-number($month,'00')" />
		<xsl:value-of select="'/'" />
		<xsl:value-of select="format-number($day,'00')" />
	</xsl:template>

	<xsl:template name="util_formatEurDate">
		<xsl:param name="eurDate"/>

		<xsl:variable name="day" 		select="substring-before($eurDate,'/')" />
		<xsl:variable name="month-temp" select="substring-after($eurDate,'/')" />
		<xsl:variable name="month" 		select="substring-before($month-temp,'/')" />
		<xsl:variable name="year" 		select="substring-after($month-temp,'/')" />

		<xsl:value-of select="format-number($day,'00')" />
		<xsl:value-of select="'/'" />
		<xsl:value-of select="format-number($month,'00')" />
		<xsl:value-of select="'/'" />
		<xsl:value-of select="$year" />
	</xsl:template>
	<xsl:template name="convertNum">
		<xsl:param name="num"/>
		<xsl:choose>
			<xsl:when test="$num = 1">01</xsl:when>
			<xsl:when test="$num = 2">02</xsl:when>
			<xsl:when test="$num = 3">03</xsl:when>
			<xsl:when test="$num = 4">04</xsl:when>
			<xsl:when test="$num = 5">05</xsl:when>
			<xsl:when test="$num = 6">06</xsl:when>
			<xsl:when test="$num = 7">07</xsl:when>
			<xsl:when test="$num = 8">08</xsl:when>
			<xsl:when test="$num = 9">09</xsl:when>
			<xsl:otherwise>$num</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="util_mathCeil">
		<xsl:param name="num"/>

		<xsl:choose>
			<xsl:when test="not(contains($num, '.'))"><xsl:value-of select="$num"></xsl:value-of></xsl:when>
			<xsl:when test="substring-after($num,'.' ) = '00'"><xsl:value-of select="substring-before($num,'.')"></xsl:value-of></xsl:when>
			<xsl:otherwise><xsl:value-of select="substring-before($num,'.') + 1"></xsl:value-of></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="util_removeDecimals">
		<xsl:param name="num"/>
		<xsl:value-of select="substring-before($num,'.')" />
	</xsl:template>

	<xsl:template name="util_replace">
		<xsl:param name="text" />
		<xsl:param name="replace" />
		<xsl:param name="with" />
		<xsl:choose>
			<xsl:when test="contains($text,$replace)">
				<xsl:value-of select="substring-before($text,$replace)" />
				<xsl:value-of select="$with" />
				<xsl:call-template name="util_replace">
					<xsl:with-param name="text"
						select="substring-after($text,$replace)" />
					<xsl:with-param name="replace" select="$replace" />
					<xsl:with-param name="with" select="$with" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="accessoryAmount">
		<xsl:param name="accCode"/>

		<xsl:variable name="accessoryValue">
			<xsl:choose>
				<xsl:when test="accs/*/sel[text()=$accCode]">
					<xsl:variable name="acc" select="accs/*/sel[text()=$accCode]/.." />
					<xsl:variable name="accInc" select="$acc/inc" />
					<xsl:variable name="accPrc" select="$acc/prc" />
					<xsl:choose>
						<xsl:when test="$accInc='N'"><xsl:value-of select="$accPrc" /></xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$accessoryValue" />
	</xsl:template>

	<xsl:template name="join">
		<xsl:param name="list" />
		<xsl:param name="separator"/>

		<xsl:for-each select="$list">
			<xsl:value-of select="." />
			<xsl:if test="position() != last()">
				<xsl:value-of select="$separator" />
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="error_message">
		<xsl:param name="service" />
		<xsl:param name="error_type"/>
		<xsl:param name="code"/>
		<xsl:param name="message"/>
		<xsl:param name="data" />

		<error service="{$service}" type="{$error_type}">
			<code><xsl:value-of select="$code" /></code>
			<message><xsl:value-of select="$message" /></message>
			<data><xsl:value-of select="$data" /></data>
		</error>
	</xsl:template>

</xsl:stylesheet>