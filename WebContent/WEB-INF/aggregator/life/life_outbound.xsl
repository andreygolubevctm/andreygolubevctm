<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- xsl:import href="../includes/utils.xsl"/ -->
	
<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="today" />

<!-- KEYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	
<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/life">
	
<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->				
		<request xmlns="urn:Lifebroker.EnterpriseAPI">
			<client>
				<name><xsl:value-of select="details/primary/name" /></name>
				<email><xsl:value-of select="contactDetails/email" /></email>
				<phone><xsl:value-of select="contactDetails/contactNumber" /></phone>
				<income><xsl:value-of select="fix" /></income>
				<age><xsl:value-of select="fix" /></age>
				<gender><xsl:value-of select="details/primary/gender" /></gender>
				<smoker><xsl:value-of select="details/primary/name" /></smoker>
				<state><xsl:value-of select="fix" /></state>
				<occupation><xsl:value-of select="details/primary/occupation" /></occupation>
			</client>
			<quote>
				<xsl:choose>
					<xsl:when test="details/primary/insurance/frequency = ''">
						<frequency>0</frequency>
					</xsl:when>
					<xsl:otherwise>
						<frequency><xsl:value-of select="details/primary/insurance/frequency" /></frequency>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="details/primary/insurance/type = ''">
						<premium_type>0</premium_type>
					</xsl:when>
					<xsl:otherwise>
						<premium_type><xsl:value-of select="details/primary/insurance/type" /></premium_type>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="details/primary/insurance/term = ''">
						<life_benefit>0</life_benefit>
					</xsl:when>
					<xsl:otherwise>
						<life_benefit><xsl:value-of select="details/primary/insurance/term" /></life_benefit>
					</xsl:otherwise>
				</xsl:choose>
			</quote>
			<flags>
			</flags>		
		</request>
				
	</xsl:template>

<!-- UTILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
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
</xsl:stylesheet>