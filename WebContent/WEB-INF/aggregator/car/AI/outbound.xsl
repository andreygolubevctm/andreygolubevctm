<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS -->
	<xsl:import href="../../includes/utils.xsl"/>
	<xsl:import href="../../includes/get_street_name.xsl"/>

	<xsl:param name="quoteType" />
	<xsl:param name="subPartnerCode" />
	<xsl:param name="agentCode" />
	<xsl:param name="productQuoted" />
	<xsl:param name="today" />

<!-- MAIN TEMPLATE -->
	<xsl:template match="/quote">

<!-- VARIABLES -->
		<xsl:variable name="rgdBirthDate">
			<xsl:call-template name="util_isoDate">
				<xsl:with-param name="eurDate" select="drivers/regular/dob" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="yngBirthDate">
			<xsl:call-template name="util_isoDate">
				<xsl:with-param name="eurDate" select="drivers/young/dob" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="rgdLicenceYear">
			<xsl:variable name="dobYr" select="substring($rgdBirthDate,1,4)" />
			<xsl:variable name="licAge" select='drivers/regular/licenceAge' />
			<xsl:value-of select="$dobYr + $licAge"/>
		</xsl:variable>

		<!-- Youngest driver - Licence Year -->
		<xsl:variable name="yngLicenceYear">
			<xsl:variable name="dobYr" select="substring($yngBirthDate,1,4)" />
			<xsl:variable name="licAge" select='drivers/young/licenceAge' />
			<xsl:value-of select="$dobYr + $licAge"/>
		</xsl:variable>

		<xsl:variable name="addressLine1">
			<xsl:call-template name="get_street_name">
				<xsl:with-param name="address" select="riskAddress" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="mobileTel">
			<xsl:if test="substring(contact/phone,1,2) = '04'">
				<xsl:value-of select="contact/phone" />
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="homeTel">
			<xsl:if test="substring(contact/phone,1,2) != '04'">
				<xsl:value-of select="contact/phone" />
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="baseExcessToTest">
			<xsl:choose>
				<xsl:when test="excess != ''">
					<xsl:value-of select="excess" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="baseExcess" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="excess">
			<xsl:choose>
				<xsl:when test="$baseExcessToTest &gt;= 1200">1200</xsl:when>
				<xsl:when test="$baseExcessToTest &gt;= 800">800</xsl:when>
				<xsl:when test="$baseExcessToTest &gt;= 600">600</xsl:when>
				<!-- AI has not default response so need to send valid excess as
					last resort to avoid service errors being returned. Front-end
					with knock out the quote if excess invalid.-->
				<xsl:otherwise><xsl:value-of select="baseExcess" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="isFinanced">
			<xsl:choose>
				<xsl:when test="vehicle/finance != 'NO'">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="isFinancedKey">
			<xsl:choose>
				<xsl:when test="$isFinanced = 'false'">1</xsl:when>
				<xsl:otherwise>349</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<soap:Envelope soap:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"
			xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<soap:Header />
			<soap:Body>
				<GetMultiPremium xmlns="http://www.softsure.co.za/">
					<QuoteDetails>
						<RequestType>NewQuote</RequestType>
						<PartnerCode>AUTOANDGEN</PartnerCode>
						<SubPartnerCode><xsl:value-of select="$subPartnerCode" /></SubPartnerCode>
						<AgentCode><xsl:value-of select="$agentCode" /></AgentCode>
						<AgentRefNo><xsl:value-of select="transactionId" /></AgentRefNo>
						<Comments></Comments>
						<PremiumQuoted>0</PremiumQuoted>
						<ExcessQuoted><xsl:value-of select="$excess" /></ExcessQuoted>
						<ProductQuoted><xsl:value-of select="$productQuoted" /></ProductQuoted>
						<CampaignID>1</CampaignID>
						<QuoteAccepted>true</QuoteAccepted>
						<InsuredDetail>
							<CustType>PrivateIndividual</CustType>
							<Surname>
							<xsl:choose>
								<xsl:when test="string-length(drivers/regular/surname) &gt; 0"><xsl:value-of select="drivers/regular/surname" /></xsl:when>
								<xsl:otherwise>TBA</xsl:otherwise>
							</xsl:choose>
							</Surname>
							<FirstName>
							<xsl:choose>
								<xsl:when test="string-length(drivers/regular/firstname) &gt; 0"><xsl:value-of select="drivers/regular/firstname" /></xsl:when>
								<xsl:otherwise>TBA</xsl:otherwise>
							</xsl:choose>
							</FirstName>
							<Gender>
							<xsl:choose>
								<xsl:when test="drivers/regular/gender = 'M'">Male</xsl:when>
								<xsl:otherwise>Female</xsl:otherwise>
							</xsl:choose>
							</Gender>
							<MaritalStatus>Unknown</MaritalStatus>
							<Title>
							<xsl:choose>
								<xsl:when test="drivers/regular/gender = 'M'">title_MR</xsl:when>
								<xsl:otherwise>title_MRS</xsl:otherwise>
							</xsl:choose>
							</Title>
							<Birthdate><xsl:value-of select="$rgdBirthDate" />T00:00:00</Birthdate>
							<MobileNo><xsl:value-of select="$mobileTel" /></MobileNo>
							<HomeTel><xsl:value-of select="$homeTel" /></HomeTel>
							<WorkTel />
							<EmailAddress><xsl:value-of select="contact/email" /></EmailAddress>
							<AddressLine1><xsl:value-of select="translate($addressLine1, $LOWERCASE, $UPPERCASE)"/></AddressLine1>
							<Suburb><xsl:value-of select="translate(riskAddress/suburbName, $LOWERCASE, $UPPERCASE)" /></Suburb>
							<State><xsl:value-of select="translate(riskAddress/state, $LOWERCASE, $UPPERCASE)" /></State>
							<Postcode><xsl:value-of select="riskAddress/postCode" /></Postcode>
							<Claims60Months>
								<xsl:choose>
									<xsl:when test="drivers/regular/claims = 'Y'">1</xsl:when>
									<xsl:otherwise>0</xsl:otherwise>
								</xsl:choose>
							</Claims60Months>
							<Claimed36Months>false</Claimed36Months>
							<LicenseYear><xsl:value-of select="$rgdLicenceYear"/></LicenseYear>
							<LicenseCancelled>false</LicenseCancelled>
							<LicenseSuspensions>0</LicenseSuspensions>
							<LicenseCode>Full_License</LicenseCode>
							<TrafficOffenses>false</TrafficOffenses>
							<Convictions>false</Convictions>
							<Judgements>false</Judgements>
							<Bankcruptcy>false</Bankcruptcy>
							<Rehabilitated>false</Rehabilitated>
							<Fraud>false</Fraud>
							<DUI>false</DUI>
							<OptOutMarketing>false</OptOutMarketing>
							<Consent1>false</Consent1>
						</InsuredDetail>
						<CarDetail>
							<Cover>Comprehensive</Cover>
							<Parking>
								<xsl:choose>
									<xsl:when test="vehicle/parking=1">Garaged</xsl:when> <!-- Garaged -->
									<xsl:when test="vehicle/parking=2">Pavement_Street</xsl:when> <!-- Street -->
									<xsl:when test="vehicle/parking=3">Driveway</xsl:when> <!-- Driveway -->
									<xsl:when test="vehicle/parking=4">Driveway</xsl:when> <!-- Private Property -->
									<xsl:when test="vehicle/parking=5">Unsecured_Carpark</xsl:when> <!-- Car Park -->
									<xsl:when test="vehicle/parking=6">Unsecured_Carpark</xsl:when> <!-- Parking Lot -->
									<xsl:when test="vehicle/parking=7">Secured_Carpark</xsl:when> <!-- Locked Compound -->
									<xsl:when test="vehicle/parking=8">Carport</xsl:when> <!-- Carport -->
								</xsl:choose>
							</Parking>
							<VehicleUse>
								<xsl:choose>
									<xsl:when test="vehicle/use='02'">PrivateUse</xsl:when> <!-- Private/Commuting -->
									<xsl:when test="vehicle/use='11'">PrivateUse</xsl:when> <!-- Private/Occ Business -->
									<xsl:when test="vehicle/use='12'">BusinessUse</xsl:when> <!-- Private & Business -->
									<xsl:when test="vehicle/use='13'">GOODS</xsl:when> <!-- Carrying goods -->
								</xsl:choose>
							</VehicleUse>
							<VehicleColour>Unknown</VehicleColour>
							<NCB>Maximum</NCB>
							<AgeExclusions>
								<xsl:choose>
									<xsl:when test="options/driverOption=''">Exclude_None</xsl:when><!-- Default if the person is under 18 (field hidden) -->
									<xsl:when test="options/driverOption='3'">Exclude_None</xsl:when><!-- No - I want anybody to be able to drive the car -->
									<xsl:when test="options/driverOption='H'">Exclude_20</xsl:when><!-- Yes - I am happy for all drivers to be 21 and over -->
									<xsl:when test="options/driverOption='7'">Exclude_25</xsl:when><!-- Yes - I am happy for all drivers to be 25 and over -->
									<xsl:when test="options/driverOption='A'">Exclude_30</xsl:when><!-- Yes - I am happy for all drivers to be 30 and over -->
									<xsl:when test="options/driverOption='D'">Exclude_35</xsl:when><!-- Yes - I am happy for all drivers to be 40 and over -->
								</xsl:choose>
							</AgeExclusions>
							<Make><xsl:value-of select="ai/Vehicle/Make"/></Make>
							<Model><xsl:value-of select="ai/Vehicle/Model"/></Model>
							<Series><xsl:value-of select="ai/Vehicle/Series"/></Series>
							<VehicleCode><xsl:value-of select="vehicle/redbookCode" /></VehicleCode>
							<VehicleYear><xsl:value-of select="vehicle/year" /></VehicleYear>
							<RegNo />
							<VINNo />
							<TrackingDevice>false</TrackingDevice>
							<GearlockDevice>false</GearlockDevice>
							<Microdots>false</Microdots>
							<Alarm>
								<xsl:choose>
									<xsl:when test="vehicle/securityOption = 'A'">true</xsl:when>
									<xsl:when test="vehicle/securityOption = 'B'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
							</Alarm>
							<Immobiliser>
								<xsl:choose>
									<xsl:when test="vehicle/securityOption = 'I'">true</xsl:when>
									<xsl:when test="vehicle/securityOption = 'B'">true</xsl:when>
									<xsl:otherwise>false</xsl:otherwise>
								</xsl:choose>
							</Immobiliser>
							<CurrentlyInsured>
								<xsl:choose>
									<xsl:when test="drivers/regular/ncd = '0'">false</xsl:when>
									<xsl:otherwise>true</xsl:otherwise>
								</xsl:choose>
							</CurrentlyInsured>
							<TrafficOffenses>false</TrafficOffenses>
							<RiskSuburb><xsl:value-of select="translate(riskAddress/suburbName, $LOWERCASE, $UPPERCASE)" /></RiskSuburb>
							<RiskState><xsl:value-of select="translate(riskAddress/state, $LOWERCASE, $UPPERCASE)" /></RiskState>
							<RiskPostcode><xsl:value-of select="riskAddress/postCode" /></RiskPostcode>
							<CarValue><xsl:value-of select="vehicle/marketValue"/></CarValue>
							<IsFinanced><xsl:value-of select="$isFinanced"/></IsFinanced>
							<FinCompKey><xsl:value-of select="$isFinancedKey"/></FinCompKey>
							<MainDriver>
								<Surname>
								<xsl:choose>
									<xsl:when test="string-length(drivers/regular/surname) &gt; 0"><xsl:value-of select="drivers/regular/surname" /></xsl:when>
									<xsl:otherwise>TBA</xsl:otherwise>
								</xsl:choose>
								</Surname>
								<FirstName>
								<xsl:choose>
									<xsl:when test="string-length(drivers/regular/firstname) &gt; 0"><xsl:value-of select="drivers/regular/firstname" /></xsl:when>
									<xsl:otherwise>TBA</xsl:otherwise>
								</xsl:choose>
								</FirstName>
								<Gender>
								<xsl:choose>
									<xsl:when test="drivers/regular/gender = 'M'">Male</xsl:when>
									<xsl:otherwise>Female</xsl:otherwise>
								</xsl:choose>
								</Gender>
								<MaritalStatus>Unknown</MaritalStatus>
								<Relation>Insured</Relation>
								<LicenseCode>Full_License</LicenseCode>
								<Birthdate><xsl:value-of select="$rgdBirthDate" />T00:00:00</Birthdate>
								<Claims60Months>
									<xsl:choose>
										<xsl:when test="drivers/regular/claims = 'Y'">1</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</Claims60Months>
								<Claimed36Months>false</Claimed36Months>
								<LicenseYear><xsl:value-of select="$rgdLicenceYear"/></LicenseYear>
								<TrafficOffenses>false</TrafficOffenses>
								<LicenseCancelled>false</LicenseCancelled>
								<LicenseSuspensions>0</LicenseSuspensions>
								<Convictions>false</Convictions>
								<Judgements>false</Judgements>
								<Bankcruptcy>false</Bankcruptcy>
								<Rehabilitated>false</Rehabilitated>
								<Fraud>false</Fraud>
								<DUI>false</DUI>
							</MainDriver>
							<xsl:if test="drivers/young/exists = 'Y'">
							<NominatedDrivers>
								<SSDriver70>
									<Gender>
										<xsl:choose>
											<xsl:when test="drivers/young/gender = 'M'">Male</xsl:when>
											<xsl:otherwise>Female</xsl:otherwise>
										</xsl:choose>
									</Gender>
									<LicenseCode>Full_License</LicenseCode>
									<Birthdate><xsl:value-of select="$yngBirthDate" />T00:00:00</Birthdate>
									<Claims60Months>0</Claims60Months>
									<Claimed36Months>false</Claimed36Months>
									<LicenseCancelled>false</LicenseCancelled>
									<Convictions>false</Convictions>
									<Judgements>false</Judgements>
									<Bankcruptcy>false</Bankcruptcy>
									<LicenseYear><xsl:value-of select="$yngLicenceYear"/></LicenseYear>
								</SSDriver70>
							</NominatedDrivers>
							</xsl:if>
						</CarDetail>
					</QuoteDetails>
					<Username>AUTOANDGEN</Username>
					<Password>Aut0andG3n</Password>
				</GetMultiPremium>
			</soap:Body>
		</soap:Envelope>
	</xsl:template>
</xsl:stylesheet>