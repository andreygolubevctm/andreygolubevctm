<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:math="http://exslt.org/math"
				extension-element-prefixes="math" xmlns="http://pricingapi.agaassistance.com.au/PricingRequest.xsd">
	<xsl:template name="printChildren">
		<xsl:param name="i" />
		<xsl:param name="count" />
		<xsl:param name="childDOB" />

		<!--begin_: RepeatTheLoopUntilFinished-->
		<xsl:if test="$i &lt;= $count">
			<Traveller>
				<Type>CHILD</Type>
				<DateOfBirth><xsl:value-of select="$childDOB" /></DateOfBirth>
			</Traveller>
			<xsl:call-template name="printChildren">
				<xsl:with-param name="i">
					<xsl:value-of select="$i + 1"/>
				</xsl:with-param>
				<xsl:with-param name="count" select="$count" />
				<xsl:with-param name="childDOB" select="$childDOB" />
			</xsl:call-template>
		</xsl:if>

	</xsl:template>
</xsl:stylesheet>