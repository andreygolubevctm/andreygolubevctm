<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:h="http://admin.privatehealth.gov.au/ws/Schemas"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:ensure="local_ensure_lookup_list"
	exclude-result-prefixes="soapenv h xsi ensure"
	>

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="info_structure" select="document('imports/info_structure.xml')" />

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId">*NONE</xsl:param>
	<xsl:param name="defaultProductId"><xsl:value-of select="$productId" /></xsl:param>
	<xsl:param name="service"></xsl:param>
	<xsl:param name="request" />
	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/">
		<xsl:choose>

		<!-- ACCEPTABLE -->
		<xsl:when test="/results/result/premium">
			<xsl:apply-templates />
		</xsl:when>

		<!-- UNACCEPTABLE -->
		<xsl:otherwise>
			<results>
				<xsl:call-template name="unavailable">
					<xsl:with-param name="productId" select="$productId" />
				</xsl:call-template>
			</results>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- PRICES AVAILABLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/results">
		<results>

			<xsl:for-each select="result">

				<xsl:element name="price">
					<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
					<xsl:attribute name="productId">
						<xsl:choose>
							<xsl:when test="$productId != '*NONE'"><xsl:value-of select="$productId" /></xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$service" />-<xsl:value-of select="@productId" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<available>Y</available>
					<transactionId><xsl:value-of select="$transactionId"/></transactionId>

					<xsl:copy-of select="premium"/>
					<xsl:copy-of select="altPremium"/>
					<xsl:copy-of select="rebateChangeoverPremium"/>
					<xsl:copy-of select="promo"/>
					<xsl:copy-of select="phio/custom"/>
					<info>
						<restrictedFund><xsl:value-of select="restrictedFund"/></restrictedFund>
						<provider><xsl:value-of select="provider"/></provider>
						<providerName><xsl:value-of select="providerName"/></providerName>
						<providerId><xsl:value-of select="providerId"/></providerId>
						<productCode><xsl:value-of select="productCode"/></productCode>
						<productTitle><xsl:value-of select="name"/></productTitle>
						<trackCode>UNKNOWN</trackCode>
						<name><xsl:value-of select="name"/></name>
						<des><xsl:value-of select="des"/></des>
						<!-- Rank is normally the benefit count so is the same across all results. -->
						<!-- <rank><xsl:value-of select="rank"/></rank> -->
						<!-- Until we have proper benefits scoring, make rank the numeric order of the results as they were returned in the SQL: 1 to 12 -->
						<rank><xsl:value-of select="position()"/></rank>
						<OtherProductFeatures>
							<xsl:value-of select="phio/hospital/OtherProductFeatures" />
						</OtherProductFeatures>
						<xsl:copy-of select="phio/info/*" />
					</info>
					<hospital>
						<xsl:copy-of select="phio/hospital/*[name() != 'benefits' and name() != 'OtherProductFeatures']" />

						<xsl:if test="phio/hospital/benefits">
							<benefits>
								<xsl:for-each select="phio/hospital/benefits/*">
									<xsl:choose>
										<!-- If a benefits is not covered then we need to blank out various fields -->
										<xsl:when test="./covered = 'n' or ./covered = 'N'">
											<xsl:element name="{local-name()}">
												<!-- Iterate the properties -->
												<xsl:for-each select="./*">
													<xsl:choose>
														<!-- Blank out specific fields -->
														<!-- This logic was taken from the old health/results.tag -->
														<xsl:when test="local-name() = 'WaitingPeriod'">
															<xsl:element name="{local-name()}">-</xsl:element>
														</xsl:when>
														<xsl:otherwise>
															<xsl:copy-of select="." />
														</xsl:otherwise>
													</xsl:choose>
												</xsl:for-each>
											</xsl:element>
										</xsl:when>
										<!-- covered=Y so simply copy it -->
										<xsl:otherwise>
											<xsl:copy-of select="." />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</benefits>
						</xsl:if>

					</hospital>
					<extras>
						<!-- Iterate the extras e.g. DentalMajor -->
						<xsl:for-each select="phio/extras/*">
							<xsl:choose>
								<!-- If an extra is not covered then we need to blank out various fields due to the PHIO containing incorrect data -->
								<xsl:when test="./covered = 'n' or ./covered = 'N'">
									<xsl:element name="{local-name()}">
										<!-- Iterate the extra's properties -->
										<xsl:for-each select="./*">
											<xsl:choose>
												<!-- Blank out specific fields/xpaths -->
												<!-- This logic was taken from the old health/results.tag -->
												<xsl:when test="local-name() = 'waitingPeriod' or local-name() = 'hasSpecialFeatures' or local-name() = 'listBenefitExample' or local-name() = 'benefitLimits' or local-name() = 'groupLimits' or local-name() = 'loyaltyBonus'">
													<xsl:choose>
														<!-- If the property has no children -->
														<xsl:when test="not(*)">
															<xsl:element name="{local-name()}">-</xsl:element>
														</xsl:when>
														<!-- The property has children -->
														<xsl:otherwise>
															<xsl:element name="{local-name()}">
																<xsl:for-each select="./*">
																	<xsl:element name="{local-name()}">-</xsl:element>
																</xsl:for-each>
															</xsl:element>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:copy-of select="." />
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</xsl:element>
								</xsl:when>
								<!-- covered=Y so simply copy it -->
								<xsl:otherwise>
									<xsl:copy-of select="." />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>

					</extras>
					<ambulance>
						<xsl:copy-of select="phio/ambulanceInfo/*" />
					</ambulance>
				</xsl:element>
			</xsl:for-each>
			<info>
				<pricesHaveChanged><xsl:value-of select="pricesHaveChanged"/></pricesHaveChanged>
				<transactionId><xsl:value-of select="transactionId"/></transactionId>
				<xsl:copy-of select="premiumRange" />
			</info>
		</results>
	</xsl:template>


	<!-- UNAVAILABLE PRICE -->
	<xsl:template name="unavailable">
		<xsl:param name="productId" />

		<xsl:element name="noresults">
			<xsl:attribute name="service"><xsl:value-of select="$service" /></xsl:attribute>
			<xsl:attribute name="productId"><xsl:value-of select="$service" />-<xsl:value-of select="$productId" /></xsl:attribute>

			<available>N</available>
			<transactionId><xsl:value-of select="$transactionId"/></transactionId>
			<xsl:choose>
				<xsl:when test="error">
					<xsl:copy-of select="error"></xsl:copy-of>
				</xsl:when>
				<xsl:otherwise>
					<error service="{$service}" type="unavailable">
						<code></code>
						<message>unavailable</message>
						<data></data>
					</error>
				</xsl:otherwise>
			</xsl:choose>
			<name></name>
			<des></des>
			<info></info>
		</xsl:element>
	</xsl:template>

	<ensure:hospital>
		<ensure:item tag="DentalGeneral"/>
		<ensure:item tag="DentalMajor"/>
		<ensure:item tag="Endodontic"/>
		<ensure:item tag="Orthodontic"/>
		<ensure:item tag="Optical"/>
		<ensure:item tag="Physiotherapy"/>
		<ensure:item tag="Chiropractic"/>
		<ensure:item tag="Podiatry"/>
		<ensure:item tag="Psychology"/>
		<ensure:item tag="NonPBS"/>
		<ensure:item tag="Acupuncture"/>
		<ensure:item tag="Naturopathy"/>
		<ensure:item tag="Massage"/>
		<ensure:item tag="HearingAids"/>
	</ensure:hospital>

	<ensure:extras>
		<ensure:item tag="AssistedReproductive"/>
		<ensure:item tag="Cardiac"/>
		<ensure:item tag="CataractEyeLens"/>
		<ensure:item tag="GastricBanding"/>
		<ensure:item tag="JointReplacementAll"/>
		<ensure:item tag="Obstetric"/>
		<ensure:item tag="Palliative"/>
		<ensure:item tag="PlasticNonCosmetic"/>
		<ensure:item tag="Podiatric"/>
		<ensure:item tag="Psychiatric"/>
		<ensure:item tag="Rehabilitation"/>
		<ensure:item tag="RenalDialysis"/>
		<ensure:item tag="Sterilisation"/>
	</ensure:extras>
</xsl:stylesheet>