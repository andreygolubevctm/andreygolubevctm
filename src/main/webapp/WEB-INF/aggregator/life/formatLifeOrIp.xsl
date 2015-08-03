<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="vertical">ip</xsl:param>
	<xsl:template match="/">

		<xsl:variable name="smoker">
			<xsl:choose>
				<xsl:when test="//primary/smoker = 'Y'">smoker</xsl:when>
				<xsl:when test="//primary/smoker = 'N'">non-smoker</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="gender">
			<xsl:choose>
				<xsl:when test="//primary/gender = 'M'">male</xsl:when>
				<xsl:when test="//primary/gender = 'F'">female</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="frequency">
			<xsl:choose>
				<xsl:when test="//primary/insurance/frequency = 'A'">Annual</xsl:when>
				<xsl:when test="//primary/insurance/frequency = 'H'">Half Yearly</xsl:when>
				<xsl:when test="//primary/insurance/frequency = 'M'">Monthly</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="type">
			<xsl:choose>
				<xsl:when test="//primary/insurance/type = 'L'">Level</xsl:when>
				<xsl:when test="//primary/insurance/type = 'S'">Stepped</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="trama">
			<xsl:choose>
				<xsl:when test="//primary/insurance/termentry"><xsl:value-of select="//primary/insurance/traumaentry" /></xsl:when>
				<xsl:when test="//primary/insurance/trauma"><xsl:value-of select="//primary/insurance/trauma" /></xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="terminal">
			<xsl:choose>
				<xsl:when test="//primary/insurance/termentry"><xsl:value-of select="//primary/insurance/termentry" /></xsl:when>
				<xsl:when test="//primary/insurance/term"><xsl:value-of select="//primary/insurance/term" /></xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="tpdentry">
			<xsl:choose>
				<xsl:when test="//primary/insurance/tpdentry"><xsl:value-of select="//primary/insurance/tpdentry" /></xsl:when>
				<xsl:when test="//primary/insurance/tpd"><xsl:value-of select="//primary/insurance/tpd" /></xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<content>
			<xsl:variable name="situation" >
				<xsl:value-of select="concat(//primary/age,' ', $gender, ', ', $smoker)" />
			</xsl:variable>
			<situation><xsl:value-of select="$situation" /></situation>
			<xsl:if test="$vertical ='life'">
				<term><xsl:value-of select="$terminal" /></term>
				<tpd><xsl:value-of select="$tpdentry" /></tpd>
				<trauma><xsl:value-of select="$trama" /></trauma>
			</xsl:if>
			<xsl:if test="$vertical ='ip'">
				<income><xsl:value-of select="//primary/insurance/incomeentry" /></income>
				<amount><xsl:value-of select="//primary/insurance/amountentry" /></amount>
			</xsl:if>
			<premium><xsl:value-of select="$frequency" /> (<xsl:value-of select="$type" />)</premium>
		</content>
	</xsl:template>
</xsl:stylesheet>