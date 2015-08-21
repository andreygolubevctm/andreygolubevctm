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
	<xsl:template match="/roadside">
	
<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

		<!-- NSW has combined coverage with ACT -->
		<xsl:variable name="state">
			<xsl:choose>
				<!-- COMBINE -->
				<xsl:when test="riskAddress/state = 'NSW'">NSW-ACT</xsl:when>
				<xsl:when test="riskAddress/state = 'ACT'">NSW-ACT</xsl:when>
				<!-- DEFAULT -->
				<xsl:otherwise >
					<xsl:value-of select="riskAddress/state" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="commercial">
			<xsl:choose>
				<!-- COMBINE -->
				<xsl:when test="vehicle/vehicle/commercial = 'Y'">1</xsl:when>
				<!-- DEFAULT -->
				<xsl:otherwise >0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="odometer">
			<xsl:choose>
				<!-- COMBINE -->
				<xsl:when test="vehicle/vehicle/odometer = 'Y'">1</xsl:when>
				<!-- DEFAULT -->
				<xsl:otherwise >0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>		
		
		<request>		
<!-- HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
			<header>
				<partnerReference><xsl:value-of select="transactionId" /></partnerReference>
				<clientIpAddress><xsl:value-of select="clientIpAddress" /></clientIpAddress>
			</header>
		
<!-- REQUEST DETAILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<!-- 
			Only item to query is the STATE
		 -->
			<details>
				<state><xsl:value-of select="$state" /></state>
				<year><xsl:value-of select="vehicle/year" /></year>
				<commercial><xsl:value-of select="$commercial" /></commercial>
				<odometer><xsl:value-of select="$odometer" /></odometer>	
			</details>
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