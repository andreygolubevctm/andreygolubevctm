<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:a1="http://schemas.datacontract.org/2004/07/QuoteLine.Aggregator.Common">

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
		<GetQuote>
			<DutyOfDisclosure>Y</DutyOfDisclosure>
			<CoverStartDate><xsl:value-of select="options/commencementDate" /></CoverStartDate>
			<RegisteredOwner></RegisteredOwner>
			<CarYear><xsl:value-of select="vehicle/year" /></CarYear>
			<CarYear_display><xsl:value-of select="vehicle/year" /></CarYear_display>
			<CarMake><xsl:value-of select="vehicle/make" /></CarMake>
			<CarMake_display><xsl:value-of select="vehicle/makeDes" /></CarMake_display>
			<CarModel><xsl:value-of select="vehicle/modelDes" /></CarModel>
			<CarModel_display><xsl:value-of select="vehicle/modelDes" /></CarModel_display>
			<CarBodyType><xsl:value-of select="vehicle/body" /></CarBodyType>
			<CarBodyType_display><xsl:value-of select="vehicle/body" /></CarBodyType_display>
			<CarSeries><xsl:value-of select="vehicle/variant" /></CarSeries>
			<CarSeries_display><xsl:value-of select="vehicle/variant" /></CarSeries_display>
			<HasExistingDamage>
				<xsl:choose>
					<xsl:when test="$existingDamage='Y'">0007</xsl:when>
					<xsl:otherwise>0003</xsl:otherwise>
				</xsl:choose>
			</HasExistingDamage>
			<AgreedValue><xsl:value-of select="vehicle/marketValue"/></AgreedValue>
			<MainAddress_PostCode><xsl:value-of select="riskAddress/postCode" /></MainAddress_PostCode>
			<MainAddress_StateValue><xsl:value-of select="$state" /></MainAddress_StateValue>
			<MainAddress_Address1Value><xsl:value-of select="translate($address,$LOWERCASE ,$UPPERCASE )" /></MainAddress_Address1Value>
			<MainAddress_Address2Value />
			<MainAddress_Address3Value />
			<MainAddress_CountryValue>
				<MainAddress_QASMonikerValue />
				<MainAddress_ConfidenceIND />
				<MainAddress_LocCode />
			</MainAddress_CountryValue>
			<DaytimePostcode><xsl:value-of select="riskAddress/postCode" /></DaytimePostcode>
			<DayTimeKept />
			<DayTimeKept_display />
			<NighttimePostcode />
			<NighttimeKept>
				<xsl:choose>
					<xsl:when test="vehicle/parking='1'">G</xsl:when>
					<xsl:when test="vehicle/parking='2'">S</xsl:when>
					<xsl:when test="vehicle/parking='3'">D</xsl:when>
					<xsl:when test="vehicle/parking='4'">D</xsl:when>
					<xsl:when test="vehicle/parking='5'">P</xsl:when>
					<xsl:when test="vehicle/parking='6'">P</xsl:when>
					<xsl:when test="vehicle/parking='7'">L</xsl:when>
					<xsl:when test="vehicle/parking='8'">C</xsl:when>
					<xsl:otherwise>S</xsl:otherwise>
				</xsl:choose>
			</NighttimeKept>
			<NighttimeKept_display>
				<xsl:choose>
					<xsl:when test="vehicle/parking='1'">Garage</xsl:when>
					<xsl:when test="vehicle/parking='2'">Street</xsl:when>
					<xsl:when test="vehicle/parking='3'">Driveway</xsl:when>
					<xsl:when test="vehicle/parking='4'">Driveway</xsl:when>
					<xsl:when test="vehicle/parking='5'">Carpark</xsl:when>
					<xsl:when test="vehicle/parking='6'">Carpark</xsl:when>
					<xsl:when test="vehicle/parking='7'">Locked Compound</xsl:when>
					<xsl:when test="vehicle/parking='8'">Carport</xsl:when>
					<xsl:otherwise>Private Property</xsl:otherwise>
				</xsl:choose>
			</NighttimeKept_display>
			<CarUsage>
				<xsl:choose>
					<xsl:when test="$vehicleUse='02'">P</xsl:when>
					<xsl:when test="$vehicleUse='11'">C</xsl:when>
					<xsl:when test="$vehicleUse='12'">C</xsl:when>
					<xsl:when test="$vehicleUse='13'">B</xsl:when>
					<xsl:otherwise>Other</xsl:otherwise>
				</xsl:choose>
			</CarUsage>
			<CarUsage_display>
				<xsl:choose>
					<xsl:when test="$vehicleUse='02'">Private and/or Commuting to work</xsl:when>
					<xsl:when test="$vehicleUse='11'">Private and Occasional Business</xsl:when>
					<xsl:when test="$vehicleUse='12'">Private and Business</xsl:when>
					<xsl:when test="$vehicleUse='13'">Carry Goods/Passengers for Reward</xsl:when>
					<xsl:otherwise>Other</xsl:otherwise>
				</xsl:choose>
			</CarUsage_display>
			<CarUsageIncome>
				<xsl:choose>
					<xsl:when test="$vehicleUse='13'">1</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</CarUsageIncome>
			<KmsTravelled>
				<xsl:call-template name="util_numbersOnly">
					<xsl:with-param name="value" select="format-number(vehicle/annualKilometres, '#')" />
				</xsl:call-template>
			</KmsTravelled>
			<KmsTravelled_display>
				<xsl:call-template name="util_numbersOnly">
					<xsl:with-param name="value" select="format-number(vehicle/annualKilometres, '#')" />
				</xsl:call-template>km</KmsTravelled_display>
			<FinanceType>
				<xsl:choose>
					<xsl:when test="vehicle/finance='NO'">O</xsl:when>
					<xsl:when test="vehicle/finance='LE'">L</xsl:when>
					<xsl:when test="vehicle/finance='HP'">P</xsl:when>
					<xsl:otherwise>U</xsl:otherwise>
				</xsl:choose>
			</FinanceType>
			<FinanceInstitution />
			<ExcludeDriversUnder25>
				<xsl:choose>
					<xsl:when test="options/driverOption='3'">1</xsl:when>
					<xsl:when test="options/driverOption='H'">1</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</ExcludeDriversUnder25>
			<InsuredLast30Days />
			<PurchaseLast30Days />
			<WhoInsured />
			<WhoInsured_Display />
			<Claims>
				<HasFraudDishonesty></HasFraudDishonesty>
				<HasClaims>
					<xsl:choose>
						<xsl:when test="drivers/regular/claims='N'">0</xsl:when>
						<xsl:when test="drivers/regular/claims='Y'">1</xsl:when>
						<xsl:otherwise>1</xsl:otherwise>
					</xsl:choose>
				</HasClaims>
				<NumberOfClaims />
				<ClaimDriverResponsible_1 />
				<ClaimDriverResponsible_1_display />
				<ClaimType_1 />
				<ClaimType_1_display />
				<ClaimAtFault_1 />
				<ClaimMonthofIncident_1 />
				<ClaimMonthofIncident_1_display />
				<ClaimYearofIncident_1 />
				<ClaimYearofIncident_1_display />
				<ClaimDriverResponsible_2 />
				<ClaimDriverResponsible_2_display />
				<ClaimType_2 />
				<ClaimType_2_display />
				<ClaimAtFault_2 />
				<ClaimMonthofIncident_2 />
				<ClaimMonthofIncident_2_display />
				<ClaimYearofIncident_2 />
				<ClaimYearofIncident_2_display />
				<ClaimDriverResponsible_3 />
				<ClaimDriverResponsible_3_display />
				<ClaimType_3 />
				<ClaimType_3_display />
				<ClaimAtFault_3 />
				<ClaimMonthofIncident_3 />
				<ClaimMonthofIncident_3_display />
				<ClaimYearofIncident_3 />
				<ClaimYearofIncident_3_display />
				<HasBankrupt />
				<HasCriminalConviction />
				<HasLicenceCancelled />
				<LeadSource />
				<LeadSource_Display />
			</Claims>
			<HasModifications>
				<xsl:choose>
					<xsl:when test="vehicle/modifications='Y'">1</xsl:when>
					<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</HasModifications>
			<HasListedModifications>
				<xsl:choose>
					<xsl:when test="vehicle/accessories='Y'">1</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</HasListedModifications>
			<HasOptionalFactoryFittedExtras><xsl:value-of select="vehicle/factoryOptions" /></HasOptionalFactoryFittedExtras>
			<HadNonStandardSecurity>
				<xsl:choose>
					<xsl:when test="vehicle/securityOption='N'">1</xsl:when>
					<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</HadNonStandardSecurity>
			<FirstName><xsl:value-of select="drivers/regular/firstname" /></FirstName>
			<Surname><xsl:value-of select="drivers/regular/surname" /></Surname>
			<DateOfBirth><xsl:value-of select="$regularDob" /></DateOfBirth>
			<AgeFullLicence><xsl:value-of select="drivers/regular/licenceAge" /></AgeFullLicence>
			<AgeFullLicence_Display><xsl:value-of select="drivers/regular/licenceAge" /></AgeFullLicence_Display>
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
			<PhoneNumber>
				<xsl:call-template name="util_numbersOnly">
					<xsl:with-param name="value" select="$def_phone" />
				</xsl:call-template>
			</PhoneNumber>
			<PhoneNumberType />
			<PhoneNumberType_Display />
			<MainDriverEmail><xsl:value-of select="contact/email" /></MainDriverEmail>
			<MainDriverKeepInformedOfOffers>
				<xsl:choose>
					<xsl:when test="contact/marketing='Y'">1</xsl:when>
					<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</MainDriverKeepInformedOfOffers>
			<MainDriverEmploymentStatus>
				<xsl:choose>
					<xsl:when test="drivers/regular/employmentStatus='E'">EMFT</xsl:when>
					<xsl:when test="drivers/regular/employmentStatus='P'">EMPT</xsl:when>
					<xsl:when test="drivers/regular/employmentStatus='H'">HMDT</xsl:when>
					<xsl:when test="drivers/regular/employmentStatus='R'">RETD</xsl:when>
					<xsl:when test="drivers/regular/employmentStatus='S'">SFEM</xsl:when>
					<xsl:when test="drivers/regular/employmentStatus='F'">STDT</xsl:when>
					<xsl:when test="drivers/regular/employmentStatus='U'">UNEM</xsl:when>
					<xsl:otherwise>UNEM</xsl:otherwise>
				</xsl:choose>
			</MainDriverEmploymentStatus>
			<MainDriverEmploymentStatus_Display>
				<xsl:choose>
					<xsl:when test="drivers/regular/employmentStatus='E'">Employed Full Time</xsl:when>
					<xsl:when test="drivers/regular/employmentStatus='P'">Employed Part Time</xsl:when>
					<xsl:when test="drivers/regular/employmentStatus='H'">Home Duties</xsl:when>
					<xsl:when test="drivers/regular/employmentStatus='R'">Retired</xsl:when>
					<xsl:when test="drivers/regular/employmentStatus='S'">Self Employed</xsl:when>
					<xsl:when test="drivers/regular/employmentStatus='F'">Student</xsl:when>
					<xsl:when test="drivers/regular/employmentStatus='U'">Unemployed</xsl:when>
					<xsl:otherwise>Other</xsl:otherwise>
				</xsl:choose>
			</MainDriverEmploymentStatus_Display>
			<MaleFemale>
				<xsl:choose>
					<xsl:when test="drivers/regular/gender='M'">M</xsl:when>
					<xsl:otherwise>F</xsl:otherwise>
				</xsl:choose>
			</MaleFemale>
			<AddDriverFirstName_2 />
			<AddDriverSurname_2 />
			<AddDriverDateOfBirth_2><xsl:value-of select="$youngDob" /></AddDriverDateOfBirth_2>
			<AddDriverMaleFemale_2><xsl:value-of select="drivers/young/gender" /></AddDriverMaleFemale_2>
			<AddDriverAgeFullLicence_2>
				<xsl:variable name="yngdrvDobYr" select="substring($youngDob,7,4)" />
				<xsl:variable name="yngdrvlicAge" select='drivers/young/licenceAge' />
				<xsl:value-of select="$yngdrvDobYr + $yngdrvlicAge"/>
			</AddDriverAgeFullLicence_2>
			<AddDriverAgeFullLicence_2_display>
				<xsl:variable name="yngdrvDobYr" select="substring($youngDob,7,4)" />
				<xsl:variable name="yngdrvlicAge" select='drivers/young/licenceAge' />
				<xsl:value-of select="$yngdrvDobYr + $yngdrvlicAge"/>
			</AddDriverAgeFullLicence_2_display>
			<AddDriverFirstName_3 />
			<AddDriverSurname_3 />
			<AddDriverDateOfBirth_3 />
			<AddDriverMaleFemale_3 />
			<AddDriverAgeFullLicence_3 />
			<AddDriverAgeFullLicence_3_display />
			<AddDriverFirstName_4 />
			<AddDriverSurname_4 />
			<AddDriverDateOfBirth_4 />
			<AddDriverMaleFemale_4 />
			<AddDriverAgeFullLicence_4 />
			<AddDriverAgeFullLicence_4_display />
			<AddDriverFirstName_5 />
			<AddDriverSurname_5 />
			<AddDriverDateOfBirth_5 />
			<AddDriverMaleFemale_5 />
			<AddDriverAgeFullLicence_5 />
			<AddDriverAgeFullLicence_5_display />
			<DialogueBoxData_HasOptionalFactoryFittedExtras>
				<xsl:choose>
					<xsl:when test="vehicle/factoryOptions='Y'">Yes</xsl:when>
					<xsl:otherwise>No</xsl:otherwise>
				</xsl:choose>
			</DialogueBoxData_HasOptionalFactoryFittedExtras>
			<DialogueBoxTotalValue_HasOptionalFactoryFittedExtras />
			<DialogueBoxData_HasNonStandardSecurity>
				<xsl:choose>
					<xsl:when test="vehicle/securityOption='N'">No alarm or immobiliser</xsl:when>
					<xsl:otherwise />
				</xsl:choose>
			</DialogueBoxData_HasNonStandardSecurity>
			<DialogueBoxTotalValue_HasNonStandardSecurity />
			<DialogBoxes />
		</GetQuote>
	</xsl:template>
</xsl:stylesheet>