<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="../../includes/get_street_name.xsl"/>
	<xsl:import href="../../includes/utils.xsl"/>


<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="schemaVersion" />

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/home">

<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->

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
				<xsl:when test="property/address/streetNum !=''">
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

		<xsl:variable name="excessHomeCode">

			<xsl:variable name="excessHomeDif" select="(homeExcess - baseHomeExcess)" />
			<!-- Codes as per A&G Rules -->
			<!-- Home: -->
			<!-- Code	 Description -->
			<!-- E	 $700 EXCESS -->
			<!-- W	 -$200 EXCESS -->
			<!-- Y	 -$100 EXCESS -->
			<!-- 0	 BASIC EXCESS ONLY -->
			<!-- 1	 $100 EXCESS -->
			<!-- 4	 $200 EXCESS -->
			<!-- 9	 $450 EXCESS -->
			<!-- Contents: -->
			<xsl:choose>
				<xsl:when test="baseExcess=''"></xsl:when>
				<xsl:when test="$excessHomeDif = 0">0</xsl:when>
				<xsl:when test="$excessHomeDif = 100">1</xsl:when>
				<xsl:when test="$excessHomeDif = 200">4</xsl:when>
				<xsl:when test="$excessHomeDif = 450">9</xsl:when>
				<xsl:when test="$excessHomeDif = 700">E</xsl:when>
				<xsl:when test="$excessHomeDif = -200">W</xsl:when>
				<xsl:when test="$excessHomeDif = -100">Y</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="excessContentsCode">

			<xsl:variable name="excessContentsDif" select="(contentsExcess - baseContentsExcess)" />
			<!-- Codes as per A&G Rules -->
			<!-- Code	 Description -->
			<!-- E	 $700 EXCESS -->
			<!-- W	 -$200 EXCESS -->
			<!-- Y	 -$100 EXCESS -->
			<!-- 0	 BASIC EXCESS ONLY -->
			<!-- 1	 $100 EXCESS -->
			<!-- 4	 $200 EXCESS -->
			<!-- 9	 $450 EXCESS -->
			<xsl:choose>
				<xsl:when test="baseExcess=''"></xsl:when>
				<xsl:when test="$excessContentsDif = 0">0</xsl:when>
				<xsl:when test="$excessContentsDif = 100">1</xsl:when>
				<xsl:when test="$excessContentsDif = 200">4</xsl:when>
				<xsl:when test="$excessContentsDif = 450">9</xsl:when>
				<xsl:when test="$excessContentsDif = 700">E</xsl:when>
				<xsl:when test="$excessContentsDif = -200">W</xsl:when>
				<xsl:when test="$excessContentsDif = -100">Y</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	<env:Envelope 	xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
					env:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
		<env:Header />
		<env:Body>
			<ns2:request xmlns:ns2="https://ecommerce.disconline.com.au/services/schema/3.0/home_quote">

<!-- HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
				<header>
					<partnerId><xsl:value-of select="$partnerId"/></partnerId>
					<sourceId><xsl:value-of select="$sourceId"/></sourceId>
					<schemaVersion><xsl:value-of select="$schemaVersion"/></schemaVersion>
					<partnerReference><xsl:value-of select="transactionId" /></partnerReference>
					<extension>
						<!-- Test if a Gomez script by checking these common used test email addresses
							gomez.testing@aihco.com.au
							aih.iia.triage@gmail.com
							preload.testing@comparethemarket.com.au -->
						<xsl:choose>
							<xsl:when test="policyHolder/email = 'gomez.testing@aihco.com.au' or policyHolder/email='preload.testing@comparethemarket.com.au' or policyHolder/email='aih.iia.triage@gmail.com' ">
								<testonly>Y</testonly>
							</xsl:when>
						</xsl:choose>
						<contentsExcess><xsl:value-of select="$excessContentsCode" /></contentsExcess>
						<buildingExcess><xsl:value-of select="$excessHomeCode" /></buildingExcess>
					</extension>
					<clientIpAddress><xsl:value-of select="clientIpAddress" /></clientIpAddress>
				</header>

<!-- REQUEST DETAILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
				<details>
					<cover>
						<coverType>
							<xsl:choose>
								<xsl:when test="coverType='Home Cover Only'">HHB</xsl:when>
								<xsl:when test="coverType='Contents Cover Only'">HHC</xsl:when>
								<xsl:when test="coverType='Home &amp; Contents Cover'">HHZ</xsl:when>
							</xsl:choose>
						</coverType>
						<commencementDate>
							<xsl:call-template name="util_isoDate">
								<xsl:with-param name="eurDate" select="startDate" />
							</xsl:call-template>
						</commencementDate>
						<buildingType>
							<xsl:choose>
								<xsl:when test="property/propertyType='Apartment'">08</xsl:when>
								<xsl:when test="property/propertyType='Duplex'">06</xsl:when>
								<xsl:when test="property/propertyType='Flat'">07</xsl:when>
								<xsl:when test="property/propertyType='Freestanding Home'">01</xsl:when>
								<xsl:when test="property/propertyType='Home Unit'">02</xsl:when>
								<xsl:when test="property/propertyType='Semi-Detached house'">18</xsl:when>
								<xsl:when test="property/propertyType='Terrace House'">04</xsl:when>
								<xsl:when test="property/propertyType='Townhouse'">03</xsl:when>
								<xsl:when test="property/propertyType='Villa'">05</xsl:when>
								<!-- This is when propertyType = 'Other' -->
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="property/bestDescribesHome='Boarding House'">09</xsl:when>
										<xsl:when test="property/bestDescribesHome='Caravan'">14</xsl:when>
										<xsl:when test="property/bestDescribesHome='Dormitory'">10</xsl:when>
										<xsl:when test="property/bestDescribesHome='Granny Flat'">12</xsl:when>
										<xsl:when test="property/bestDescribesHome='Mobile home'">11</xsl:when>
										<xsl:when test="property/bestDescribesHome='Shed'">13</xsl:when>
										<xsl:when test="property/bestDescribesHome='Shipping container'">17</xsl:when>
										<xsl:when test="property/bestDescribesHome='Storage facility'">15</xsl:when>
										<xsl:when test="property/bestDescribesHome='Warehouse'">16</xsl:when>
										<xsl:otherwise>99</xsl:otherwise>
								</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</buildingType>
						<yearBuilt><xsl:value-of select="property/yearBuilt" /></yearBuilt>
						<heritageListed>
							<xsl:choose>
								<xsl:when test="property/isHeritage='Y'">Y</xsl:when>
								<xsl:otherwise>N</xsl:otherwise>
							</xsl:choose>
						</heritageListed>
						<buildingMaterialWalls>
							<xsl:choose>
								<xsl:when test="property/wallMaterial='Cladding'">04</xsl:when>
								<xsl:when test="property/wallMaterial='Besser Block/Cement'">07</xsl:when>
								<xsl:when test="property/wallMaterial='Brick Veneer'">06</xsl:when>
								<xsl:when test="property/wallMaterial='Brick'">02</xsl:when>
								<xsl:when test="property/wallMaterial='Fibro'">03</xsl:when>
								<xsl:when test="property/wallMaterial='Stone'">05</xsl:when>
								<xsl:when test="property/wallMaterial='Weatherboard'">01</xsl:when>
								<xsl:otherwise>99</xsl:otherwise>
							</xsl:choose>
						</buildingMaterialWalls>
						<buildingMaterialRoof>
							<xsl:choose>
								<xsl:when test="property/roofMaterial='Cement Tiles'">01</xsl:when>
								<xsl:when test="property/roofMaterial='Clay/Terracotta Tiles'">04</xsl:when>
								<xsl:when test="property/roofMaterial='Colourbond'">02</xsl:when>
								<xsl:when test="property/roofMaterial='Metal Other'">03</xsl:when>
								<xsl:when test="property/roofMaterial='Slate'">05</xsl:when>
								<xsl:when test="property/roofMaterial='Thatch'">TH</xsl:when>
								<xsl:otherwise>99</xsl:otherwise>
							</xsl:choose>
						</buildingMaterialRoof>
						<bodyCorporate>
							<xsl:choose>
								<xsl:when test="property/bodyCorp='Y'">Y</xsl:when>
								<xsl:otherwise>N</xsl:otherwise>
							</xsl:choose>
						</bodyCorporate>

						<xsl:choose>
							<xsl:when test="coverType='Home Cover Only'">
								<buildingOnly>
									<xsl:call-template name="building"/>
								</buildingOnly>
							</xsl:when>
							<xsl:when test="coverType='Contents Cover Only'">
								<contentsOnly>
									<xsl:call-template name="contents"/>
								</contentsOnly>
							</xsl:when>
							<xsl:when test="coverType='Home &amp; Contents Cover'">
								<building>
									<xsl:call-template name="building"/>
								</building>
								<contents>
									<xsl:call-template name="contents"/>
								</contents>
							</xsl:when>
						</xsl:choose>

						<xsl:choose>
<!-- 							@todo = specifiedPersonalEffects has a schema problem -->
							<xsl:when test="coverAmounts/itemsAway='Y'">
								<personalEffects>
									<xsl:if test="coverAmounts/unspecifiedCoverAmount!='0' and coverAmounts/unspecifiedCoverAmount!=''">
										<unspecifiedCover><xsl:value-of select="coverAmounts/unspecifiedCoverAmount" /></unspecifiedCover>
									</xsl:if>
									<xsl:if test="coverAmounts/specifiedPersonalEffects/bicycle!='0' and coverAmounts/specifiedPersonalEffects/bicycle!=''">
										<bicyles><xsl:value-of select="coverAmounts/specifiedPersonalEffects/bicycle" /></bicyles>
									</xsl:if>
									<xsl:if test="coverAmounts/specifiedPersonalEffects/musical!='0' and coverAmounts/specifiedPersonalEffects/musical!=''">
										<musicalInstruments><xsl:value-of select="coverAmounts/specifiedPersonalEffects/musical" /></musicalInstruments>
									</xsl:if>
									<xsl:if test="coverAmounts/specifiedPersonalEffects/photo!='0' and coverAmounts/specifiedPersonalEffects/photo!=''">
										<photoEquipment><xsl:value-of select="coverAmounts/specifiedPersonalEffects/photo" /></photoEquipment>
									</xsl:if>
									<xsl:if test="coverAmounts/specifiedPersonalEffects/clothing!='0' and coverAmounts/specifiedPersonalEffects/clothing!=''">
										<clothing><xsl:value-of select="coverAmounts/specifiedPersonalEffects/clothing" /></clothing>
									</xsl:if>
									<xsl:if test="coverAmounts/specifiedPersonalEffects/jewellery!='0' and coverAmounts/specifiedPersonalEffects/jewellery!=''">
										<jewelleryWatches><xsl:value-of select="coverAmounts/specifiedPersonalEffects/jewellery" /></jewelleryWatches>
									</xsl:if>
									<xsl:if test="coverAmounts/specifiedPersonalEffects/sporting!='0' and coverAmounts/specifiedPersonalEffects/sporting!=''">
										<sportEquipment><xsl:value-of select="coverAmounts/specifiedPersonalEffects/sporting" /></sportEquipment>
									</xsl:if>
								</personalEffects>
							</xsl:when>
							<xsl:otherwise>
								<noPersonalEffects />
							</xsl:otherwise>
						</xsl:choose>
					</cover>

					<address>
						<postCode><xsl:value-of select="property/address/postCode" /></postCode>
						<suburbName><xsl:value-of select="property/address/suburbName" /></suburbName>
						<streetName><xsl:value-of select="$streetName" /></streetName>
						<streetNumber><xsl:value-of select="$streetNumber"/></streetNumber>
						<xsl:if test="$unitLevel != ''">
							<unitLevel><xsl:value-of select="$unitLevel"/></unitLevel>
						</xsl:if>
						<state><xsl:value-of select="property/address/state" /></state>
					</address>

					<occupancy>
						<ownProperty>
							<xsl:choose>
								<xsl:when test="occupancy/ownProperty='Y'">Y</xsl:when>
								<xsl:otherwise>N</xsl:otherwise>
							</xsl:choose>
						</ownProperty>
						<xsl:choose>
							<xsl:when test="occupancy/principalResidence='Y'">
								<moveInDate>
									<xsl:choose>
										<xsl:when test="occupancy/whenMovedIn/year='NotAtThisAddress'">0001-01</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="occupancy/whenMovedIn/year" />
											<xsl:if test="occupancy/whenMovedIn/month">-<xsl:value-of select="format-number(occupancy/whenMovedIn/month, '00')" /></xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</moveInDate>
							</xsl:when>
							<xsl:otherwise>
								<residenceUse>
									<xsl:choose>
										<xsl:when test="occupancy/howOccupied='Rented to tenants'">LO</xsl:when>
										<xsl:when test="occupancy/howOccupied='Holiday home (may be rented out)'">HR</xsl:when>
										<xsl:when test="occupancy/howOccupied='Holiday home (not rented out)'">HH</xsl:when>
										<xsl:when test="occupancy/howOccupied='Unoccupied'">UN</xsl:when>
										<xsl:otherwise>OT</xsl:otherwise>
									</xsl:choose>
								</residenceUse>
							</xsl:otherwise>
						</xsl:choose>
					</occupancy>

					<business>

						<xsl:choose>

							<xsl:when test="businessActivity/conducted='N'">
								<noBusinessActivity/>
							</xsl:when>

							<xsl:when test="businessActivity/businessType='Home office'">
								<homeOffice>
									<xsl:call-template name="homeOfficeOrSurgery"/>
								</homeOffice>
							</xsl:when>

							<xsl:when test="businessActivity/businessType='Surgery/consulting rooms'">
								<surgery>
									<xsl:call-template name="homeOfficeOrSurgery"/>
								</surgery>
							</xsl:when>

							<xsl:when test="businessActivity/businessType='Day care'">
								<dayCare>
									<childrenNumbers><xsl:value-of select="businessActivity/children" /></childrenNumbers>
									<registeredOrganisation>
										<xsl:choose>
											<xsl:when test="businessActivity/registeredDayCare='Y'">Y</xsl:when>
											<xsl:otherwise>N</xsl:otherwise>
										</xsl:choose>
									</registeredOrganisation>
								</dayCare>
							</xsl:when>

							<xsl:otherwise>
								<businessActivity>
									<xsl:choose>
										<xsl:when test="businessActivity/businessType='Bed &amp; breakfast'">03</xsl:when>
										<xsl:when test="businessActivity/businessType='Commercial Farming'">04</xsl:when>
										<xsl:when test="businessActivity/businessType='Hairdresser/beauty therapist'">05</xsl:when>
										<xsl:when test="businessActivity/businessType='Photography studio'">06</xsl:when>
										<xsl:when test="businessActivity/businessType='Food preparation/catering'">08</xsl:when>
										<xsl:when test="businessActivity/businessType='Mechanical workshop'">09</xsl:when>
										<xsl:otherwise>99</xsl:otherwise>
									</xsl:choose>
								</businessActivity>
							</xsl:otherwise>

						</xsl:choose>
					</business>

					<policyHolder>
						<firstName><xsl:value-of select="policyHolder/firstName" /></firstName>
						<surname><xsl:value-of select="policyHolder/lastName" /></surname>
						<email><xsl:value-of select="policyHolder/email" /></email>
						<dob>
							<xsl:call-template name="util_isoDate">
								<xsl:with-param name="eurDate" select="policyHolder/dob" />
							</xsl:call-template>
						</dob>
						<contactNumber>
							<xsl:choose>
								<xsl:when test="policyHolder/phone != ''"><xsl:value-of select="policyHolder/phone" /></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</contactNumber>
						<allowMarketing>N</allowMarketing>
					</policyHolder>

					<olderResident>
						<olderResidentDob>
							<xsl:choose>
								<xsl:when test="policyHolder/anyoneOlder = 'Y' ">
									<xsl:call-template name="util_isoDate">
										<xsl:with-param name="eurDate" select="policyHolder/oldestPersonDob" />
									</xsl:call-template></xsl:when>
								<xsl:otherwise>0001-01-01</xsl:otherwise>
							</xsl:choose>
						</olderResidentDob>
						<olderResidentRetired>
							<xsl:choose>
								<xsl:when test="policyHolder/over55 ! =''">
									<xsl:value-of select="policyHolder/over55" />
								</xsl:when>
								<xsl:otherwise>N</xsl:otherwise>
							</xsl:choose>
						</olderResidentRetired>
					</olderResident>

					<personalHistory >
						<xsl:choose>
							<xsl:when test="disclosures/previousInsurance='Y'">
								<previousPolicy>
									<sameAddress>
										<xsl:choose>
											<xsl:when test="disclosures/atCurrentAddress='Y'">Y</xsl:when>
											<xsl:otherwise>N</xsl:otherwise>
										</xsl:choose>
									</sameAddress>
									<insuranceCompany>
										<xsl:choose>
											<xsl:when test="disclosures/insurer='AAMI'">7111</xsl:when>
											<xsl:when test="disclosures/insurer='AI Insurance'">7773</xsl:when>
											<xsl:when test="disclosures/insurer='Allianz'">7316</xsl:when>
											<xsl:when test="disclosures/insurer='ANZ'">7778</xsl:when>
											<xsl:when test="disclosures/insurer='APIA'">7326</xsl:when>
											<xsl:when test="disclosures/insurer='Auto &amp; General'">7127</xsl:when>
											<xsl:when test="disclosures/insurer='Australia Post Insurance'">7379</xsl:when>
											<xsl:when test="disclosures/insurer='Bank of Queensland Insurance'">8040</xsl:when>
											<xsl:when test="disclosures/insurer='Bingle'">7669</xsl:when>
											<xsl:when test="disclosures/insurer='Budget Direct'">7387</xsl:when>
											<xsl:when test="disclosures/insurer='BUPA Insurance'">7941</xsl:when>
											<xsl:when test="disclosures/insurer='CGU'">7130</xsl:when>
											<xsl:when test="disclosures/insurer='Coles Insurance'">7875</xsl:when>
											<xsl:when test="disclosures/insurer='Comminsure'">7402</xsl:when>
											<xsl:when test="disclosures/insurer='Elders Insurance'">7323</xsl:when>
											<xsl:when test="disclosures/insurer='GIO'">7315</xsl:when>
											<xsl:when test="disclosures/insurer='HBF Insurance'">7157</xsl:when>
											<xsl:when test="disclosures/insurer='Hollard'">7406</xsl:when>
											<xsl:when test="disclosures/insurer='iSelect'">7800</xsl:when>
											<xsl:when test="disclosures/insurer='Just Car Insurance'">7335</xsl:when>
											<xsl:when test="disclosures/insurer='Kmart Insurance'">7874</xsl:when>
											<xsl:when test="disclosures/insurer='Lumley'">7165</xsl:when>
											<xsl:when test="disclosures/insurer='NAB'">7786</xsl:when>
											<xsl:when test="disclosures/insurer='NRMA'">7176</xsl:when>
											<xsl:when test="disclosures/insurer='Other'">7824</xsl:when>
											<xsl:when test="disclosures/insurer='Progressive'">7894</xsl:when>
											<xsl:when test="disclosures/insurer='QBE'">7181</xsl:when>
											<xsl:when test="disclosures/insurer='RAA'">7183</xsl:when>
											<xsl:when test="disclosures/insurer='RACQ'">7219</xsl:when>
											<xsl:when test="disclosures/insurer='RACV'">7314</xsl:when>
											<xsl:when test="disclosures/insurer='RACW'">7184</xsl:when>
											<xsl:when test="disclosures/insurer='Real Insurance'">7663</xsl:when>
											<xsl:when test="disclosures/insurer='SGIC'">7189</xsl:when>
											<xsl:when test="disclosures/insurer='SGIO'">7190</xsl:when>
											<xsl:when test="disclosures/insurer='Shannons'">7334</xsl:when>
											<xsl:when test="disclosures/insurer='Suncorp'">7197</xsl:when>
											<xsl:when test="disclosures/insurer='The Buzz'">7825</xsl:when>
											<xsl:when test="disclosures/insurer='Vero'">7386</xsl:when>
											<xsl:when test="disclosures/insurer='Virgin Money Insurance'">7808</xsl:when>
											<xsl:when test="disclosures/insurer='Wesfarmers'">7213</xsl:when>
											<xsl:when test="disclosures/insurer='Westpac'">7434</xsl:when>
											<xsl:when test="disclosures/insurer='Woolworths Insurance'">8026</xsl:when>
											<xsl:when test="disclosures/insurer='YOUI'">7766</xsl:when>
										</xsl:choose>
									</insuranceCompany>
									<expiryDate>
										<xsl:call-template name="util_isoDate">
											<xsl:with-param name="eurDate" select="disclosures/expiry" />
										</xsl:call-template>
									</expiryDate>
									<yearsInsured>
										<xsl:value-of select="disclosures/coverLength" />
									</yearsInsured>
								</previousPolicy>
							</xsl:when>
							<xsl:otherwise>
								<noPreviousPolicy />
							</xsl:otherwise>
						</xsl:choose>
						<previousClaims>
							<xsl:choose>
								<xsl:when test="disclosures/claims='Y'">Y</xsl:when>
								<xsl:otherwise>N</xsl:otherwise>
							</xsl:choose>
						</previousClaims>
					</personalHistory >
				</details>
			</ns2:request>
		</env:Body>
	</env:Envelope>

	</xsl:template>


<!-- SUPPORT TEMPLATES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="building">
		<rebuildCost><xsl:value-of select="coverAmounts/rebuildCost"/></rebuildCost>
	</xsl:template>

	<xsl:template name="contents">
		<replacementCost><xsl:value-of select="coverAmounts/replaceContentsCost"/></replacementCost>
		<contentsAboveLimit><xsl:value-of select="coverAmounts/abovePolicyLimits"/></contentsAboveLimit>
		<!-- @todo = above policy limits amount (coverAmounts/abovePolicyLimitsAmount) -->
		<xsl:choose>
			<xsl:when test="property/securityFeatures/internalSiren = 'Y' or
							property/securityFeatures/externalSiren = 'Y' or
							property/securityFeatures/strobeLight = 'Y' or
							property/securityFeatures/backToBase = 'Y'">
				<alarm>
					<alarmFitted>Y</alarmFitted>
					<internalSiren>
						<xsl:choose>
							<xsl:when test="property/securityFeatures/internalSiren='Y'">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</internalSiren>
					<externalSiren>
						<xsl:choose>
							<xsl:when test="property/securityFeatures/externalSiren='Y'">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</externalSiren>
					<externalStrobe>
						<xsl:choose>
							<xsl:when test="property/securityFeatures/strobeLight='Y'">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</externalStrobe>
					<backToBaseMonitoring>
						<xsl:choose>
							<xsl:when test="property/securityFeatures/backToBase='Y'">Y</xsl:when>
							<xsl:otherwise>N</xsl:otherwise>
						</xsl:choose>
					</backToBaseMonitoring>
				</alarm>
			</xsl:when>
			<xsl:otherwise>
				<noAlarm />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="homeOfficeOrSurgery">
		<roomsUsed><xsl:value-of select="businessActivity/rooms" /></roomsUsed>
		<otherEmployees>
			<xsl:choose>
				<xsl:when test="businessActivity/employeeAmount != ''"><xsl:value-of select="businessActivity/employeeAmount" /></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</otherEmployees>
	</xsl:template>

</xsl:stylesheet>