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

		<xsl:variable name="homeExcessToUse">
			<xsl:choose>
				<xsl:when test="homeExcess != ''">
					<xsl:value-of select="homeExcess" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="baseHomeExcess" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="excessHomeCode">
			<!-- Codes as per A&G Rules based on $500 excess -->
			<!-- Code	 Description 	Base Offset
				 P	 	$100 EXCESS 		-400
				 Q	 	$200 EXCESS 		-300
				 W	 	$300 EXCESS 		-200
				 Y	 	$400 EXCESS 		-100
				 0	 	$500 EXCESS 		0
				 5	 	$750 EXCESS 		+250
				 A	 	$1000 EXCESS 		+500
				 R	 	$1500 EXCESS 		+1000
				 S	 	$2000 EXCESS 		+1500
				 T		$3000 EXCESS		+2500
				 U		$4000 EXCESS		+3500
				 V		$5000 EXCESS		+4500
			-->

			<xsl:choose>
				<xsl:when test="$homeExcessToUse = 100">P</xsl:when>
				<xsl:when test="$homeExcessToUse = 200">Q</xsl:when>
				<xsl:when test="$homeExcessToUse = 300">W</xsl:when>
				<xsl:when test="$homeExcessToUse = 400">Y</xsl:when>
				<xsl:when test="$homeExcessToUse = 500">0</xsl:when>
				<xsl:when test="$homeExcessToUse = 750">5</xsl:when>
				<xsl:when test="$homeExcessToUse = 1000">A</xsl:when>
				<xsl:when test="$homeExcessToUse = 1500">R</xsl:when>
				<xsl:when test="$homeExcessToUse = 2000">S</xsl:when>
				<xsl:when test="$homeExcessToUse = 3000">T</xsl:when>
				<xsl:when test="$homeExcessToUse = 4000">U</xsl:when>
				<xsl:when test="$homeExcessToUse = 5000">V</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="contentsExcessToUse">
			<xsl:choose>
				<xsl:when test="contentsExcess != ''">
					<xsl:value-of select="contentsExcess" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="baseContentsExcess" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="excessContentsCode">
			<!-- Codes as per A&G Rules based on $500 excess -->
			<!-- Code	 Description 	Base Offset
				 P	 	$100 EXCESS 		-400
				 Q	 	$200 EXCESS 		-300
				 W	 	$300 EXCESS 		-200
				 Y	 	$400 EXCESS 		-100
				 0	 	$500 EXCESS 		0
				 5	 	$750 EXCESS 		+250
				 A	 	$1000 EXCESS 		+500
				 R	 	$1500 EXCESS 		+1000
				 S	 	$2000 EXCESS 		+1500
				 T		$3000 EXCESS		+2500
				 U		$4000 EXCESS		+3500
				 V		$5000 EXCESS		+4500
			-->
			<xsl:choose>
				<xsl:when test="$contentsExcessToUse = 100">P</xsl:when>
				<xsl:when test="$contentsExcessToUse = 200">Q</xsl:when>
				<xsl:when test="$contentsExcessToUse = 300">W</xsl:when>
				<xsl:when test="$contentsExcessToUse = 400">Y</xsl:when>
				<xsl:when test="$contentsExcessToUse = 500">0</xsl:when>
				<xsl:when test="$contentsExcessToUse = 750">5</xsl:when>
				<xsl:when test="$contentsExcessToUse = 1000">A</xsl:when>
				<xsl:when test="$contentsExcessToUse = 1500">R</xsl:when>
				<xsl:when test="$contentsExcessToUse = 2000">S</xsl:when>
				<xsl:when test="$contentsExcessToUse = 3000">T</xsl:when>
				<xsl:when test="$contentsExcessToUse = 4000">U</xsl:when>
				<xsl:when test="$contentsExcessToUse = 5000">V</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	<env:Envelope 	xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
					env:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
		<env:Header />
		<env:Body>
			<ns2:request xmlns:ns2="https://ecommerce.disconline.com.au/services/schema/5.0/home_quote">

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
								<xsl:when test="property/wallMaterial='Double Brick'">02</xsl:when>
								<xsl:when test="property/wallMaterial='Asbestos Fibro'">08</xsl:when>
								<xsl:when test="property/wallMaterial='Non-asbestos Fibro'">10</xsl:when>
								<xsl:when test="property/wallMaterial='Stone'">05</xsl:when>
								<xsl:when test="property/wallMaterial='Weatherboard'">01</xsl:when>
								<xsl:otherwise>99</xsl:otherwise>
							</xsl:choose>
						</buildingMaterialWalls>
						<buildingMaterialRoof>
							<xsl:choose>
								<xsl:when test="property/roofMaterial='Cement Tiles'">01</xsl:when>
								<xsl:when test="property/roofMaterial='Clay/Terracotta Tiles'">04</xsl:when>
								<xsl:when test="property/roofMaterial='Colorbond'">02</xsl:when>
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
							<xsl:when test="coverAmounts/itemsAway='Y'">
								<personalEffects>
									<unspecifiedCover>
										<xsl:choose>
											<xsl:when test="coverAmounts/unspecifiedCoverAmount!='0' and coverAmounts/unspecifiedCoverAmount!=''">
												<xsl:value-of select="coverAmounts/unspecifiedCoverAmount" />
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</unspecifiedCover>
									<bicycles>
										<xsl:choose>
											<xsl:when test="coverAmounts/specifiedPersonalEffects/bicycle!='0' and coverAmounts/specifiedPersonalEffects/bicycle!=''">
												<xsl:value-of select="coverAmounts/specifiedPersonalEffects/bicycle" />
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</bicycles>
									<musicalInstruments>
										<xsl:choose>
											<xsl:when test="coverAmounts/specifiedPersonalEffects/musical!='0' and coverAmounts/specifiedPersonalEffects/musical!=''">
												<xsl:value-of select="coverAmounts/specifiedPersonalEffects/musical" />
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</musicalInstruments>
									<photoEquipment>
										<xsl:choose>
											<xsl:when test="coverAmounts/specifiedPersonalEffects/photo!='0' and coverAmounts/specifiedPersonalEffects/photo!=''">
												<xsl:value-of select="coverAmounts/specifiedPersonalEffects/photo" />
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</photoEquipment>
									<clothing>
										<xsl:choose>
											<xsl:when test="coverAmounts/specifiedPersonalEffects/clothing!='0' and coverAmounts/specifiedPersonalEffects/clothing!=''">
												<xsl:value-of select="coverAmounts/specifiedPersonalEffects/clothing" />
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</clothing>
									<jewelleryWatches>
										<xsl:choose>
											<xsl:when test="coverAmounts/specifiedPersonalEffects/jewellery!='0' and coverAmounts/specifiedPersonalEffects/jewellery!=''">
												<xsl:value-of select="coverAmounts/specifiedPersonalEffects/jewellery" />
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</jewelleryWatches>
									<sportEquipment>
										<xsl:choose>
											<xsl:when test="coverAmounts/specifiedPersonalEffects/sporting!='0' and coverAmounts/specifiedPersonalEffects/sporting!=''">
												<xsl:value-of select="coverAmounts/specifiedPersonalEffects/sporting" />
											</xsl:when>
											<xsl:otherwise>0</xsl:otherwise>
										</xsl:choose>
									</sportEquipment>
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
									<xsl:choose>
										<xsl:when test="occupancy/whenMovedIn/year='NotAtThisAddress'"></xsl:when>
										<xsl:otherwise>
								<moveInDate>
											<xsl:value-of select="occupancy/whenMovedIn/year" /><xsl:if test="occupancy/whenMovedIn/month">-<xsl:value-of select="format-number(occupancy/whenMovedIn/month, '00')" /></xsl:if>
								</moveInDate>
										</xsl:otherwise>
									</xsl:choose>
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
						<email />
						<dob>
							<xsl:call-template name="util_isoDate">
								<xsl:with-param name="eurDate" select="policyHolder/dob" />
							</xsl:call-template>
						</dob>
						<contactNumber>0</contactNumber>
					</policyHolder>

					<olderResident>
						<olderResidentRetired>
							<xsl:choose>
								<xsl:when test="policyHolder/retired !=''">
									<xsl:value-of select="policyHolder/retired" />
								</xsl:when>
								<xsl:otherwise>N</xsl:otherwise>
							</xsl:choose>
						</olderResidentRetired>
					</olderResident>

					<personalHistory >
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
