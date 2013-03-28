<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="node()|@*">
		<xsl:choose>
			<xsl:when test="name()='number' and name(parent::*)='credit'">
				<!--  Do nothing  -->
			</xsl:when>
			<xsl:when test="name()='number' and name(parent::*)='bank'">
				<!--  Do nothing  -->
			</xsl:when>
			<xsl:when test="name()='number' and name(parent::*)='claim'">
				<!--  Do nothing  -->
			</xsl:when>
			<xsl:when test="name()='operatorId' and name(parent::*)!='health'">
				<!--  Do nothing  -->
			</xsl:when>
			<xsl:otherwise> 
				<xsl:copy>
					<xsl:apply-templates select="node()|@*"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
