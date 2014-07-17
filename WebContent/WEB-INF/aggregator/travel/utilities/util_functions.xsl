<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:math="http://exslt.org/math"
				extension-element-prefixes="math">
	<xsl:template name="util_randomNumber">
		<xsl:variable name="pre1" select="floor(math:random()*16)"/>
		<xsl:variable name="pre2" select="floor(math:random()*16)"/>
		<xsl:variable name="pre3" select="floor(math:random()*16)"/>
		<xsl:variable name="pre4" select="floor(math:random()*16)"/>
		<xsl:variable name="pre5" select="floor(math:random()*16)"/>
		<xsl:variable name="pre6" select="floor(math:random()*16)"/>
		<xsl:variable name="pre7" select="floor(math:random()*16)"/>
		<xsl:variable name="pre8" select="floor(math:random()*16)"/>
		<xsl:variable name="pre9" select="floor(math:random()*16)"/>
		<xsl:variable name="pre10" select="floor(math:random()*16)"/>
		<xsl:variable name="pre11" select="floor(math:random()*16)"/>
		<xsl:variable name="pre12" select="floor(math:random()*16)"/>
		<xsl:variable name="pre13" select="floor(math:random()*16)"/>
		<xsl:variable name="pre14" select="floor(math:random()*16)"/>
		<xsl:variable name="pre15" select="floor(math:random()*16)"/>
		<xsl:variable name="pre16" select="floor(math:random()*16)"/>
		<xsl:variable name="pre17" select="floor(math:random()*16)"/>
		<xsl:variable name="pre18" select="floor(math:random()*16)"/>
		<xsl:variable name="pre19" select="floor(math:random()*16)"/>
		<xsl:variable name="pre20" select="floor(math:random()*16)"/>
		<xsl:variable name="pre21" select="floor(math:random()*16)"/>
		<xsl:variable name="pre22" select="floor(math:random()*16)"/>
		<xsl:variable name="pre23" select="floor(math:random()*16)"/>
		<xsl:variable name="pre24" select="floor(math:random()*16)"/>
		<xsl:variable name="pre25" select="floor(math:random()*16)"/>
		<xsl:variable name="pre26" select="floor(math:random()*16)"/>
		<xsl:variable name="pre27" select="floor(math:random()*16)"/>
		<xsl:variable name="pre28" select="floor(math:random()*16)"/>
		<xsl:variable name="pre29" select="floor(math:random()*16)"/>
		<xsl:variable name="pre30" select="floor(math:random()*16)"/>
		<xsl:variable name="pre31" select="floor(math:random()*16)"/>
		<xsl:variable name="pre32" select="floor(math:random()*16)"/>

		<xsl:variable name="pos1">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre1" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos2">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre2" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos3">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre3" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos4">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre4" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos5">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre5" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos6">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre6" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos7">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre7" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos8">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre8" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos9">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre9" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos10">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre10" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos11">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre11" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos12">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre12" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos13">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre13" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos14">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre14" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos15">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre15" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos16">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre16" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos17">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre17" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos18">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre18" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos19">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre19" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos20">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre20" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos21">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre21" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos22">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre22" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos23">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre23" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos24">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre24" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos25">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre25" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos26">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre26" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos27">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre27" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos28">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre28" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos29">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre29" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos30">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre30" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos31">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre31" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="pos32">
			<xsl:call-template name="util_makeHex">
				<xsl:with-param name="digit" select="$pre32" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="$pos1" /><xsl:value-of select="$pos2" /><xsl:value-of select="$pos3" /><xsl:value-of select="$pos4" />
		<xsl:value-of select="$pos5" /><xsl:value-of select="$pos6" /><xsl:value-of select="$pos7" /><xsl:value-of select="$pos8" />-<xsl:value-of select="$pos9" />
		<xsl:value-of select="$pos10" /><xsl:value-of select="$pos11" /><xsl:value-of select="$pos12" />-<xsl:value-of select="$pos13" />
		<xsl:value-of select="$pos14" /><xsl:value-of select="$pos15" /><xsl:value-of select="$pos16" />-<xsl:value-of select="$pos17" />
		<xsl:value-of select="$pos18" /><xsl:value-of select="$pos19" /><xsl:value-of select="$pos20" />-<xsl:value-of select="$pos21" />
		<xsl:value-of select="$pos22" /><xsl:value-of select="$pos23" /><xsl:value-of select="$pos24" /><xsl:value-of select="$pos25" />
		<xsl:value-of select="$pos26" /><xsl:value-of select="$pos27" /><xsl:value-of select="$pos28" /><xsl:value-of select="$pos29" />
		<xsl:value-of select="$pos30" /><xsl:value-of select="$pos31" /><xsl:value-of select="$pos32" />
	</xsl:template>

	<xsl:template name="util_makeHex">
		<xsl:param name="digit" />

		<xsl:choose>
			<xsl:when test="$digit='10'">A</xsl:when>
			<xsl:when test="$digit='11'">B</xsl:when>
			<xsl:when test="$digit='12'">C</xsl:when>
			<xsl:when test="$digit='13'">D</xsl:when>
			<xsl:when test="$digit='14'">E</xsl:when>
			<xsl:when test="$digit='15'">F</xsl:when>
			<xsl:otherwise><xsl:value-of select="$digit" /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>