<!-- Yes this is a bit of an odd filename as the function below is used for those partners using our ws documetnation as gospel from v 1.5 and below -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="printChildren">
		<xsl:param name="i" />
		<xsl:param name="count" />

		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<traveller>
				<line_id><xsl:value-of select="$i + 1"/></line_id>
				<type>CHILD</type>
				<age>10</age>
			</traveller>
				
			<xsl:call-template name="printChildren">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count" select="$count" />
			</xsl:call-template>
		</xsl:if>

	</xsl:template>
</xsl:stylesheet>