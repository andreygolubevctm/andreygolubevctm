<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
							xmlns:health="http://admin.privatehealth.gov.au/ws/Schemas">
<xsl:output omit-xml-declaration="yes" indent="no"></xsl:output>
<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:include href="./product_properties_sql.xsl"/>
	
<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="productId" />
	<xsl:param name="providerId" />
	<xsl:param name="schema">ctm</xsl:param>

	<xsl:template match="health:Code" />
	<xsl:template match="health:Message" />

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="health:Product">
		<xsl:call-template name="start-write-prop" />		
		<!-- Iterate through the attributes of the Product -->
		<xsl:for-each select="@*">
			<xsl:choose>
				<xsl:when test="contains(name(),'Date')">
					<xsl:call-template name="write-prop">
						<xsl:with-param name="name" select="name()" />
						<xsl:with-param name="txt" select="." />
						<xsl:with-param name="dat" select="." />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="write-prop">
						<xsl:with-param name="name" select="name()" />
						<xsl:with-param name="txt" select="." />
					</xsl:call-template>				
				</xsl:otherwise>
			</xsl:choose>	
		</xsl:for-each>	
	
	
		<!-- Iterate through the child nodes of the Product -->
		<xsl:for-each select="*">

	
			<xsl:choose>
			
			<!-- PREMIUM AMOUNTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
				<xsl:when test="contains(name(),'Premium')">
					<xsl:call-template name="write-prop">
						<xsl:with-param name="name" select="name()" />
						<xsl:with-param name="txt">$<xsl:value-of select="." /></xsl:with-param>
						<xsl:with-param name="amt" select="." />
					</xsl:call-template>
				</xsl:when>

			<!-- DATES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
				<xsl:when test="contains(name(),'Date')">
					<xsl:call-template name="write-prop">
						<xsl:with-param name="name" select="name()" />
						<xsl:with-param name="txt" select="." />
						<xsl:with-param name="dat" select="." />
					</xsl:call-template>
				</xsl:when>

				<xsl:when test="name() = 'HospitalCover'">
					<xsl:for-each select=".//*[name()='MedicalService']">
							<xsl:variable name="title">
								<xsl:choose>
									<xsl:when test="starts-with(./@Title,'JointReplacement')">JointReplacement</xsl:when>
									<xsl:otherwise><xsl:value-of select="./@Title" /></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							
							<xsl:variable name="txtValue">
								<xsl:choose>
									<xsl:when test="./@Cover = 'Covered'">Y</xsl:when>
									<xsl:when test="./@Cover = 'Restricted'">Y</xsl:when>
									<xsl:when test="./@Cover = 'BLP'">Y</xsl:when>
									<xsl:otherwise>N</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							
							<xsl:variable name="amtValue">
								<xsl:choose>
									<xsl:when test="./@Cover = 'Covered'">1</xsl:when>
									<xsl:when test="./@Cover = 'Restricted'">0.5</xsl:when>
									<xsl:when test="./@Cover = 'BLP'">0.5</xsl:when>
									<xsl:otherwise>0</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:call-template name="write-prop">
								<xsl:with-param name="name"><xsl:value-of select="$title" /></xsl:with-param>
								<xsl:with-param name="txt"><xsl:value-of select="$txtValue" /></xsl:with-param>
								<xsl:with-param name="amt"><xsl:value-of select="$amtValue" /></xsl:with-param>
							</xsl:call-template>
					</xsl:for-each>
	
					<xsl:for-each select=".//*[name()='Accommodation']">
						<xsl:variable name="accommodation"><xsl:value-of select="." /></xsl:variable>
							
						<xsl:variable name="private"><xsl:choose>
							<xsl:when test="$accommodation = 'PrivateOrPublic'">Y</xsl:when>
							<xsl:when test="$accommodation = 'Public'">N</xsl:when>
							<xsl:when test="$accommodation = 'PrivateSharedPublic'">Y</xsl:when>
							<xsl:when test="$accommodation = 'PrivateSharedPublicShared'">Y</xsl:when>
							<xsl:when test="$accommodation = 'PublicShared'">N</xsl:when>													
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose></xsl:variable>

						<xsl:variable name="public"><xsl:choose>
							<xsl:when test="$accommodation = 'PrivateOrPublic'">Y</xsl:when>
							<xsl:when test="$accommodation = 'Public'">Y</xsl:when>
							<xsl:when test="$accommodation = 'PrivateSharedPublic'">Y</xsl:when>
							<xsl:when test="$accommodation = 'PrivateSharedPublicShared'">Y</xsl:when>
							<xsl:when test="$accommodation = 'PublicShared'">Y</xsl:when>							
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose></xsl:variable>

						<xsl:call-template name="write-prop">
							<xsl:with-param name="name">PrivateHospital</xsl:with-param>
							<xsl:with-param name="txt"><xsl:value-of select="$private"/></xsl:with-param>
							<xsl:with-param name="amt"><xsl:choose><xsl:when test="$private= 'Y'">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:with-param>
						</xsl:call-template>

						<xsl:call-template name="write-prop">
							<xsl:with-param name="name">PublicHospital</xsl:with-param>
							<xsl:with-param name="txt"><xsl:value-of select="$public"/></xsl:with-param>
							<xsl:with-param name="amt"><xsl:choose><xsl:when test="$public= 'Y'">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>


					<xsl:for-each select=".//*[name()='HospitalAmbulance']">
						<xsl:variable name="ambulance"><xsl:value-of select="." /></xsl:variable>
							
						<xsl:variable name="ambulanceCover">
							<xsl:choose>
								<xsl:when test="$ambulance = 'Full'">Y</xsl:when>
								<xsl:when test="$ambulance = 'StateGovt'">Y</xsl:when>
								<xsl:otherwise>N</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<xsl:call-template name="write-prop">
							<xsl:with-param name="name">Ambulance</xsl:with-param>
							<xsl:with-param name="txt"><xsl:value-of select="$ambulanceCover"/></xsl:with-param>
							<xsl:with-param name="amt"><xsl:choose><xsl:when test="$ambulanceCover= 'Y'">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					
					<xsl:variable name="excessAmount">
						<xsl:for-each select="health:Excesses">
							<xsl:variable name="excessPerPerson"><xsl:value-of select="health:ExcessPerPerson" /></xsl:variable>
							<xsl:variable name="excessPerAdmission"><xsl:value-of select="health:ExcessPerAdmission" /></xsl:variable>
						
							<xsl:choose>
								<xsl:when test="@ExcessType = 'PerAdmissionOnly'"><xsl:value-of select="health:ExcessPerAdmission" /></xsl:when>
								<xsl:when test="@ExcessType = 'LimitedPerYear' and $excessPerAdmission = 0"><xsl:value-of select="h:ExcessPerPolicy" /></xsl:when>
								<xsl:when test="@ExcessType = 'LimitedPerYear'"><xsl:value-of select="health:ExcessPerAdmission" /></xsl:when>
								<xsl:when test="@ExcessType = 'LimitedPerPerson'"><xsl:value-of select="health:ExcessPerPerson" /></xsl:when>
								<xsl:when test="@ExcessType = 'LimitedPerPersonPerPolicy'"><xsl:value-of select="health:ExcessPerPerson" /></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>		
						</xsl:for-each>
					</xsl:variable>
					<xsl:call-template name="write-prop">
						<xsl:with-param name="name">excessAmount</xsl:with-param>
						<xsl:with-param name="txt">$<xsl:value-of select="$excessAmount"/></xsl:with-param>
						<xsl:with-param name="amt"><xsl:value-of select="$excessAmount"/></xsl:with-param>
					</xsl:call-template>					
				</xsl:when>
				
				<xsl:when test="name() = 'GeneralHealthCover'">
					<xsl:for-each select=".//*[name()='GeneralHealthService']">
							<xsl:variable name="title"><xsl:value-of select="./@Covered" /></xsl:variable>
							<xsl:call-template name="write-prop">
								<xsl:with-param name="name"><xsl:value-of select="./@*" /></xsl:with-param>
								<xsl:with-param name="txt"><xsl:choose><xsl:when test="$title = '1'">Y</xsl:when><xsl:otherwise>N</xsl:otherwise></xsl:choose></xsl:with-param>
								<xsl:with-param name="amt"><xsl:value-of select="$title" /></xsl:with-param>
							</xsl:call-template>
					</xsl:for-each>
				</xsl:when>

			<!-- ALL OTHERS - TREAT AS TEXT NODE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->				
				<xsl:otherwise>
					<xsl:call-template name="write-prop">
						<xsl:with-param name="name" select="name()" />
						<xsl:with-param name="txt" select="." />
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

		<xsl:if test="not(//*[name() = 'HospitalCover'])">
			<xsl:call-template name="write-prop">
				<xsl:with-param name="name">excessAmount</xsl:with-param>
				<xsl:with-param name="txt">No Excess</xsl:with-param>
				<xsl:with-param name="amt">0</xsl:with-param>
			</xsl:call-template>			
		</xsl:if>
	</xsl:template>
		
				
</xsl:stylesheet>