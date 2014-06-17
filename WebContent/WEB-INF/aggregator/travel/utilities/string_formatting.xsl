<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="replace-string">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="with"/>
		<xsl:choose>
		<xsl:when test="contains($text,$replace)">
			<xsl:value-of select="substring-before($text,$replace)"/>
			<xsl:value-of select="$with"/>
			<xsl:call-template name="replace-string">
			<xsl:with-param name="text" select="substring-after($text,$replace)"/>
			<xsl:with-param name="replace" select="$replace"/>
			<xsl:with-param name="with" select="$with"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$text"/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="removeDollarFormatting">
		<xsl:param name="oldDollarValue" />

		<xsl:variable name="dollarValue">
			<xsl:choose>
				<!-- Fixing values like $2.5 million which is used all over the place on partner's site -->
				<xsl:when test="contains($oldDollarValue, ' million')">
					<xsl:choose>
							<!-- If the value has a . like 2.5 million, we remove the . and add only 5 zeros -->
							<xsl:when test="contains($oldDollarValue, '.')">
								<xsl:variable name="tempDollarValue">
									<xsl:value-of select="translate( $oldDollarValue, '.', '')" />
								</xsl:variable>
								<xsl:call-template name="replace-string">
									<xsl:with-param name="text" select="$tempDollarValue"/>
									<xsl:with-param name="replace" select="' million'" />
									<xsl:with-param name="with" select="'00000'"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<!-- otherwise add 6 zeros -->
								<xsl:call-template name="replace-string">
									<xsl:with-param name="text" select="$oldDollarValue"/>
									<xsl:with-param name="replace" select="' million'" />
									<xsl:with-param name="with" select="'000000'"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$oldDollarValue" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="removedDollarSign">
			<xsl:value-of select="translate( $dollarValue, '$', '')" />
		</xsl:variable>
		<xsl:value-of select="translate( $removedDollarSign, ',', '')" />
	</xsl:template>

	<xsl:template name="formatAmount">
		<xsl:param name="amount"/>
		<xsl:value-of select="format-number($amount,'#,###,###')"/>
	</xsl:template>

</xsl:stylesheet>