<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS -->
	<xsl:import href="../includes/utils.xsl"/>
	<xsl:import href="../includes/get_street_name.xsl"/>

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



		<xsl:variable name="vehicleUse">
			<xsl:choose>
				<xsl:when test="vehicle/use='13'">yes</xsl:when>
				<xsl:otherwise>no</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="existingDamage">
			<xsl:choose>
				<xsl:when test="vehicle/damage='Y'">yes</xsl:when>
				<xsl:otherwise>no</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="businessUse">
			<xsl:choose>
				<xsl:when test="vehicle/use='02'">no</xsl:when>
				<xsl:otherwise>yes</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Address variables -->
		<xsl:variable name="streetNameLower">
			<xsl:call-template name="get_street_name">
				<xsl:with-param name="address" select="riskAddress"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="streetName" select="translate($streetNameLower, $LOWERCASE, $UPPERCASE)" />
		<xsl:variable name="suburbName" select="translate(riskAddress/suburbName, $LOWERCASE, $UPPERCASE)" />
		<xsl:variable name="state" select="translate(riskAddress/state, $LOWERCASE, $UPPERCASE)" />

		<xsl:variable name="address">
			<xsl:value-of select="concat($streetName, ' ', $suburbName, ' ', $state, ' ', riskAddress/postCode)" />
		</xsl:variable>

		<!-- Street Number -->
		<xsl:variable name="streetNo">
			<xsl:choose>
				<xsl:when test="riskAddress/streetNum != ''">
					<xsl:value-of select="riskAddress/streetNum" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="riskAddress/houseNoSel" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<!-- Licence Year -->
		<xsl:variable name="licenceYear">
			<xsl:variable name="rgdDobYr" select="substring($regularDob,7,4)" />
			<xsl:variable name="licAge" select='drivers/regular/licenceAge' />
			<xsl:value-of select="$rgdDobYr + $licAge"/>
		</xsl:variable>

		<!-- two years after licence date -->
		<xsl:variable name="licenceDateAddtwo">
			<xsl:value-of select="concat($licenceYear + 2 ,'-',substring($regularDob,4,2),'-',substring($regularDob,1,2))" />
		</xsl:variable>

		<!-- 25 yrs after rgdDob -->
		<xsl:variable name="dobadd25">
			<xsl:value-of select="concat(substring($regularDob,7,4) + 25 ,'-',substring($regularDob,4,2),'-',substring($regularDob,1,2))" />
		</xsl:variable>

		<!-- TEMPORARY HACK 2 - prevent ANY driver under 25 -->
		<xsl:variable name="yngDobAdd25">
			<xsl:choose>
				<xsl:when test="drivers/young/exists='Y'">
					<xsl:value-of select="concat(substring($youngDob,7,4) + 25 ,'-',substring($youngDob,4,2),'-',substring($youngDob,1,2))" />
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<keys>
			<SiteId>WebPurchase_AG</SiteId>
			<DutyOfDisclosure>yes</DutyOfDisclosure>
			<RegisteredOwner></RegisteredOwner>
			<CurrentlyInsured></CurrentlyInsured>
			<Modifications>
				<xsl:choose>
					<xsl:when test="vehicle/modifications='Y'">yes</xsl:when>
					<xsl:otherwise>no</xsl:otherwise>
				</xsl:choose>
			</Modifications>
			<AcceptableModifications></AcceptableModifications>
			<LicensedTwoYears>
				<xsl:choose>
					<xsl:when test="translate($licenceDateAddtwo,'-' ,'' ) > translate($today,'-' ,'' ) ">no</xsl:when>
					<xsl:otherwise>yes</xsl:otherwise>
				</xsl:choose>
			</LicensedTwoYears>
			<VehicleUse><xsl:value-of select="$vehicleUse" /></VehicleUse>
			<Conviction></Conviction>
			<TrafficOffences></TrafficOffences>
			<LicenseCancellations></LicenseCancellations>
			<Bankrupt></Bankrupt>
			<PreExistingDamage><xsl:value-of select="$existingDamage" /></PreExistingDamage>
			<Under25>
				<xsl:choose>
					<xsl:when test="translate($dobadd25,'-' ,'' ) > translate($today,'-' ,'' )">yes</xsl:when>
					<xsl:when test="translate($yngDobAdd25,'-' ,'' ) > translate($today,'-' ,'' )">yes</xsl:when>
					<xsl:otherwise>no</xsl:otherwise>
				</xsl:choose>
			</Under25>
			<ClaimDeclined></ClaimDeclined>
			<MotorClaims></MotorClaims>
			<Rego />
			<RedBookId><xsl:value-of select="vehicle/redbookCode" /></RedBookId>
			<DistancePerYear>
				<xsl:call-template name="util_numbersOnly">
					<xsl:with-param name="value" select="format-number(vehicle/annualKilometres, '#')" />
				</xsl:call-template>
			</DistancePerYear>
			<BusinessUse><xsl:value-of select="$businessUse" /></BusinessUse>
			<financier>
				<xsl:choose>
					<xsl:when test="vehicle/finance='NO'">no</xsl:when>
					<xsl:otherwise>yes</xsl:otherwise>
				</xsl:choose>
			</financier>
			<PostcodeSuburb><xsl:value-of select="concat($suburbName,' ',$state,' ',riskAddress/postCode)" /></PostcodeSuburb>
			<Address><xsl:value-of select="translate($address,$LOWERCASE ,$UPPERCASE )" /></Address>
			<AddressSelect><xsl:value-of select="translate($address,$LOWERCASE ,$UPPERCASE )" /></AddressSelect>
			<StorageDetails />
			<FirstName><xsl:value-of select="drivers/regular/firstname" /></FirstName>
			<Surname><xsl:value-of select="drivers/regular/surname" /></Surname>
			<DateOfBirth><xsl:value-of select="$regularDob" /></DateOfBirth>
			<Gender>
				<xsl:choose>
					<xsl:when test="drivers/regular/gender='M'">Male</xsl:when>
					<xsl:otherwise>Female</xsl:otherwise>
				</xsl:choose>
			</Gender>
			<LicenceYear><xsl:value-of select="$licenceYear" /></LicenceYear>
			<ClaimsAccidents>
				<xsl:choose>
					<xsl:when test="drivers/regular/claims='N'">0</xsl:when>
					<xsl:when test="drivers/regular/claims='Y'">1</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</ClaimsAccidents>
			<xsl:choose>
				<xsl:when test="drivers/young/exists='Y'">
					<YoungerDriver>yes</YoungerDriver>
					<YoungestTitle />
					<YoungestFirstName />
					<YoungestSurname />
					<YoungestDateOfBirth><xsl:value-of select="$youngDob" /></YoungestDateOfBirth>
					<YoungestGender>
						<xsl:choose>
							<xsl:when test="drivers/young/gender='M'">Male</xsl:when>
							<xsl:otherwise>Female</xsl:otherwise>
						</xsl:choose>
					</YoungestGender>
					<YoungestNumberOfClaims>0</YoungestNumberOfClaims>
					<YoungestLicenceObtained>
						<xsl:variable name="yngdrvDobYr" select="substring($youngDob,7,4)" />
						<xsl:variable name="yngdrvlicAge" select='drivers/young/licenceAge' />
						<xsl:value-of select="$yngdrvDobYr + $yngdrvlicAge"/>
					</YoungestLicenceObtained>
				</xsl:when>
				<xsl:otherwise>
					<YoungerDriver>no</YoungerDriver>
					<YoungestTitle />
					<YoungestFirstName />
					<YoungestSurname />
					<YoungestDateOfBirth>31/12/9999</YoungestDateOfBirth>
					<YoungestGender />
					<YoungestNumberOfClaims>0</YoungestNumberOfClaims>
					<YoungestLicenceObtained>9999</YoungestLicenceObtained>
				</xsl:otherwise>
			</xsl:choose>

			<!-- HACK to provide a default phone when not supplied -->
			<xsl:variable name="def_phone">
			<xsl:choose>
				<xsl:when test="contact/phone != ''">
					<xsl:value-of select="contact/phone" />
				</xsl:when>
				<xsl:otherwise>
					11111111111
				</xsl:otherwise>
			</xsl:choose>
			</xsl:variable>

			<PrimaryPhoneNumber>
				<xsl:call-template name="util_numbersOnly">
					<xsl:with-param name="value" select="$def_phone" />
				</xsl:call-template>
			</PrimaryPhoneNumber>

			<PrimaryPhoneType />
			<SecondaryPhoneNumber />
			<SecondaryPhoneType />
			<EmailAddress><xsl:value-of select="contact/email" /></EmailAddress>
			<DayState><xsl:value-of select="$state" /></DayState>
			<DayPostcode><xsl:value-of select="riskAddress/postCode" /></DayPostcode>
			<DayStreetName><xsl:value-of select="$streetName" /></DayStreetName>
			<DayStreetType />
			<DayStreetNumber1><xsl:value-of select="$streetNo" /></DayStreetNumber1>
			<DayStreetNumber2 />
			<DayFlatNumber />
			<DaySuburb><xsl:value-of select="$suburbName" /></DaySuburb>
			<VehicleDesc />
			<financierSelect />
			<RetailValue><xsl:value-of select="vehicle/marketValue"/></RetailValue>
			<AgreedValue><xsl:value-of select="vehicle/marketValue"/></AgreedValue>
			<Excess>
				<xsl:choose>
					<xsl:when test="excess &gt; 499"><xsl:value-of select="excess" /></xsl:when>
					<xsl:otherwise>600</xsl:otherwise>
				</xsl:choose>
			</Excess>
			<Windscreen>no</Windscreen>
			<CarHire>0</CarHire>
			<Carbon>no</Carbon>
			<ParkedAtNight>
				<xsl:choose>
					<xsl:when test="vehicle/parking=1">GA</xsl:when>
					<xsl:when test="vehicle/parking=2">ST</xsl:when>
					<xsl:when test="vehicle/parking=3">PP</xsl:when>
					<xsl:when test="vehicle/parking=4">PP</xsl:when>
					<xsl:when test="vehicle/parking=5">CP</xsl:when>
					<xsl:when test="vehicle/parking=6">PL</xsl:when>
					<xsl:when test="vehicle/parking=7">LC</xsl:when>
					<xsl:when test="vehicle/parking=8">CA</xsl:when>
				</xsl:choose>
			</ParkedAtNight>
			<Year />
			<Make />
			<Model />
			<Transmission />
			<Series />
		</keys>
	</xsl:template>
</xsl:stylesheet>