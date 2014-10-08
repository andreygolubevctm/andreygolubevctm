<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- xsl:import href="../includes/utils.xsl"/ -->

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- KEYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- LIFE TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/life|/ip">

<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<xsl:variable name="isIP"><xsl:value-of select="primary/insurance/income" /></xsl:variable>

		<request xmlns="urn:Lifebroker.EnterpriseAPI">
			<contact>
				<affiliate_id><xsl:value-of select="$transactionId" /></affiliate_id>
				<email><xsl:value-of select="contactDetails/email" /></email>
				<phone><xsl:value-of select="contactDetails/contactNumber" /></phone>
				<state><xsl:value-of select="primary/state" /></state>
				<postcode><xsl:value-of select="primary/postCode" /></postcode>
				<client>
					<name><xsl:value-of select="primary/firstName" /> <xsl:value-of select="primary/lastname" /></name>
					<age><xsl:value-of select="primary/age" /></age>
					<gender><xsl:value-of select="primary/gender" /></gender>
					<smoker><xsl:value-of select="primary/smoker" /></smoker>
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
					<occupation><xsl:value-of select="partner/occupation" /></occupation>
				<xsl:choose>
					<xsl:when test="$isIP != ''">
					<income><xsl:value-of select="partner/insurance/income" /></income>
					</xsl:when>
					<xsl:otherwise><!-- IGNORE --></xsl:otherwise>
				</xsl:choose>
				</partner>
			</xsl:if>
			</contact>
			<quote>
		<xsl:choose>
			<xsl:when test="$isIP != ''">
				<frequency><xsl:value-of select="primary/insurance/frequency" /></frequency>
				<premium_type><xsl:value-of select="primary/insurance/type" /></premium_type>
				<client>
					<benefit><xsl:value-of select="primary/insurance/amount" /></benefit>
					<indemnity><xsl:value-of select="primary/insurance/value" /></indemnity>
					<wait_period><xsl:value-of select="primary/insurance/waiting" /></wait_period>
					<benefit_period><xsl:value-of select="primary/insurance/benefit" /></benefit_period>
				</client>
				<partner>
				<xsl:if test="partner/insurance/amount != '' and primary/insurance/tpd != '0'">
					<benefit><xsl:value-of select="partner/insurance/amount" /></benefit>
					<indemnity><xsl:value-of select="partner/insurance/value" /></indemnity>
					<wait_period><xsl:value-of select="partner/insurance/waiting" /></wait_period>
					<benefit_period><xsl:value-of select="partner/insurance/benefit" /></benefit_period>
				</xsl:if>
				</partner>
			</xsl:when>
			<xsl:otherwise>
				<frequency><xsl:value-of select="primary/insurance/frequency" /></frequency>
				<premium_type><xsl:value-of select="primary/insurance/type" /></premium_type>
				<client>
				<xsl:if test="primary/insurance/term != '0'">
					<life_benefit><xsl:value-of select="primary/insurance/term" /></life_benefit>
				</xsl:if>
				<xsl:if test="primary/insurance/trauma != '0'">
					<trauma_benefit><xsl:value-of select="primary/insurance/trauma" /></trauma_benefit>
				</xsl:if>
				<xsl:if test="primary/insurance/tpd != '0'">
					<tpd_benefit><xsl:value-of select="primary/insurance/tpd" /></tpd_benefit>
					<tpd_any_own><xsl:value-of select="primary/insurance/tpdanyown" /></tpd_any_own>
				</xsl:if>
				</client>
				<xsl:if test="primary/insurance/partner = 'Y'">
				<partner>
					<xsl:if test="primary/insurance/term != '0'">
					<life_benefit><xsl:value-of select="primary/insurance/term" /></life_benefit>
					</xsl:if>
					<xsl:if test="primary/insurance/trauma != '0'">
					<trauma_benefit><xsl:value-of select="primary/insurance/trauma" /></trauma_benefit>
					</xsl:if>
					<xsl:if test="primary/insurance/tpd != '0'">
					<tpd_benefit><xsl:value-of select="primary/insurance/tpd" /></tpd_benefit>
					<tpd_any_own><xsl:value-of select="primary/insurance/tpdanyown" /></tpd_any_own>
					</xsl:if>
				</partner>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
			</quote>
			<xsl:choose>
				<xsl:when test="contactLeadSent != '' and contactLeadSent = 'Y'">
					<additional>
						<progress>Quote</progress>
					</additional>
				</xsl:when>
				<xsl:otherwise>
					<additional>
						<progress>Start</progress>
					</additional>
				</xsl:otherwise>
			</xsl:choose>
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