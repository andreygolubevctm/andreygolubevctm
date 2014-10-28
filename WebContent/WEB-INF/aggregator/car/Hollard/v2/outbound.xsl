<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS -->
	<xsl:import href="../../includes/utils.xsl"/>
	<xsl:import href="../../includes/get_street_name.xsl"/>

	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

<!-- MAIN TEMPLATE -->
	<xsl:template match="/quote">

		<!-- LOCAL VARIABLES -->
		<xsl:variable name="timeString">T00:00:00</xsl:variable>

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
		<xsl:variable name="suburbName" select="translate(riskAddress/suburbName, $LOWERCASE, $UPPERCASE)" />
		<xsl:variable name="state" select="translate(riskAddress/state, $LOWERCASE, $UPPERCASE)" />

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

		<!-- Prevent any driver under 25 -->
		<xsl:variable name="yngDobAdd25">
			<xsl:choose>
				<xsl:when test="drivers/young/exists='Y'">
					<xsl:value-of select="concat(substring($youngDob,7,4) + 25 ,'-',substring($youngDob,4,2),'-',substring($youngDob,1,2))" />
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Commencement date needs to be in DD Mmm YYYY format -->
		<xsl:variable name="commencementDate">
			<xsl:variable name="getMonth"><xsl:value-of select="substring(options/commencementDate,4,2)" /></xsl:variable>
			<xsl:variable name="Mmm">
				<xsl:choose>
					<xsl:when test="$getMonth='01'"> Jan </xsl:when>
					<xsl:when test="$getMonth='02'"> Feb </xsl:when>
					<xsl:when test="$getMonth='03'"> Mar </xsl:when>
					<xsl:when test="$getMonth='04'"> Apr </xsl:when>
					<xsl:when test="$getMonth='05'"> May </xsl:when>
					<xsl:when test="$getMonth='06'"> Jun </xsl:when>
					<xsl:when test="$getMonth='07'"> Jul </xsl:when>
					<xsl:when test="$getMonth='08'"> Aug </xsl:when>
					<xsl:when test="$getMonth='09'"> Sep </xsl:when>
					<xsl:when test="$getMonth='10'"> Oct </xsl:when>
					<xsl:when test="$getMonth='11'"> Nov </xsl:when>
					<xsl:otherwise> Dec </xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:value-of select="substring(options/commencementDate,1,2)" />
			<xsl:value-of select="$Mmm" />
			<xsl:value-of select="substring(options/commencementDate,7,4)" />
		</xsl:variable>


<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<soapenv:Envelope 	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
						xmlns:tem="http://tempuri.org/"
						xmlns:real="http://schemas.datacontract.org/2004/07/Real.Aggregator.Service.DataContracts"
						xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays"
						xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
		<soapenv:Header/>
		<soapenv:Body>
			<tem:GetMotorQuote xmlns:a="http://schemas.datacontract.org/2004/07/Real.Aggregator.Service.DataContracts" xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns:q1="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
				<tem:token><xsl:value-of select="token" /></tem:token>

				<tem:motorRisk>

					<real:Claims i:nil="true"/> <!--  We do not ask the year of the claims or any other details (Y/N/Unsure only) -->
					<real:CoverStartDate>
						<xsl:choose>
							<xsl:when test="options/commencementDate != ''">
								<xsl:value-of select="$commencementDate" />
							</xsl:when>
						</xsl:choose>
					</real:CoverStartDate>
					<real:CurrentlyInsured i:nil="true"/> <!-- This is no longer asked -->
					<real:DutyOfDisclosure i:nil="true"/> <!-- Unsure what is needed here -->
					<real:FinanceInstution i:nil="true"/> <!-- Unsure what is needed here -->
					<real:FinanceType>
						<xsl:choose>
							<xsl:when test="vehicle/finance='NO'">O</xsl:when>
							<xsl:when test="vehicle/finance='LE'">L</xsl:when>
							<xsl:when test="vehicle/finance='HP'">L</xsl:when>
							<xsl:otherwise>O</xsl:otherwise>
						</xsl:choose>
					</real:FinanceType>
					<real:HasBankrupt i:nil="true"/> <!-- Do not ask this question -->
					<!-- real:HasClaims -->
					<xsl:choose>
						<xsl:when test="drivers/regular/claims='N'"><real:HasClaims>false</real:HasClaims></xsl:when>
						<xsl:when test="drivers/regular/claims='Y'"><real:HasClaims>true</real:HasClaims></xsl:when>
					</xsl:choose>
					<real:HasCriminalConviction i:nil="true"/> <!-- Do not ask this question -->
					<real:HasFraudOrDishonesty i:nil="true"/> <!-- Do not ask this question -->
					<real:HasLicenceCancelled i:nil="true"/> <!-- Do not ask this question -->
					<real:InsuredLast30Days i:nil="true"/> <!-- Do not ask this question -->
					<real:LeadSource i:nil="true"/> <!-- TODO: Seems important ... -->
					<!--  MainPolicyDateOfBirth -->
					<xsl:choose>
						<xsl:when test="drivers/regular/licenceAge != ''">
							<real:MainPolicyDateOfBirth>
								<xsl:call-template name="util_isoDate">
									<xsl:with-param name="eurDate" select="$regularDob" />
								</xsl:call-template>
								<xsl:value-of select="$timeString" />
							</real:MainPolicyDateOfBirth>
						</xsl:when>
						<xsl:otherwise>
							<real:MainPolicyDateOfBirth i:nil="true"/>
						</xsl:otherwise>
					</xsl:choose>
					<!-- NumberClaims -->
					<xsl:choose>
						<xsl:when test="drivers/regular/claims='N'"><real:NumberClaims>0</real:NumberClaims></xsl:when>
						<xsl:when test="drivers/regular/claims='Y'"><real:NumberClaims>1</real:NumberClaims></xsl:when>
						<xsl:when test="drivers/regular/claims='U'"><real:NumberClaims>0</real:NumberClaims></xsl:when>
					</xsl:choose>
					<real:PurchasedLast30Days i:nil="true"/> <!-- Do not ask this question -->
					<real:QLPromoCode i:nil="true"/> <!-- Do not ask this question -->
					<real:RiskAddress>
						<real:AddressLine1><xsl:value-of select="$streetNameLower" /></real:AddressLine1>
						<real:AddressLine2 i:nil="true"></real:AddressLine2>
						<real:AddressLine3 i:nil="true"></real:AddressLine3>
						<real:ConfidenceIND i:nil="true"/> <!-- Don't have this detail -->
						<real:Country>AUSTRALIA</real:Country>
						<real:LocCode i:nil="true"/> <!-- Don't have this detail -->
						<real:PostCode><xsl:value-of select="riskAddress/postCode" /></real:PostCode>
						<real:State><xsl:value-of select="$state" /></real:State>
						<real:Suburb><xsl:value-of select="riskAddress/suburbName" /></real:Suburb>
					</real:RiskAddress>
					<real:TransactionReference><xsl:value-of select="$transactionId" /></real:TransactionReference>
					<real:WhoInsured i:nil="true"/> <!-- No longer ask this -->
					<real:WhyNotInsured i:nil="true"/> <!-- Do not ask this question -->
					<real:AgreedValue>
						<xsl:choose>
							<xsl:when test="vehicle/marketValue != ''"><xsl:value-of select="vehicle/marketValue"/></xsl:when>
						</xsl:choose>
					</real:AgreedValue>
					<real:CarExcess i:nil="true"/> <!-- TODO: Should this be the excess figure? How was this previously determined? -->
					<real:CarSeries><xsl:value-of select="glasses" /></real:CarSeries>
					<real:CarUsage>
						<xsl:choose>
							<xsl:when test="vehicle/use='02'">P</xsl:when>
							<xsl:when test="vehicle/use='11'">C</xsl:when>
							<xsl:when test="vehicle/use='12'">C</xsl:when>
							<xsl:when test="vehicle/use='13'">B</xsl:when>
							<xsl:otherwise>Other</xsl:otherwise>
						</xsl:choose>
					</real:CarUsage>
					<real:CarUsageIncome>
						<xsl:choose>
							<xsl:when test="$vehicleUse='13'">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</real:CarUsageIncome>
					<real:CarYear>
						<xsl:choose>
							<xsl:when test="vehicle/year != ''"><xsl:value-of select="vehicle/year" /></xsl:when>
						</xsl:choose>
					</real:CarYear>
					<real:DayTimeKept i:nil="true"/> <!-- Do not ask this question -->
					<real:DayTimePostcode><xsl:value-of select="riskAddress/postCode" /></real:DayTimePostcode>
					<real:ExcludeDriversUnder25>
						<xsl:choose>
							<xsl:when test="options/driverOption=''">false</xsl:when><!-- Default if the person is under 18 (field hidden) -->
							<xsl:when test="options/driverOption='3'">false</xsl:when>
							<xsl:when test="options/driverOption='H'">false</xsl:when>
							<xsl:otherwise>true</xsl:otherwise>
						</xsl:choose>
					</real:ExcludeDriversUnder25>
					<real:HasExistingDamage>
						<xsl:choose>
							<xsl:when test="vehicle/damage='Y'">0007</xsl:when>
							<xsl:otherwise>0003</xsl:otherwise>
						</xsl:choose>
					</real:HasExistingDamage>
					<real:HasListedModifications i:nil="true"/> <!-- Do not ask this question -->
					<real:HasModifications>
						<xsl:choose>
							<xsl:when test="vehicle/modifications='Y'">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</real:HasModifications>
					<real:HasNonStandardSecurityFeatures>
						<xsl:choose>
							<xsl:when test="vehicle/securityOptionCheck='Y'">false</xsl:when>
							<xsl:otherwise>true</xsl:otherwise>
						</xsl:choose>
					</real:HasNonStandardSecurityFeatures>
					<real:HasOptionalFactoryFittedExtras>
						<xsl:choose>
							<xsl:when test="accs or vehicle/factoryOptions = 'Y'">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</real:HasOptionalFactoryFittedExtras>
					<real:IsRegisteredOwner i:nil="true"/> <!-- Do not ask this question -->
					<real:KmsTravelledPerYear>
						<xsl:choose>
							<xsl:when test="vehicle/annualKilometres != ''">
								<xsl:call-template name="util_numbersOnly">
									<xsl:with-param name="value" select="format-number(vehicle/annualKilometres, '########')" />
								</xsl:call-template>
							</xsl:when>
						</xsl:choose>
					</real:KmsTravelledPerYear>
					<real:LimitKmsPerYear i:nil="true"/> <!-- Do not ask this question -->
					<real:MainDriver>
						<real:AgeFullLicence><xsl:value-of select="drivers/regular/licenceAge" /></real:AgeFullLicence>
						<real:DateOfBirth>
							<xsl:choose>
								<xsl:when test="drivers/regular/licenceAge != ''">
									<xsl:call-template name="util_isoDate">
										<xsl:with-param name="eurDate" select="$regularDob" />
									</xsl:call-template>
									<xsl:value-of select="$timeString" />
								</xsl:when>
							</xsl:choose>
						</real:DateOfBirth>
						<real:Email><xsl:value-of select="contact/email" /></real:Email>
						<real:EmploymentStatus>
							<xsl:choose>
								<xsl:when test="drivers/regular/employmentStatus='E'">EMFT</xsl:when>
								<xsl:when test="drivers/regular/employmentStatus='P'">EMPT</xsl:when>
								<xsl:when test="drivers/regular/employmentStatus='H'">HMDT</xsl:when>
								<xsl:when test="drivers/regular/employmentStatus='C'">HMDT</xsl:when>
								<xsl:when test="drivers/regular/employmentStatus='R'">RETD</xsl:when>
								<xsl:when test="drivers/regular/employmentStatus='S'">SFEM</xsl:when>
								<xsl:when test="drivers/regular/employmentStatus='F'">STDT</xsl:when>
								<xsl:when test="drivers/regular/employmentStatus='U'">UNEM</xsl:when>
								<xsl:when test="drivers/regular/employmentStatus='A'">HMDT</xsl:when>
								<xsl:otherwise>UNEM</xsl:otherwise>
							</xsl:choose>
						</real:EmploymentStatus>
						<xsl:if test="drivers/regular/firstname != ''">
							<real:FirstName><xsl:value-of select="drivers/regular/firstname" /></real:FirstName>
						</xsl:if>
						<real:Gender>
							<xsl:choose>
								<xsl:when test="drivers/regular/gender='M'">M</xsl:when>
								<xsl:otherwise>F</xsl:otherwise>
							</xsl:choose>
						</real:Gender>
						<real:OptIn>false</real:OptIn><!-- Do not allow marketing -->
						<!-- Provide a default phone when not supplied -->
						<xsl:variable name="def_phone">
							<xsl:choose>
								<xsl:when test="contact/phone != ''">
									<xsl:value-of select="contact/phone" />
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<real:PhoneNumber>
							<xsl:call-template name="util_numbersOnly">
								<xsl:with-param name="value" select="$def_phone" />
							</xsl:call-template>
						</real:PhoneNumber>
						<xsl:if test="contact/phone != ''">
							<real:PhoneNumberType>Home</real:PhoneNumberType>
						</xsl:if>
						<xsl:if test="drivers/regular/surname != ''">
							<real:Surname><xsl:value-of select="drivers/regular/surname" /></real:Surname>
						</xsl:if>
					</real:MainDriver>
					<real:NightTimeKept>
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
					</real:NightTimeKept>
					<real:NightTimePostcode><xsl:value-of select="riskAddress/postCode" /></real:NightTimePostcode>

					<xsl:choose>
						<xsl:when test="vehicle/securityOptionCheck='Y'"> <!-- Introduced a hidden value to check if the Alarm and Immobiliser are pre-defined in features and pass an empty array-->
							<real:NonStandardSecurityFeatures xmlns:q1="http://schemas.microsoft.com/2003/10/Serialization/Arrays" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="vehicle/securityOption='A'">
									<real:NonStandardSecurityFeatures xmlns:q1="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
										<arr:string>CS05;Alarm</arr:string>
									</real:NonStandardSecurityFeatures>
								</xsl:when>
								<xsl:when test="vehicle/securityOption='I'">
									<real:NonStandardSecurityFeatures xmlns:q1="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
										<arr:string>CS04;Immobiliser</arr:string>
									</real:NonStandardSecurityFeatures>
								</xsl:when>
								<xsl:when test="vehicle/securityOption='B'">
									<real:NonStandardSecurityFeatures xmlns:q1="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
										<arr:string>CS05;Alarm</arr:string>
										<arr:string>CS04;Immobiliser</arr:string>
									</real:NonStandardSecurityFeatures>
								</xsl:when>
								<xsl:otherwise>
									<real:NonStandardSecurityFeatures xmlns:q1="http://schemas.microsoft.com/2003/10/Serialization/Arrays" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:choose>
						<xsl:when test="accs or vehicle/factoryOptions = 'Y'">
							<real:OptionalFactoryFittedExtras xmlns:q2="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
							<xsl:for-each select="accs/*">
								<arr:string>
									<xsl:value-of select="desc/HOLL/" />
								</arr:string>
							</xsl:for-each>
							</real:OptionalFactoryFittedExtras>
						</xsl:when>
						<xsl:otherwise>
							<real:OptionalFactoryFittedExtras xmlns:q2="http://schemas.microsoft.com/2003/10/Serialization/Arrays" i:nil="true"/>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:variable name="totalAccessoryValue" select="sum(accs/*/prc)" />

					<xsl:choose>
						<xsl:when test="$totalAccessoryValue > 0">
							<real:OptionalFactoryFittedExtrasValue xmlns:q2="http://schemas.microsoft.com/2003/10/Serialization/Arrays"><xsl:value-of select="$totalAccessoryValue" /></real:OptionalFactoryFittedExtrasValue>
						</xsl:when>
						<xsl:when test="vehicle/factoryOptions = 'Y' and not($totalAccessoryValue)">
							<real:OptionalFactoryFittedExtrasValue>0</real:OptionalFactoryFittedExtrasValue>
						</xsl:when>
						<xsl:otherwise><real:OptionalFactoryFittedExtrasValue i:nil="true"/></xsl:otherwise>
					</xsl:choose>

					<xsl:choose>
						<xsl:when test="drivers/young/exists='Y'">
							<real:SecondaryDrivers>
								<real:Driver>
									<real:AgeFullLicence><xsl:value-of select="drivers/young/licenceAge"/></real:AgeFullLicence>
									<real:DateOfBirth>
										<xsl:call-template name="util_isoDate">
											<xsl:with-param name="eurDate" select="$youngDob" />
										</xsl:call-template>
										<xsl:value-of select="$timeString" />
									</real:DateOfBirth>
									<real:Email i:nil="true"/> <!-- Do not ask this question -->
									<real:EmploymentStatus i:nil="true"/> <!-- Do not ask this question -->
									<real:FirstName i:nil="true"/><!-- Do not ask this question -->
									<real:Gender><xsl:value-of select="drivers/young/gender" /></real:Gender>
									<real:OptIn>false</real:OptIn> <!-- Do not allow marketing -->
									<real:PhoneNumber i:nil="true"/><!-- Do not ask this question -->
									<real:PhoneNumberType i:nil="true"/> <!-- Do not ask this question -->
									<real:Surname i:nil="true"/> <!-- Do not ask this question -->
								</real:Driver>
							</real:SecondaryDrivers>
						</xsl:when>
						<xsl:otherwise>
							<real:SecondaryDrivers i:nil="true" />
						</xsl:otherwise>
					</xsl:choose>
					<a:TransactionReference><xsl:value-of select="$transactionId" /></a:TransactionReference>
				</tem:motorRisk>
			</tem:GetMotorQuote>
		</soapenv:Body>
	</soapenv:Envelope>
	</xsl:template>
</xsl:stylesheet>