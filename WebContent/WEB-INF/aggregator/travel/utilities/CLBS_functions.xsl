<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="getChildMembers">
		<xsl:param name="start" />
		<xsl:param name="end" />
		<xsl:param name="dob" />
		<xsl:param name="disableOutputEscaping" />

		<xsl:if test="not($start = $end)">

			<xsl:variable name="childMember">
				<xsl:text>&lt;partyMember id=&quot;</xsl:text><xsl:value-of select="$start + 1" /><xsl:text>&quot;&gt;</xsl:text>
					<xsl:text>&lt;dob fte=&quot;n&quot;&gt;</xsl:text><xsl:value-of select="$dob" /><xsl:text>&lt;/dob&gt;</xsl:text>
				<xsl:text>&lt;/partyMember&gt;</xsl:text>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="$disableOutputEscaping ='yes'">
					<xsl:value-of select="$childMember" disable-output-escaping="yes" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$childMember" disable-output-escaping="no" />
				</xsl:otherwise>
			</xsl:choose>
			
			<xsl:call-template name="getChildMembers">
				<xsl:with-param name="start" select="$start + 1" />
				<xsl:with-param name="end" select="$end" />
				<xsl:with-param name="dob" select="$dob" />
				<xsl:with-param name="disableOutputEscaping" select="$disableOutputEscaping" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>