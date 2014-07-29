<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS -->
	<xsl:import href="../includes/utils.xsl"/>
	<xsl:import href="../includes/get_street_name.xsl"/>

	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>

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
	<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" >
		<s:Body>
			<GetQuote xmlns="http://tempuri.org/">
				<token><xsl:value-of select="token" /></token>

				<risk xmlns:a="http://schemas.datacontract.org/2004/07/Real.Aggregator.Service.DataContracts" xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns:q1="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
					<a:AgreedValue>
						<xsl:choose>
							<xsl:when test="vehicle/marketValue != ''"><xsl:value-of select="vehicle/marketValue"/></xsl:when>
						</xsl:choose>
					</a:AgreedValue>
					<a:CarSeries><xsl:value-of select="glasses" /></a:CarSeries>
					<a:CarUsage>
						<xsl:choose>
							<xsl:when test="vehicle/use='02'">P</xsl:when>
							<xsl:when test="vehicle/use='11'">C</xsl:when>
							<xsl:when test="vehicle/use='12'">C</xsl:when>
							<xsl:when test="vehicle/use='13'">B</xsl:when>
							<xsl:otherwise>Other</xsl:otherwise>
						</xsl:choose>
					</a:CarUsage>
					<a:CarUsageIncome>
						<xsl:choose>
							<xsl:when test="$vehicleUse='13'">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</a:CarUsageIncome>
					<a:CarYear>
						<xsl:choose>
							<xsl:when test="vehicle/year != ''"><xsl:value-of select="vehicle/year" /></xsl:when>
						</xsl:choose>
					</a:CarYear>
					<a:Claims i:nil="true"/>
					<a:CoverStartDate>
						<xsl:choose>
							<xsl:when test="options/commencementDate != ''">
								<xsl:value-of select="$commencementDate" />
							</xsl:when>
						</xsl:choose>
					</a:CoverStartDate>
					<a:DayTimePostcode><xsl:value-of select="riskAddress/postCode" /></a:DayTimePostcode>
					<a:ExcludeDriversUnder25>
						<xsl:choose>
							<xsl:when test="options/driverOption=''">false</xsl:when><!-- Default if the person is under 18 (field hidden) -->
							<xsl:when test="options/driverOption='3'">false</xsl:when>
							<xsl:when test="options/driverOption='H'">false</xsl:when>
							<xsl:otherwise>true</xsl:otherwise>
						</xsl:choose>
					</a:ExcludeDriversUnder25>
					<a:FinanceType>
						<xsl:choose>
							<xsl:when test="vehicle/finance='NO'">O</xsl:when>
							<xsl:when test="vehicle/finance='LE'">L</xsl:when>
							<xsl:when test="vehicle/finance='HP'">L</xsl:when>
							<xsl:otherwise>O</xsl:otherwise>
						</xsl:choose>
					</a:FinanceType>
					<xsl:choose>
						<xsl:when test="drivers/regular/claims='N'"><a:HasClaims>false</a:HasClaims></xsl:when>
						<xsl:when test="drivers/regular/claims='Y'"><a:HasClaims>true</a:HasClaims></xsl:when>
					</xsl:choose>
					<a:HasExistingDamage>
						<xsl:choose>
							<xsl:when test="vehicle/damage='Y'">0007</xsl:when>
							<xsl:otherwise>0003</xsl:otherwise>
						</xsl:choose>
					</a:HasExistingDamage>
					<a:HasModifications>
						<xsl:choose>
							<xsl:when test="vehicle/modifications='Y'">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</a:HasModifications>
					<a:HasNonStandardSecurityFeatures>
						<xsl:choose>
							<xsl:when test="vehicle/securityOptionCheck='Y'">false</xsl:when>
							<xsl:otherwise>true</xsl:otherwise>
						</xsl:choose>
					</a:HasNonStandardSecurityFeatures>
					<a:HasOptionalFactoryFittedExtras>
						<xsl:choose>
							<xsl:when test="accs or vehicle/factoryOptions = 'Y'">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</a:HasOptionalFactoryFittedExtras>
					<a:KmsTravelledPerYear>
						<xsl:choose>
							<xsl:when test="vehicle/annualKilometres != ''">
								<xsl:call-template name="util_numbersOnly">
									<xsl:with-param name="value" select="format-number(vehicle/annualKilometres, '########')" />
								</xsl:call-template>
							</xsl:when>
						</xsl:choose>
					</a:KmsTravelledPerYear>
					<a:MainDriver>
						<a:AgeFullLicence><xsl:value-of select="drivers/regular/licenceAge" /></a:AgeFullLicence>
						<a:DateOfBirth>
							<xsl:choose>
								<xsl:when test="drivers/regular/licenceAge != ''">
									<xsl:call-template name="util_isoDate">
										<xsl:with-param name="eurDate" select="$regularDob" />
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
						</a:DateOfBirth>
						<a:Email><xsl:value-of select="contact/email" /></a:Email>
						<a:EmploymentStatus>
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
						</a:EmploymentStatus>
						<xsl:if test="drivers/regular/firstname != ''">
							<a:FirstName><xsl:value-of select="drivers/regular/firstname" /></a:FirstName>
						</xsl:if>
						<a:Gender>
							<xsl:choose>
								<xsl:when test="drivers/regular/gender='M'">M</xsl:when>
								<xsl:otherwise>F</xsl:otherwise>
							</xsl:choose>
						</a:Gender>
						<a:OptIn>
							<xsl:choose>
								<xsl:when test="contact/marketing='Y'">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</a:OptIn>
						<!-- Provide a default phone when not supplied -->
						<xsl:variable name="def_phone">
						<xsl:choose>
							<xsl:when test="contact/phone != ''">
								<xsl:value-of select="contact/phone" />
							</xsl:when>
							<xsl:otherwise>

							</xsl:otherwise>
						</xsl:choose>
						</xsl:variable>
						<a:PhoneNumber>
							<xsl:call-template name="util_numbersOnly">
								<xsl:with-param name="value" select="$def_phone" />
							</xsl:call-template>
						</a:PhoneNumber>
						<xsl:if test="contact/phone != ''">
							<a:PhoneNumberType>Home</a:PhoneNumberType>
						</xsl:if>
						<xsl:if test="drivers/regular/surname != ''">
							<a:Surname><xsl:value-of select="drivers/regular/surname" /></a:Surname>
						</xsl:if>
					</a:MainDriver>
					<a:NightTimeKept>
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
					</a:NightTimeKept>
					<a:NightTimePostcode><xsl:value-of select="riskAddress/postCode" /></a:NightTimePostcode>


					<xsl:choose>
						<xsl:when test="vehicle/securityOptionCheck='Y'"> <!-- Introduced a hidden value to check if the Alarm and Immobiliser are pre-defined in features and pass an empty array-->
							<a:NonStandardSecurityFeatures xmlns:b="http://schemas.microsoft.com/2003/10/Serialization/Arrays" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="vehicle/securityOption='A'">
									<a:NonStandardSecurityFeatures xmlns:b="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
										<b:string>CS05;Alarm</b:string>
									</a:NonStandardSecurityFeatures>
								</xsl:when>
								<xsl:when test="vehicle/securityOption='I'">
									<a:NonStandardSecurityFeatures xmlns:b="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
										<b:string>CS04;Immobiliser</b:string>
									</a:NonStandardSecurityFeatures>
								</xsl:when>
								<xsl:when test="vehicle/securityOption='B'">
									<a:NonStandardSecurityFeatures xmlns:b="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
										<b:string>CS05;Alarm</b:string>
										<b:string>CS04;Immobiliser</b:string>
									</a:NonStandardSecurityFeatures>
								</xsl:when>
								<xsl:otherwise>
									<a:NonStandardSecurityFeatures xmlns:b="http://schemas.microsoft.com/2003/10/Serialization/Arrays" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>



					<xsl:choose>
						<xsl:when test="drivers/regular/claims='N'"><a:NumberClaims>0</a:NumberClaims></xsl:when>
						<xsl:when test="drivers/regular/claims='Y'"><a:NumberClaims>1</a:NumberClaims></xsl:when>
						<xsl:when test="drivers/regular/claims='U'"><a:NumberClaims>0</a:NumberClaims></xsl:when>
					</xsl:choose>

					<xsl:choose>
						<xsl:when test="accs or vehicle/factoryOptions = 'Y'">
							<a:OptionalFactoryFittedExtras xmlns:b="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
							<xsl:for-each select="accs/*">
								<b:string>
									<xsl:choose>
										<xsl:when test="sel = 'CAD'">FE14;Other</xsl:when>
										<xsl:when test="sel = 'CD0'">FE14;Other</xsl:when>
										<xsl:when test="sel = 'CB'">FE01;Air Conditioner</xsl:when>
										<xsl:when test="sel = 'CA'">FE14;Other</xsl:when>
										<xsl:when test="sel = 'CC'">FE29;Wheels: Alloy/Mag Wheels including Wheel Lock nuts</xsl:when>
										<xsl:when test="sel = 'C&amp;'">FE13;Music &amp;amp;Visual equipment: Hi Fi, Amplifier, CD/MP3 Player/Stacker, DVD Player, Boot Speakers; Sub-woofers</xsl:when>
										<xsl:when test="sel = 'C8'">FE13;Music &amp;amp;Visual equipment: Hi Fi, Amplifier, CD/MP3 Player/Stacker, DVD Player, Boot Speakers; Sub-woofers</xsl:when>
										<xsl:when test="sel = 'CE'">FE04;Brakes: performance brakes; electric brakes/trailer controls</xsl:when>
										<xsl:when test="sel = 'CF'">FE02;Bars: Bull Bar &amp;amp;/or Winch; Tow Bars/Tow packs, nudge bars front and rear</xsl:when>
										<xsl:when test="sel = 'C#'">FE99;Camper Added</xsl:when>
										<xsl:when test="sel = 'C7'">FE27;Ute covers, tops and canopies: Tray Top; Tonneau cover; Fibreglass, aluminium or canvas canopies</xsl:when>
										<xsl:when test="sel = 'C/'">FE17;Protectors - internal: Boot Liner, seat covers, mud flaps, cargo barrier, dash, floor mat(s)</xsl:when>
										<xsl:when test="sel = 'CG'">FE05;Camping/off road extras: dual batteries, dual fuel tanks (not LPG), snorkel, CB/UHF Radio (Hardwired Only)</xsl:when>
										<xsl:when test="sel = 'CH'">FE13;Music &amp;amp; Visual equipment: Hi Fi, Amplifier, CD/MP3 Player/Stacker, DVD Player, Boot Speakers; Sub-woofers</xsl:when>
										<xsl:when test="sel = 'C6'">FE20;Security features: Alarm, Central/Remote Locking, Immobiliser</xsl:when>
										<xsl:when test="sel = 'C{'">FE14;Other</xsl:when>
										<xsl:when test="sel = 'CI'">FE06;Cruise Control</xsl:when>
										<xsl:when test="sel = 'C@'">FE05;Camping/off road extras: dual batteries, dual fuel tanks (not LPG), snorkel, CB/UHF Radio (Hardwired Only)</xsl:when>
										<xsl:when test="sel = 'CD1'">FE05;Camping/off road extras: dual batteries, dual fuel tanks (not LPG), snorkel, CB/UHF Radio (Hardwired Only)</xsl:when>
										<xsl:when test="sel = 'CQ'">FE08;Dual Fuel/LPG Conversion</xsl:when>
										<xsl:when test="sel = 'CAI'">FE13;Music &amp;amp; Visual equipment: Hi Fi, Amplifier, CD/MP3 Player/Stacker, DVD Player, Boot Speakers; Sub-woofers</xsl:when>
										<xsl:when test="sel = 'CD7'">FE04;Brakes: performance brakes; electric brakes/trailer controls</xsl:when>
										<xsl:when test="sel = 'C_'">FE15;Paint and paint protection: paint/signwriting; Fabric, Paint or Rust Protection</xsl:when>
										<xsl:when test="sel = 'CL'">FE11;Lights: Fog/Driving Lights &amp;amp;/or Spot Lights</xsl:when>
										<xsl:when test="sel = 'C0'">FE29;Wheels: Alloy/Mag Wheels including Wheel Lock nuts</xsl:when>
										<xsl:when test="sel = 'CAJ'">FE09;GPS / Satellite Navigation (Hardwired Only)</xsl:when>
										<xsl:when test="sel = 'C*'">FE13;Music &amp;amp; Visual equipment: Hi Fi, Amplifier, CD/MP3 Player/Stacker, DVD Player, Boot Speakers; Sub-woofers</xsl:when>
										<xsl:when test="sel = 'CD3'">FE18;Racks: Roof racks and Ladder racks</xsl:when>
										<xsl:when test="sel = 'CAE'">FE10;Leather Interior</xsl:when>
										<xsl:when test="sel = 'CO'">FE29;Wheels: Alloy/Mag Wheels including Wheel Lock nuts</xsl:when>
										<xsl:when test="sel = 'C!'">FE05;Camping/off road extras: dual batteries, dual fuel tanks (not LPG), snorkel, CB/UHF Radio (Hardwired Only)</xsl:when>
										<xsl:when test="sel = 'CK'">FE12;Mobile Phone Kit including Bluetooth (Hardwired)</xsl:when>
										<xsl:when test="sel = 'CAB'">FE29;Wheels: Alloy/Mag Wheels including Wheel Lock nuts</xsl:when>
										<xsl:when test="sel = 'CN'">FE02;Bars: Bull Bar &amp;amp;/or Winch; Tow Bars/Tow packs, nudge bars front and rear</xsl:when>
										<xsl:when test="sel = 'C2'">FE02;Bars: Bull Bar &amp;amp;/or Winch; Tow Bars/Tow packs, nudge bars front and rear</xsl:when>
										<xsl:when test="sel = 'C='">FE15;Paint and paint protection: paint/signwriting; Fabric, Paint or Rust Protection</xsl:when>
										<xsl:when test="sel = 'CAC'">FE15;Paint and paint protection: paint/signwriting; Fabric, Paint or Rust Protection</xsl:when>
										<xsl:when test="sel = 'CT'">FE16;Protectors - external: Car Bra; Bonnet protector; Head light protectors; Mud flaps; Weather/wind shield(s)/Louvre/Shade</xsl:when>
										<xsl:when test="sel = 'C%'">FE16;Protectors - external: Car Bra; Bonnet protector; Head light protectors; Mud flaps; Weather/wind shield(s)/Louvre/Shade</xsl:when>
										<xsl:when test="sel = 'CR'">FE30;Windows: Power Windows &amp;amp;/or Window tinting films</xsl:when>
										<xsl:when test="sel = 'CS'">FE13;Music &amp;amp; Visual equipment: Hi Fi, Amplifier, CD/MP3 Player/Stacker, DVD Player, Boot Speakers; Sub-woofers</xsl:when>
										<xsl:when test="sel = 'CM'">FE11;Lights: Fog/Driving Lights &amp;amp;/or Spot Lights</xsl:when>
										<xsl:when test="sel = 'CAA'">FE03;Body Kit - genuine, non factory fitted, including spoiler</xsl:when>
										<xsl:when test="sel = 'CAF'">FE19;Reverse Monitoring: Reversing Sensors, Camera and Monitor/TV</xsl:when>
										<xsl:when test="sel = 'CJ'">FE99;Roll Bar (Utility)</xsl:when>
										<xsl:when test="sel = 'CV'">FE18;Racks: Roof racks and Ladder racks</xsl:when>
										<xsl:when test="sel = 'C-'">FE15;Paint and paint protection: paint/signwriting; Fabric, Paint or Rust Protection</xsl:when>
										<xsl:when test="sel = 'CW'">FE17;Protectors - internal: Boot Liner, seat covers, mud flaps, cargo barrier, dash, floor mat(s)</xsl:when>
										<xsl:when test="sel = 'CD4'">FE14;Other</xsl:when>
										<xsl:when test="sel = 'C9'">FE05;Camping/off road extras: dual batteries, dual fuel tanks (not LPG), snorkel, CB/UHF Radio (Hardwired Only)</xsl:when>
										<xsl:when test="sel = 'CD2'">FE16;Protectors - external: Car Bra; Bonnet protector; Head light protectors; Mud flaps; Weather/wind shield(s)/Louvre/Shade</xsl:when>
										<xsl:when test="sel = 'CY'">FE22;Steering Wheel &amp;amp;/or Gear Shift Knob or Short Shifter - Sports Type</xsl:when>
										<xsl:when test="sel = 'C3'">FE21;Side Rails - Step Up / Side Steps</xsl:when>
										<xsl:when test="sel = 'CD9'">FE13;Music &amp;amp; Visual equipment: Hi Fi, Amplifier, CD/MP3 Player/Stacker, DVD Player, Boot Speakers; Sub-woofers</xsl:when>
										<xsl:when test="sel = 'CZ'">FE23;Sunroof</xsl:when>
										<xsl:when test="sel = 'CAK'">FE13;Music &amp;amp; Visual equipment: Hi Fi, Amplifier, CD/MP3 Player/Stacker, DVD Player, Boot Speakers; Sub-woofers</xsl:when>
										<xsl:when test="sel = 'CAG'">FE27;Ute covers, tops and canopies: Tray Top; Tonneau cover; Fibreglass, aluminium or canvas canopies</xsl:when>
										<xsl:when test="sel = 'C1'">FE02;Bars: Bull Bar &amp;amp;/or Winch; Tow Bars/Tow packs, nudge bars front and rear</xsl:when>
										<xsl:when test="sel = 'C}'">FE27;Ute covers, tops and canopies: Tray Top; Tonneau cover; Fibreglass, aluminium or canvas canopies</xsl:when>
										<xsl:when test="sel = 'CAH'">FE27;Ute covers, tops and canopies: Tray Top; Tonneau cover; Fibreglass, aluminium or canvas canopies</xsl:when>
										<xsl:when test="sel = 'C4'">FE02;Bars: Bull Bar &amp;amp;/or Winch; Tow Bars/Tow packs, nudge bars front and rear</xsl:when>
										<xsl:when test="sel = 'CU'">FE16;Protectors - external: Car Bra; Bonnet protector; Head light protectors; Mud flaps; Weather/wind shield(s)/Louvre/Shade</xsl:when>
										<xsl:when test="sel = 'C5'">FE30;Windows: Power Windows &amp;amp;/or Window tinting films</xsl:when>
									</xsl:choose>
								</b:string>
							</xsl:for-each>
							</a:OptionalFactoryFittedExtras>
						</xsl:when>
						<xsl:otherwise>
							<a:OptionalFactoryFittedExtras xmlns:b="http://schemas.microsoft.com/2003/10/Serialization/Arrays" i:nil="true"/>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:variable name="totalAccessoryValue" select="sum(accs/*/prc)" />

					<xsl:choose>
						<xsl:when test="$totalAccessoryValue > 0">
							<a:OptionalFactoryFittedExtrasValue><xsl:value-of select="$totalAccessoryValue" /></a:OptionalFactoryFittedExtrasValue>
						</xsl:when>
						<xsl:when test="vehicle/factoryOptions = 'Y' and not($totalAccessoryValue)">
							<a:OptionalFactoryFittedExtrasValue>0</a:OptionalFactoryFittedExtrasValue>
						</xsl:when>
						<xsl:otherwise><a:OptionalFactoryFittedExtrasValue i:nil="true"/></xsl:otherwise>
					</xsl:choose>
					<a:RiskAddress>
						<a:AddressLine1><xsl:value-of select="$streetNameLower" /></a:AddressLine1>
						<a:AddressLine2 i:nil="true"></a:AddressLine2>
						<a:AddressLine3 i:nil="true"></a:AddressLine3>
						<a:Country>AUSTRALIA</a:Country>
						<a:PostCode><xsl:value-of select="riskAddress/postCode" /></a:PostCode>
						<a:State><xsl:value-of select="$state" /></a:State>
						<a:Suburb><xsl:value-of select="riskAddress/suburbName" /></a:Suburb>
					</a:RiskAddress>
					<xsl:choose>
						<xsl:when test="drivers/young/exists='Y'">
							<a:SecondaryDrivers>
								<a:Driver>
									<a:AgeFullLicence><xsl:value-of select="drivers/young/licenceAge"/></a:AgeFullLicence>
									<a:DateOfBirth>
										<xsl:call-template name="util_isoDate">
											<xsl:with-param name="eurDate" select="$youngDob" />
										</xsl:call-template>
									</a:DateOfBirth>
									<a:Gender><xsl:value-of select="drivers/young/gender" /></a:Gender>
								</a:Driver>
							</a:SecondaryDrivers>
						</xsl:when>
						<xsl:otherwise>
							<a:SecondaryDrivers i:nil="true" />
						</xsl:otherwise>
					</xsl:choose>
					<a:TransactionReference><xsl:value-of select="$transactionId" /></a:TransactionReference>
				</risk>
			</GetQuote>
		</s:Body>
	</s:Envelope>
	</xsl:template>

<!-- UTILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="util_isoDate">
		<xsl:param name="eurDate"/>

		<xsl:variable name="day" 		select="substring-before($eurDate,'/')" />
		<xsl:variable name="month-temp" select="substring-after($eurDate,'/')" />
		<xsl:variable name="month" 		select="substring-before($month-temp,'/')" />
		<xsl:variable name="year" 		select="substring-after($month-temp,'/')" />

		<xsl:value-of select="$year" />
		<xsl:value-of select="'-'" />
		<xsl:value-of select="format-number($month, '00')" />
		<xsl:value-of select="'-'" />
		<xsl:value-of select="format-number($day, '00')" />
		<xsl:value-of select="'T00:00:00'" />
	</xsl:template>
</xsl:stylesheet>