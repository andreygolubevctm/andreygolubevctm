<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output omit-xml-declaration="yes" indent="no"></xsl:output>

	<xsl:template match="/">
		<phio>
			<xsl:apply-templates select="merge/phio/*"/>
			
			<ambulanceInfo>
				<xsl:apply-templates select="/merge/ancillaryData/ambulance/*" />
			</ambulanceInfo>		
		</phio>
	</xsl:template>

	<xsl:template match="extras">
		<extras>
			<xsl:for-each select="*">
			
				<xsl:choose>
					<xsl:when test="*">
						<xsl:element name="{name()}">
							<xsl:copy-of select="*" />
						
							<xsl:variable name="elem" select="name()" />
							<xsl:copy-of select="/merge/ancillaryData/extras/*[name()=$elem]/*" />
						</xsl:element>
					
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="." />
					</xsl:otherwise>
				</xsl:choose>			
			</xsl:for-each>
			
			<xsl:apply-templates select="/merge/ancillaryData/ancillary/*" />			
		</extras>
	</xsl:template>
	
	<xsl:template match="covered">
		<xsl:variable name="v"><xsl:value-of select="."/></xsl:variable>
		<xsl:choose>
			<xsl:when test="substring($v,1,1)='Y'">
				<covered>Y</covered>
			</xsl:when>
			<xsl:otherwise>
				<covered>N</covered>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="*[name()!='ancillaryData' 
							and name()!='extras']">
							
		<xsl:choose>
			<xsl:when test="*">
				<xsl:element name="{name()}">
					<xsl:apply-templates />
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
			
				<xsl:variable name="v"><xsl:value-of select="."/></xsl:variable>
				<xsl:choose>
					<xsl:when test="$v='-' and name()='loyaltyBonus'">
					</xsl:when>
					<xsl:when test="$v='0'">
						<xsl:element name="{name()}">None</xsl:element>
					</xsl:when>
					<xsl:when test="$v='YES'">
						<xsl:element name="{name()}">Y</xsl:element>
					</xsl:when>
					<xsl:when test="$v='NO'">
						<xsl:element name="{name()}">N</xsl:element>
					</xsl:when>					
					<xsl:otherwise>
						<xsl:copy-of select="." />
					</xsl:otherwise>
				</xsl:choose>		
				
			</xsl:otherwise>
		</xsl:choose>									

	</xsl:template>
	
</xsl:stylesheet>