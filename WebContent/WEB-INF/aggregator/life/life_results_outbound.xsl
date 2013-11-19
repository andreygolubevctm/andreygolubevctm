<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- xsl:import href="../includes/utils.xsl"/ -->

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="today" />
	<xsl:param name="vertical" />

<!-- KEYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<xsl:template match="/life|/ip">

		<!-- Replace the phone no if selected 'do not call' -->
		<xsl:variable name="okToCall"><xsl:value-of select="contactDetails/call" /></xsl:variable>
		<xsl:variable name="marketing"><xsl:value-of select="contactDetails/call" /></xsl:variable>
		<xsl:variable name="phoneNo">
			<xsl:choose>
				<xsl:when test="$okToCall = 'N'">
					<xsl:text>0000000000</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="contactDetails/contactNumber" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Replace the email if selected 'no marketing' -->
		<xsl:variable name="optIn"><xsl:value-of select="contactDetails/optIn" /></xsl:variable>
		<xsl:variable name="email"><xsl:value-of select="contactDetails/email" /></xsl:variable>

<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<request xmlns="urn:Lifebroker.EnterpriseAPI">
			<client>
				<affiliate_id><xsl:value-of select="transactionId" /></affiliate_id>
				<name><xsl:value-of select="primary/firstName" /><xsl:text> </xsl:text><xsl:value-of select="primary/lastname" /></name>
				<email><xsl:value-of select="$email" /></email>
				<phone><xsl:value-of select="$phoneNo" /></phone>
				<age><xsl:value-of select="primary/age" /></age>
				<gender><xsl:value-of select="primary/gender" /></gender>
				<smoker><xsl:value-of select="primary/smoker" /></smoker>
				<state><xsl:value-of select="primary/state" /></state>
				<occupation><xsl:value-of select="primary/occupation" /></occupation>
			<xsl:if test="$vertical = 'ip'">
				<income><xsl:value-of select="primary/insurance/income" /></income>
			</xsl:if>
			</client>
		<xsl:if test="primary/insurance/partner = 'Y'">
			<partner>
				<name><xsl:value-of select="partner/firstName" /><xsl:text> </xsl:text><xsl:value-of select="partner/lastname" /></name>
				<age><xsl:value-of select="partner/age" /></age>
				<gender><xsl:value-of select="partner/gender" /></gender>
				<smoker><xsl:value-of select="partner/smoker" /></smoker>
				<occupation><xsl:value-of select="partner/occupation" /></occupation>
			<xsl:if test="$vertical = 'ip'">
				<income><xsl:value-of select="primary/insurance/income" /></income>
			</xsl:if>
			</partner>
		</xsl:if>
			<quote>
		<xsl:choose>
			<xsl:when test="$vertical = 'ip'">
				<frequency><xsl:value-of select="primary/insurance/frequency" /></frequency>
				<premium_type><xsl:value-of select="primary/insurance/type" /></premium_type>
				<benefit><xsl:value-of select="primary/insurance/amount" /></benefit>
				<indemnity><xsl:value-of select="primary/insurance/value" /></indemnity>
				<wait_period><xsl:value-of select="primary/insurance/waiting" /></wait_period>
				<benefit_period><xsl:value-of select="primary/insurance/benefit" /></benefit_period>
			</xsl:when>
			<xsl:otherwise>
				<frequency><xsl:value-of select="primary/insurance/frequency" /></frequency>
				<premium_type><xsl:value-of select="primary/insurance/type" /></premium_type>
				<life_benefit><xsl:value-of select="primary/insurance/term" /></life_benefit>
				<trauma_benefit><xsl:value-of select="primary/insurance/trauma" /></trauma_benefit>
				<tpd_benefit><xsl:value-of select="primary/insurance/tpd" /></tpd_benefit>
			</xsl:otherwise>
		</xsl:choose>
			</quote>
			<flags>
				<flag>AgeRestriction</flag>
				<flag>SIRestriction</flag>
				<flag>ICB</flag>
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