<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
	xmlns:h="http://admin.privatehealth.gov.au/ws/Schemas"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:ensure="local_ensure_lookup_list"
	exclude-result-prefixes="soapenv h xsi ensure"
	xmlns=""
	>
	
<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:variable name="info_structure" select="document('imports/info_structure.xml')" />
	<xsl:variable name="ensure_hospital" select="document('')/ensure:hospital" />
	<xsl:variable name="ensure_extras" select="document('')/ensure:extras" />
	
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
					<xsl:copy-of select="promo"/>
					<info>
						<provider><xsl:value-of select="provider"/></provider>
						<providerName><xsl:value-of select="providerName"/></providerName>
						<productCode><xsl:value-of select="productCode"/></productCode>
						<trackCode>UNKNOWN</trackCode>
						<name><xsl:value-of select="name"/></name>
						<des><xsl:value-of select="des"/></des>
						<rank><xsl:value-of select="rank"/></rank>						
						<acn></acn>
						<afsLicenceNo></afsLicenceNo>
						<about>paragraph of text</about>
						<promotions>paragraphs of text</promotions>
						<OtherProductFeatures>
							<xsl:value-of select="phio/hospital/inclusions/OtherProductFeatures" xmlns=""/>
						</OtherProductFeatures>						
						<xsl:copy-of select="phio/info/*" xmlns=""/>
					</info>
					<hospital>
						<xsl:copy-of select="phio/hospital/*[name()!='OtherProductFeatures']" xmlns=""/>
						<xsl:call-template name="ensureHospitalBenefits">
							<xsl:with-param name="benefits" select="phio/hospital/benefits"/>
						</xsl:call-template>
					</hospital>
					<extras>
						<xsl:copy-of select="phio/extras/*" xmlns=""/>
						<xsl:call-template name="ensureExtras">
							<xsl:with-param name="extras" select="phio/extras"/>
						</xsl:call-template>						
					</extras>
					<ambulance>
						<xsl:copy-of select="phio/ambulanceInfo/*" xmlns=""/>	
					</ambulance>
				</xsl:element>		
			</xsl:for-each>
			
		</results>
	</xsl:template>


	<!-- UNAVAILABLE PRICE -->
	<xsl:template name="unavailable">
		<xsl:param name="productId" />

		<xsl:element name="price">
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

	<xsl:template name="ensureHospitalBenefits">
		<xsl:param name="benefits" />
		
		<xsl:for-each select="$ensure_hospital/*">
			<xsl:choose>
			<xsl:when test="$benefits[name()=@tag]">
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{@tag}">
					<covered>N</covered>
					<WaitingPeriod>-</WaitingPeriod>
					<benefitLimitationPeriod>-</benefitLimitationPeriod>
				</xsl:element>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		
		
		
		
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
	
	<xsl:template name="ensureExtras">
		<xsl:param name="extras" />
		
		<xsl:for-each select="$ensure_extras/*">
			<xsl:choose>
			<xsl:when test="$extras[name()=@tag]">
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{@tag}">
					 <covered>N</covered>
					<hasSpecialFeatures>-</hasSpecialFeatures>
					<waitingPeriod>-</waitingPeriod>
					<benefits>-</benefits>
					<benefitLimits>
						<perPerson>-</perPerson>
						<perPolicy>-</perPolicy>
						<combinedLimit />
						<serviceLimit>-</serviceLimit>
						<loyaltyBonus>-</loyaltyBonus>
					</benefitLimits>
				</xsl:element>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
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