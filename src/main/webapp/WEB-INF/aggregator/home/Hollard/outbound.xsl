<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS -->
	<xsl:import href="../../includes/utils.xsl"/>
	<xsl:import href="../../includes/get_street_name.xsl"/>

	<xsl:param name="today" />
	<xsl:param name="transactionId">*NONE</xsl:param>
	<xsl:param name="schemaVersion" />

<!-- MAIN TEMPLATE -->
	<xsl:template match="/home">

		<xsl:variable name="currentDate"><xsl:value-of select="currentDate" /></xsl:variable>

		<!-- LOCAL VARIABLES -->
		<xsl:variable name="streetName">
			<xsl:choose>
				<xsl:when test="property/address/nonStd='Y'">
					<xsl:value-of select="property/address/nonStdStreet" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="property/address/streetName" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="streetNumber">
			<xsl:choose>
				<xsl:when test="property/address/streetNum != ''">
					<xsl:value-of select="property/address/streetNum" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="property/address/houseNoSel" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="unitLevel">
			<xsl:choose>
				<xsl:when test="property/address/nonStd='Y'">
					<xsl:value-of select="property/address/unitShop" />
				</xsl:when>
				<xsl:when test="property/address/unitSel !=''">
					<xsl:value-of select="property/address/unitSel" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="property/address/unitShop" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Commencement date needs to be in DD Mmm YYYY format -->
		<xsl:variable name="commencementDate">
			<xsl:variable name="getMonth"><xsl:value-of select="substring(startDate,4,2)" /></xsl:variable>
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
			<xsl:value-of select="substring(startDate,1,2)" />
			<xsl:value-of select="$Mmm" />
			<xsl:value-of select="substring(startDate,7,4)" />
		</xsl:variable>

		<xsl:variable name="policyExpiryDate">
			<xsl:call-template name="util_isoDate">
				<xsl:with-param name="eurDate" select="disclosures/expiry" />
			</xsl:call-template>
		</xsl:variable>


<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
				xmlns:tem="http://tempuri.org/"
				xmlns:real="http://schemas.datacontract.org/2004/07/Real.Aggregator.Service.DataContracts"
				xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays"
				xmlns:i="http://www.w3.org/2001/XMLSchema-instance">

		<soapenv:Body>
			<tem:GetHomeQuote>
				<tem:token><xsl:value-of select="token" /></tem:token>

				<tem:homeRisk xmlns:a="http://schemas.datacontract.org/2004/07/Real.Aggregator.Service.DataContracts" xmlns:i="http://www.w3.org/2001/XMLSchema-instance" xmlns:q1="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
					<!-- THIS IS TEMPORARY (1 MONTH) TO AUTOMATICALLY KNOCK OUT HOLLARD UNTIL THEY SORT THEIR LIVES OUT -->
					<xsl:choose>
						<xsl:when test="coverAmounts/specifiedPersonalEffects/musical > 25000 or
										coverAmounts/specifiedPersonalEffects/jewellery > 25000 or
										coverAmounts/specifiedPersonalEffects/sporting > 25000 or
										coverAmounts/specifiedPersonalEffects/clothing > 25000 or
										coverAmounts/specifiedPersonalEffects/photo > 25000 or
										coverAmounts/specifiedPersonalEffects/bicycle > 25000">
							<failnode>specifiedPersonalEffects Above Limits</failnode>
						</xsl:when>
						<xsl:otherwise>
											<real:Claims i:nil="true"/>
											<real:CoverStartDate><xsl:value-of select="$commencementDate"/></real:CoverStartDate>
											<real:CurrentlyInsured i:nil="true"/>
											<real:DutyOfDisclosure i:nil="true"/>
											<real:FinanceInstution i:nil="true"/>
											<real:FinanceType i:nil="true"/>
											<real:HasBankrup i:nil="true"/>
											<real:HasClaims>
												<xsl:choose>
													<xsl:when test="disclosures/claims = 'Y'">true</xsl:when>
													<xsl:otherwise>false</xsl:otherwise>
												</xsl:choose>
											</real:HasClaims>
											<real:HasCriminalConviction i:nil="true"/>
											<real:HasFraudOrDishonesty i:nil="true"/>
											<real:HasLicenceCancelled i:nil="true"/>
											<real:InsuredLast30Days i:nil="true"/>
											<real:LeadSource i:nil="true"/>
											<real:MainPolicyDateOfBirth>
												<xsl:call-template name="util_isoDate">
													<xsl:with-param name="eurDate" select="policyHolder/dob" />
												</xsl:call-template>
											</real:MainPolicyDateOfBirth>
											<real:NumberClaims>0</real:NumberClaims>
											<real:PurchasedLast30Days i:nil="true"/>
											<real:QLPromoCode i:nil="true"/>
											<real:RiskAddress>
												<real:AddressLine1><xsl:value-of select="property/address/fullAddressLineOne" /></real:AddressLine1>
												<real:AddressLine2 i:nil="true"/>
												<real:AddressLine3 i:nil="true"/>
												<real:ConfidenceIND>false</real:ConfidenceIND>
												<real:LocCode i:nil="true"/>
												<real:Country>AUSTRALIA</real:Country>
												<real:PostCode><xsl:value-of select="property/address/postCode" /></real:PostCode>
												<real:State><xsl:value-of select="property/address/state" /></real:State>
												<real:Suburb><xsl:value-of select="property/address/suburbName" /></real:Suburb>
											</real:RiskAddress>
											<real:TransactionReference><xsl:value-of select="transactionId" /></real:TransactionReference>
											<real:WhoInsured i:nil="true"/>
											<real:WhyNotInsured i:nil="true"/>
											<!-- BusinessNature -->
											<xsl:choose>
												<xsl:when test="businessActivity/conducted='Y'">
													<xsl:choose>
														<xsl:when test="businessActivity/businessType='Home office'"><real:BusinessNature>BC</real:BusinessNature></xsl:when>
														<xsl:when test="businessActivity/businessType='Surgery/consulting rooms'"><real:BusinessNature>DR</real:BusinessNature></xsl:when>
														<xsl:when test="businessActivity/businessType='Commercial Farming'"><real:BusinessNature>FR</real:BusinessNature></xsl:when>
														<xsl:when test="businessActivity/businessType='Hairdresser/beauty therapist'"><real:BusinessNature>HD</real:BusinessNature></xsl:when>
														<xsl:when test="businessActivity/businessType='Photography studio'"><real:BusinessNature>PS</real:BusinessNature></xsl:when>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise><real:BusinessNature i:nil="true"/></xsl:otherwise>
											</xsl:choose>
											<real:ContentsExcess>
												<xsl:choose>
													<xsl:when test="contentsExcess != ''"><xsl:value-of select="contentsExcess" /></xsl:when>
													<xsl:otherwise><xsl:value-of select="baseContentsExcess" /></xsl:otherwise>
												</xsl:choose>
											</real:ContentsExcess>
											<!-- ContentsValue -->
											<xsl:choose>
												<xsl:when test="coverAmounts/replaceContentsCost != ''"><real:ContentsValue><xsl:value-of select="coverAmounts/replaceContentsCost" /></real:ContentsValue></xsl:when>
												<xsl:otherwise><real:ContentsValue i:nil="true"/></xsl:otherwise>
											</xsl:choose>
											<real:CurrentlyUnderConstruction i:nil="true"/>
											<real:FloorOfAppartment i:nil="true"/>
											<real:HazardousMaterial i:nil="true"/>
											<real:HomeExcess>
												<xsl:choose>
													<xsl:when test="homeExcess != ''"><xsl:value-of select="homeExcess" /></xsl:when>
													<xsl:otherwise><xsl:value-of select="baseHomeExcess" /></xsl:otherwise>
												</xsl:choose>
											</real:HomeExcess>
											<real:HomeSecurity i:nil="true"/>
											<!-- HomeValue -->
											<xsl:choose>
												<xsl:when test="coverAmounts/rebuildCost != ''"><real:HomeValue><xsl:value-of select="coverAmounts/rebuildCost" /></real:HomeValue></xsl:when>
												<xsl:otherwise><real:HomeValue i:nil="true"/></xsl:otherwise>
											</xsl:choose>
											<!-- TIME UNOCCUPIED -->
											<real:HowLongUnoccupied i:nil="true"/>
											<real:HowManyBedrooms i:nil="true"/>
											<real:HowManyLevels i:nil="true"/>
											<real:Is25UsedForBusiness i:nil="true"/>
											<!-- IsHeritageListed -->
											<xsl:choose>
												<xsl:when test="property/isHeritage='Y'"><real:IsHeritageListed>true</real:IsHeritageListed></xsl:when>
												<xsl:when test="property/isHeritage='N'"><real:IsHeritageListed>false</real:IsHeritageListed></xsl:when>
												<xsl:otherwise><real:IsHeritageListed i:nil="true"/></xsl:otherwise>
											</xsl:choose>
											<!-- IsSublet -->
											<xsl:choose>
												<xsl:when test="occupancy/ownProperty = 'Y' and
																occupancy/principalResidence = 'N'"><real:IsSublet>true</real:IsSublet></xsl:when>
												<xsl:when test="occupancy/ownProperty = 'N' and
																occupancy/principalResidence = 'N'"><real:IsSublet>true</real:IsSublet></xsl:when>
												<xsl:otherwise><real:IsSublet i:nil="true"/></xsl:otherwise>
											</xsl:choose>
											<real:IsUnderFinance i:nil="true"/>
											<real:IsUsedForBusiness>
												<xsl:choose>
													<xsl:when test="businessActivity/conducted='Y'">true</xsl:when>
													<xsl:otherwise>false</xsl:otherwise>
												</xsl:choose>
											</real:IsUsedForBusiness>
											<real:IsWellMaintained i:nil="true"/>
											<real:LessThan10Acres i:nil="true"/>
											<!-- MainConstructionMaterial -->
											<xsl:choose>
												<xsl:when test="property/wallMaterial='Cladding'"><real:MainConstructionMaterial>A</real:MainConstructionMaterial></xsl:when>
												<xsl:when test="property/wallMaterial='Besser Block/Cement'"><real:MainConstructionMaterial>C</real:MainConstructionMaterial></xsl:when>
												<xsl:when test="property/wallMaterial='Brick Veneer'"><real:MainConstructionMaterial>V</real:MainConstructionMaterial></xsl:when>
												<xsl:when test="property/wallMaterial='Double Brick'"><real:MainConstructionMaterial>D</real:MainConstructionMaterial></xsl:when>
												<xsl:when test="property/wallMaterial='Non-asbestos Fibro'"><real:MainConstructionMaterial>F</real:MainConstructionMaterial></xsl:when>
												<xsl:when test="property/wallMaterial='Stone'"><real:MainConstructionMaterial>S</real:MainConstructionMaterial></xsl:when>
												<xsl:when test="property/wallMaterial='Weatherboard'"><real:MainConstructionMaterial>T</real:MainConstructionMaterial></xsl:when>
												<xsl:otherwise><real:MainConstructionMaterial i:nil="true"/></xsl:otherwise>
											</xsl:choose>
											<real:MainPolicyHolder>
												<real:DateOfBirth> <!--This is DATETIME for some insane reason... probably mongoose insurrection -->
													<xsl:call-template name="util_isoDate">
														<xsl:with-param name="eurDate" select="policyHolder/dob" />
													</xsl:call-template>T00:00:00</real:DateOfBirth>
												<real:Email i:nil="true"/>
												<real:EmploymentStatus i:nil="true"/> <!-- We do not collect this -->
												<real:FirstName><xsl:value-of select="policyHolder/firstName" /></real:FirstName>
												<!-- GENDER -->
												<xsl:choose>
													<xsl:when test="policyHolder/title = 'MR'"><real:Gender>M</real:Gender></xsl:when>
													<xsl:when test="policyHolder/title = 'MRS' or
																	policyHolder/title = 'MISS' or
																	policyHolder/title = 'MS'"><real:Gender>F</real:Gender></xsl:when>
													<xsl:otherwise><real:Gender i:nil="true"/></xsl:otherwise> <!-- In case we add more titles -->
												</xsl:choose>
												<real:OptIn>false</real:OptIn>  <!-- Customers NEVER opt in to a partners marketing -->
												<!-- PHONE NUMBER -->
												<real:PhoneNumber i:nil="true"/>
												<real:PhoneNumberType i:nil="true"/>  <!-- Unsure what options they are expecting with this -->
												<real:Surname><xsl:value-of select="policyHolder/lastName" /></real:Surname>
											</real:MainPolicyHolder>
											<!--  MainRoofMaterial -->
											<xsl:choose>
												<xsl:when test="property/roofMaterial='Cement Tiles'"><real:MainRoofMaterial>C</real:MainRoofMaterial></xsl:when>
												<xsl:when test="property/roofMaterial='Clay/Terracotta Tiles'"><real:MainRoofMaterial>C</real:MainRoofMaterial></xsl:when>
												<xsl:when test="property/roofMaterial='Colorbond'"><real:MainRoofMaterial>A</real:MainRoofMaterial></xsl:when>
												<xsl:when test="property/roofMaterial='Slate'"><real:MainRoofMaterial>B</real:MainRoofMaterial></xsl:when>
												<xsl:otherwise><real:MainRoofMaterial i:nil="true"/></xsl:otherwise>
											</xsl:choose>
											<real:MoreThan3Unrelated i:nil="true"/>
											<real:PremisesCashValue i:nil="true"/>
											<real:PremisesStockValue i:nil="true"/>
											<real:RemainStructuralUnderConst i:nil="true"/>
											<real:ResidenceUnderTitle i:nil="true"/>
											<xsl:choose>
												<xsl:when test="policyHolder/jointDob != ''">
													<real:SecondaryPolicyHolders>
														<real:PolicyHolder>
															<real:DateOfBirth> <!--This is DATETIME for some insane reason... probably mongoose insurrection -->
																<xsl:call-template name="util_isoDate">
																	<xsl:with-param name="eurDate" select="policyHolder/jointDob" />
																</xsl:call-template>T00:00:00</real:DateOfBirth>
															<real:Email i:nil="true"/>
															<xsl:choose>
																<xsl:when test="policyHolder/jointFirstName != ''">
																	<real:FirstName><xsl:value-of select="policyHolder/jointFirstName" /></real:FirstName>
																</xsl:when>
																<xsl:otherwise><real:FirstName i:nil="true"/></xsl:otherwise>
															</xsl:choose>
															<!-- GENDER -->
															<xsl:choose>
																<xsl:when test="policyHolder/jointTitle = 'MR'"><real:Gender>M</real:Gender></xsl:when>
																<xsl:when test="policyHolder/jointTitle = 'MRS' or
																				policyHolder/jointTitle = 'MISS' or
																				policyHolder/jointTitle = 'MS'"><real:Gender>F</real:Gender></xsl:when>
																<xsl:otherwise><real:Gender i:nil="true"/></xsl:otherwise> <!-- In case we add more titles -->
															</xsl:choose>
															<real:OptIn>false</real:OptIn>  <!-- Customers NEVER opt in to a partners marketing -->
															<real:PhoneNumber i:nil="true"/>
															<xsl:choose>
																<xsl:when test="policyHolder/jointLastName != ''">
																	<real:Surname><xsl:value-of select="policyHolder/jointLastName" /></real:Surname>
																</xsl:when>
																<xsl:otherwise><real:Surname i:nil="true"/></xsl:otherwise>
															</xsl:choose>
														</real:PolicyHolder>
													</real:SecondaryPolicyHolders>
												</xsl:when>
												<xsl:otherwise><real:SecondaryPolicyHolders i:nil="true"/></xsl:otherwise>
											</xsl:choose>
											<!-- SoleFamilyAtResidence -->
											<xsl:choose>
												<xsl:when test="occupancy/ownProperty = 'Y' and
																occupancy/principalResidence = 'Y'"><real:SoleFamilyAtResidence>true</real:SoleFamilyAtResidence></xsl:when>
												<xsl:when test="occupancy/ownProperty = 'N' and
																occupancy/principalResidence = 'Y'"><real:SoleFamilyAtResidence>false</real:SoleFamilyAtResidence></xsl:when>
												<xsl:when test="occupancy/ownProperty = 'Y' and
																occupancy/principalResidence = 'N'"><real:SoleFamilyAtResidence>false</real:SoleFamilyAtResidence></xsl:when>
												<xsl:when test="occupancy/ownProperty = 'N' and
																occupancy/principalResidence = 'N'"><real:SoleFamilyAtResidence>false</real:SoleFamilyAtResidence></xsl:when>
												<xsl:otherwise><real:SoleFamilyAtResidence>true</real:SoleFamilyAtResidence></xsl:otherwise>
											</xsl:choose>
											<xsl:choose>
												<xsl:when test="coverAmounts/specifyPersonalEffects='Y'">
													<real:SpecifiedItems>
													<xsl:choose>
														<xsl:when test="coverAmounts/specifiedPersonalEffects/jewellery>0">
															<real:SpecifiedItem>
																<real:Category>JWL</real:Category>
																<real:Description> Jewellery &amp; Watches </real:Description>
																<real:Value><xsl:value-of select="coverAmounts/specifiedPersonalEffects/jewellery" /></real:Value>
															</real:SpecifiedItem>
														</xsl:when>
													</xsl:choose>
													<xsl:choose>
														<xsl:when test="coverAmounts/specifiedPersonalEffects/sporting>0">
															<real:SpecifiedItem>
																<real:Category>SPO</real:Category>
																<real:Description> Sporting equipment </real:Description>
																<real:Value><xsl:value-of select="coverAmounts/specifiedPersonalEffects/sporting" /></real:Value>
															</real:SpecifiedItem>
														</xsl:when>
													</xsl:choose>
													<xsl:choose>
														<xsl:when test="coverAmounts/specifiedPersonalEffects/clothing>0">
															<real:SpecifiedItem>
																<real:Category>CLO</real:Category>
																<real:Description> Clothing </real:Description>
																<real:Value><xsl:value-of select="coverAmounts/specifiedPersonalEffects/clothing" /></real:Value>
															</real:SpecifiedItem>
														</xsl:when>
													</xsl:choose>
													<xsl:choose>
														<xsl:when test="coverAmounts/specifiedPersonalEffects/musical>0">
															<real:SpecifiedItem>
																<real:Category>MUS</real:Category>
																<real:Description> Musical Equipment </real:Description>
																<real:Value><xsl:value-of select="coverAmounts/specifiedPersonalEffects/musical" /></real:Value>
															</real:SpecifiedItem>
														</xsl:when>
													</xsl:choose>
													<xsl:choose>
														<xsl:when test="coverAmounts/specifiedPersonalEffects/bicycle>0">
															<real:SpecifiedItem>
																<real:Category>SPO</real:Category>
																<real:Description> Bicycles </real:Description>
																<real:Value><xsl:value-of select="coverAmounts/specifiedPersonalEffects/bicycle" /></real:Value>
															</real:SpecifiedItem>
														</xsl:when>
													</xsl:choose>
													<xsl:choose>
														<xsl:when test="coverAmounts/specifiedPersonalEffects/photo>0">
															<real:SpecifiedItem>
																<real:Category>CAM</real:Category>
																<real:Description> Photographic equipment </real:Description>
																<real:Value><xsl:value-of select="coverAmounts/specifiedPersonalEffects/photo" /></real:Value>
															</real:SpecifiedItem>
														</xsl:when><xsl:otherwise><real:SpecifiedItems i:nil="true"/></xsl:otherwise>
													</xsl:choose>
													</real:SpecifiedItems>
												</xsl:when>
												<xsl:otherwise><real:SpecifiedItems i:nil="true"/></xsl:otherwise>
											</xsl:choose>
											<!-- TypeOfBuilding -->
											<xsl:choose>
												<xsl:when test="property/propertyType='Apartment'"><real:TypeOfBuilding>A</real:TypeOfBuilding></xsl:when>
												<xsl:when test="property/propertyType='Duplex'"><real:TypeOfBuilding>D</real:TypeOfBuilding></xsl:when>
												<xsl:when test="property/propertyType='Freestanding Home'"><real:TypeOfBuilding>H</real:TypeOfBuilding></xsl:when>
												<xsl:when test="property/propertyType='Semi-Detached house'"><real:TypeOfBuilding>H</real:TypeOfBuilding></xsl:when>
												<xsl:when test="property/propertyType='Home Unit'"><real:TypeOfBuilding>U</real:TypeOfBuilding></xsl:when>
												<xsl:when test="property/propertyType='Townhouse'"><real:TypeOfBuilding>T</real:TypeOfBuilding></xsl:when>
												<xsl:when test="property/propertyType='Villa'"><real:TypeOfBuilding>V</real:TypeOfBuilding></xsl:when>
												<!-- This is when propertyType = 'Other' -->
												<xsl:otherwise><real:TypeOfBuilding i:nil="true"/></xsl:otherwise>
											</xsl:choose>
											<real:TypeOfCover>
												<xsl:choose>
													<xsl:when test="coverType='Home Cover Only'">Home</xsl:when>
													<xsl:when test="coverType='Contents Cover Only'">Contents</xsl:when>
													<xsl:when test="coverType='Home &amp; Contents Cover'">HomeContents</xsl:when>
												</xsl:choose>
											</real:TypeOfCover>
											<xsl:choose>
												<xsl:when test="coverAmounts/unspecifiedCoverAmount='1000'"><real:UnspecifiedGroupValue>2500</real:UnspecifiedGroupValue></xsl:when>
												<xsl:when test="coverAmounts/unspecifiedCoverAmount='2000'"><real:UnspecifiedGroupValue>2500</real:UnspecifiedGroupValue></xsl:when>
												<xsl:when test="coverAmounts/unspecifiedCoverAmount='3000'"><real:UnspecifiedGroupValue>3000</real:UnspecifiedGroupValue></xsl:when>
												<xsl:when test="coverAmounts/unspecifiedCoverAmount='4000'"><real:UnspecifiedGroupValue>4000</real:UnspecifiedGroupValue></xsl:when>
												<xsl:when test="coverAmounts/unspecifiedCoverAmount='5000'"><real:UnspecifiedGroupValue>5000</real:UnspecifiedGroupValue></xsl:when>
												<xsl:otherwise><real:UnspecifiedGroupValue i:nil="true"/></xsl:otherwise>
											</xsl:choose>
											<real:ValuablesCover i:nil="true"/>
											<real:ValueOfConstruction i:nil="true"/>
											<real:WhenWasResidenceBuilt>
												<xsl:choose>
													<xsl:when test="property/yearBuilt='2011'">2011</xsl:when>
													<xsl:when test="property/yearBuilt='2000'">2005</xsl:when>
													<xsl:when test="property/yearBuilt='1990'">1995</xsl:when>
													<xsl:when test="property/yearBuilt='1980'">1985</xsl:when>
													<xsl:when test="property/yearBuilt='1970'">1975</xsl:when>
													<xsl:when test="property/yearBuilt='1960'">1965</xsl:when>
													<xsl:when test="property/yearBuilt='1945'">1950</xsl:when>
													<xsl:when test="property/yearBuilt='1940'">1942</xsl:when>
													<xsl:when test="property/yearBuilt='1914'">1926</xsl:when>
													<xsl:when test="property/yearBuilt='1900'">1907</xsl:when>
													<xsl:when test="property/yearBuilt='1891'">1895</xsl:when>
													<xsl:when test="property/yearBuilt='1840'">1865</xsl:when>
													<xsl:when test="property/yearBuilt='1839'">1840</xsl:when>
												</xsl:choose>
											</real:WhenWasResidenceBuilt>
											<!-- WhoLivesAtResidence -->
											<xsl:choose>
												<xsl:when test="occupancy/ownProperty = 'Y' and
																occupancy/principalResidence = 'Y'"><real:WhoLivesAtResidence i:nil="true"/></xsl:when>
												<xsl:when test="occupancy/ownProperty = 'N' and
																occupancy/principalResidence = 'Y'"><real:WhoLivesAtResidence>R</real:WhoLivesAtResidence></xsl:when>
												<xsl:when test="occupancy/ownProperty = 'Y' and
																occupancy/principalResidence = 'N'"><real:WhoLivesAtResidence>T</real:WhoLivesAtResidence></xsl:when>
												<xsl:when test="occupancy/ownProperty = 'N' and
																occupancy/principalResidence = 'N'"><real:WhoLivesAtResidence>T</real:WhoLivesAtResidence></xsl:when>
												<xsl:otherwise><real:WhoLivesAtResidence i:nil="true"/></xsl:otherwise>
											</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</tem:homeRisk>
			</tem:GetHomeQuote>
		</soapenv:Body>
	</soapenv:Envelope>
	</xsl:template>

</xsl:stylesheet>
