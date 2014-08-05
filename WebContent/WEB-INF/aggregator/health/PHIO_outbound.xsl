<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="today" />
	<xsl:param name="providerId">0</xsl:param>


<xsl:template name="ProviderNameToId">
	<xsl:param name="name" />
	<xsl:choose>
		<xsl:when test="$name = 'AHM'">9</xsl:when>
		<xsl:when test="$name = 'AUF'">1</xsl:when>
		<xsl:when test="$name = 'BUP'">15</xsl:when>
		<xsl:when test="$name = 'CBH'">10</xsl:when>
		<xsl:when test="$name = 'CUA'">12</xsl:when>
		<xsl:when test="$name = 'CTM'">14</xsl:when>
		<xsl:when test="$name = 'FRA'">8</xsl:when>
		<xsl:when test="$name = 'GMF'">6</xsl:when>
		<xsl:when test="$name = 'GMH'">5</xsl:when>
		<xsl:when test="$name = 'HCF'">2</xsl:when>
		<xsl:when test="$name = 'HIF'">11</xsl:when>
		<xsl:when test="$name = 'NIB'">3</xsl:when>
		<xsl:when test="$name = 'THF'">13</xsl:when>
		<xsl:when test="$name = 'WFD'">7</xsl:when>
		<xsl:otherwise>0</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- KEYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	
<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/health">
	
<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<xsl:variable name="benefits">
	<xsl:for-each select="//benefitsExtras/*">
		<xsl:text>'</xsl:text>
		<xsl:choose>
			<xsl:when test="name()='HearingAid'">HearingAids</xsl:when>
			<xsl:when test="name()='Naturopath'">Naturopathy</xsl:when>
			<xsl:otherwise><xsl:value-of select="name()" /></xsl:otherwise>
		</xsl:choose>
		
		<xsl:text>'</xsl:text>
		<xsl:if test="position() != last()" >
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:for-each>
</xsl:variable>

		<request>		
<!-- HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
			<header>
				<partnerReference><xsl:value-of select="transactionId" /></partnerReference>
				<clientIpAddress><xsl:value-of select="clientIpAddress" /></clientIpAddress>
				<providerId>
					<xsl:choose>
						<xsl:when test="showAll = 'N' and string-length(application/provider) &gt; 0">
							<xsl:call-template name="ProviderNameToId">
								<xsl:with-param name="name" select="application/provider"/>
							</xsl:call-template>
						</xsl:when>
					<xsl:when test="$providerId != 0">
						<xsl:value-of select="$providerId" />
					</xsl:when>
						<xsl:when test="situation/providerKey != ''">
							<xsl:choose>
								<xsl:when test="situation/providerKey = 'au_74815263'">1</xsl:when>
								<xsl:when test="situation/providerKey = 'hcf_7895123'">2</xsl:when>
								<xsl:when test="situation/providerKey = 'nib_784512'">3</xsl:when>
								<xsl:when test="situation/providerKey = 'gmhba_74851253'">5</xsl:when>
								<xsl:when test="situation/providerKey = 'gmf_46251379'">6</xsl:when>
								<xsl:when test="situation/providerKey = 'frank_7152463'">8</xsl:when>
								<xsl:when test="situation/providerKey = 'ahm_685347'">9</xsl:when>
								<xsl:when test="situation/providerKey = 'cbhs_597125'">10</xsl:when>
								<xsl:when test="situation/providerKey = 'hif_87364556'">11</xsl:when>
								<xsl:when test="situation/providerKey = 'cua_089105165'">12</xsl:when>
								<xsl:when test="situation/providerKey = 'thf_9348212'">13</xsl:when>
								<xsl:when test="situation/providerKey = 'ctm_123456789'">14</xsl:when>
								<xsl:when test="situation/providerKey = 'bup_744568719'">15</xsl:when>
								<xsl:otherwise>-1</xsl:otherwise>							</xsl:choose>
						</xsl:when>
					<xsl:when test="situation/singleProvider != ''">
						<xsl:value-of select="situation/singleProvider" />
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</providerId>
				<brandFilter>
					<xsl:choose>
						<xsl:when test="$providerId = 0 and string-length(filter/providerExclude) &gt; 0 and (not(situation/singleProvider) or situation/singleProvider = '')">
							<xsl:call-template name="tokenizeProviders">
								<xsl:with-param name="providerString" select="filter/providerExclude" />
							</xsl:call-template>

							<xsl:text>0</xsl:text>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</brandFilter>
				<priceMinimum><xsl:value-of select="filter/priceMin" /></priceMinimum>
				<paymentFrequency><xsl:value-of select="filter/frequency" /></paymentFrequency>
				<filter>
					<tierHospital><xsl:value-of select="filter/tierHospital" /></tierHospital>
					<tierExtras><xsl:value-of select="filter/tierExtras" /></tierExtras>
				</filter>
				<!-- Excluding particular status information (call center and online)  -->
				<xsl:choose>
					<xsl:when test='simples'>
						<isSimples>Y</isSimples>
						<excludeStatus>'N','X','O'</excludeStatus>
					</xsl:when>
					<xsl:otherwise>
						<isSimples>N</isSimples>
						<excludeStatus>'N','X','C'</excludeStatus>
					</xsl:otherwise>
				</xsl:choose>
				<productId><xsl:value-of select="application/productId" /></productId>
				<productName><xsl:value-of select="application/productName" /></productName>
				<productTitle><xsl:value-of select="application/productTitle" /></productTitle>
				<showAll><xsl:value-of select="showAll" /></showAll>
				<onResultsPage><xsl:value-of select="onResultsPage" /></onResultsPage>
				<retrieve>
					<xsl:copy-of select="retrieve/*"/>
				</retrieve>
				<priceType>gross</priceType>
			</header>
		
<!-- REQUEST DETAILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
			<details>
				<state>
					<xsl:choose>
						<xsl:when test="situation/state = 'ACT'">NSW</xsl:when>
						<xsl:otherwise><xsl:value-of select="situation/state" /></xsl:otherwise>
					</xsl:choose>
				</state>
				<searchDate>
					<xsl:choose>
						<xsl:when test="string-length(payment/details/start) &gt; 0"><xsl:value-of select="payment/details/start" /></xsl:when>
						<xsl:otherwise><xsl:value-of select="searchDate" /></xsl:otherwise>
					</xsl:choose>
				</searchDate>
				<searchResults><xsl:value-of select="searchResults" /></searchResults>
				<cover><xsl:value-of select="situation/healthCvr" /></cover>
				<situation><xsl:value-of select="situation/healthSitu" /></situation>
				<rebate><xsl:value-of select="rebate" /></rebate>				
				<loading><xsl:value-of select="loading" /></loading>
				<income><xsl:value-of select="healthCover/income" /></income>
				<dependants><xsl:value-of select="healthCover/dependants" /></dependants>
				<preferences><xsl:value-of select="$benefits" /></preferences>
				<prHospital>
					<xsl:choose>
						<xsl:when test="//benefitsExtras/PrHospital = 'Y'">Y</xsl:when>
						<xsl:otherwise>N</xsl:otherwise>
					</xsl:choose>
				</prHospital>
				<puHospital>
					<xsl:choose>
						<xsl:when test="//benefitsExtras/PuHospital = 'Y'">Y</xsl:when>
						<xsl:otherwise>N</xsl:otherwise>
					</xsl:choose>
				</puHospital>				
				<excess><xsl:value-of select="excess" /></excess>
				
				<xsl:variable name="hBenefitsList">Hospital,PrHospital PuHospital Cardiac Obstetric AssistedReproductive CataractEyeLens JointReplacementAll PlasticNonCosmetic Podiatric Sterilisation GastricBanding RenalDialysis Palliative Psychiatric Rehabilitation Ambulance</xsl:variable>
				<xsl:variable name="hBenefits">
					<xsl:for-each select="benefits/benefitsExtras/*">
						<xsl:if test="contains($hBenefitsList,name())">#</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<hBenefits><xsl:value-of select="$hBenefits" /></hBenefits>
				
				<xsl:variable name="eBenefitsList">GeneralHealth,DentalGeneral DentalMajor Endodontic Orthodontic Optical Physiotherapy Chiropractic Podiatry Acupuncture Naturopath Massage Psychology GlucoseMonitor HearingAid NonPBS Orthotics SpeechTherapy OccupationalTherapy Dietetics EyeTherapy LifestyleProducts</xsl:variable>
				<xsl:variable name="eBenefits">
					<xsl:for-each select="benefits/benefitsExtras/*">
						<xsl:if test="contains($eBenefitsList,name())">#</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<eBenefits><xsl:value-of select="$eBenefits" /></eBenefits>
				
				<productType>
					<xsl:choose>
						<!-- Hospital and extras benefits selected -->
						<xsl:when test="$hBenefits != '' and $eBenefits != ''">Combined</xsl:when>
						<!-- Extras benefits only -->
						<xsl:when test="$eBenefits != ''">GeneralHealth</xsl:when>
						<!-- Hospital benefits only -->
						<xsl:when test="$hBenefits != ''">Hospital</xsl:when>
						<!-- Base default -->
						<xsl:otherwise>Combined</xsl:otherwise>
					</xsl:choose>
				</productType>
				<accountType><xsl:value-of select="payment/details/type" /></accountType>
				
			</details>
			
		</request>
				
	</xsl:template>


	<xsl:template name="tokenizeProviders">
		<xsl:param name="providerString" />
		<xsl:param name="delimiter" select="','" />

		<xsl:variable name="first-item" select="normalize-space(substring-before( concat( $providerString, $delimiter), $delimiter))" />
		<xsl:if test="$first-item">
			<!-- Convert the provider code into the provider ID -->
			<xsl:call-template name="ProviderNameToId"><xsl:with-param name="name" select="$first-item"/></xsl:call-template>
			<xsl:value-of select="$delimiter" />

			<xsl:call-template name="tokenizeProviders">
				<xsl:with-param name="providerString" select="substring-after($providerString,',')" />
				<xsl:with-param name="delimiter" select="$delimiter" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>