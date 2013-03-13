<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xalan="http://xml.apache.org/xalan">

<!-- IMPORTS -->
	<xsl:import href="../includes/get_street_name.xsl"/>
	<xsl:import href="../includes/utils.xsl"/>

	<xsl:param name="today" />
	<xsl:param name="request" />	
	<xsl:param name="servicePassword" />

	<xsl:variable name="tableSoundAccs" select="document('AGIS_sound_accessories.xml')" />
	<xsl:variable name="tableOtherAccs" select="document('AGIS_other_accessories.xml')" />
	
<!-- MAIN TEMPLATE -->	
	<xsl:template match="/quote">
	
		<xsl:variable name="commencementDate">
			<xsl:call-template name="util_formatEurDate">
				<xsl:with-param name="eurDate" select="options/commencementDate" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="commencementDateDay"   select="substring($commencementDate,1,2)" />
		<xsl:variable name="commencementDateMonth" select="substring($commencementDate,4,2)" />
		<xsl:variable name="commencementDateYear"  select="substring($commencementDate,7,4)" />

		<!-- Regular Driver Date Of Birth -->
		<xsl:variable name="regularDob">
			<xsl:call-template name="util_formatEurDate">
				<xsl:with-param name="eurDate" select="drivers/regular/dob" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="regularDobDay" select="substring($regularDob,1,2)" />
		<xsl:variable name="regularDobMonth" select="substring($regularDob,4,2)" />
		<xsl:variable name="regularDobYear" select="substring($regularDob,7,4)" />

		<!-- Regular driver - Licence Year -->
		<xsl:variable name="rgdLicenceYear">
			<xsl:variable name="dobYr" select="substring($regularDob,7,4)" />
			<xsl:variable name="licAge" select="drivers/regular/licenceAge" />
			<xsl:value-of select="$dobYr + $licAge" />
		</xsl:variable>

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
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:quot="http://services.fastr.com.au/Quotation" xmlns:quotdata="http://services.fastr.com.au/Quotation/Data" xmlns:motordata="http://services.fastr.com.au/Motor/Data" xmlns:data="http://services.fastr.com.au/Data" xmlns:i="http://www.w3.org/2001/XMLSchema-instance">
		   <soapenv:Header/>
		   <soapenv:Body>
      			<quot:RequestInitialQuotation>
					
					<quot:quotationRequest xmlns:quotdata="http://services.fastr.com.au/Quotation/Data">
					
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
						
						<quotdata:CustomerNumber i:nil="true" />
				        <quotdata:FinanceDetails i:nil="true" />
				        <quotdata:FmoCustomerNumber i:nil="true" />
				        <quotdata:Fsg i:nil="true" />
				        <quotdata:GapQuotationItem i:nil="true" />
				        <quotdata:LgiQuotationItem i:nil="true" />
				        <quotdata:LtiQuotationItem i:nil="true" />
						
						<quotdata:MainInsured xmlns:quotdata="http://services.fastr.com.au/Quotation/Data">
						
							<Accidents xmlns="http://services.fastr.com.au/Quotation/Data" xmlns:b="http://services.fastr.com.au/Motor/Data" i:nil="true" />
							
							<DateOfBirth xmlns="http://services.fastr.com.au/Quotation/Data" xmlns:b="http://services.fastr.com.au/Data">
								<b:Day>
									<xsl:value-of select="$regularDobDay" />
								</b:Day>
								<b:Month>
									<xsl:value-of select="$regularDobMonth" />
								</b:Month>
								<b:Year>
									<xsl:value-of select="$regularDobYear" />
								</b:Year>
							</DateOfBirth>

							<FirstName xmlns="http://services.fastr.com.au/Quotation/Data" i:nil="true" />
<!-- 							
							<FirstName xmlns="http://services.fastr.com.au/Quotation/Data">
								<xsl:value-of select="drivers/regular/firstname" />
							</FirstName>
 -->						
							<Gender xmlns="http://services.fastr.com.au/Quotation/Data">
								<xsl:choose>
									<xsl:when test="drivers/regular/gender='M'">Male</xsl:when>
									<xsl:otherwise>Female</xsl:otherwise>
								</xsl:choose>
							</Gender>
							
							<KilometresPerYear xmlns="http://services.fastr.com.au/Quotation/Data">
								<xsl:call-template name="util_numbersOnly">
									<xsl:with-param name="value" select="format-number(vehicle/annualKilometres, '#')" />
								</xsl:call-template>
							</KilometresPerYear>
							
							<LicenseEndorsements xmlns="http://services.fastr.com.au/Quotation/Data" xmlns:b="http://services.fastr.com.au/Motor/Data" i:nil="true" />
							
							<LicenseNumber xmlns="http://services.fastr.com.au/Quotation/Data" xmlns:b="http://services.fastr.com.au/Motor/Data" i:nil="true" />
							
							<MotoringOffences xmlns="http://services.fastr.com.au/Quotation/Data" xmlns:b="http://services.fastr.com.au/Motor/Data" i:nil="true" />
	
							<Surname xmlns="http://services.fastr.com.au/Quotation/Data" i:nil="true" />	
<!--							
							<Surname xmlns="http://services.fastr.com.au/Quotation/Data">
								<xsl:value-of select="drivers/regular/surname" />
							</Surname>
 -->						
							<Title xmlns="http://services.fastr.com.au/Quotation/Data" i:nil="true" />
							
							<YearFirstLicensed xmlns="http://services.fastr.com.au/Quotation/Data">
								<xsl:value-of select="$rgdLicenceYear" />
							</YearFirstLicensed>

 							<quotdata:Abn i:nil="true" />
							<quotdata:BusinessName i:nil="true" />

							<quotdata:Email>
								<xsl:value-of select="contact/email" />
							</quotdata:Email>

							<quotdata:InputTaxCredit>0</quotdata:InputTaxCredit>
							
							<quotdata:IsBusinessUse>
								<xsl:choose>
									<xsl:when test="vehicle/use='02'">false</xsl:when> <!-- Private/Commuting -->
									<xsl:otherwise>true</xsl:otherwise>
								</xsl:choose>
							</quotdata:IsBusinessUse>
							
							<quotdata:IsRegisteredOwner>true</quotdata:IsRegisteredOwner>
							
							<quotdata:Mobile i:nil="true" />
							<quotdata:Occupation i:nil="true" />
							
							<quotdata:Phone1><xsl:value-of select="contact/phone" /></quotdata:Phone1>
							
							<quotdata:PostCode>
								<xsl:value-of select="$postcode" />
							</quotdata:PostCode>
							
							<quotdata:PostalAddress1>
								<xsl:value-of select="$streetName" />
							</quotdata:PostalAddress1>
							
							<quotdata:RegisteredForGst>false</quotdata:RegisteredForGst>
							
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
							<quotdata:CoverEndDate i:nil="true" />
							<quotdata:CoverTypeCode>MVCMP</quotdata:CoverTypeCode>

							<xsl:choose>
								<xsl:when test="drivers/young/exists = 'Y' and drivers/young/KilometresPerYear != '' and drivers/young/YearFirstLicensed != ''">
								
									<xsl:variable name="youngestDob">
										<xsl:call-template name="util_formatEurDate">
											<xsl:with-param name="eurDate" select="drivers/young/dob" />
										</xsl:call-template>
									</xsl:variable>
									<xsl:variable name="yngDobDay" select="substring($youngestDob,1,2)" />
									<xsl:variable name="yngDobMonth" select="substring($youngestDob,4,2)" />
									<xsl:variable name="yngDobYear" select="substring($youngestDob,7,4)" />
						
									<!-- Youngest driver - Licence Year -->
									<xsl:variable name="yngLicenceYear">
										<xsl:variable name="yngDobYr" select="substring($youngestDob,7,4)" />
										<xsl:variable name="yngLicAge" select="drivers/young/licenceAge" />
										<xsl:value-of select="$yngDobYr + $yngLicAge" />
									</xsl:variable>								
									<!-- TODO:Look at this -->
									<quotdata:AdditionalDrivers>
										<quotdata:Driver>
											<quotdata:Accidents i:nil="true" />
											<quotdata:DateOfBirth>
												<data:Day>
													<xsl:value-of select="$yngDobDay" />
												</data:Day>
												<data:Month>
													<xsl:value-of select="$yngDobMonth" />
												</data:Month>
												<data:Year>
													<xsl:value-of select="$yngDobYear" />
												</data:Year>
											</quotdata:DateOfBirth>
											<quotdata:FirstName i:nil="true" />
											<quotdata:Gender>
												<xsl:choose>
													<xsl:when test="drivers/young/gender='M'">Male</xsl:when>
													<xsl:otherwise>Female</xsl:otherwise>
												</xsl:choose>
											</quotdata:Gender>
											<quotdata:KilometresPerYear><xsl:value-of select="format-number(drivers/young/annualKilometres, '#')" /></quotdata:KilometresPerYear>
											<quotdata:LicenseEndorsements i:nil="true" />
											<quotdata:LicenseNumber i:nil="true" />
											<quotdata:MotoringOffences i:nil="true" />
											<quotdata:Surname i:nil="true" />
											<quotdata:Title i:nil="true" />
											<data:YearFirstLicensed><xsl:value-of select="$yngLicenceYear" /></data:YearFirstLicensed>
											<quotdata:RelationshipToInsured i:nil="true" />
										</quotdata:Driver>
									</quotdata:AdditionalDrivers>
								</xsl:when>
								<xsl:otherwise>
									<quotdata:AdditionalDrivers i:nil="true" />
								</xsl:otherwise>
							</xsl:choose>

							<quotdata:OtherInformation i:nil="true" />
							
							<quotdata:Rating>
								<xsl:value-of select="drivers/regular/ncd" />
							</quotdata:Rating>
							
							<quotdata:RatingProtectionRequired>
								<xsl:choose>
									<xsl:when test="drivers/regular/ncd='5'">
										<xsl:choose>
											<xsl:when test="drivers/regular/ncdpro = 'Y'">true</xsl:when>
											<xsl:otherwise>false</xsl:otherwise>
										</xsl:choose>									
									</xsl:when>
									<xsl:otherwise>
										false
									</xsl:otherwise>
								</xsl:choose>
							</quotdata:RatingProtectionRequired>
							
							<quotdata:Vehicle>
							
								<motordata:DetailsOfExistingDamage i:nil="true" /> <!-- We do not capture this -->
								<motordata:EngineNumber i:nil="true" /> <!-- We do not capture this -->
								
								<motordata:HasAirConditioning>
									<xsl:choose>								
										<xsl:when test="accs/*/sel[text()='CB']">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>											
								</motordata:HasAirConditioning>
								
								<motordata:HasBodyKitModification>false</motordata:HasBodyKitModification>
								<motordata:HasEngineModification>false</motordata:HasEngineModification>
								
								<motordata:HasExistingDamage>
									<xsl:choose>
										<xsl:when test="vehicle/damage = 'Y'">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>	
								</motordata:HasExistingDamage>							

								<motordata:HasExtractorsModification>false</motordata:HasExtractorsModification> <!-- We do not capture this -->

								<motordata:HasImmobiliserOrAlarm>
									<xsl:choose>
										<xsl:when test="vehicle/securityOption = 'N'">false</xsl:when>
										<xsl:otherwise>true</xsl:otherwise>
									</xsl:choose>									
								</motordata:HasImmobiliserOrAlarm> 

								<motordata:HasLoweredChasisModification>false</motordata:HasLoweredChasisModification> <!-- We do not capture this -->
								
								<motordata:HasLoweredSuspensionModification>false</motordata:HasLoweredSuspensionModification> <!-- We do not capture this -->
								
								<motordata:HasOtherModification>
									<xsl:choose>
										<xsl:when test="vehicle/modifications = 'Y'">true</xsl:when>
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
								
								<motordata:OtherModificationAmount>0</motordata:OtherModificationAmount>
								<motordata:OtherModificationDescription i:nil="true" />
								
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
								
								<motordata:RegistrationNumber i:nil="true" />
								
								<motordata:Transmission>
									<xsl:choose>
										<xsl:when test="vehicle/trans = 'M'">Manual</xsl:when>
										<xsl:otherwise>Automatic</xsl:otherwise>
									</xsl:choose>
								</motordata:Transmission>
								<motordata:VehicleCondition>New</motordata:VehicleCondition>
								<motordata:VinNumber i:nil="true" />
							</quotdata:Vehicle>
							
							<quotdata:VehicleGaragedPostcode><xsl:value-of select="$postcode" /></quotdata:VehicleGaragedPostcode>
							
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

						<quotdata:quotationNumber i:nil="true" />
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

					</quot:quotationRequest>
					<!--Optional:-->
					<quot:username><xsl:value-of select="$servicePassword"/></quot:username>
				</quot:RequestInitialQuotation>
				
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

</xsl:stylesheet>

		