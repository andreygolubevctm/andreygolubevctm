<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="../includes/utils.xsl" />

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- KEYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- LIFE TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/life|/ip">

<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<request xmlns="urn:Lifebroker.EnterpriseAPI">
			<contact>
				<affiliate_id><xsl:value-of select="$transactionId" /></affiliate_id>
				<email><xsl:value-of select="contactDetails/email" /></email>
				<phone>
					<xsl:choose>
						<xsl:when test="contactDetails/call = 'N'">
							<xsl:text>0000000000</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="contactDetails/contactNumber" />
						</xsl:otherwise>
					</xsl:choose>
				</phone>
				<state><xsl:value-of select="primary/state" /></state>
				<postcode><xsl:value-of select="primary/postCode" /></postcode>
				<client>
					<name><xsl:value-of select="primary/firstName" /><xsl:text> </xsl:text><xsl:value-of select="primary/lastname" /></name>
					<xsl:if test="primary/age != 'NaN'">
						<age><xsl:value-of select="primary/age" /></age>
					</xsl:if>
					<gender><xsl:value-of select="primary/gender" /></gender>
					<smoker><xsl:value-of select="primary/smoker" /></smoker>
					<occupation><xsl:value-of select="primary/occupation" /></occupation>
					<xsl:if test="local-name() = 'ip' and primary/insurance/income">
						<income><xsl:value-of select="primary/insurance/income" /></income>
					</xsl:if>
				</client>
			</contact>
			<xsl:if test="
				(
					local-name() = 'ip'
					and primary/insurance/amount
				) or (
					local-name() = 'life'
					and (
						primary/insurance/term
						or primary/insurance/trauma
						or primary/insurance/tpd
					)
				)
			">
				<quote>
					<frequency>M</frequency>
					<premium_type>S</premium_type>

					<xsl:choose>
						<xsl:when test="local-name() = 'ip'">
							<client>
								<benefit><xsl:value-of select="primary/insurance/amount" /></benefit>

								<indemnity>
									<xsl:call-template name="default_value">
										<xsl:with-param name="value" select="primary/insurance/value" />
										<xsl:with-param name="default" select='"0"' />
									</xsl:call-template>
								</indemnity>

								<wait_period>
									<xsl:call-template name="default_value">
										<xsl:with-param name="value" select="primary/insurance/waiting" />
										<xsl:with-param name="default" select='"0"' />
									</xsl:call-template>
								</wait_period>

								<benefit_period>
									<xsl:call-template name="default_value">
										<xsl:with-param name="value" select="primary/insurance/benefit" />
										<xsl:with-param name="default" select='"0"' />
									</xsl:call-template>
								</benefit_period>
							</client>
						</xsl:when>
						<xsl:otherwise>
							<client>
								<life_benefit>
									<xsl:call-template name="default_value">
										<xsl:with-param name="value" select="primary/insurance/term" />
										<xsl:with-param name="default" select='"0"' />
									</xsl:call-template>
								</life_benefit>

								<trauma_benefit>
									<xsl:call-template name="default_value">
										<xsl:with-param name="value" select="primary/insurance/trauma" />
										<xsl:with-param name="default" select='"0"' />
									</xsl:call-template>
								</trauma_benefit>

								<tpd_benefit>
									<xsl:call-template name="default_value">
										<xsl:with-param name="value" select="primary/insurance/tpd" />
										<xsl:with-param name="default" select='"0"' />
									</xsl:call-template>
								</tpd_benefit>

								<tpd_any_own>
									<xsl:call-template name="default_value">
										<xsl:with-param name="value" select="primary/insurance/tpdanyown" />
										<xsl:with-param name="default" select='"A"' />
									</xsl:call-template>
								</tpd_any_own>
							</client>

							<xsl:if test="primary/insurance/partner = 'Y'">
							<partner>
								<xsl:choose>
									<xsl:when test="primary/insurance/samecover = 'Y'">
										<life_benefit>
											<xsl:call-template name="default_value">
												<xsl:with-param name="value" select="primary/insurance/term" />
												<xsl:with-param name="default" select='"0"' />
											</xsl:call-template>
										</life_benefit>
									</xsl:when>
									<xsl:otherwise>
										<life_benefit>
											<xsl:call-template name="default_value">
												<xsl:with-param name="value" select="partner/insurance/term" />
												<xsl:with-param name="default" select='"0"' />
											</xsl:call-template>
										</life_benefit>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="primary/insurance/samecover = 'Y'">
										<trauma_benefit>
											<xsl:call-template name="default_value">
												<xsl:with-param name="value" select="primary/insurance/trauma" />
												<xsl:with-param name="default" select='"0"' />
											</xsl:call-template>
										</trauma_benefit>
									</xsl:when>
									<xsl:otherwise>
										<trauma_benefit>
											<xsl:call-template name="default_value">
												<xsl:with-param name="value" select="partner/insurance/trauma" />
												<xsl:with-param name="default" select='"0"' />
											</xsl:call-template>
										</trauma_benefit>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="primary/insurance/samecover = 'Y'">
										<tpd_benefit>
											<xsl:call-template name="default_value">
												<xsl:with-param name="value" select="primary/insurance/tpd" />
												<xsl:with-param name="default" select='"0"' />
											</xsl:call-template>
										</tpd_benefit>

										<tpd_any_own>
											<xsl:call-template name="default_value">
												<xsl:with-param name="value" select="primary/insurance/tpdanyown" />
												<xsl:with-param name="default" select='"A"' />
											</xsl:call-template>
										</tpd_any_own>
									</xsl:when>
									<xsl:otherwise>
										<tpd_benefit>
											<xsl:call-template name="default_value">
												<xsl:with-param name="value" select="partner/insurance/tpd" />
												<xsl:with-param name="default" select='"0"' />
											</xsl:call-template>
										</tpd_benefit>

										<tpd_any_own>
											<xsl:call-template name="default_value">
												<xsl:with-param name="value" select="partner/insurance/tpdanyown" />
												<xsl:with-param name="default" select='"A"' />
											</xsl:call-template>
										</tpd_any_own>
									</xsl:otherwise>
								</xsl:choose>
							</partner>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>

					<flags>
						<flag>AgeRestriction</flag>
						<flag>SIRestriction</flag>
						<flag>ICB</flag>
					</flags>
				</quote>
			</xsl:if>
			<additional>
				<xsl:choose>
					<xsl:when test="quoteAction = 'apply'">
						<quote_action>Apply</quote_action>
					</xsl:when>
					<xsl:when test="quoteAction = 'call'">
						<quote_action>Call</quote_action>
					</xsl:when>
					<xsl:when test="quoteAction = 'delay'">
						<quote_action>Delay</quote_action>
					</xsl:when>
					<xsl:otherwise>
						<progress>Start</progress>
					</xsl:otherwise>
				</xsl:choose>
			</additional>
		</request>

	</xsl:template>

</xsl:stylesheet>