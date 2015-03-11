<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="../includes/utils.xsl" />

<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="sourceId" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- KEYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

<xsl:template match="/life">

		<!-- Replace the phone no if selected 'do not call' -->
		<xsl:variable name="okToCall"><xsl:value-of select="contactDetails/call" /></xsl:variable>
		<xsl:variable name="marketing"><xsl:value-of select="contactDetails/call" /></xsl:variable>
		<xsl:variable name="phoneNo">0000000000</xsl:variable>
		<xsl:variable name="email">e@fake.org</xsl:variable>
		<xsl:variable name="primaryDob"><xsl:value-of select="primary/dob" /></xsl:variable>
		<xsl:variable name="partnerDob"><xsl:value-of select="partner/dob" /></xsl:variable>

<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" env:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
			<env:Header />
			<env:Body>
				<ns2:request xmlns:ns2="https://ecommerce.disconline.com.au/services/schema/3.1/life_quote">
					<header>
						<partnerId>CTM0000400</partnerId>
						<sourceId><xsl:value-of select="$sourceId" /></sourceId>
						<schemaVersion>3.1</schemaVersion>
						<extension />
						<partnerReference><xsl:value-of select="$transactionId" /></partnerReference>
						<clientIpAddress><xsl:value-of select="clientIpAddress" /></clientIpAddress>
					</header>
					<details>
						<emailAddress><xsl:value-of select="$email" /></emailAddress>
						<phoneNumber><xsl:value-of select="$phoneNo" /></phoneNumber>
						<postCode><xsl:value-of select="primary/postCode" /></postCode>
						<client>
							<firstName><xsl:value-of select="primary/firstName" /></firstName>
							<surname><xsl:value-of select="primary/lastname" /></surname>
							<dob>
								<xsl:call-template name="util_isoDate">
									<xsl:with-param name="eurDate" select="$primaryDob" />
								</xsl:call-template>
							</dob>
							<gender><xsl:value-of select="primary/gender" /></gender>
							<smoker><xsl:value-of select="primary/smoker" /></smoker>
							<occupation><xsl:value-of select="primary/occupationTitle" /></occupation>
							<occupationGroup><xsl:value-of select="primary/hannover" /></occupationGroup>
							<xsl:choose>
								<xsl:when test="primary/insurance/term != ''">
									<lifeBenefit><xsl:value-of select="primary/insurance/term" /></lifeBenefit>
								</xsl:when>
								<xsl:otherwise>
									<lifeBenefit>0</lifeBenefit>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="primary/insurance/tpd != ''">
									<tpdBenefit><xsl:value-of select="primary/insurance/tpd" /></tpdBenefit>
								</xsl:when>
								<xsl:otherwise>
									<tpdBenefit>0</tpdBenefit>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="primary/insurance/trauma != ''">
									<traumaBenefit><xsl:value-of select="primary/insurance/trauma" /></traumaBenefit>
								</xsl:when>
								<xsl:otherwise>
									<traumaBenefit>0</traumaBenefit>
								</xsl:otherwise>
							</xsl:choose>
						</client>
						<xsl:if test="primary/insurance/partner = 'Y'">
							<partner>
								<firstName><xsl:value-of select="partner/firstName" /></firstName>
								<surname><xsl:value-of select="partner/lastname" /></surname>
								<dob>
									<xsl:call-template name="util_isoDate">
										<xsl:with-param name="eurDate" select="$partnerDob" />
									</xsl:call-template>
								</dob>
								<gender><xsl:value-of select="partner/gender" /></gender>
								<smoker><xsl:value-of select="partner/smoker" /></smoker>
								<occupation><xsl:value-of select="partner/occupationTitle" /></occupation>
								<occupationGroup><xsl:value-of select="partner/hannover" /></occupationGroup>

								<xsl:choose>
									<xsl:when test="primary/insurance/samecover != 'Y' and partner/insurance/term != ''">
										<lifeBenefit><xsl:value-of select="partner/insurance/term" /></lifeBenefit>
									</xsl:when>
									<xsl:when test="primary/insurance/term != ''">
										<lifeBenefit><xsl:value-of select="primary/insurance/term" /></lifeBenefit>
									</xsl:when>
									<xsl:otherwise>
										<lifeBenefit>0</lifeBenefit>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="primary/insurance/samecover != 'Y' and partner/insurance/tpd != ''">
										<tpdBenefit><xsl:value-of select="partner/insurance/tpd" /></tpdBenefit>
									</xsl:when>
									<xsl:when test="primary/insurance/tpd != ''">
										<tpdBenefit><xsl:value-of select="primary/insurance/tpd" /></tpdBenefit>
									</xsl:when>
									<xsl:otherwise>
										<tpdBenefit>0</tpdBenefit>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:choose>
									<xsl:when test="primary/insurance/samecover != 'Y' and partner/insurance/trauma != ''">
										<traumaBenefit><xsl:value-of select="partner/insurance/trauma" /></traumaBenefit>
									</xsl:when>
									<xsl:when test="primary/insurance/trauma != ''">
										<traumaBenefit><xsl:value-of select="primary/insurance/trauma" /></traumaBenefit>
									</xsl:when>
									<xsl:otherwise>
										<traumaBenefit>0</traumaBenefit>
									</xsl:otherwise>
								</xsl:choose>
							</partner>
						</xsl:if>
					</details>
				</ns2:request>
			</env:Body>
		</env:Envelope>
	</xsl:template>
</xsl:stylesheet>