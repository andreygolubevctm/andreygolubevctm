<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan">

<!-- IMPORTS -->
	<xsl:import href="../includes/get_street_name.xsl"/>
	<xsl:import href="../includes/utils.xsl"/>

	<xsl:param name="today" />
	<xsl:param name="request" />

	<xsl:variable name="tableSoundAccs" select="document('AGIS_sound_accessories.xml')" />
	<xsl:variable name="tableOtherAccs" select="document('AGIS_other_accessories.xml')" />

<!-- MAIN TEMPLATE -->
	<xsl:template match="/quote">

		<!-- Address variables -->
		<xsl:variable name="streetNameLower">
			<xsl:call-template name="get_street_name">
				<xsl:with-param name="address" select="riskAddress" />
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="streetName"
			select="translate($streetNameLower, $LOWERCASE, $UPPERCASE)" />
		<xsl:variable name="suburbName"
			select="translate(riskAddress/suburbName, $LOWERCASE, $UPPERCASE)" />
		<xsl:variable name="state"
			select="translate(riskAddress/state, $LOWERCASE, $UPPERCASE)" />
		<xsl:variable name="postcode" select="riskAddress/postCode" />

		<!-- SOAP REQUEST -->
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
			xmlns:quot="http://services.fastr.com.au/Quotation"
			xmlns:quotdata="http://services.fastr.com.au/Quotation/Data"
			xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
		<soapenv:Header/>
		<soapenv:Body>
				<RequestFinalQuotation xmlns="http://services.fastr.com.au/Quotation">
				<quotationRequest xmlns="http://services.fastr.com.au/Quotation" xmlns:quotdata="http://services.fastr.com.au/Quotation/Data">

						<xsl:variable name="commencementDate">
							<xsl:call-template name="util_formatEurDate">
								<xsl:with-param name="eurDate" select="options/commencementDate" />
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="commencementDateDay"   select="substring($commencementDate,1,2)" />
						<xsl:variable name="commencementDateMonth" select="substring($commencementDate,4,2)" />
						<xsl:variable name="commencementDateYear"  select="substring($commencementDate,7,4)" />

						<quotdata:CciQuotationItem i:nil="true" />

						<quotdata:CoverStartDate xmlns:data="http://services.fastr.com.au/Data">
							<data:Day>
								<xsl:value-of select="$commencementDateDay" />
							</data:Day>
							<data:Month>
								<xsl:value-of select="$commencementDateMonth" />
							</data:Month>
							<data:Year>
								<xsl:value-of select="$commencementDateYear" />
							</data:Year>
						</quotdata:CoverStartDate>

						<!-- Regular Driver Date Of Birth -->
							<xsl:variable name="regularDob">
								<xsl:call-template name="util_formatEurDate">
									<xsl:with-param name="eurDate" select="avea/driver0/dob" />
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="regularDobDay" select="substring($regularDob,1,2)" />
							<xsl:variable name="regularDobMonth" select="substring($regularDob,4,2)" />
							<xsl:variable name="regularDobYear" select="substring($regularDob,7,4)" />

						<quotdata:CustomerNumber xmlns="http://services.fastr.com.au/Quotation/Data">
							<quotdata:DriverLicenceNumber><xsl:value-of select="avea/driver0/licenceNumber" /></quotdata:DriverLicenceNumber>
							<quotdata:YearOfBirth><xsl:value-of select="$regularDobYear" /></quotdata:YearOfBirth>
						</quotdata:CustomerNumber>


						<quotdata:FinanceDetails i:nil="true" />
						<quotdata:FmoCustomerNumber i:nil="true" />
						<quotdata:Fsg i:nil="true" />
						<quotdata:GapQuotationItem i:nil="true" />
						<quotdata:LgiQuotationItem i:nil="true" />
						<quotdata:LtiQuotationItem i:nil="true" />

						<quotdata:MainInsured xmlns:quotdata="http://services.fastr.com.au/Quotation/Data">

							<Accidents xmlns="http://services.fastr.com.au/Quotation/Data" xmlns:motordata="http://services.fastr.com.au/Motor/Data" i:nil="true">

								<xsl:for-each select="avea/accidents/*">

									<xsl:choose>
										<xsl:when test="driver[text()='driver0']">

											<xsl:variable name="accident" select="driver[text()='driver0']/.." />
											<xsl:variable name="incidentDetails" select="$accident/incidentDetails" />
											<xsl:variable name="atFault" select="$accident/driverFault" />
											<xsl:variable name="insurerName" select="$accident/incidentInsurer" />
											<xsl:variable name="lossAmount" select="$accident/amount" />
											<xsl:variable name="theftOrMaliciousDamage" select="$accident/malicious" />
											<xsl:variable name="fire" select="$accident/fire" />

											<xsl:variable name="incidentDate">
												<xsl:call-template name="util_formatEurDate">
													<xsl:with-param name="eurDate" select="$accident/date" />
												</xsl:call-template>
											</xsl:variable>
											<xsl:variable name="incidentDateDay" select="substring($incidentDate,1,2)" />
											<xsl:variable name="incidentDateMonth" select="substring($incidentDate,4,2)" />
											<xsl:variable name="incidentDateYear" select="substring($incidentDate,7,4)" />

											<motordata:Accident xmlns:motordata="http://services.fastr.com.au/Motor/Data">
												<motordata:IncidentDate xmlns:data="http://services.fastr.com.au/Data">
													<data:Day><xsl:value-of select="$incidentDateDay" /></data:Day>
													<data:Month><xsl:value-of select="$incidentDateMonth" /></data:Month>
													<data:Year><xsl:value-of select="$incidentDateYear" /></data:Year>
												</motordata:IncidentDate>
												<motordata:IncidentDetails><xsl:value-of select="$incidentDetails" /></motordata:IncidentDetails>
												<motordata:AtFault>
													<xsl:choose>
														<xsl:when test="$atFault='Y'">true</xsl:when> <!-- Private/Commuting -->
														<xsl:otherwise>false</xsl:otherwise>
													</xsl:choose>
												</motordata:AtFault>
												<motordata:InsurerName><xsl:value-of select="$insurerName" /></motordata:InsurerName>
												<motordata:LossAmount><xsl:value-of select="$lossAmount" /></motordata:LossAmount>
												<motordata:TheftOrMaliciousDamage>
													<xsl:choose>
														<xsl:when test="$fire='1' or $theftOrMaliciousDamage='1'">true</xsl:when> <!-- Private/Commuting -->
														<xsl:otherwise>false</xsl:otherwise>
													</xsl:choose>
												</motordata:TheftOrMaliciousDamage>
											</motordata:Accident>

										</xsl:when>
									</xsl:choose>

								</xsl:for-each>

							</Accidents>

							<!-- Regular driver - Licence Year -->
							<xsl:variable name="rgdLicenceYear">
								<xsl:variable name="dobYr" select="substring($regularDob,7,4)" />
								<xsl:variable name="licAge" select="drivers/regular/licenceAge" />
								<xsl:value-of select="$dobYr + $licAge" />
							</xsl:variable>

							<DateOfBirth xmlns="http://services.fastr.com.au/Quotation/Data" xmlns:data="http://services.fastr.com.au/Data">
								<data:Day>
									<xsl:value-of select="$regularDobDay" />
								</data:Day>
								<data:Month>
									<xsl:value-of select="$regularDobMonth" />
								</data:Month>
								<data:Year>
									<xsl:value-of select="$regularDobYear" />
								</data:Year>
							</DateOfBirth>

							<FirstName xmlns="http://services.fastr.com.au/Quotation/Data">
								<xsl:value-of select="avea/driver0/firstName" />
							</FirstName>

							<Gender xmlns="http://services.fastr.com.au/Quotation/Data">Unspecified</Gender>

							<KilometresPerYear xmlns="http://services.fastr.com.au/Quotation/Data">
								<xsl:call-template name="util_numbersOnly">
									<xsl:with-param name="value" select="format-number(vehicle/annualKilometres, '#')" />
								</xsl:call-template>
							</KilometresPerYear>

							<LicenseEndorsements xmlns="http://services.fastr.com.au/Quotation/Data" xmlns:motordata="http://services.fastr.com.au/Motor/Data" i:nil="true">

								<xsl:for-each select="avea/licenseEndorsements/*">

									<xsl:choose>
										<xsl:when test="driver[text()='driver0']">

											<xsl:variable name="licenseEndorsement" select="driver[text()='driver0']/.." />
											<xsl:variable name="suspensionPeriodInMonths" select="$licenseEndorsement/period" />
											<xsl:variable name="incidentDetails" select="$licenseEndorsement/details" />

											<xsl:variable name="incidentDate">
												<xsl:call-template name="util_formatEurDate">
													<xsl:with-param name="eurDate" select="$licenseEndorsement/date" />
												</xsl:call-template>
											</xsl:variable>
											<xsl:variable name="incidentDateDay" select="substring($incidentDate,1,2)" />
											<xsl:variable name="incidentDateMonth" select="substring($incidentDate,4,2)" />
											<xsl:variable name="incidentDateYear" select="substring($incidentDate,7,4)" />

											<motordata:LicenseEndorsement>
													<motordata:IncidentDate xmlns:data="http://services.fastr.com.au/Data">
														<data:Day><xsl:value-of select="$incidentDateDay" /></data:Day>
														<data:Month><xsl:value-of select="$incidentDateMonth" /></data:Month>
														<data:Year><xsl:value-of select="$incidentDateYear" /></data:Year>
													</motordata:IncidentDate>
													<motordata:IncidentDetails><xsl:value-of select="$incidentDetails" /></motordata:IncidentDetails>
													<motordata:SuspensionPeriodInMonths><xsl:value-of select="$suspensionPeriodInMonths" /></motordata:SuspensionPeriodInMonths>
											</motordata:LicenseEndorsement>

										</xsl:when>
									</xsl:choose>

								</xsl:for-each>

							</LicenseEndorsements>

							<LicenseNumber xmlns="http://services.fastr.com.au/Quotation/Data">
								<xsl:value-of select="avea/driver0/licenceNumber" />
							</LicenseNumber>

							<MotoringOffences xmlns="http://services.fastr.com.au/Quotation/Data" xmlns:motordata="http://services.fastr.com.au/Motor/Data" i:nil="true">

								<xsl:for-each select="avea/motoringOffences/*">

									<xsl:choose>
										<xsl:when test="driver[text()='driver0']">

											<xsl:variable name="motoringOffence" select="driver[text()='driver0']/.." />
											<xsl:variable name="demeritPoints" select="$motoringOffence/demeritPoints" />
											<xsl:variable name="incidentDetails" select="$motoringOffence/details" />

											<xsl:variable name="incidentDate">
												<xsl:call-template name="util_formatEurDate">
													<xsl:with-param name="eurDate" select="$motoringOffence/date" />
												</xsl:call-template>
											</xsl:variable>
											<xsl:variable name="incidentDateDay" select="substring($incidentDate,1,2)" />
											<xsl:variable name="incidentDateMonth" select="substring($incidentDate,4,2)" />
											<xsl:variable name="incidentDateYear" select="substring($incidentDate,7,4)" />

											<motordata:MotoringOffence>
													<motordata:IncidentDate  xmlns:data="http://services.fastr.com.au/Data">
														<data:Day><xsl:value-of select="$incidentDateDay" /></data:Day>
														<data:Month><xsl:value-of select="$incidentDateMonth" /></data:Month>
														<data:Year><xsl:value-of select="$incidentDateYear" /></data:Year>
													</motordata:IncidentDate>
													<motordata:IncidentDetails><xsl:value-of select="$incidentDetails" /></motordata:IncidentDetails>
													<motordata:DemeritPoints><xsl:value-of select="$demeritPoints" /></motordata:DemeritPoints>
											</motordata:MotoringOffence>

										</xsl:when>
									</xsl:choose>

								</xsl:for-each>

							</MotoringOffences>

							<Surname xmlns="http://services.fastr.com.au/Quotation/Data">
								<xsl:value-of select="avea/driver0/lastName" />
							</Surname>

							<Title xmlns="http://services.fastr.com.au/Quotation/Data">
								<xsl:value-of select="avea/driver0/title" />
							</Title>

							<YearFirstLicensed xmlns="http://services.fastr.com.au/Quotation/Data">
								<xsl:value-of select="$rgdLicenceYear" />
							</YearFirstLicensed>

							<quotdata:Abn i:nil="true" />
							<quotdata:BusinessName i:nil="true" />

							<quotdata:Email>
								<xsl:value-of select="contact/email" />
							</quotdata:Email>

							<quotdata:IsBusinessUse>
								<xsl:choose>
									<xsl:when test="vehicle/use='02'">false</xsl:when> <!-- Private/Commuting -->
									<xsl:otherwise>true</xsl:otherwise>
								</xsl:choose>
							</quotdata:IsBusinessUse>

							<quotdata:IsRegisteredOwner>true</quotdata:IsRegisteredOwner>

							<quotdata:Mobile i:nil="true" />
							<quotdata:Occupation i:nil="true" />

							<quotdata:Phone1>
								<xsl:choose>
									<xsl:when test="contact/phone!=''"><xsl:value-of select="contact/phone" /></xsl:when>
									<xsl:otherwise>000000000000</xsl:otherwise>
								</xsl:choose>
							</quotdata:Phone1>

							<quotdata:PostCode>
								<xsl:value-of select="$postcode" />
							</quotdata:PostCode>

							<quotdata:PostalAddress1>
								<xsl:value-of select="$streetName" />
							</quotdata:PostalAddress1>

							<quotdata:RegisteredOwnersName i:nil="true" />

							<quotdata:State>
								<xsl:value-of select="$state" />
							</quotdata:State>

							<quotdata:Suburb>
								<xsl:value-of select="$suburbName" />
							</quotdata:Suburb>

							<quotdata:WorkPhone i:nil="true" />

						</quotdata:MainInsured>

						<quotdata:MotorVehicleQuotation>
							<quotdata:CoverEndDate xmlns:data="http://services.fastr.com.au/Data" i:nil="true" />
							<quotdata:CoverTypeCode>MVCMP</quotdata:CoverTypeCode>

							<quotdata:AdditionalDrivers xmlns:motordata="http://services.fastr.com.au/Motor/Data">

								<xsl:for-each select="avea/drivers/*">

									<xsl:variable name="driverNodeName" select="name()" />
									<xsl:variable name="driverExists" select="firstName" />

									<xsl:if test="$driverExists!=''">

										<quotdata:Driver>

											<motordata:Accidents>

												<xsl:for-each select="/quote/avea/accidents/*">

													<xsl:choose>
														<xsl:when test="driver[text()=$driverNodeName]">

															<xsl:variable name="accident" select="driver[text()=$driverNodeName]/.." />
															<xsl:variable name="incidentDetails" select="$accident/incidentDetails" />
															<xsl:variable name="atFault" select="$accident/driverFault" />
															<xsl:variable name="insurerName" select="$accident/incidentInsurer" />
															<xsl:variable name="lossAmount" select="$accident/amount" />
															<xsl:variable name="theftOrMaliciousDamage" select="$accident/malicious" />
															<xsl:variable name="fire" select="$accident/fire" />
															<xsl:variable name="incidentDate">
																<xsl:call-template name="util_formatEurDate">
																	<xsl:with-param name="eurDate" select="$accident/date" />
																</xsl:call-template>
															</xsl:variable>
															<xsl:variable name="incidentDateDay" select="substring($incidentDate,1,2)" />
															<xsl:variable name="incidentDateMonth" select="substring($incidentDate,4,2)" />
															<xsl:variable name="incidentDateYear" select="substring($incidentDate,7,4)" />

																<motordata:Accident xmlns:data="http://services.fastr.com.au/Motor/Data">
																	<data:IncidentDate xmlns:data="http://services.fastr.com.au/Data">
																		<data:Day><xsl:value-of select="$incidentDateDay" /></data:Day>
																		<data:Month><xsl:value-of select="$incidentDateMonth" /></data:Month>
																		<data:Year><xsl:value-of select="$incidentDateYear" /></data:Year>
																	</data:IncidentDate>
																	<data:IncidentDetails><xsl:value-of select="$incidentDetails" /></data:IncidentDetails>
																	<data:AtFault>
																		<xsl:choose>
																			<xsl:when test="$atFault='Y'">true</xsl:when> <!-- Private/Commuting -->
																			<xsl:otherwise>false</xsl:otherwise>
																		</xsl:choose>
																	</data:AtFault>
																	<data:InsurerName><xsl:value-of select="$insurerName" /></data:InsurerName>
																	<data:LossAmount><xsl:value-of select="$lossAmount" /></data:LossAmount>
																	<data:TheftOrMaliciousDamage>
																		<xsl:choose>
																			<xsl:when test="$fire='true' or $theftOrMaliciousDamage='true'">true</xsl:when> <!-- Private/Commuting -->
																			<xsl:otherwise>false</xsl:otherwise>
																		</xsl:choose>
																	</data:TheftOrMaliciousDamage>
																</motordata:Accident>

														</xsl:when>
													</xsl:choose>

												</xsl:for-each>

											</motordata:Accidents>

											<!-- Driver DOB -->
											<xsl:variable name="driverDob">
												<xsl:call-template name="util_formatEurDate">
													<xsl:with-param name="eurDate" select="dob" />
												</xsl:call-template>
											</xsl:variable>
											<xsl:variable name="driverDobDay" select="substring($driverDob,1,2)" />
											<xsl:variable name="driverDobMonth" select="substring($driverDob,4,2)" />
											<xsl:variable name="driverDobYear" select="substring($driverDob,7,4)" />

											<motordata:DateOfBirth xmlns:data="http://services.fastr.com.au/Data">
												<data:Day>
													<xsl:value-of select="$driverDobDay" />
												</data:Day>
												<data:Month>
													<xsl:value-of select="$driverDobMonth" />
												</data:Month>
												<data:Year>
													<xsl:value-of select="$driverDobYear" />
												</data:Year>
											</motordata:DateOfBirth>

											<motordata:FirstName><xsl:value-of select="firstName" /></motordata:FirstName>

											<motordata:Gender>Unspecified</motordata:Gender>

											<motordata:KilometresPerYear><xsl:value-of select="format-number(kilometresDriven, '#')" /></motordata:KilometresPerYear>

											<motordata:LicenseEndorsements>

												<xsl:for-each select="/quote/avea/licenseEndorsements/*">

													<xsl:choose>
														<xsl:when test="driver[text()=$driverNodeName]">

															<xsl:variable name="licenseEndorsement" select="driver[text()=$driverNodeName]/.." />
															<xsl:variable name="suspensionPeriodInMonths" select="$licenseEndorsement/period" />
															<xsl:variable name="incidentDetails" select="$licenseEndorsement/details" />

															<xsl:variable name="incidentDate">
																<xsl:call-template name="util_formatEurDate">
																	<xsl:with-param name="eurDate" select="$licenseEndorsement/date" />
																</xsl:call-template>
															</xsl:variable>
															<xsl:variable name="incidentDateDay" select="substring($incidentDate,1,2)" />
															<xsl:variable name="incidentDateMonth" select="substring($incidentDate,4,2)" />
															<xsl:variable name="incidentDateYear" select="substring($incidentDate,7,4)" />

															<motordata:LicenseEndorsement xmlns:motordata="http://services.fastr.com.au/Motor/Data">
																<motordata:IncidentDate xmlns:data="http://services.fastr.com.au/Data">
																	<data:Day><xsl:value-of select="$incidentDateDay" /></data:Day>
																	<data:Month><xsl:value-of select="$incidentDateMonth" /></data:Month>
																	<data:Year><xsl:value-of select="$incidentDateYear" /></data:Year>
																</motordata:IncidentDate>
																<motordata:IncidentDetails><xsl:value-of select="$incidentDetails" /></motordata:IncidentDetails>
																<motordata:SuspensionPeriodInMonths><xsl:value-of select="$suspensionPeriodInMonths" /></motordata:SuspensionPeriodInMonths>
															</motordata:LicenseEndorsement>

														</xsl:when>
													</xsl:choose>

												</xsl:for-each>

											</motordata:LicenseEndorsements>

											<motordata:LicenseNumber><xsl:value-of select="licenceNumber" /></motordata:LicenseNumber>

											<motordata:MotoringOffences>

												<xsl:for-each select="/quote/avea/motoringOffences/*">

													<xsl:choose>
														<xsl:when test="driver[text()=$driverNodeName]">

															<xsl:variable name="motoringOffence" select="driver[text()=$driverNodeName]/.." />

															<xsl:variable name="demeritPoints" select="$motoringOffence/demeritPoints" />
															<xsl:variable name="incidentDetails" select="$motoringOffence/details" />

															<xsl:variable name="incidentDate">
																<xsl:call-template name="util_formatEurDate">
																	<xsl:with-param name="eurDate" select="$motoringOffence/date" />
																</xsl:call-template>
															</xsl:variable>
															<xsl:variable name="incidentDateDay" select="substring($incidentDate,1,2)" />
															<xsl:variable name="incidentDateMonth" select="substring($incidentDate,4,2)" />
															<xsl:variable name="incidentDateYear" select="substring($incidentDate,7,4)" />

															<motordata:MotoringOffence xmlns:motordata="http://services.fastr.com.au/Motor/Data">
																	<motordata:IncidentDate xmlns:data="http://services.fastr.com.au/Data">
																		<data:Day><xsl:value-of select="$incidentDateDay" /></data:Day>
																		<data:Month><xsl:value-of select="$incidentDateMonth" /></data:Month>
																		<data:Year><xsl:value-of select="$incidentDateYear" /></data:Year>
																	</motordata:IncidentDate>
																	<motordata:IncidentDetails><xsl:value-of select="$incidentDetails" /></motordata:IncidentDetails>
																	<motordata:DemeritPoints><xsl:value-of select="$demeritPoints" /></motordata:DemeritPoints>
															</motordata:MotoringOffence>

														</xsl:when>
													</xsl:choose>

												</xsl:for-each>

											</motordata:MotoringOffences>

											<motordata:Surname><xsl:value-of select="lastName" /></motordata:Surname>
											<motordata:Title><xsl:value-of select="title" /></motordata:Title>
											<motordata:YearFirstLicensed><xsl:value-of select="firstYearLicenced" /></motordata:YearFirstLicensed>
											<motordata:RelationshipToInsured i:nil="true" />

										</quotdata:Driver>

									</xsl:if>

								</xsl:for-each>

							</quotdata:AdditionalDrivers>

							<quotdata:OtherInformation xmlns:motordata="http://services.fastr.com.au/Motor/Data" >
								<!--Optional:-->
								<xsl:variable name="criminalConvictionsDetails">

									<xsl:call-template name="convictionsTemplate">
										<xsl:with-param name="driver" select="'driver0'" />
									</xsl:call-template>

									<xsl:for-each select="avea/drivers/*">

										<xsl:variable name="driverNodeName" select="name()" />
										<xsl:variable name="driverExists" select="firstName" />
										<xsl:if test="$driverExists!=''">
											<xsl:call-template name="convictionsTemplate">
												<xsl:with-param name="driver"><xsl:value-of select="$driverNodeName" /></xsl:with-param>
											</xsl:call-template>
										</xsl:if>
									</xsl:for-each>

								</xsl:variable>

								<xsl:variable name="insuranceRefusedDetails">

									<xsl:call-template name="insuranceRefusedTemplate">
										<xsl:with-param name="driver" select="'driver0'" />
									</xsl:call-template>

									<xsl:for-each select="avea/drivers/*">

										<xsl:variable name="driverNodeName" select="name()" />
										<xsl:variable name="driverExists" select="firstName" />
										<xsl:if test="$driverExists!=''">
											<xsl:call-template name="insuranceRefusedTemplate">
												<xsl:with-param name="driver"><xsl:value-of select="$driverNodeName" /></xsl:with-param>
											</xsl:call-template>
										</xsl:if>
									</xsl:for-each>

								</xsl:variable>

								<motordata:CriminalConvictionDetails i:nil="true"><xsl:value-of select="$criminalConvictionsDetails" /></motordata:CriminalConvictionDetails>
								<motordata:HadInsuranceRefused>
									<xsl:choose>
										<xsl:when test="$insuranceRefusedDetails!=''">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</motordata:HadInsuranceRefused>
								<motordata:HasCriminalConviction>
									<xsl:choose>
										<xsl:when test="$criminalConvictionsDetails!=''">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</motordata:HasCriminalConviction>
								<!--Optional:-->
								<motordata:InsuranceRefusedDetails i:nil="true"><xsl:value-of select="$insuranceRefusedDetails" /></motordata:InsuranceRefusedDetails>
							</quotdata:OtherInformation>

							<quotdata:Rating>
								<xsl:value-of select="drivers/regular/ncd" />
							</quotdata:Rating>

							<quotdata:RatingProtectionRequired>false</quotdata:RatingProtectionRequired>

							<quotdata:Vehicle xmlns:motordata="http://services.fastr.com.au/Motor/Data">

								<motordata:DetailsOfExistingDamage i:nil="true" /> <!-- We do not capture this -->
								<motordata:EngineNumber i:nil="true" /> <!-- We do not capture this -->

								<motordata:HasAirConditioning>
									<xsl:choose>
										<xsl:when test="accs/*/sel[text()='CB']">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</motordata:HasAirConditioning>

								<motordata:HasBodyKitModification>
									<xsl:choose>
										<xsl:when test="/quote/avea/modifications/bodyKit = '1'">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</motordata:HasBodyKitModification>

								<motordata:HasEngineModification>
									<xsl:choose>
										<xsl:when test="/quote/avea/modifications/engineMod = '1'">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</motordata:HasEngineModification>

								<motordata:HasExistingDamage>
									<xsl:choose>
										<xsl:when test="vehicle/damage = 'Y'">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</motordata:HasExistingDamage>

								<motordata:HasExtractorsModification>
									<xsl:choose>
										<xsl:when test="/quote/avea/modifications/extractor = '1'">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</motordata:HasExtractorsModification>

								<motordata:HasImmobiliserOrAlarm>
									<xsl:choose>
										<xsl:when test="vehicle/securityOption = 'N'">false</xsl:when>
										<xsl:otherwise>true</xsl:otherwise>
									</xsl:choose>
								</motordata:HasImmobiliserOrAlarm>

								<motordata:HasLoweredChasisModification>
									<xsl:choose>
										<xsl:when test="/quote/avea/modifications/loweredChassis = '1'">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</motordata:HasLoweredChasisModification>

								<motordata:HasLoweredSuspensionModification>
									<xsl:choose>
										<xsl:when test="/quote/avea/modifications/loweredSuspension = '1'">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</motordata:HasLoweredSuspensionModification>

								<motordata:HasOtherModification>
									<xsl:choose>
										<xsl:when test="vehicle/modification = 'Y'">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</motordata:HasOtherModification>

								<motordata:HasOtherNonStandardAccessories>false</motordata:HasOtherNonStandardAccessories>

								<!-- We do not capture this -->
								<motordata:HasPowerSteering>false</motordata:HasPowerSteering>

								<!-- This has been deprecated -->
								<motordata:KilometresPerYear>0</motordata:KilometresPerYear>

								<motordata:NonStandardSoundSystemAmount>
									<xsl:variable name="accs" select="/quote/accs"/>
									<xsl:call-template name="nonStandardAmountTemplate">
										<xsl:with-param name="path" select="$tableSoundAccs/soundAccessories/item" />
										<xsl:with-param name="accs" select="$accs"/>
									</xsl:call-template>
								</motordata:NonStandardSoundSystemAmount>

								<motordata:NonStandardSoundSystemDetails>

									<xsl:variable name="accs" select="/quote/accs"/>
									<xsl:for-each select='$tableSoundAccs/soundAccessories/item'>

										<xsl:variable name="elementName" select="./@name"/>
										<xsl:variable name="elementCode" select="./@code"/>

										<xsl:call-template name="nonStandardDetailsTemplate">
											<xsl:with-param name="name"><xsl:value-of select="$elementName"/></xsl:with-param>
											<xsl:with-param name="code"><xsl:value-of select="$elementCode"/></xsl:with-param>
											<xsl:with-param name="accs" select="$accs"/>
										</xsl:call-template>

									</xsl:for-each>
								</motordata:NonStandardSoundSystemDetails>

								<motordata:NonStandardSpoilerAmount>
									<xsl:call-template name="accessoryAmount">
										<xsl:with-param name="accCode" select="'CAA'" />
									</xsl:call-template>
								</motordata:NonStandardSpoilerAmount>

								<motordata:NonStandardSteeringWheelAmount>
									<xsl:call-template name="accessoryAmount">
										<xsl:with-param name="accCode" select="'CY'" />
									</xsl:call-template>
								</motordata:NonStandardSteeringWheelAmount>

								<motordata:NonStandardSunroofAmount>
									<xsl:call-template name="accessoryAmount">
										<xsl:with-param name="accCode" select="'CZ'" />
									</xsl:call-template>
								</motordata:NonStandardSunroofAmount>

								<motordata:NonStandardWheelAmount>
									<xsl:call-template name="accessoryAmount">
										<xsl:with-param name="accCode" select="'CAB'" />
									</xsl:call-template>
								</motordata:NonStandardWheelAmount>
								<motordata:NonStandardWheelDetails i:nil="true" />

								<motordata:OtherModificationAmount>
									<xsl:choose>
										<xsl:when test="/quote/avea/modifications/other = '1'">
											<xsl:value-of select="/quote/avea/modifications/otherModificationValue" />
										</xsl:when>
										<xsl:otherwise>0</xsl:otherwise>
									</xsl:choose>
								</motordata:OtherModificationAmount>

								<motordata:OtherModificationDescription>
									<xsl:choose>
										<xsl:when test="/quote/avea/modifications/other = '1'">
											<xsl:value-of select="/quote/avea/modifications/otherModification" />
										</xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
								</motordata:OtherModificationDescription>

								<motordata:OtherNonStandardAccessoriesAmount>
									<xsl:variable name="accs" select="/quote/accs"/>
									<xsl:call-template name="nonStandardAmountTemplate">
										<xsl:with-param name="path" select="$tableOtherAccs/accessories/item" />
										<xsl:with-param name="accs" select="$accs"/>
									</xsl:call-template>
								</motordata:OtherNonStandardAccessoriesAmount>
								<motordata:OtherNonStandardAccessoriesDescription>
									<xsl:variable name="accs" select="/quote/accs"/>
									<xsl:for-each select='$tableOtherAccs/accessories/item'>
										<xsl:variable name="elementName" select="./@name"/>
										<xsl:variable name="elementCode" select="./@code"/>
										<xsl:call-template name="nonStandardDetailsTemplate">
											<xsl:with-param name="name"><xsl:value-of select="$elementName"/></xsl:with-param>
											<xsl:with-param name="code"><xsl:value-of select="$elementCode"/></xsl:with-param>
											<xsl:with-param name="accs" select="$accs"/>
										</xsl:call-template>
									</xsl:for-each>
								</motordata:OtherNonStandardAccessoriesDescription>

								<motordata:RedbookKey><xsl:value-of select="vehicle/redbookCode" /></motordata:RedbookKey>

								<motordata:RegistrationNumber><xsl:value-of select="avea/regoNumber" /></motordata:RegistrationNumber>

								<motordata:Transmission>
									<xsl:choose>
										<xsl:when test="vehicle/trans = 'M'">Manual</xsl:when>
										<xsl:otherwise>Automatic</xsl:otherwise>
									</xsl:choose>
								</motordata:Transmission>
								<motordata:VehicleCondition>Unspecified</motordata:VehicleCondition>
								<motordata:VinNumber i:nil="true" />
							</quotdata:Vehicle>

							<quotdata:VehicleGaragedPostcode><xsl:value-of select="$postcode" /></quotdata:VehicleGaragedPostcode>

							<quotdata:VehicleUse><xsl:value-of select="vehicle/use" /></quotdata:VehicleUse>

							<quotdata:WhereGaragedDuringDay i:nil="true" />

							<quotdata:WhereGaragedDuringNight>
								<xsl:choose>
									<xsl:when test="vehicle/parking = '1'">Garaged</xsl:when>
									<xsl:when test="vehicle/parking = '2'">Street</xsl:when>
									<xsl:when test="vehicle/parking = '3'">Driveway</xsl:when>
									<xsl:when test="vehicle/parking = '4'">On Private Property</xsl:when>
									<xsl:when test="vehicle/parking = '5'">Car Park</xsl:when>
									<xsl:when test="vehicle/parking = '6'">Parking Lot</xsl:when>
									<xsl:when test="vehicle/parking = '7'">Locked Compound</xsl:when>
									<xsl:when test="vehicle/parking = '8'">Carport</xsl:when>
								</xsl:choose>
							</quotdata:WhereGaragedDuringNight>

							<quotdata:WindscreenProtectionRequired>false</quotdata:WindscreenProtectionRequired>

						</quotdata:MotorVehicleQuotation>

						<quotdata:QuotationNumber><xsl:value-of select="avea/leadNo" /></quotdata:QuotationNumber>
						<quotdata:registrationNumber i:nil="true" />
						<quotdata:ServiceContractQuotationItem i:nil="true" />

						<quotdata:StampDutyState>
							<xsl:value-of select="$state" />
						</quotdata:StampDutyState>

						<quotdata:TotalAssistQuotationItem i:nil="true" />
						<quotdata:TruckGapQuotationItem i:nil="true" />
						<quotdata:VehicleUsage><xsl:value-of select="vehicle/use" /></quotdata:VehicleUsage>
						<quotdata:VehiclePurchaseDate i:nil="true" />  <!-- We do not capture this -->
						<quotdata:VehiclePurchasePrice>0</quotdata:VehiclePurchasePrice>  <!-- We do not capture this -->
						<quotdata:WarrantyQuotationItem i:nil="true" />

					</quotationRequest>
					<!--Optional:-->
					<quot:username>
						<xsl:choose>
							<xsl:when test="/quote/avea/productId = 'crsr'">captaincompare</xsl:when>
							<xsl:when test="/quote/avea/productId = 'aubn'">captaincompareauto</xsl:when>
							<xsl:otherwise>captaincompare</xsl:otherwise>
						</xsl:choose>
					</quot:username>
				</RequestFinalQuotation>

			</soapenv:Body>
		</soapenv:Envelope>

	</xsl:template>

	<!-- Non Standard Amount Template -->
	<xsl:template name="nonStandardAmountTemplate">
		<xsl:param name="path"/>
		<xsl:param name="accs"/>

		<xsl:variable name="totalAmount" select="0" />

		<xsl:variable name="accAmount">
			<total_amount>
				<xsl:for-each select='$path'>
					<xsl:variable name="elementCode" select="./@code"/>

					<xsl:if test="$accs/*/sel[text()=$elementCode]">
					<item>
						<xsl:variable name="acc" select="$accs/*/sel[text()=$elementCode]/.." />
						<xsl:variable name="accInc" select="$acc/inc" />
						<xsl:variable name="accPrc" select="$acc/prc" />
						<xsl:choose>
							<xsl:when test="$accInc='N'"><xsl:value-of select="$accPrc" /></xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</item>
					</xsl:if>

				</xsl:for-each>
			</total_amount>
		</xsl:variable>

		<xsl:variable name="myTotal" select="xalan:nodeset($accAmount)"/>
		<xsl:value-of select="sum($myTotal/total_amount/item)" />

	</xsl:template>

	<!-- Non Standard Details Template -->
	<xsl:template name="nonStandardDetailsTemplate">
		<xsl:param name="name"/>
		<xsl:param name="code"/>
		<xsl:param name="accs"/>

		<xsl:variable name="accCode" select="string($code)"/>

		<xsl:if test="$accs/*/sel[text()=$accCode]">
			<xsl:value-of select="normalize-space($name)" />,
		</xsl:if>

	</xsl:template>

	<xsl:template name="convictionsTemplate">
		<xsl:param name="driver"/>

		<xsl:variable name="driverNode" select="string($driver)"/>

		<xsl:variable name="convictions">

			<xsl:for-each select="/quote/avea/criminalConvictions/*">

				<xsl:choose>
					<xsl:when test="driver[text()=$driverNode]">
						<xsl:variable name="driverConviction" select="driver[text()=$driverNode]/.." />
						<xsl:variable name="details" select="$driverConviction/details" />
						<xsl:variable name="date" select="$driverConviction/date" />
						<xsl:value-of select="$driverNode" />: Date (<xsl:value-of select="$date" />) <xsl:value-of select="$details" />,
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>

		</xsl:variable>

		<xsl:value-of select="normalize-space($convictions)" />

	</xsl:template>

	<xsl:template name="insuranceRefusedTemplate">
		<xsl:param name="driver"/>

		<xsl:variable name="driverNode" select="string($driver)"/>

		<xsl:variable name="insuranceRefused">

			<xsl:for-each select="/quote/avea/insuranceRefused/*">

				<xsl:choose>
					<xsl:when test="driver[text()=$driverNode]">
						<xsl:variable name="driverRefusal" select="driver[text()=$driverNode]/.." />
						<xsl:variable name="details" select="$driverRefusal/details" />
						<xsl:variable name="date" select="$driverRefusal/date" />
						<xsl:value-of select="$driverNode" />: Date (<xsl:value-of select="$date" />) <xsl:value-of select="$details" />,
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>

		</xsl:variable>

		<xsl:value-of select="normalize-space($insuranceRefused)" />

	</xsl:template>

</xsl:stylesheet>

