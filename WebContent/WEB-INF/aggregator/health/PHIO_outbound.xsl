<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- xsl:import href="../includes/utils.xsl"/ -->
	
<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="today" />
	<xsl:param name="providerId">0</xsl:param>

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
					<xsl:when test="$providerId != 0">
						<xsl:value-of select="$providerId" />
					</xsl:when>
					<xsl:when test="situation/singleProvider != ''">
						<xsl:value-of select="situation/singleProvider" />
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</providerId>
				<productId><xsl:value-of select="application/productId" /></productId>
				<showAll><xsl:value-of select="showAll" /></showAll>
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
				<cover><xsl:value-of select="situation/healthCvr" /></cover>
				<situation><xsl:value-of select="situation/healthSitu" /></situation>
				<rebate><xsl:value-of select="rebate" /></rebate>				
				<loading><xsl:value-of select="loading" /></loading>
				<income><xsl:value-of select="healthCover/income" /></income>
				<dependants><xsl:value-of select="healthCover/dependants" /></dependants>
				<preferences><xsl:value-of select="$benefits" /></preferences>
				<prHospital>
					<xsl:choose>
						<xsl:when test="not(//benefitsExtras/PrHospital) or //benefitsExtras/PrHospital != 'Y'">N</xsl:when>
						<xsl:otherwise>Y</xsl:otherwise>
					</xsl:choose>
				</prHospital>
				<puHospital>
					<xsl:choose>
						<xsl:when test="not(//benefitsExtras/PuHospital) or //benefitsExtras/PuHospital != 'Y'">N</xsl:when>
						<xsl:otherwise>Y</xsl:otherwise>
					</xsl:choose>
				</puHospital>				
				<excess><xsl:value-of select="excess" /></excess>
				
				<xsl:variable name="hBenefitsList">PrHospital PuHospital Cardiac Obstetric AssistedReproductive CataractEyeLens JointReplacementAll PlasticNonCosmetic Podiatric Sterilisation GastricBanding RenalDialysis Palliative Psychiatric Rehabilitation Ambulance</xsl:variable>
				<xsl:variable name="hBenefits">
					<xsl:for-each select="benefits/benefitsExtras/*">
						<xsl:if test="contains($hBenefitsList,name())">#</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<hBenefits><xsl:value-of select="$hBenefits" /></hBenefits>
				
				<xsl:variable name="eBenefitsList">DentalGeneral DentalMajor Endodontic Orthodontic Optical Physiotherapy Chiropractic Podiatry Acupuncture Naturopath Massage Psychology GlucoseMonitor HearingAid NonPBS Orthotics SpeechTherapy OccupationalTherapy Dietetics EyeTherapy LifestyleProducts</xsl:variable>
				<xsl:variable name="eBenefits">
					<xsl:for-each select="benefits/benefitsExtras/*">
						<xsl:if test="contains($eBenefitsList,name())">#</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<eBenefits><xsl:value-of select="$eBenefits" /></eBenefits>
				
				<productType>
					<xsl:choose>
						<xsl:when test="$hBenefits != '' and $eBenefits != ''">Combined</xsl:when>
						<xsl:when test="$eBenefits != ''">GeneralHealth</xsl:when>
						<xsl:otherwise>Hospital</xsl:otherwise>
					</xsl:choose>
				</productType>
				
				<paymentFrequency><xsl:value-of select="payment/details/frequency" /></paymentFrequency>
				<accountType><xsl:value-of select="payment/details/type" /></accountType>
				
			</details>
			
		</request>
				
	</xsl:template>
</xsl:stylesheet>