<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- IMPORTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:import href="../../includes/get_street_name.xsl"/>
	<xsl:import href="../../includes/utils.xsl"/>


<!-- PARAMETERS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:param name="partnerId" />
	<xsl:param name="sourceId" />
	<xsl:param name="today" />

<!-- KEYS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:key name="keyAccs" match="item" use="@code"/>

<!-- MAIN TEMPLATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template match="/quote">


<!-- LOCAL VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
		<xsl:variable name="streetName">
			<xsl:choose>
				<xsl:when test="riskAddress/nonStd='Y'">
					<xsl:value-of select="riskAddress/nonStdStreet" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="riskAddress/streetName" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="streetNumber">
			<xsl:choose>
				<xsl:when test="riskAddress/streetNum != ''">
					<xsl:value-of select="riskAddress/streetNum" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="riskAddress/houseNoSel" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="unitLevel">
			<xsl:choose>
				<xsl:when test="riskAddress/nonStd='Y'">
					<xsl:value-of select="riskAddress/unitShop" />
				</xsl:when>
				<xsl:when test="riskAddress/unitSel !=''">
					<xsl:value-of select="riskAddress/unitSel" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="riskAddress/unitShop" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="excessToTestWith">
			<xsl:choose>
				<xsl:when test="excess != ''">
					<xsl:value-of select="excess" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="baseExcess" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="excessCode">
			<!-- Codes as per A&G Rules -->
			<!-- Code	 Description -->
			<!-- 0	 $600 EXCESS -->
			<!-- 2	 $700 EXCESS -->
			<!-- 4	 $800 EXCESS -->
			<!-- 6	 $900 EXCESS -->
			<!-- 8	 $1000 EXCESS -->
			<!-- A	 $1100 EXCESS -->
			<xsl:choose>
				<xsl:when test="$excessToTestWith >= 1100">A</xsl:when>
				<xsl:when test="$excessToTestWith >= 1000">8</xsl:when>
				<xsl:when test="$excessToTestWith >= 900">6</xsl:when>
				<xsl:when test="$excessToTestWith >= 800">4</xsl:when>
				<xsl:when test="$excessToTestWith >= 700">2</xsl:when>
				<xsl:when test="$excessToTestWith >= 600">0</xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	<env:Envelope env:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"
			xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
		<env:Header />
		<env:Body>
			<ns2:request xmlns:ns2="https://ecommerce.disconline.com.au/services/schema/3.1/car_quote">

<!-- HEADER ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
				<header>
					<partnerId><xsl:value-of select="$partnerId"/></partnerId>
					<sourceId><xsl:value-of select="$sourceId"/></sourceId>
					<schemaVersion>3.1</schemaVersion>
					<partnerReference><xsl:value-of select="transactionId" /></partnerReference>
					<extension>
						<!-- Test if a Gomez script by checking these common used test email addresses
							gomez.testing@aihco.com.au
							aih.iia.triage@gmail.com
							preload.testing@comparethemarket.com.au ~ CAR-211 -->
						<xsl:choose>
							<xsl:when test="(contact/email = 'gomez.testing@aihco.com.au') or (contact/email='preload.testing@comparethemarket.com.au') or (contact/email='aih.iia.triage@gmail.com') ">
									<testonly>Y</testonly>
							</xsl:when>
						</xsl:choose>
						<!--  End  CAR-211 -->

						<excess><xsl:value-of select="$excessCode" /></excess>
					</extension>
					<clientIpAddress><xsl:value-of select="clientIpAddress" /></clientIpAddress>
				</header>

<!-- REQUEST DETAILS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
				<details>
					<cover>A</cover>
					<vehicle>
						<redbookCode><xsl:value-of select="vehicle/redbookCode" /></redbookCode>
						<registrationYear><xsl:value-of select="vehicle/registrationYear" /></registrationYear>
						<securityDevice><xsl:value-of select="vehicle/securityOption" /></securityDevice>
						<modified><xsl:value-of select="vehicle/modifications" /></modified>
						<accidentHailDamage><xsl:value-of select="vehicle/damage" /></accidentHailDamage>
						<annualKilometres>
							<xsl:call-template name="kilometreCode">
								<xsl:with-param name="kms" select="translate(vehicle/annualKilometres,'0123456789kms,','0123456789')" />
							</xsl:call-template>
						</annualKilometres>

						<xsl:call-template name="nonStandardAccessories" />

						<!-- Factory Options -->
						<xsl:choose>
							<xsl:when test="vehicle/factoryOptions = 'Y'">
								<factoryOptionList>
								<xsl:for-each select="opts/*[starts-with(name(),'opt')]">
									<factoryOptionCode><xsl:value-of select="." /></factoryOptionCode>
								</xsl:for-each>
								</factoryOptionList>
							</xsl:when>

							<xsl:otherwise>
								<noFactoryOptions />
							</xsl:otherwise>
						</xsl:choose>
					</vehicle>
					<address>
						<xsl:if test="$unitLevel != ''">
							<unitLevel><xsl:value-of select="$unitLevel"/></unitLevel>
						</xsl:if>
						<streetNumber><xsl:value-of select="$streetNumber"/></streetNumber>
						<streetName><xsl:value-of select="$streetName" /></streetName>
						<suburbName><xsl:value-of select="riskAddress/suburbName" /></suburbName>
						<state><xsl:value-of select="riskAddress/state" /></state>
						<postCode><xsl:value-of select="riskAddress/postCode" /></postCode>
					</address>
					<whereParked><xsl:value-of select="vehicle/parking" /></whereParked>
					<vehicleUse><xsl:value-of select="vehicle/use" /></vehicleUse>
					<finance><xsl:value-of select="vehicle/finance" /></finance>
					<commencementDate>
						<xsl:call-template name="util_isoDate">
							<xsl:with-param name="eurDate" select="options/commencementDate" />
						</xsl:call-template>
					</commencementDate>
					<regularDriver>
						<xsl:if test="drivers/regular/firstname != ''">
							<firstName><xsl:value-of select="substring(drivers/regular/firstname, 1, 15)"/></firstName>
						</xsl:if>
						<xsl:if test="drivers/regular/surname != ''">
							<surname><xsl:value-of select="substring(drivers/regular/surname, 1, 20)" /></surname>
						</xsl:if>
						<DOB>
							<xsl:call-template name="util_isoDate">
								<xsl:with-param name="eurDate" select="drivers/regular/dob" />
							</xsl:call-template>
						</DOB>
						<gender><xsl:value-of select="drivers/regular/gender" /></gender>
						<employmentStatus><xsl:value-of select="drivers/regular/employmentStatus" /></employmentStatus>
						<claims><xsl:value-of select="drivers/regular/claims" /></claims>
						<ownsAnotherCar><xsl:value-of select="drivers/regular/ownsAnotherCar" /></ownsAnotherCar>
						<NCD><xsl:value-of select="drivers/regular/ncd" /></NCD>
						<NCDPro>N</NCDPro>
					</regularDriver>

					<xsl:choose>
						<xsl:when test="drivers/spouse/exists = 'Y'">
							<spouse>
								<DOB>
									<xsl:call-template name="util_isoDate">
										<xsl:with-param name="eurDate" select="drivers/spouse/dob" />
									</xsl:call-template>
								</DOB>
								<gender><xsl:value-of select="drivers/spouse/gender" /></gender>
								<employmentStatus><xsl:value-of select="drivers/spouse/employmentStatus" /></employmentStatus>
							</spouse>
						</xsl:when>
						<xsl:otherwise>
							<noSpouse />
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="drivers/young/exists = 'Y'">
							<youngestDriver>
								<DOB>
									<xsl:call-template name="util_isoDate">
										<xsl:with-param name="eurDate" select="drivers/young/dob" />
									</xsl:call-template>
								</DOB>
								<gender><xsl:value-of select="drivers/young/gender" /></gender>
							</youngestDriver>
						</xsl:when>
						<xsl:otherwise>
							<noYoungestDriver />
						</xsl:otherwise>
					</xsl:choose>
					<ageRestriction>
						<xsl:choose>
							<xsl:when test="options/driverOption != ''">
								<xsl:value-of select="options/driverOption" />
							</xsl:when>
							<xsl:otherwise>3</xsl:otherwise><!-- Default if the person is under 18 (field hidden) -->
						</xsl:choose>
					</ageRestriction>
				</details>

			</ns2:request>
		</env:Body>
	</env:Envelope>

	</xsl:template>


<!-- SUPPORT TEMPLATES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:template name="kilometreCode">
		<xsl:param name="kms" />

		<xsl:choose>
			<xsl:when test="$kms &lt; 5001">K</xsl:when>
			<xsl:when test="$kms &lt; 8001">L</xsl:when>
			<xsl:when test="$kms &lt; 10001">M</xsl:when>
			<xsl:when test="$kms &lt; 12001">N</xsl:when>
			<xsl:when test="$kms &lt; 15001">O</xsl:when>
			<xsl:when test="$kms &lt; 17501">P</xsl:when>
			<xsl:when test="$kms &lt; 20001">Q</xsl:when>
			<xsl:when test="$kms &lt; 25001">R</xsl:when>
			<xsl:when test="$kms &lt; 30001">S</xsl:when>
			<xsl:otherwise>T</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="nonStandardAccessories">
		<xsl:choose>
			<xsl:when test="vehicle/accessories = 'Y'">

				<nonStandardAccessoryList>
				<xsl:for-each select="accs/*[starts-with(name(),'acc')]">
					<xsl:sort select="name()" />

					<!--  set up some variables because the context will change inside the for loop -->
					<xsl:variable name="accCode" select="sel" />
					<xsl:variable name="accInc" select="inc" />
					<xsl:variable name="accPrc" select="prc" />
					<xsl:variable name="accDesc" select="desc/AGIS" />

					<xsl:element name="{$accDesc}">
						<xsl:attribute name="code"><xsl:value-of select="$accCode" /></xsl:attribute>

						<!-- Purchase prices supplied? -->
						<xsl:choose>
							<xsl:when test="$accInc = 'N'">
								<purchasePrice><xsl:value-of select="$accPrc" /></purchasePrice>
							</xsl:when>
							<xsl:otherwise>
								<includedInCar />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:element>

				</xsl:for-each>
				</nonStandardAccessoryList>
			</xsl:when>

			<xsl:otherwise>
				<noNonStandardAccessories />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>