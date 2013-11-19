<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- xsl:import href="../includes/utils.xsl"/ -->

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="today" />

<!-- KEYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- LIFE TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/life|/ip">

<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<xsl:variable name="isIP"><xsl:value-of select="primary/insurance/income" /></xsl:variable>

		<request xmlns="urn:Lifebroker.EnterpriseAPI">
			<client>
				<affiliate_id><xsl:value-of select="current/transactionId" /></affiliate_id>
				<name><xsl:value-of select="primary/firstName" /> <xsl:value-of select="primary/lastname" /></name>
				<email><xsl:value-of select="contactDetails/email" /></email>
				<phone><xsl:value-of select="contactDetails/contactNumber" /></phone>
				<age><xsl:value-of select="primary/age" /></age>
				<gender><xsl:value-of select="primary/gender" /></gender>
				<smoker><xsl:value-of select="primary/smoker" /></smoker>
				<state><xsl:value-of select="primary/state" /></state>
				<occupation><xsl:value-of select="primary/occupation" /></occupation>
		<xsl:choose>
			<xsl:when test="$isIP != ''">
				<income><xsl:value-of select="primary/insurance/income" /></income>
			</xsl:when>
			<xsl:otherwise><!-- IGNORE --></xsl:otherwise>
		</xsl:choose>
			</client>
		<xsl:if test="primary/insurance/partner = 'Y'">
			<partner>
				<name><xsl:value-of select="partner/firstName" /> <xsl:value-of select="partner/lastname" /></name>
				<age><xsl:value-of select="partner/age" /></age>
				<gender><xsl:value-of select="partner/gender" /></gender>
				<smoker><xsl:value-of select="partner/smoker" /></smoker>
				<state><xsl:value-of select="partner/state" /></state>
				<occupation><xsl:value-of select="partner/occupation" /></occupation>
		<xsl:choose>
			<xsl:when test="$isIP = ''">
				<income><xsl:value-of select="partner/insurance/income" /></income>
			</xsl:when>
			<xsl:otherwise><!-- IGNORE --></xsl:otherwise>
		</xsl:choose>
			</partner>
		</xsl:if>
			<quote>
				<frequency><xsl:value-of select="primary/insurance/frequency" /></frequency>
				<premium_type><xsl:value-of select="primary/insurance/type" /></premium_type>
		<xsl:choose>
			<xsl:when test="$isIP = ''">
				<tpd_benefit><xsl:value-of select="primary/insurance/tpd" /></tpd_benefit>
				<trauma_benefit><xsl:value-of select="primary/insurance/trauma" /></trauma_benefit>
				<life_benefit><xsl:value-of select="primary/insurance/term" /></life_benefit>
			</xsl:when>
			<xsl:otherwise>
				<ip_benefit><xsl:value-of select="primary/insurance/amount" /></ip_benefit>
				<ip_indemnity><xsl:value-of select="primary/insurance/value" /></ip_indemnity>
				<ip_wait_period><xsl:value-of select="primary/insurance/waiting" /></ip_wait_period>
				<ip_benefit_period><xsl:value-of select="primary/insurance/benefit" /></ip_benefit_period>
			</xsl:otherwise>
		</xsl:choose>
			</quote>
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