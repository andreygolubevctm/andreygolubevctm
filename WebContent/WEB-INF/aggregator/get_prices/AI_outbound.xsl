<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS -->
	<xsl:import href="../includes/utils.xsl"/>
	
	<xsl:param name="today" />
	
<!-- MAIN TEMPLATE -->	
	<xsl:template match="/quote">
	
		<!-- LOCAL VARIABLES -->
		<xsl:variable name="regularDob">
			<xsl:call-template name="util_formatEurDate">
				<xsl:with-param name="eurDate" select="drivers/regular/dob" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="youngDob">
			<xsl:call-template name="util_formatEurDate">
				<xsl:with-param name="eurDate" select="drivers/young/dob" />
			</xsl:call-template>
		</xsl:variable>
				
		<xsl:variable name="excess">
			<xsl:choose>
				<xsl:when test="excess &gt;= 800">1200</xsl:when>
				<xsl:otherwise>600</xsl:otherwise>
			</xsl:choose>		
		</xsl:variable>
		
		
		<!-- Regular driver - Licence Year -->
		<xsl:variable name="rgdLicenceYear">
			<xsl:variable name="dobYr" select="substring($regularDob,7,4)" />
			<xsl:variable name="licAge" select='drivers/regular/licenceAge' />
			<xsl:value-of select="$dobYr + $licAge"/>
		</xsl:variable>
		
		<!-- Youngest driver - Licence Year -->
		<xsl:variable name="yngLicenceYear">
			<xsl:variable name="dobYr" select="substring($youngDob,7,4)" />
			<xsl:variable name="licAge" select='drivers/young/licenceAge' />
			<xsl:value-of select="$dobYr + $licAge"/>
		</xsl:variable>
		
		<xsl:variable name="yngDobISO">
			<xsl:call-template name="util_isoDate">
				<xsl:with-param name="eurDate" select="$youngDob" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="rgdDobISO">
			<xsl:call-template name="util_isoDate">
				<xsl:with-param name="eurDate" select="$regularDob" />
			</xsl:call-template>
		</xsl:variable>
		
		<!-- Determine which driver we're going to rate on -->
		<xsl:variable name="rateDriver">
			<xsl:choose>
				<xsl:when test="drivers/young/exists='Y' and $yngLicenceYear &gt; $rgdLicenceYear">YOUNG</xsl:when>
				<xsl:when test="drivers/young/exists='Y' and $yngLicenceYear = $rgdLicenceYear">
					<!-- If the youngest driver got their licence in the same year as the rgd - determine by dob -->
					<xsl:choose>
						<xsl:when test="translate($yngDobISO, '-', '') &gt; translate($rgdDobISO, '-', '')">YOUNG</xsl:when>
						<xsl:otherwise>REGULAR</xsl:otherwise> 
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>REGULAR</xsl:otherwise> 
			</xsl:choose>
		</xsl:variable>
		
		<!-- Licence Year -->
		<xsl:variable name="licenceYear">
			<xsl:choose>
			<xsl:when test="$rateDriver = 'YOUNG'">
				<xsl:value-of select="$yngLicenceYear" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$rgdLicenceYear" />			
			</xsl:otherwise>
			</xsl:choose>			
		</xsl:variable>

		<!-- Claims/Losses in the last 5 years -->
		<xsl:variable name="claimsLosses">
			<xsl:choose>
				<xsl:when test="drivers/regular/claims = 'Y'">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<!-- Client dob -->
		<xsl:variable name="clnDob">
			<xsl:choose>
			<xsl:when test="$rateDriver = 'YOUNG'">
				<xsl:value-of select="$youngDob" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$regularDob" />			
			</xsl:otherwise>
			</xsl:choose>					
		</xsl:variable>
		
		<!-- Client gender -->
		<xsl:variable name="clnGender">
			<xsl:choose>
			<xsl:when test="$rateDriver = 'YOUNG'">
				<xsl:value-of select="drivers/young/gender" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="drivers/regular/gender" />			
			</xsl:otherwise>
			</xsl:choose>					
		</xsl:variable>
	
		<soap:Envelope soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"
			xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<soap:Header />
			<soap:Body>
				<GetSpecifiedVehiclePremium xmlns="http://www.softsure.co.za/"> 
      				<XMLInput><xsl:text disable-output-escaping="yes">&lt;![CDATA[</xsl:text>
						<quotes>
							<quote>
								<ClnDOB>
									<xsl:call-template name="util_reversedDate">
										<xsl:with-param name="eurDate" select="$clnDob" />
									</xsl:call-template>
								</ClnDOB>
								<ClnLicence><xsl:value-of select="$licenceYear" />/01/01</ClnLicence>
								<ClnPostalCode><xsl:value-of select="riskAddress/postCode" /></ClnPostalCode>
								<ClnSuburb><xsl:value-of select="translate(riskAddress/suburbName, LOWERCASE, UPPERCASE)" /></ClnSuburb>
								<ClnGender>
									<xsl:choose>	
										<xsl:when test="$clnGender = 'M'">MALE</xsl:when>
										<xsl:otherwise>FEMALE</xsl:otherwise>
									</xsl:choose>
								</ClnGender>
								<ClnNoInsurance>
									<xsl:choose>
										<xsl:when test="drivers/regular/ncd = '0'">True</xsl:when>
										<xsl:otherwise>False</xsl:otherwise>
									</xsl:choose>
								</ClnNoInsurance>
								<ClnLosses1Yr><xsl:value-of select="$claimsLosses" /></ClnLosses1Yr>
								<ClnLosses5Yr><xsl:value-of select="$claimsLosses" /></ClnLosses5Yr>								
								<ClnNoLoss3Yrs>True</ClnNoLoss3Yrs>
								<ClnNoLoss5Yrs>
									<xsl:choose>
										<xsl:when test="drivers/regular/claims = 'Y'">False</xsl:when>
										<xsl:otherwise>True</xsl:otherwise>
									</xsl:choose>
								</ClnNoLoss5Yrs>
								
								<ClnNomDrivers>
									<xsl:choose>
										<xsl:when test="drivers/young/exists = 'Y'">1</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</ClnNomDrivers>
								<ClnEndorcedLicence>False</ClnEndorcedLicence>
								<ClnEndorcementNumber>0</ClnEndorcementNumber>
								<ClnAgeExclusion>
									<xsl:choose>
										<xsl:when test="options/driverOption='3'">None</xsl:when><!-- No - I want anybody to be able to drive the car -->
										<xsl:when test="options/driverOption='H'">Under 20</xsl:when><!-- Yes - I am happy for all drivers to be 21 and over -->
										<xsl:when test="options/driverOption='7'">Under 25</xsl:when><!-- Yes - I am happy for all drivers to be 25 and over -->
										<xsl:when test="options/driverOption='A'">Under 30</xsl:when><!-- Yes - I am happy for all drivers to be 30 and over -->
										<xsl:when test="options/driverOption='D'">Under 35</xsl:when><!-- Yes - I am happy for all drivers to be 40 and over -->
									</xsl:choose>
								</ClnAgeExclusion>
								<ClnLicenseType>FULL</ClnLicenseType>
								<VechColor>Other</VechColor>
								<VechKey><xsl:value-of select="vehicle/redbookCode" /></VechKey>
								<VechUse>
									<xsl:choose>
										<xsl:when test="vehicle/use='02'">PRIVATE</xsl:when> <!-- Private/Commuting -->
										<xsl:when test="vehicle/use='11'">PRIVATE</xsl:when> <!-- Private/Occ Business -->
										<xsl:when test="vehicle/use='12'">BUSINESS</xsl:when> <!-- Private & Business -->
										<xsl:when test="vehicle/use='13'">GOODS</xsl:when> <!-- Carrying goods -->
									</xsl:choose>
								</VechUse>
								<VechValue><xsl:value-of select="vehicle/marketValue"/></VechValue>
								<VechYear><xsl:value-of select="vehicle/year"/></VechYear>
								<VechAccessories>
									<xsl:choose>
										<xsl:when test="vehicle/accessories = 'N'">0</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="count(accs/*)" />
										</xsl:otherwise>
									</xsl:choose>
								</VechAccessories>
								<VechAlarm>
									<xsl:choose>
										<xsl:when test="vehicle/securityOption='A'">True</xsl:when><!-- alarm -->
										<xsl:when test="vehicle/securityOption='B'">True</xsl:when><!-- both -->
										<xsl:otherwise>False</xsl:otherwise>
									</xsl:choose>
								</VechAlarm>
								<VechImported>False</VechImported>
								<VechParked>
									<xsl:choose>
										<xsl:when test="vehicle/parking=1">Garaged</xsl:when> <!-- Garaged -->
										<xsl:when test="vehicle/parking=2">On the street</xsl:when> <!-- Street -->
										<xsl:when test="vehicle/parking=3">Driveway</xsl:when> <!-- Driveway -->
										<xsl:when test="vehicle/parking=4">Driveway</xsl:when> <!-- Private Property -->
										<xsl:when test="vehicle/parking=5">Unsecured Carpark</xsl:when> <!-- Car Park -->
										<xsl:when test="vehicle/parking=6">Unsecured Carpark</xsl:when> <!-- Parking Lot -->
										<xsl:when test="vehicle/parking=7">Secured Carpark</xsl:when> <!-- Locked Compound -->
										<xsl:when test="vehicle/parking=8">Carport</xsl:when> <!-- Carport -->									
									</xsl:choose>
								</VechParked>
								<VechDamage></VechDamage>
								<PrdName>CLASSIC</PrdName>
								<PrdExcess><xsl:value-of select="$excess" /></PrdExcess>
								<VersionNumber />
							</quote>
						</quotes>      				
      				<xsl:text disable-output-escaping="yes">]]&gt;</xsl:text></XMLInput>
					<Username>AUTOANDGEN</Username>
					<Password>Aut0andG3n</Password>
				</GetSpecifiedVehiclePremium>
			</soap:Body>
		</soap:Envelope>
	</xsl:template>
</xsl:stylesheet>